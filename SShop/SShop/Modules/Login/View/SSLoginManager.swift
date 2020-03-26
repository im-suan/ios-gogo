//
//  SSLoginManager.swift
//  SShop
//
//  Created by Nguyen Xuan on 3/16/20.
//  Copyright © 2020 Nguyen Xuan. All rights reserved.
//

import Foundation
import CoreData
import GoogleSignIn
import FBSDKLoginKit

enum SSLoginService: String {
    case facebook
    case google
}

protocol SSLoginManagerDelegate {
    func loginDidComplete()
    func logoutDidComplete()
}

class SSLoginManager: NSObject {
    static let shared = SSLoginManager()
    private var currentUser: User? = nil
    private var activeService: SSLoginService? = nil
    var delegate: SSLoginManagerDelegate? = nil
    
    weak var presentingViewController: UIViewController! {
        didSet {
            GIDSignIn.sharedInstance()?.presentingViewController = self.presentingViewController
            GIDSignIn.sharedInstance()?.delegate = self
        }
    }
    private var context: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }

    private override init(){
        print("init ssloginmanager")
        super.init()
        
        if let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String, let gidSignIn = GIDSignIn.sharedInstance() {
            gidSignIn.clientID = clientId
            gidSignIn.presentingViewController = presentingViewController
            gidSignIn.restorePreviousSignIn()
        }
        
        if currentUser == nil {
            if let currentUser = self.loadUserInfo() {
                self.currentUser = currentUser
                self.activeService = currentUser.service
            }
        }
    }
    
    func getUser() -> User? {
        return currentUser
    }
    
    func login(with service: SSLoginService) {
        guard presentingViewController != nil else { return }
        
        switch service {
        case .facebook:
            print("signIn facebook")
            let fbLoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["public_profile", "email"], from: presentingViewController){ result, error in
                guard error == nil, let result = result else {
                    print("Error when login with Facebook: \(error?.localizedDescription ?? "")")
                    return
                }
                self.loginFacebookDidComplete(result)
            }
        case .google:
            print("signIn google", GIDSignIn.sharedInstance() ?? "nil")
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    func logout() {
        switch activeService {
        case .facebook:
            print("signOut facebook")
            let fbLoginManager = LoginManager()
            fbLoginManager.logOut()
        case .google:
            print("signOut google")
            GIDSignIn.sharedInstance()?.signOut()
        case .none:
            return
        }
        
        activeService = nil
        resetUserInfo()
        currentUser = nil
        delegate?.logoutDidComplete()
    }
    
    private func loginFacebookDidComplete(_ result: LoginManagerLoginResult) {
        print("login facebook completed")
        if let token = result.token?.tokenString {
            fetchUserDataFromFB(with: token)
        }
    }
}

//MARK: - GIDSignInDelegate
extension SSLoginManager: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("google sign-in")
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
        } else {
            var picture: UIImage? = nil
            if user.profile.hasImage, let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 480), let data = try? Data(contentsOf: imageUrl) {
                picture = UIImage(data: data)
            }
            currentUser = User(id: user.userID, name: user.profile.name, service: .google, picture: picture, email: user.profile.email, phone: nil)
            activeService = .google
            saveUserInfo()
        }
        print("DONE")
        delegate?.loginDidComplete()
    }
}

//MARK: - related user info
extension SSLoginManager {
    
    private func saveUserInfo() {
        guard let context = context, let currentUser = currentUser, let activeService = activeService else { return }
        
        let user = UserMO(context: context)
        user.id = currentUser.id
        user.name = currentUser.name
        user.email = currentUser.email
        user.phone = currentUser.phone
        user.picture = currentUser.picture?.pngData()
        user.service = activeService.rawValue
        do { try context.save() }
        catch { print("Error saving context: \(error.localizedDescription)") }
    }
    
    private func resetUserInfo() {
        guard let context = context, let _ = activeService else { return }
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        do {
            let data = try context.fetch(request)
            guard data.count > 0, let umo = data[0] as? UserMO else { return }
            context.delete(umo)
            do { try context.save() }
            catch { throw error }
        } catch {
            print("Error when reseting user info: \(error.localizedDescription)")
        }
    }
    
    private func fetchUserDataFromFB(with token: String) {
        GraphRequest(graphPath: "me",
                     parameters: ["fields":"id,email,name,picture.width(480).height(480)"],
                     tokenString: token,
                     version: nil,
                     httpMethod: .get)
            .start { (connection, result, error) in
                if error != nil {
                    print("error when request: \(error!.localizedDescription)")
                } else {
                    print("picture \(String(describing: result))")
                    guard let result = result as? [String: Any] else { return }
                    let user = User(id: result["id"] as? String ?? "unknown",
                                    name: result["name"] as? String ?? "",
                                    service: SSLoginService.facebook,
                                    picture: nil,
                                    email: result["email"] as? String,
                                    phone: result["phone"] as? String)
                    if let picRef = result["picture"] as? [String: Any],
                        let picData = picRef["data"] as? [String: Any],
                        let picUrl = picData["url"] as? String {
                        if let url = URL(string: picUrl),
                            let data = try? Data(contentsOf: url) {
                            user.picture = UIImage(data: data)
                        }
                    }
                    self.currentUser = user
                    self.activeService = .facebook
                    self.saveUserInfo()
                }
                self.delegate?.loginDidComplete()
        }
    }
    
    private func loadUserInfo() -> User? {
        print("load user info")
        guard let context = context else { return nil }
        let request: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        do {
            let data = try context.fetch(request)
            guard data.count > 0, let umo = data[0] as? UserMO, umo.service != nil, let service = SSLoginService(rawValue: umo.service!) else { return nil }
            
            let u = User(id: umo.id ?? "unknown", name: umo.name ?? "-", service: service, picture:nil, email: umo.email, phone: umo.phone)
            if let picData = umo.picture, let pic = UIImage(data: picData) {
                u.picture = pic
            }
            return u
        } catch {
            print("Error when loading user info: \(error.localizedDescription)")
        }
        return nil
    }
}

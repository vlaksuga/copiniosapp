//
//  GoogleSignInButton.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/26.
//

import SwiftUI
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import CryptoKit
import AuthenticationServices

let provider = OAuthProvider(providerID: "twitter.com")

// Sign-In flow UI of the provider
class SocialLogin: ObservableObject {
    
    @State var entrySetDone = false
    @State var apiURL = UserDefaults.standard.string(forKey: "apiURL")
    @State var deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
    
    func attemptLoginGoogle() {
        // Must present viewController UIViewController in UIKit, not support for SwiftUI 2.0 yet.
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func signOutGoogleAccount() {
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func attemptLoginTwitter() {
        print("twitter login try")
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            Auth.auth().signIn(with: credential!) { res, e in
                if e != nil {
                    print((e?.localizedDescription) ?? "error")
                    return
                }
                print("Firebase - Twitter Authentication Success")
                // login auth server with firebase user
                let firebaseUser = Auth.auth().currentUser ?? nil
                self.loginWithFirebaseUser(user: firebaseUser!)
            }
        }
    }
    
    let loginManager = LoginManager()
    func attemptLoginFacebook() {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { result in
            switch result {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User Canceled")
            case .success(granted: _, declined: _, token: let accessToken):
                print(accessToken?.tokenString ?? "no token")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken?.tokenString ?? "")
                Auth.auth().signIn(with: credential) { (res, e) in
                    if e != nil {
                        print((e?.localizedDescription) ?? "error")
                        return
                    }
                    print("Firebase - Facebook Authentication Success")
                }
            }
        }
    }
    
    func loginWithFirebaseUser(user: User?) {
        if user != nil {
            user?.getIDToken(completion: { (token, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "unknown error")
                    return
                }
                
                if let token: String = token {
                    print(token)
                    let subURL: String = "a/processLoginFirebase.json"
                    guard let url = URL(string: self.apiURL + subURL + "?idToken=" + token + "&c=" + self.deviceToken! + "&d=android") else {
                        print("invalid URL")
                        return
                    }
                    
                    let request = URLRequest(url: url)
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        print("reponse : \(response.debugDescription)" )
                        print("data : \(String(data: data!, encoding: .utf8)!)" )
                        if let data = data {
                            print("data inside")
                            if let decodedResponse = try? JSONDecoder().decode(RetLogin.self, from: data) {
                                let body = decodedResponse.body
                                UserDefaults.standard.set(body.t2, forKey: "loginToken")
                                UserDefaults.standard.set(body.token, forKey: "accountToken")
                                UserDefaults.standard.set(body.userinfo.accountpkey, forKey: "accountPKey")
                                // Set identitys for trackers here...
                                
                            } else {
                                print("decode fail")
                            }
                            
                        } else { print(error?.localizedDescription ?? "Unknown") }
                    }.resume()
                }
            })
        }
    }
}

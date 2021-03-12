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

// Facebook Sign In
class FacebookLoginManager: ObservableObject {

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
                    // Send backend Auth
                }
            }
        }
    }
}

// Sign-In flow UI of the provider
struct SocialLogin: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
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
                // Send backend Auth
            }
        }
    }
    
}

//
//  copinappApp.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Google Init
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().restorePreviousSignIn()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, option: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Handle sign-in errors
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out")
            } else {
                print("error signing into Google \(error.localizedDescription)")
            }
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // Firebase auth signin with creadential
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase authentication error \(error.localizedDescription)")
            } else {
                print("Firebase authentication success")
                // Send Backend Here Maybe...
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Google signout
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
}

extension AppDelegate: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        try! Auth.auth().signOut()
        print("Did Logout")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print((error?.localizedDescription))
            return
        }
        
        if AccessToken.current != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            if error != nil {
                print((error?.localizedDescription))
                return
            }
            
            print("Facebook Login Success")
            // TODO : Backend login with credential
        }
    }
}



@main
struct copinappApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

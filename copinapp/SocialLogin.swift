//
//  GoogleSignInButton.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/26.
//

import SwiftUI
import GoogleSignIn
import FBSDKCoreKit


// Google Sign In
struct GoogleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> GIDSignInButton {
        return GIDSignInButton()
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
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
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}

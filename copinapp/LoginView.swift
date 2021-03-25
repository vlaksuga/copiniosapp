//
//  TestLoginView.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/23.
//

import SwiftUI

struct LoginView: View {
    
    let appDelegate = AppDelegate()
    @State var activePurchase = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    SocialLogin().attemptLoginGoogle()
                }, label: {
                    Image("google")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                })
                
                Button(action: {
                    SocialLogin().attemptLoginFacebook()
                }, label: {
                    Image("facebook")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                })
                
                Button(action: {
                    SocialLogin().attemptLoginTwitter()
                }, label: {
                    Image("twitter")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                })
                
                Button {
                    appDelegate.attemptLoginApple()
                } label: {
                    Image("apple")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

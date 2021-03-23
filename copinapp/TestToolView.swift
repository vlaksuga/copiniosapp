//
//  TestToolView.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/23.
//

import SwiftUI

struct TestToolView: View {
    
    let appDelegate = AppDelegate()
    
    var body: some View {
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
                FacebookLoginManager().attemptLoginFacebook()
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

struct TestToolView_Previews: PreviewProvider {
    static var previews: some View {
        TestToolView()
    }
}

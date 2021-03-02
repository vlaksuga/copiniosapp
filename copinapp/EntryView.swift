//
//  EntryView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/26.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                GoogleSignInButton()
                    .onTapGesture {
                        SocialLogin().attemptLoginGoogle()
                    }
            }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}

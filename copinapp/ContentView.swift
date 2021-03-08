//
//  ContentView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var showLoader = false
    @State var entrySetDone = true
    @State var isLogin = false
    
    var body: some View {
        
                return Group {
                    if entrySetDone {
                        ZStack {
                            VStack(spacing: 0) {
                                // Webview Here
                                WebView(viewModel: viewModel, urlType: .stageUrl).onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) {
                                    value in self.showLoader = value
                                }
                            }
        
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
                                }
                            }
        
                            if showLoader{
                                Loader()
                            }
        
                        }
                    } else {
                        EntryView()
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

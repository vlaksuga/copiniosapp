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
    @State var result = CheckVersion()
    @State var entrySetDone = false
    @State var showLoader = false
    @State var isLogin = false
    
    func checkVersion() {
        guard let url = URL(string: "https://sapi.copincomics.com/a/checkVersion.json") else {
            print("invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("reponse : \(response.debugDescription)" )
            print("data : \(String(data: data!, encoding: String.Encoding.utf8)!)" )
            if let data = data {
                print(data)
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        result = decodedResponse.checkVersionResult
                    print(result.head?.msg ?? "Unknown Header")
                    return
                }
                entrySetDone = true
            } else { print(error?.localizedDescription ?? "Unknown") }
        }.resume()
    }
    
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
                            .onAppear(perform: checkVersion)
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

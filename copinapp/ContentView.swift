//
//  ContentView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    let currentVersion = 11
    let appDelegate = AppDelegate()
    @ObservedObject var viewModel = ViewModel()
    @State var apiURL = "https://sapi.copincomics.com/"
    @State var entryURL = "https://stage.copincomics.com"
    @State var showLoader = false
    @State var entrySetDone = false
    @State var versionCheck = false
    @State var loginToken = UserDefaults.standard.string(forKey: "loginToken")
    @State var deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
    
    var body: some View {
        return Group {
            if entrySetDone {
                ZStack {
                    VStack(spacing: 0) {
                        WebView(viewModel: viewModel, urlType: .stageUrl, apiType: .stageAPI)
                            .onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                                self.showLoader = value
                            }
                    }
                    
                    TestLoginView()
                    
                    if showLoader {
                        Loader()
                    }
                    
                }
            } else {
                EntryView()
                    .onAppear(perform: checkVersion)
            }
        }
    }
    
    func checkVersion() {
        let subURL: String = "a/checkVersion.json"
        guard let url = URL(string: apiURL + subURL) else {
            print("invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("reponse : \(response.debugDescription)" )
            print("data : \(String(data: data!, encoding: .utf8)!)" )
            if let data = data {
                print("data inside")
                if let decodedResponse = try? JSONDecoder().decode(CheckVersion.self, from: data) {
                    let body = decodedResponse.body
                    
                    // versions
                    let minimumVersion = Int(body.IOSMIN) ?? 0
                    let recentVersion = Int(body.IOSRECENT) ?? 0
                    
                    // url
                    let apiURL11 = body.APIURL11
                    let entryURL11 = body.ENTRYURL11
                    let defaultEntryURL = body.DEFAULTENTRYURL
                    let defaultApiURL = body.DEFAULTAPIURL
                    
                    if currentVersion < minimumVersion {
                        print("currentVersion (\(currentVersion)) is lower than minimumVersion (\(minimumVersion))")
                        print("This app needs updated.")
                        // Alret here to send apple market or finish app
                    } else {
                        apiURL = defaultApiURL
                        entryURL = defaultEntryURL
                        if currentVersion > recentVersion {
                            print("Updated API & Entry url to ver.11")
                            apiURL = apiURL11
                            entryURL = entryURL11
                            print(apiURL)
                            print(entryURL)
                            checkLogin()
                        }
                    }
                    print("recentVersion is \(recentVersion)")
                } else {
                    print("decode fail")
                }
                
            } else { print(error?.localizedDescription ?? "Unknown") }
        }.resume()
    }
    
    func checkLogin() {
        print("checkLogin Start")
        if loginToken != nil {
            print("Login Token : \(String(describing: loginToken))")
            let subURL = "a/processLoginFirebase.json"
            let queryString = "?idToken=\(loginToken ?? "")"
            guard let url = URL(string: apiURL + subURL + queryString) else {
                print("invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("reponse : \(response.debugDescription)" )
                print("data : \(String(data: data!, encoding: .utf8)!)" )
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(RetLogin.self, from: data) {
                        let head = decodedResponse.head
                        if head.status != "error" {
                            let body = decodedResponse.body
                            print(body.t2)
                            print(body.token)
                            print(body.userinfo.accountpkey)
                            // Webview Login Firebase
                            entrySetDone = true
                        } else {
                            print(error?.localizedDescription ?? "Unkwnown Error")
                        }
                    }
                } else { print(error?.localizedDescription ?? "Unknown") }
            }.resume()
        } else {
            print("Login Token is Empty")
            entrySetDone = true
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

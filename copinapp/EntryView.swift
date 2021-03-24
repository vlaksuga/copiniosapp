//
//  EntryView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/26.
//

import SwiftUI
import Firebase



struct EntryView: View {
    
    let currentVersion = 11
    let appDelegate = AppDelegate()
    let contentView = ContentView()
    
    @ObservedObject var viewModel = ViewModel()
    @State var apiURL = "https://sapi.copincomics.com/"
    @State var entryURL = "https://stage.copincomics.com"
    @State var showLoader = false
    @Binding var entrySetDone : Bool
    @State var versionCheck = false
    @State var loginToken = UserDefaults.standard.string(forKey: "loginToken")
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .frame(width: 120, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                        UserDefaults.standard.set(defaultApiURL, forKey: "apiURL")
                        UserDefaults.standard.set(defaultEntryURL, forKey: "entryURL")
                        if currentVersion > recentVersion {
                            print("Updated API & Entry url to ver.11")
                            UserDefaults.standard.set(apiURL11, forKey: "apiURL")
                            UserDefaults.standard.set(entryURL11, forKey: "entryURL")
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
                            UserDefaults.standard.set(body.t2, forKey: "loginToken")
                            UserDefaults.standard.set(body.token, forKey: "accountToken")
                            UserDefaults.standard.set(body.userinfo.accountpkey, forKey: "accountPKey")
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

struct EntryView_Previews: PreviewProvider {
    
    @State static var entrySetDone = false
    
    static var previews: some View {
        EntryView(entrySetDone: $entrySetDone)
    }
}

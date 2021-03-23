//
//  ContentView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    @StateObject var storeManager: StoreManager
    @ObservedObject var viewModel = ViewModel()
    
    let currentVersion = 11
    let appDelegate = AppDelegate()
    
    
    @State var apiURL = "https://sapi.copincomics.com/"
    @State var entryURL = "https://stage.copincomics.com"
    @State var showLoader = false
    @State var startMainView = false
    @State var versionCheck = false
    @State var testMode = true
    @State var purchaseMode = false
    @State var loginToken = UserDefaults.standard.string(forKey: "loginToken")
    @State var deviceToken = UserDefaults.standard.string(forKey: "deviceToken")
    
    var body: some View {
        
        return Group {
            if startMainView {
                ZStack {
                    VStack(spacing: 0) {
                        WebView(viewModel: viewModel, urlType: .stageUrl, apiType: .stageAPI)
                            .onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                                self.showLoader = value
                            }
                    }
                    if testMode {
                        TestToolView()
                    }
                    
                    if showLoader {
                        Loader()
                    }
                    
                }
            } else {
                if purchaseMode {
                    PurchaseView(storeManager: storeManager)
                } else {
                    EntryView()
                        .onAppear(perform: EntryView(viewModel: viewModel).checkLogin)
                        .onReceive(self.viewModel.entryPublisher.receive(on: RunLoop.main)) { value in
                            self.startMainView = true
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(storeManager: StoreManager())
    }
}

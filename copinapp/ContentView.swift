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
    @State var entrySetDone = false
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

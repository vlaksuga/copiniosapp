//
//  ContentView.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import SwiftUI
import GoogleSignIn
import StoreKit

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @StateObject var storeManager = StoreManager()
    @State var showLoader = false
    @State var entrySetDone = false
    @State var showTestButton = true
    @State var storeMode = false
    
    let productIDs = [
        "com.vlaksuga.copinios.coin10",
        "com.vlaksuga.copinios.coin30"
    ]
    
    var body: some View {
        return Group {
            if entrySetDone {
                if storeMode {
                    PurchaseView(storeManager: storeManager)
                        .onAppear(perform: {
                            storeManager.getProducts(productIDs: productIDs)
                            SKPaymentQueue.default().add(storeManager)
                        })
                } else {
                    ZStack {
                        VStack(spacing: 0) {
                            WebView(viewModel: viewModel, urlType: .stageUrl, apiType: .stageAPI)
                                .onReceive(self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                                    self.showLoader = value
                                }
                        }
                        if showTestButton {
                            TestLoginView()
                        }
                        
                        if showLoader {
                            Loader()
                        }
                        
                    }
                }
            } else {
                EntryView(entrySetDone: $entrySetDone)
                    .onAppear(perform: EntryView(entrySetDone: $entrySetDone).checkVersion)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

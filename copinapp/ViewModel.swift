//
//  ViewModel.swift
//  copinapp
//
//  Created by Rockteki on 2021/02/24.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var webViewNavigationPublisher = PassthroughSubject<WebViewNavigation, Never>()
    var valuePublisher = PassthroughSubject<String, Never>()
    var authPublisher = PassthroughSubject<Bool, Never>()
    var showLoader = PassthroughSubject<Bool, Never>()
}

enum WebViewNavigation {
    case backward, forword, reload
}

enum WebUrlType {
    case publicUrl, stageUrl, devUrl
}

enum APIUrlType {
    case publicAPI, stageAPI, devAPI
}

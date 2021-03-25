//
//  NetworkMonitor.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/25.
//

import Foundation
import Network
import SwiftUI


class NetworkMonitor: ObservableObject {
    
    @Published var showAlert = false
    
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("Network connected")
            } else {
                print("No connection")
                // Show Alert
                self?.showAlert = true
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}


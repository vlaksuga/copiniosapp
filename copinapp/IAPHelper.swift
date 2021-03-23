//
//  IAPHelper.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/16.
//

import StoreKit

public typealias ProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

class IAPHelper: NSObject {
    
    private let productIdentifiers: [String]
    private var productRequest: SKProductsRequest?
    private var productRequestCompletionHandler: ProductRequestCompletionHandler?
    
    public init(productIds: [String]) {
        productIdentifiers = productIds
        super.init()
    }
    
    public func requestProducts(_ completionHandler: @escaping ProductRequestCompletionHandler) {
        productRequest?.cancel()
        productRequestCompletionHandler = completionHandler
//        productRequest = SKProductsRequest(productIdentifiers: InAppPruduct.productIdentifiers)
//        productRequest?.delegate = self
        productRequest?.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

//extension IAPHelper: SKProductsRequestDelegate {
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        <#code#>\]]]\
//    }
//}

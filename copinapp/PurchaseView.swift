//
//  PurchaseView.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/16.
//

import SwiftUI

struct PurchaseView: View {
    
    @StateObject var storeManager : StoreManager
    
    var body: some View {
        List(storeManager.myProducts, id:\.self) { product in
            HStack {
                VStack(alignment: .leading) {
                    Text(product.localizedTitle)
                        .font(.headline)
                    Text(product.localizedDescription)
                        .font(.caption2)
                }.padding()
                
                Spacer()
                
                Button(action: {
                    storeManager.purchaseProduct(product: product)
                }, label: {
                    Text("Buy for \(product.price) $")
                        .padding()
                })
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
}



struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(storeManager: StoreManager())
    }
}

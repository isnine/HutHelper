//
//  StoreHelper.swift
//  HutHelper
//
//  Created by nine on 2018/12/18.
//  Copyright © 2018 nine. All rights reserved.
//

import Foundation
import SwiftyStoreKit

public class StoreHelper {
    static func buy(productId: String) {
//        NoticeHelper.showThanks("感谢您")
        SwiftyStoreKit.purchaseProduct("name.wxz.huthelper.support", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                DispatchQueue.main.async {
                    NoticeHelper.showThanks("感谢您\(purchase.product.localizedTitle)")
                }
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
    }
}

public class StoreOCHelper: NSObject {
    static func storeLanuch() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased: \(purchase)")
                }
            }
        }
    }

}

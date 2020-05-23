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
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                DispatchQueue.main.async {
                    NoticeHelper.showThanks("感谢您\(purchase.product.localizedTitle)")
                }
            case .error(let error):
                switch error.code {
                case .unknown: NoticeHelper.showError("Unknown error. Please contact support")
                case .clientInvalid: NoticeHelper.showError("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: NoticeHelper.showError("The purchase identifier was invalid")
                case .paymentNotAllowed: NoticeHelper.showError("The device is not allowed to make the payment")
                case .storeProductNotAvailable: NoticeHelper.showError("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: NoticeHelper.showError("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: NoticeHelper.showError("Could not connect to the network")
                case .cloudServiceRevoked: NoticeHelper.showError("User has revoked permission to use this cloud service")
                default: NoticeHelper.showError((error as NSError).localizedDescription)
                }
            }
        }

    }
}

public class StoreOCHelper: NSObject {
    @objc
    static public func storeLanuch() {

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

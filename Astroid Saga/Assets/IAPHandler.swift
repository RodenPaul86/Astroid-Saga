//
//  IAPHandler.swift
//  Astroid Saga
//
//  Created by Paul on 10/19/18.
//  Copyright © 2018 Studio4Designsoftware. All rights reserved.
//

import UIKit
import SpriteKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!!"
        case .restored: return "You've successfully restored your purchase!!"
        case .purchased: return "You've successfully made this purchase!!"
        }
    }
}

class IAPHandler: NSObject {
    
    static let shared = IAPHandler()
    
    let save = UserDefaults.standard
    let CONSUMABLE_PURCHASE_PRODUCT1_ID = "Studio4DesignSoftware.AsteroidSaga.6Lives"
    let CONSUMABLE_PURCHASE_PRODUCT2_ID = "Studio4DesignSoftware.AsteroidSaga.8Lives"
    let CONSUMABLE_PURCHASE_PRODUCT3_ID = "Studio4DesignSoftware.AsteroidSaga.10Lives"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "Studio4DesignSoftware.AsteroidSaga.RemoveADs"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts() {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: CONSUMABLE_PURCHASE_PRODUCT1_ID, CONSUMABLE_PURCHASE_PRODUCT2_ID, CONSUMABLE_PURCHASE_PRODUCT3_ID, NON_CONSUMABLE_PURCHASE_PRODUCT_ID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    //Add any product here...
                    
                    if productID == CONSUMABLE_PURCHASE_PRODUCT1_ID {
                        addOns = true
                        lifeNumber += 6
                        save.set(true, forKey: "6LifesPurchased")
                        save.synchronize()
                        break
                    } else if productID == CONSUMABLE_PURCHASE_PRODUCT2_ID {
                        addOns = true
                        lifeNumber += 8
                        save.set(true, forKey: "8LifesPurchased")
                        save.synchronize()
                        break
                    } else if productID == CONSUMABLE_PURCHASE_PRODUCT3_ID {
                        addOns = true
                        lifeNumber += 10
                        save.set(true, forKey: "10LifesPurchased")
                        save.synchronize()
                        break
                    } else if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID {
                        addOns = true
                        removeAdBtn.removeFromParent()
                        removeAdBtnText.removeFromParent()
                        
                        save.set(true, forKey: "removeAdsPurchased")
                        save.synchronize()
                    }
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    break
                    
                default: break
                }}}
    }
}

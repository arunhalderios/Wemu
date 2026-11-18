
import Foundation
import StoreKit
import SwiftyJSON

class InAppPurchase : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let sharedInstance = InAppPurchase()
    
#if DEBUG
    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
#endif
    
    let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
    let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
    let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
    let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"
    
//    let unlockTestInAppPurchase1ProductId = "com.testing.iap1"
//    let unlockTestInAppPurchase2ProductId = "com.testing.iap2"
    let autorenewableSubscriptionProductId = "Monthpre"
//    let nonrenewingSubscriptionProductId = "com.wemo.subscription.monthly"
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        //self.fetchProductId()
        
    }
    
//    func fetchProductId(){
//        guard let url = Bundle.main.url(forResource: "PropertyList", withExtension: "plist") else { fatalError("Unable to resolve url for in the bundle.") }
//        do {
//            let data = try Data(contentsOf: url)
//            let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String]
//            validate(productIdentifiers: productIdentifiers!)
//            print(productIdentifiers as Any)
//        } catch let error as NSError {
//            print("\(error.localizedDescription)")
//        }
//    }
//
//    // Keep a strong reference to the product request.
//    var request: SKProductsRequest!
//
//    func validate(productIdentifiers: [String]) {
//         let productIdentifiers = Set(productIdentifiers)
//
//         request = SKProductsRequest(productIdentifiers: productIdentifiers)
//         request.delegate = self
//         request.start()
//    }
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        /* ... */
//        SKPaymentQueue.default().add(self)
//        return true
//    }
    
    
    
    func buyProduct(_ product: SKProduct) {
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error %@ \(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: error.localizedDescription)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Got the request from Apple")
        let count: Int = response.products.count
        if count >= 0 {
            _ = response.products
            let validProduct: SKProduct = response.products[0]
            print(validProduct.localizedTitle)
            print(validProduct.localizedDescription)
            print(validProduct.price)
            buyProduct(validProduct);
        }
        else {
            print("No products")
        }
    }
    

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple ::: \(transactions)");
        
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased ID ::: \(trans.payment.productIdentifier)")
                    
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductPurchasedNotification), object: nil)
                   // NotificationCenter.default.post(name: Notification.Name("subcription"), object: nil)
                    AuthService.instance.subcriptionAPI(transactionId: "\(String(describing: transaction.transactionIdentifier!))", completion: {(success, data, message) in
                        if success{
                            print(message as Any)
                            NotificationCenter.default.post(name: Notification.Name("subcription"), object: nil)

                        }else{
                            print(message as Any)
                        }
                    })
                 //   receiptValidation()
//                    print(trans.payment.productIdentifier as Any)
//                    print(transaction.original as Any)
//                    print(transaction.transactionIdentifier as Any)
                    break
                    
                case .failed:
                    print("Purchased Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchaseFailedNotification), object: nil)
                    break
                    
                case .restored:
                    print("Product Restored")
                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductRestoredNotification), object: nil)
                    break
                    
                default:
                    break
                }
            }
            else {
                
            }
        }
    }
    
    func savePurchasedProductIdentifier(_ productIdentifier: String!) {
        UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
        UserDefaults.standard.synchronize()
    }

    
    func receiptValidation() {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject] //, "password" : "dab3f8e770384d99ae7dda0096529a30" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    //print("Receipt Validation JSON RESPONSE::::::\(jsonResponse)")
                    let resultValue = SwiftyJSON.JSON(jsonResponse)
                    print("=============RESPONSE DATA==================")
                    print(resultValue)
                    
                    let allInApp = resultValue["receipt"]["in_app"].arrayValue
                    let idStr = allInApp[allInApp.count-1]["transaction_id"].stringValue
                    AuthService.instance.subcriptionAPI(transactionId: "\(idStr)", completion: {(success, data, message) in
                        if success{
                            print(message as Any)
                            NotificationCenter.default.post(name: Notification.Name("subcription"), object: nil)
                            
                        }else{
                            print(message as Any)
                        }
                    })
                    
//                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
//                        print(date)
//                    }
                } catch let parseError {
                    print("Receipt Validation parseError::::::\(parseError)")
                }
            })
            task.resume()
        } catch let parseError {
            print("Receipt Validation parseError::::::\(parseError)")
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {

            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func unlockProduct(_ productIdentifier: String!) {
        if SKPaymentQueue.canMakePayments() {
            let productID: NSSet = NSSet(object: productIdentifier as Any)
            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
            print("Fetching Products")
        }
        else {
            print("Сan't make purchases")
            NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: NSLocalizedString("CANT_MAKE_PURCHASES", comment: "Can't make purchases"))
        }
    }
    
//    func buyUnlockTestInAppPurchase1() {
//        unlockProduct(unlockTestInAppPurchase1ProductId)
//    }
//
//    func buyUnlockTestInAppPurchase2() {
//        unlockProduct(unlockTestInAppPurchase2ProductId)
//    }
//
    func buyAutorenewableSubscription() {
        unlockProduct(autorenewableSubscriptionProductId)
    }
//
    
//    func buyNonrenewingSubscription() {
//        unlockProduct(nonrenewingSubscriptionProductId)
//    }
    
    @available(iOS 11.0, *)
      func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
          print("================NEW TEST====================")
          print(payment)
        return true
      }

    
}

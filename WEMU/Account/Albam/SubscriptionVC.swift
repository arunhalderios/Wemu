//
//  SubscriptionVC.swift
//  WEMU
//
//  Created by Arun Halder on 12/09/22.
//

import UIKit
import InAppPurchase
import StoreKit

enum Constant {
    enum Product {
        static let subscription = "com.wemo.autoReNewSubscription.monthly"//"com.wemo.subscription.monthly"
    }
}

class SubscriptionVC: UIViewController{ //, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var vw_FreePlan: RoundView!
    @IBOutlet weak var vw_PaidPlan: RoundView!
    
    @IBOutlet weak var vw_CheckFreePlan: RoundView!
    @IBOutlet weak var vw_CheckProPlan: RoundView!
    
  //  let iap = InAppPurchase.default
    var transactions: [PaymentTransaction] = []
    let defaults = UserDefaults.standard
    var product_id: NSString?
    var proplan =  false
    var navFrom = ""
    
//#if DEBUG
//    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
//#else
//    let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
//#endif
//
//    let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
//    let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
//    let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
//    let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"
//
//
//    let nonrenewingSubscriptionProductId = "com.wemo.subscription.monthly"
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if self.navFrom == "otp"{
            let alert = UIAlertController(title: "WEMO", message: "Do you want to skip the scrbcription now?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
              print("Yes")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc,animated: true)
              }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if AuthService.instance.isSubcriptionApply == true{
                let storyboard = UIStoryboard(name: "Account", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                self.navigationController?.pushViewController(vc,animated: true)
            }
            else{
                if let nav = self.navigationController {
                        nav.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }


    @IBAction func action_FreePlan(_ sender: UIButton) {
        self.vw_FreePlan.borderWidth = 4.0
        self.vw_FreePlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.vw_PaidPlan.borderWidth = 0.0
        //self.vw_CheckFreePlan.isHidden = true
        //self.vw_CheckProPlan.isHidden = false
        self.proplan = false
    }
    
    
    @IBAction func action_PaidPlan(_ sender: UIButton) {
        self.vw_PaidPlan.borderWidth = 4.0
        self.vw_PaidPlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.vw_FreePlan.borderWidth = 0.0
      //  self.vw_CheckFreePlan.isHidden = true
      //  self.vw_CheckProPlan.isHidden = false
        self.proplan = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.vw_FreePlan.borderWidth = 4.0
        self.vw_FreePlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.vw_PaidPlan.borderWidth = 0.0
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.MyProfileAPICall()
            NotificationCenter.default.addObserver(self, selector: #selector(self.subcriptionDone), name: Notification.Name("subcription"), object: nil)
            
            if AuthService.instance.subcription == true{
                self.vw_PaidPlan.borderWidth = 4.0
                self.vw_PaidPlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                self.vw_FreePlan.borderWidth = 0.0
                self.vw_CheckFreePlan.isHidden = true
                self.vw_CheckProPlan.isHidden = false
            }else{
                self.vw_FreePlan.borderWidth = 4.0
                self.vw_FreePlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                self.vw_PaidPlan.borderWidth = 0.0
                self.vw_CheckFreePlan.isHidden = false
                self.vw_CheckProPlan.isHidden = true
            }
        }
    }
    
    @objc func subcriptionDone (notification: NSNotification){
        let alert = UIAlertController(title: "WEMO", message: "Successfully Subcription done for 1 month", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
          print("Successfully Subcription done for 1 month")
            if self.navFrom == "otp"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(vc,animated: true)
            }
            else{
                DispatchQueue.main.async {
                    self.MyProfileAPICall()
                }
            }

          }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: API CALL
        
        func MyProfileAPICall(){
            AuthService.instance.MyProfileAPI(completion: {(success, data, message) in
                if success{
                    if AuthService.instance.subcription == true{
                        self.vw_PaidPlan.borderWidth = 4.0
                        self.vw_PaidPlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                        self.vw_FreePlan.borderWidth = 0.0
                        self.vw_CheckFreePlan.isHidden = true
                        self.vw_CheckProPlan.isHidden = false
                    }else{
                        self.vw_FreePlan.borderWidth = 4.0
                        self.vw_FreePlan.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                        self.vw_PaidPlan.borderWidth = 0.0
                        self.vw_CheckFreePlan.isHidden = false
                        self.vw_CheckProPlan.isHidden = true
                    }
                }else{
                }
            })
        }



    
    @IBAction func btnPayment(_ sender: UIButton){
        print("About to fetch the products")
        if proplan == true{
            InAppPurchase.sharedInstance.buyAutorenewableSubscription()
           // HUD.show(to: self.view)
           // unlockProduct(nonrenewingSubscriptionProductId)
        }
        else{
            if AuthService.instance.subcription == true{
                
                let refreshAlert = UIAlertController(title: "WEMU", message: "Are you confirm to cancel the subcription?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                  print("Yes")
//                    AuthService.instance.removeSubcriptionAPI(completion: {(success, data, message) in
//                        if success{
//                            print(message as Any)
//                            self.showAlert(message: message!)
//                            self.MyProfileAPICall()
//
//                        }else{
//                            print(message as Any)
//                        }
//                    })
                    @available(iOS 15.0.0, *)
                        func showManageSubscription(_ windowScene: UIWindowScene) async {
                            do {
                                try await StoreKit.AppStore.showManageSubscriptions(in: windowScene)
                                print("Sheet is closed")
                            } catch {
                                print("Sheet can not be opened")
                            }
                        }

                  }))

                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("No")
                  }))

                present(refreshAlert, animated: true, completion: nil)

            }
        }
    }
    
//    func buyProduct(_ product: SKProduct) {
//      //  HUD.show(to: self.view)
//        print("Sending the Payment Request to Apple")
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment)
//        DispatchQueue.main.async {
//
//            HUD.hide(to: self.view)
//        }
//    }
//
//    func restoreTransactions() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Error %@ \(error)")
//        NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: error.localizedDescription)
//    }
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print("Got the request from Apple")
//        let count: Int = response.products.count
//        if count >= 0 {
//            _ = response.products
//            let validProduct: SKProduct = response.products[0]
//            print(validProduct.localizedTitle)
//            print(validProduct.localizedDescription)
//            print(validProduct.price)
//            buyProduct(validProduct);
//           // HUD.hide(to: self.view)
//
//        }
//        else {
//            print("No products")
//            self.showAlert(message: "No products found")
//            HUD.hide(to: self.view)
//
//
//        }
//    }
//
//
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        print("Received Payment Transaction Response from Apple");
//
//        for transaction: AnyObject in transactions {
//            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
//                switch trans.transactionState {
//                case .purchased:
//                    print("Product Purchased")
//
//                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductPurchasedNotification), object: nil)
//                    NotificationCenter.default.post(name: Notification.Name("subcription"), object: nil)
//                    AuthService.instance.subcriptionAPI(transactionId: "\(transaction.transactionIdentifier!)", completion: {(success, data, message) in
//                        if success{
//                            print(message as Any)
//                            NotificationCenter.default.post(name: Notification.Name("subcription"), object: nil)
//
//                        }else{
//                            print(message as Any)
//                        }
//                    })
//                    receiptValidation()
//                    print(trans.payment.productIdentifier as Any)
//                    print(transaction.original as Any)
//                    print(transaction.transactionIdentifier as Any)
//                    break
//
//                case .failed:
//                    print("Purchased Failed")
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchaseFailedNotification), object: nil)
//                    break
//
//                case .restored:
//                    print("Product Restored")
//                    savePurchasedProductIdentifier(trans.payment.productIdentifier)
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductRestoredNotification), object: nil)
//                    break
//
//                default:
//                    break
//                }
//            }
//            else {
//
//            }
//        }
//    }
//
//    func savePurchasedProductIdentifier(_ productIdentifier: String!) {
//        UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
//        UserDefaults.standard.synchronize()
//    }
//
//
//    func receiptValidation() {
//
//        let receiptFileURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptFileURL!)
//        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject] //, "password" : "dab3f8e770384d99ae7dda0096529a30" as AnyObject]
//
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let storeURL = URL(string: verifyReceiptURL)!
//            var storeRequest = URLRequest(url: storeURL)
//            storeRequest.httpMethod = "POST"
//            storeRequest.httpBody = requestData
//
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
//
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    print(jsonResponse)
//                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
//                        print(date)
//                    }
//                } catch let parseError {
//                    print(parseError)
//                }
//            })
//            task.resume()
//        } catch let parseError {
//            print(parseError)
//        }
//    }
//
//    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
//
//        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
//
//            let lastReceipt = receiptInfo.lastObject as! NSDictionary
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
//
//            if let expiresDate = lastReceipt["expires_date"] as? String {
//                return formatter.date(from: expiresDate)
//            }
//
//            return nil
//        }
//        else {
//            return nil
//        }
//    }
//
//    func unlockProduct(_ productIdentifier: String!) {
//
//        if SKPaymentQueue.canMakePayments() {
//            let productID: NSSet = NSSet(object: productIdentifier as Any)
//            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
//            productsRequest.delegate = self
//            productsRequest.start()
//            print("Fetching Products")
//           // HUD.hide(to: self.view)
//        }
//        else {
//            print("Сan't make purchases")
//            NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: NSLocalizedString("CANT_MAKE_PURCHASES", comment: "Can't make purchases"))
//            HUD.hide(to: self.view)
//
//        }
//    }

    func showAlert(message:String) {
        let alert = UIAlertController(title: "WEMO", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


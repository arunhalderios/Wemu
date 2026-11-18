//
//  webvwVC.swift
//  WEMU
//
//  Created by Arun Halder on 24/11/22.
//

import UIKit
import WebKit

class webvwVC: UIViewController {
    
    
    @IBOutlet weak var webVw: WKWebView!
    

    var urlStr = ""
    
    @IBAction func btn_Back(_ sender: UIButton){
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if urlStr != ""{
            DispatchQueue.main.async {
                let url = URL(string: "\(self.urlStr)")
                self.webVw.load(URLRequest(url: url!))
                }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

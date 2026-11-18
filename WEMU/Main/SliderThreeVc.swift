//
//  SliderThreeVc.swift
//  Tnevi
//
//  Created by Ivan on 12/02/21.
//

import UIKit

class SliderThreeVc: UIViewController {

    var delegate: SliderOneDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK:- Button action
    
     @IBAction func skipBtnPressed(_ sender: UIButton) {
//        print("LetsStartAction")
//        if delegate != nil {
//            self.delegate?.nextButtonTapped(index: 2)
//        }
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

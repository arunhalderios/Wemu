//
//  SliderOneVC.swift
//  Tnevi
//
//  Created by Ivan on 12/02/21.
//

import UIKit
import BmoViewPager


protocol SliderOneDelegate: AnyObject {
    func nextButtonTapped(index:Int)
}

class SliderOneVC: UIViewController {
    
    var delegate: SliderOneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipBtnPressed(_ sender: UIButton){
//        print("SliderOneVC - Next Button Pressed")
//        if delegate != nil {
//            self.delegate?.nextButtonTapped(index: 0)
//        }
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    


}

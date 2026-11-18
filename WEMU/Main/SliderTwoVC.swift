//
//  SliderTwoVC.swift
//  Tnevi
//
//  Created by Ivan on 12/02/21.
//

import UIKit

class SliderTwoVC: UIViewController {
    
    var delegate: SliderOneDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func skipBtnPressed(_ sender: UIButton) {
//        if delegate != nil {
//            self.delegate?.nextButtonTapped(index: 1)
//        }
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)

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

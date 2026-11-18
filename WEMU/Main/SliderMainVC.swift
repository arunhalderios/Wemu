//
//  SliderMainVC.swift
//  Tnevi
//
//  Created by Ivan on 12/02/21.
//

import UIKit
import BmoViewPager

class SliderMainVC: UIViewController {
  
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.splashScreenAPICall()

        viewPager.delegate = self
        viewPager.dataSource = self
    
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black   
    }
    
    //MARK: FUNCTIONS
    
    func splashScreenAPICall(){
        HUD.show(to: self.view)
        AuthService.instance.splashScreenAPI(completion: {(success, data, message) in
            if success{
                HUD.hide(to: self.view)
            }else{
                //print(message)
                HUD.hide(to: self.view)
            }
        })
    }
}

extension SliderMainVC: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 3
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SliderOneVC") as? SliderOneVC {
                vc.delegate = self
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SliderTwoVC") as? SliderTwoVC {
                vc.delegate = self
                return vc
            }
        case 2:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SliderThreeVc") as? SliderThreeVc {
                vc.delegate = self
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
}

extension SliderMainVC: BmoViewPagerDelegate {

    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        pageControl.currentPage = page
    }
}


extension SliderMainVC: SliderOneDelegate {
    func nextButtonTapped(index: Int) {
        print("index = \(index)")
        if index == 0{
            pageControl.currentPage = index + 1
            viewPager.presentedPageIndex = index + 1
        }else if index == 1 {
            pageControl.currentPage = index + 1
            viewPager.presentedPageIndex = index + 1
        }else{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

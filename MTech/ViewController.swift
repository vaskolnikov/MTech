//
//  ViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import JGProgressHUD
import PMAlertController

class ViewController: UIViewController {

    let hud = JGProgressHUD(style: .extraLight)
    //let n = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SPNativeColors.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(afterDelay: 0.5)
        }
    }
    
    func getTabbarHeight() -> CGFloat {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height
        return tabBarHeight ?? 50
    }
    
    func getStatusBarHeight() ->CGFloat {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
       // let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        return barHeight
    }

    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        //let build = dictionary["CFBundleVersion"] as! String
        //return "\(version) build \(build)"
        return "V \(version)"

    }
    
    func getHeightWithStatusBarAndNavigation() -> CGFloat{
        return topbarHeight
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Iptal", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
   

}

extension UIViewController {

/**
 *  Height of status bar + navigation bar (if navigation bar exist)
 */

    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var statusBarHeight:CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    func showAlertWithCallback(with title: String?, message: String, callback: @escaping () -> Void) {
        
        let alertVC = PMAlertController(title: title, description: message, image:nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Iptal", style: .cancel))
        alertVC.addAction(PMAlertAction(title: "Tamam", style: .default, action: {
            callback()
        }))
        
        if (self.presentingViewController != nil) {
            self.present(alertVC,animated: true)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true)
        }
        //self.present(alertVC,animated: true)

    }
    
    @objc func logout(){
        self.showAlertWithCallback(with: "Dikkat", message: "Cikis yapmak uzeresiniz. Giris icin yeniden kayit olmaniz gerekecektir.") {
            User.logout()
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.openApp()
            }
        }
    }
}



extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}




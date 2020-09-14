//
//  SplashViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UIViewControllerTransitioningDelegate {
    

    lazy var bg:SPView = {
        let i = SPView()
        i.frame = view.frame
        i.backgroundColor = SPNativeColors.white
        return i
    }()
    
    lazy var logo:SPImageView = {
        let i = SPImageView()
//        i.frame = CGRect(x: (view.frame.width / 2) - 75 , y: (view.frame.height / 2) - 75 , width: 150, height: 150)
        let image = UIImage(named: "mtech.png")
        i.image = image
        i.translatesAutoresizingMaskIntoConstraints = false

        return i
    }()
    
    
    lazy var version: SPLabel = {
        let l = SPLabel()
        l.frame = CGRect(x: 10, y: view.frame.height - 60, width: view.frame.width - 20, height: 30)
        l.textAlignment = .center
        l.font = Global.defaultFont
        l.textColor = .white
        l.text = (Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String)
        return l
    }()
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setupUI()
    }
   
    private func setupUI() {
        view.backgroundColor = Global.appColor
        view.addSubview(bg)
        view.addSubview(version)
        bg.addSubview(logo)
        
       logo.centerXAnchor.constraint(lessThanOrEqualTo: self.view.centerXAnchor).isActive = true
       logo.centerYAnchor.constraint(lessThanOrEqualTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        delay(2.0) {
            self.goToLogin()
        }
        

    }
    
    func goToLogin(){
        //let vc = LoginViewController()
        //self.navigationController?.pushViewController(viewController: vc, animated: true, completion: {
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.openApp()
            }
        //})
    }
    
    
}

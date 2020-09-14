//
//  RegisterViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 14.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit


import UIKit
import SkyFloatingLabelTextField
import FontAwesome_swift
import SPStorkController

class RegisterViewController: ViewController, UIScrollViewDelegate {

    let navBar = SPFakeBarView(style: .stork)
    var lightStatusBar: Bool = false
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height))
        s.delegate = self
        s.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 60)
        s.backgroundColor = .white
        return s
    }()

    
    lazy var seperator: SPSeparatorView = {
        let s = SPSeparatorView()
        s.frame = CGRect(x: 10, y: 40, width: view.frame.width - 20, height: 1)
        return s
    }()
    
    lazy var userField: SkyFloatingLabelTextField = {
        let u = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 20, width: view.frame.width - 20, height: 40))
         u.placeholder = "Isim/"
         u.title = "Isim"
         u.textContentType = .username
         u.font = UIFont(name: "Montserrat-Bold", size: 13)
        return u
    }()
    
    lazy var lastname: SkyFloatingLabelTextField = {
        let u = SkyFloatingLabelTextField(frame: CGRect(x: 10, y:  userField.frame.origin.y +   userField.frame.height + 10,
                                                        width: view.frame.width - 20,
                                                        height: 40))
         u.placeholder = "Soyisim"
         u.title = "Soyisim"
         u.textContentType = .username
         u.font = UIFont(name: "Montserrat-Bold", size: 13)
        return u
    }()
    
    lazy var email: SkyFloatingLabelTextField = {
        let u = SkyFloatingLabelTextField(frame: CGRect(x: 10, y:  lastname.frame.origin.y +   lastname.frame.height + 10,
                                                        width: view.frame.width - 20,
                                                        height: 40))
         u.placeholder = "email"
         u.title = "email"
         u.textContentType = .emailAddress
         u.font = UIFont(name: "Montserrat-Bold", size: 13)
        return u
    }()
    
    lazy var password: SkyFloatingLabelTextField = {
        let u = SkyFloatingLabelTextField(frame: CGRect(x: 10, y:  email.frame.origin.y +   email.frame.height + 10,
                                                        width: view.frame.width - 20,
                                                        height: 40))
         u.placeholder = "sifre"
         u.title = "sifre"
         u.textContentType = .password
         u.font = UIFont(name: "Montserrat-Bold", size: 13)
        return u
    }()
    

    

    
   
   // var membershipButton = SPButton()
    lazy var registerButton: SPButton = {
        let r = SPButton()
        r.setTitle("Üye Ol")
        r.frame = CGRect(x: 10,
                         y: view.frame.height - 160 - navBar.height,
                                      width: view.frame.width - 20 ,
                                      height: 40)
        r.setTitleColor(.white)
        r.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        r.titleLabel?.font =  UIFont(name: "Montserrat", size: 15)
        r.backgroundColor = Global.appColor
        r.rounded = true
        r.set(enable: true, animatable: true)
        r.addTarget(self, action: #selector(registerClicked), for: .touchUpInside)
        return r
    }()
    

    
    var user:User?


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        self.navBar.titleLabel.text = "Kayıt Ol"
        self.navBar.titleLabel.font =  UIFont(name: "Montserrat", size: 13)
        self.view.addSubview(self.navBar)
        view.backgroundColor = .white
        view.addSubview(scrollView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.scrollView.addGestureRecognizer(tapGesture)
   
        //scrollView.addSubview(seperator)
        scrollView.addSubview(userField)
        scrollView.addSubview(lastname)
        scrollView.addSubview(email)
        scrollView.addSubview(password)

        scrollView.addSubview(registerButton)

        scrollView.contentSize = CGSize(width: view.frame.width, height: registerButton.frame.origin.y + registerButton.frame.height + 30)

        addDoneButtonToTextFields()

    }
    
    func setTitle(title: String){
        self.navBar.titleLabel.text = title
    }
    
    @objc func registerClicked(sender: UIButton){
        self.showLoading()
        if self.email.text!.isEmpty || self.password.text!.isEmpty {
            self.showAlert(title: "hata", message: "email ve sifre  alani bos olamaz")
            self.hideLoading()
        } else {
            let name = self.userField.text ?? ""
            let lastname = self.lastname.text ??  ""
            let email = self.email.text!.lowercased()
            let password = self.password.text!.lowercased() 
            
            let user = User(username: name, email: email, lastName: lastname, password: password)
            
            delay(1.0) {
                 User.saveUser(user: user)
                 DispatchQueue.main.async {
                    
                   self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: Notification.Name("registered"),
                                                               object: nil,
                                                               userInfo:["registered":true])
                }
            }
            
        }
                
    }

    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        userField.resignFirstResponder()
        lastname.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()


    }
    
     private func addDoneButtonToTextFields() {
           
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action:#selector(self.dismissKeyboard (_:)))
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 15.0)!, NSAttributedString.Key.foregroundColor: SPNativeColors.purple], for: .normal)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.userField.inputAccessoryView = toolbar
        self.lastname.inputAccessoryView = toolbar

        self.email.inputAccessoryView = toolbar
        password.resignFirstResponder()


    }

    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items

        items[1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 15.0)!, NSAttributedString.Key.foregroundColor: SPNativeColors.purple], for: .normal)
        toolbar.sizeToFit()

        return toolbar
    }

    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView == self.scrollView {
             SPStorkController.scrollViewDidScroll(scrollView)
         }
     }
}



extension RegisterViewController: SPStorkControllerDelegate {
    
    func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }
      
    func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
   
}




//
//  LoginViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

import UIKit
import SkyFloatingLabelTextField
import FontAwesome_swift
import SPStorkController
import JGProgressHUD

class LoginViewController: ViewController, UITextFieldDelegate {
        
    
    var emailField = SkyFloatingLabelTextField()
    var password = SkyFloatingLabelTextField()
    
    var showPassword = UIButton()
    var loginButton = UIButton()
    var titleLabel = UILabel()
    var lightStatusBar: Bool = false
    
    var registerButton = UIButton()

        
    lazy var seperator: SPSeparatorView = {
        let s = SPSeparatorView()
        s.frame = CGRect(x: 10, y: 140, width: view.frame.width - 20, height: 1)
        return s
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        
        
        view.backgroundColor = SPNativeColors.customGray
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.registeredUser), name: Notification.Name("registered"), object: nil)
        
        self.title = "Login"
        emailField = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 100, width: view.frame.width - 20, height: 45))
        emailField.placeholder = "E-posta"
        emailField.title = "E-posta"
        emailField.textContentType = .emailAddress
        emailField.font = UIFont(name: "Montserrat-Bold", size: 13)
        emailField.delegate = self

        self.view.addSubview(emailField)
        
        password = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 145, width: view.frame.width - 20, height: 45))
        password.placeholder = "Şifre"
        password.title = "Şifreniz"
        password.textContentType = .password
        password.isSecureTextEntry = true
        password.font = UIFont(name: "Montserrat-Bold", size: 13)
        password.delegate = self

        // password.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.view.addSubview(password)
        
        showPassword = UIButton(frame: CGRect(x: view.frame.width - 40, y: 155, width: 30 , height: 30))
        showPassword.addTarget(self, action: #selector(showPasswordClicked), for: .touchUpInside)
        showPassword.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style:. solid)
        showPassword.setTitle(String.fontAwesomeIcon(name: .lock), for: .normal)
        showPassword.backgroundColor = Global.appColor
        showPassword.layer.cornerRadius = 15
        showPassword.layer.masksToBounds = true
        view.addSubview(showPassword)
        
        loginButton = UIButton(frame: CGRect(x: 10, y: 250, width: view.frame.width - 20 , height: 40))
        loginButton.setTitle("Giriş Yap", for: .normal)
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        loginButton.backgroundColor = Global.appColor
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font =  UIFont(name: "Montserrat", size: 14)
        
        registerButton = UIButton(frame: CGRect(x: 10, y: 300, width: view.frame.width - 20 , height: 40))
        registerButton.setTitle("Kayit Ol", for: .normal)
        registerButton.addTarget(self, action: #selector(registerClicked), for: .touchUpInside)
        registerButton.backgroundColor = SPNativeColors.purple
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = 10
        registerButton.titleLabel?.font =  UIFont(name: "Montserrat", size: 14)
        

        view.addSubview(loginButton)
        view.addSubview(registerButton)

        
        addDoneButtonToTextFields()
    }

    
    @objc func dismissView(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func loginClicked(sender: UIButton){
        print(#function)
        if let email = emailField.text?.lowercased(), let pass = password.text?.lowercased(), !emailField.isEmptyText, !password.isEmptyText {
            
            if email == User.currentUser()?.email?.lowercased() && pass == User.currentUser()?.password?.lowercased() {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.goToDashBoard()
                }
            } else {
                showAlert(title: "", message: "hatali kullanici adi/sifre")
            }
        
            
        } else {
            showAlert(title: "", message: "Email ve sifre giriniz.")
        }

    }
    
    @objc func registerClicked(sender: UIButton){
        
        let modal = RegisterViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        self.present(modal, animated: true, completion: nil)
    }
    
    @objc func registeredUser(notification: Notification) {
        
        if var registered = notification.userInfo?["registered"]{
            registered =  (notification.userInfo?["registered"])! as! Bool
            if registered as! Bool {
                let message = "eposta: " + (User.currentUser()?.email)! + " / sifre: " +   (User.currentUser()?.password)!
                DispatchQueue.main.async {
                    self.showAlert(title: "Giris bilgileriniz", message: message)
                }
            }
        }
    }
    
    @objc func showPasswordClicked(sender: UIButton){
        if sender.tag == 0 {
            password.isSecureTextEntry = false
            showPassword.setTitle(String.fontAwesomeIcon(name: .unlock), for: .normal)
            showPassword.tag = 1
        } else {
            password.isSecureTextEntry = true
            showPassword.setTitle(String.fontAwesomeIcon(name: .lock), for: .normal)
            showPassword.tag = 0
        }
    }
    
    private func addDoneButtonToTextFields() {
           
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action:#selector(self.dismissKeyboard (_:)))
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 15.0)!, NSAttributedString.Key.foregroundColor: SPNativeColors.purple], for: .normal)
//        doneBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SPNativeColors.purple], for: .normal)

        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.password.inputAccessoryView = toolbar
        self.emailField.inputAccessoryView = toolbar


    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        password.resignFirstResponder()
        emailField.resignFirstResponder()

    }
}


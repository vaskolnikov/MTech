//
//  ProfileFieldsCell.swift
//  MTech
//
//  Created by Adem Özsayın on 14.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol ProfileFieldsCellDelagete:class {
    func updateProfile(_ name: String, _ last: String, _ email:String)
    func textFieldDidChange( textfield: UITextField, tag:Int)
}
class ProfileFieldsCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate:ProfileFieldsCellDelagete? = nil
    var name = SkyFloatingLabelTextField()
    var lastname = SkyFloatingLabelTextField()
    var email = SkyFloatingLabelTextField()

    var saveTapped:Bool? = false {
        didSet {
            if let tapped = saveTapped, tapped {
                print(tapped)
                checkForRowAlert()
            }
        }
    }
    
    
   var rname = ""
   var rlastName = ""
   var remail = ""


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        name = SkyFloatingLabelTextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(name)
        
        name.placeholder = "Isim"
        name.title = "Isim"
        name.textContentType = .name
        name.font = UIFont(name: "Montserrat-Bold", size: 13)
        name.delegate = self
        name.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        name.tag = 0
       
        lastname = SkyFloatingLabelTextField()
        lastname.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lastname)
        
        
       lastname.placeholder = "soyisim"
       lastname.title = "soyisim"
       lastname.textContentType = .name
       lastname.font = UIFont(name: "Montserrat-Bold", size: 13)
       lastname.delegate = self
        lastname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastname.tag = 1


        email = SkyFloatingLabelTextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(email)
        
        email.placeholder = "email"
        email.title = "email"
        email.textContentType = .emailAddress
        email.font = UIFont(name: "Montserrat-Bold", size: 13)
        email.delegate = self
        email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        email.tag = 2

        
        NSLayoutConstraint.activate([
           
          
            name.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 40),
            
            lastname.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            lastname.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            lastname.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
    
            email.topAnchor.constraint(equalTo: lastname.bottomAnchor, constant: 10),
            email.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            email.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

             

        ])
        
        addDoneButtonToTextFields()


    }
    
    func setData(user:User){
        let currentUser = user
        if let name = currentUser.username {
            self.name.text = name
        }
        
        if let lastname = currentUser.lastName {
          self.lastname.text = lastname
        }
        
        if let email = currentUser.email {
            self.email.text = email
        }
    
    }
    
    func checkForRowAlert() {
        var nameValid: Bool  = true
        var lastNameValid: Bool = true
        var isEmailValid:Bool = true
        if rname == "" {
            name.errorMessage = "isim giriniz"
            nameValid = false
        } else {
            name.errorMessage = ""
        }
        
        if rlastName ==  "" {
            lastname.errorMessage = "soyisim giriniz"
            lastNameValid = false
        } else {
            lastname.errorMessage = ""
        }
        
        if remail == "" || !remail.isEmail {
            email.errorMessage = "gecersiz e posta"
            isEmailValid = false
        } else {
            email.errorMessage = ""
        }
        
        if nameValid && lastNameValid && isEmailValid  {
            delegate?.updateProfile(name.text!, lastname.text!, email.text!)
        }
        
        
    }
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
       name.resignFirstResponder()
       lastname.resignFirstResponder()
       email.resignFirstResponder()

    }
       
    private func addDoneButtonToTextFields() {
          
       let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.frame.size.width, height: 30))
       let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       
       let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action:#selector(self.dismissKeyboard (_:)))
       doneBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 15.0)!, NSAttributedString.Key.foregroundColor: SPNativeColors.purple], for: .normal)
       toolbar.setItems([flexSpace, doneBtn], animated: false)
       toolbar.sizeToFit()
       
       self.name.inputAccessoryView = toolbar
       self.lastname.inputAccessoryView = toolbar

       self.email.inputAccessoryView = toolbar


    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        delegate?.textFieldDidChange( textfield: textfield, tag: textfield.tag)
     }
}

extension ProfileFieldsCell {
    static let identifire = "ProfileFieldsCell"
}





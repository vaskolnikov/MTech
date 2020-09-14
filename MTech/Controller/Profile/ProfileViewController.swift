//
//  ProfileViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ProfileViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var tableView = UITableView()

    var currentUser:User?
    
    var save = SPButton()
    var saveTapped:Bool = false
    
    var name = ""
    var lastName = ""
    var email = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let user = User.currentUser()
        self.name = user?.username! as! String
        self.lastName = user?.lastName as! String
        self.email = user?.email as! String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profilim"
        setup()
    
    }
    
    func setup() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserPhotoCell.self, forCellReuseIdentifier: UserPhotoCell.identifire)
        tableView.register(ProfileFieldsCell.self, forCellReuseIdentifier: ProfileFieldsCell.identifire)
        tableView.separatorStyle = .none
        
        save = SPButton()
        save.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(save)
        save.setTitle("Kaydet", for: .normal)
        save.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        save.backgroundColor = Global.appColor
        save.layer.masksToBounds = true
        save.layer.cornerRadius = 10
        save.titleLabel?.font =  UIFont(name: "Montserrat", size: 14)

        
        NSLayoutConstraint.activate([
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
             tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -self.getTabbarHeight() - 70),
             
             save.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
             save.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             save.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
             save.heightAnchor.constraint(equalToConstant: 40),
             
             
        ])
        currentUser = User.currentUser()
        tableView.reloadData()

    }
    
    private func openPicker() {
        print(#function)
        let alert = UIAlertController(title: "Resim Secimi", message: "Bu resmi nereden seçmek istiyorsun?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kamera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Iptal", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        print(#function)
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            self.showLoading()
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print(#function)
           self.dismiss(animated: true) { [weak self] in

               guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
               //Setting image to your image view
                //self?.currentUser?.image = image
                let imageDefaults = UserDefaults()
                imageDefaults.setImage(image: image, forKey: "imageDefaults")

                let indexPath = IndexPath(item: 0, section: 0)
                DispatchQueue.main.async {
                   self?.tableView.reloadRows(at: [indexPath], with: .none)
                    self?.hideLoading()
               }
           }
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print(#function)
            self.hideLoading()
           picker.dismiss(animated: true, completion: nil)

       }
    
    @objc func saveClicked() {
        //print(#function)
        self.saveTapped = true
//        if self.name == "" || self.lastName ==  "" || self.email == "" {
//
//        }
        
        let indexPath = IndexPath(item: 0, section: 1)
                
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.saveTapped = false

        }
   
    }
}

extension ProfileViewController:UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
       
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPhotoCell.identifire, for: indexPath) as! UserPhotoCell
            cell.selectionStyle = .none
            cell.delegate = self
            if let user = User.currentUser() {
                cell.setData(user: user)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileFieldsCell.identifire, for: indexPath) as! ProfileFieldsCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setData(user: User.currentUser()!)
            cell.rname = self.name
            cell.remail = self.email
            cell.rlastName = self.lastName
            cell.saveTapped = self.saveTapped
            return cell
        default:
          return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0,1:
            return 160
        default:
            return UITableView.automaticDimension
        }
    }
    
}

extension ProfileViewController:UserPhotoCellDelegate {

    func openPhoto(cell: UITableViewCell, image: UIImage) {
        let imageInfo   = GSImageInfo(image: image, imageMode: .aspectFit)
        
        let transitionInfo = GSTransitionInfo(fromView: cell)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        imageViewer.dismissCompletion = {
            print("dismissCompletion")
        }
        present(imageViewer, animated: true, completion: nil)

    }

    
    func editPhoto() {
        self.openPicker()
    }
    
    
}


extension ProfileViewController:ProfileFieldsCellDelagete {
    func textFieldDidChange(textfield: UITextField, tag: Int) {
        //print(textfield)
        self.saveTapped = false

        DispatchQueue.main.async {
            if tag == 0 {
                self.name = textfield.text!
            }
            
            if tag == 1 {
               self.lastName  = textfield.text!
            }
            
            if tag == 2 {
                self.email = textfield.text!
            }
        }
    
        
    }
    
    func updateProfile(_ name: String, _ last: String, _ email: String) {
        self.showLoading()
        let newInfo = User(username: self.name, email: self.email, lastName: self.lastName, password: User.currentUser()?.password)
        
        User.saveUser(user: newInfo)
        
        delay(1.0) {
            self.hideLoading()
            let banner = GrowingNotificationBanner(title: "", subtitle: "Bilgilerininz guncellendi", style: .success)
            banner.show(bannerPosition: .top)
            _ = self.tabBarController?.selectedIndex = 0
        }
    }
    

    
    
}

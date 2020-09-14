//
//  UserPhotoCell.swift
//  MTech
//
//  Created by Adem Özsayın on 13.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol UserPhotoCellDelegate:class {
    func openPhoto(cell: UITableViewCell, image: UIImage)
    func editPhoto()
}

class UserPhotoCell: UITableViewCell {
    
    var userPhoto = SPImageView()
    var editButtonIcon = SPButton()
    var imageContainer = UIView()

    weak var delegate:UserPhotoCellDelegate? = nil
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
        imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageContainer)
        
        userPhoto = SPImageView()
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(userPhoto)
        let profileIcon = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
        userPhoto.image = profileIcon
//        userPhoto.layer.masksToBounds = true
//        userPhoto.layer.cornerRadius = 8
       
        userPhoto.applyshadowWithCorner(containerView: imageContainer, cornerRadious: 12)
        
        
        editButtonIcon = SPButton()
        editButtonIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(editButtonIcon)
        let editIcon = UIImage.fontAwesomeIcon(name: .edit, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
        editButtonIcon.setImage(editIcon)
        editButtonIcon.layer.masksToBounds = true
        editButtonIcon.layer.cornerRadius = 20
        editButtonIcon.layer.borderColor = Global.appColor.cgColor
        editButtonIcon.layer.borderWidth = 1
        
        
        
        let tapPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photoClicked))
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tapPhoto)
        
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(self.tappedEdit))
        editButtonIcon.isUserInteractionEnabled = true
        editButtonIcon.addGestureRecognizer(tapEdit)
        
        NSLayoutConstraint.activate([
            
            imageContainer.heightAnchor.constraint(equalToConstant: 160),
            imageContainer.widthAnchor.constraint(equalToConstant: 160),
        
            imageContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
           
            userPhoto.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            userPhoto.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            userPhoto.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            userPhoto.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant:  -20),

//
            editButtonIcon.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: -20),
            editButtonIcon.leadingAnchor.constraint(equalTo: userPhoto.trailingAnchor, constant: -20),
            editButtonIcon.heightAnchor.constraint(equalToConstant: 40),
            editButtonIcon.widthAnchor.constraint(equalToConstant: 40),

         ])
    }
    
    func setData(user:User) {
//        if user.image != nil {
//            userPhoto.image = user.image
//        } else {
//            let profileIcon = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
//            userPhoto.image = profileIcon
//        }
        let imageDefaults = UserDefaults()
        let bgImage = imageDefaults.imageForKey(key: "imageDefaults")!
        userPhoto.image = bgImage

    }
    
    @objc func photoClicked() {
        delegate?.openPhoto(cell: self, image: userPhoto.image!)
    }

    @objc func tappedEdit() {
        delegate?.editPhoto()
     }
}


extension UserPhotoCell {
    static let identifire = "UserPhotoCell"
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

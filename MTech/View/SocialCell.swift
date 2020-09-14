//
//  SocialCell.swift
//  MTech
//
//  Created by Adem Özsayın on 14.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

class SocialCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
   required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let buttonsView = SPView()
       buttonsView.translatesAutoresizingMaskIntoConstraints = false
       contentView.addSubview(buttonsView)
       buttonsView.backgroundColor = SPNativeColors.white
       
       buttonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0).isActive = true
       buttonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  0).isActive = true
       buttonsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
       buttonsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
       buttonsView.heightAnchor.constraint(equalToConstant: 60).isActive = true
       
       let buttonStackView = UIStackView()
       buttonStackView.translatesAutoresizingMaskIntoConstraints = false
       buttonsView.addSubview(buttonStackView)

   
       for i in 0...2 {
           let iconImageView = SPImageView()
           iconImageView.translatesAutoresizingMaskIntoConstraints = false
           iconImageView.contentMode = .scaleAspectFit
           var icon = UIImage.fontAwesomeIcon(name:.twitter , style: .brands, textColor: .white, size: CGSize(width: 25, height: 25))
           if i == 0 {
            icon = UIImage.fontAwesomeIcon(name:.pinterest , style: .brands, textColor: Global.appColor, size: CGSize(width: 25, height: 25))
           } else if i == 1 {
               icon = UIImage.fontAwesomeIcon(name:.twitter , style: .brands, textColor: Global.appColor, size: CGSize(width: 25, height: 25))
           } else {
               icon = UIImage.fontAwesomeIcon(name: .google, style: .brands, textColor: Global.appColor, size: CGSize(width: 25, height: 25))
           }
           iconImageView.image = icon
           iconImageView.tag = i
           //button.animateTap()
           
           buttonStackView.alignment = .center
           buttonStackView.distribution = .fillEqually
           buttonStackView.spacing = 10.0
           buttonStackView.addArrangedSubview(iconImageView)
            
       }
       
       buttonStackView.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0).isActive = true
       buttonStackView.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: 0).isActive = true
       buttonStackView.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: 0).isActive = true
       buttonStackView.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 0).isActive = true

    }
    
}

extension SocialCell {
    static let identifire = "SocialCell"
}

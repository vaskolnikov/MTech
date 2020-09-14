//
//  PharmacyCell.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol PharmacyCellDelegate:class{
    func topButtonTouched(indexPath:IndexPath)
    func openMap(pharmacy:Pharmacy)
}

class PharmacyCell: UICollectionViewCell {
    
    var pharmacy:Pharmacy?
    
    var topButton = SPButton()
    weak var delegate:PharmacyCellDelegate?
    let padding:CGFloat = 8
    
    var titleLabel = SPLabel()
    var districtLabel = SPLabel()
    var addressLabel = SPLabel()
    var phoneLabel = SPLabel()
    var mapImageView = SPImageView()

    public var indexPath:IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
       
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
    }
    
    func setup() {
        
        self.backgroundColor = .clear
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bgView)
        bgView.backgroundColor = SPNativeColors.white
        bgView.setshadowRadiusView(radius: 8, shadowRadiuss: 9, shadowheight: 3, shadowOpacity: 0.35, shadowColor: Global.appColor)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.topButtonTouched))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(tap)
        
        topButton = SPButton()
        topButton.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(topButton)
        let arrowUp = UIImage.fontAwesomeIcon(name: .arrowDown, style: .solid, textColor: Global.appColor, size: CGSize(width: 20, height: 20))
        topButton.setImage(arrowUp)
        topButton.addTarget(self, action: #selector(topButtonTouched), for: .touchUpInside)
        
        titleLabel = SPLabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(titleLabel)
        titleLabel.font = Global.Font.Cell.title
        
        districtLabel = SPLabel()
        districtLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(districtLabel)
        districtLabel.font = Global.Font.Cell.subtitle
        
        addressLabel = SPLabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(addressLabel)
        addressLabel.font = Global.Font.Cell.normalSubtitle
        addressLabel.numberOfLines = 2
        addressLabel.isHidden = true
        
        phoneLabel = SPLabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(phoneLabel)
        phoneLabel.font = Global.Font.Cell.normalSubtitle
        phoneLabel.isHidden = true
        

        mapImageView = SPImageView()
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(mapImageView)
        let mapIcon = UIImage.fontAwesomeIcon(name: .locationArrow, style: .solid, textColor: Global.appColor, size: CGSize(width: 20, height: 20))
        mapImageView.image = mapIcon
        mapImageView.isHidden = true
        
        let tapMap = UITapGestureRecognizer(target: self, action: #selector(self.seeOnMapClicked))
        mapImageView.isUserInteractionEnabled = true

        mapImageView.addGestureRecognizer(tapMap)

        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            
            topButton.widthAnchor.constraint(equalToConstant: 30),
            topButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -padding),
            topButton.topAnchor.constraint(equalTo: bgView.topAnchor, constant: padding),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            titleLabel.trailingAnchor.constraint(equalTo: topButton.leadingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: padding),
            
            districtLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            districtLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            districtLabel.topAnchor.constraint(equalTo: titleLabel  .bottomAnchor, constant: padding),
            
            addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            addressLabel.topAnchor.constraint(equalTo: districtLabel.bottomAnchor, constant: padding),

            phoneLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            phoneLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: padding),
            
            mapImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2 * padding),
            mapImageView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: padding),
            //mapImageView
            
            

        ])
    }
    
    func configure(pharmacy:Pharmacy, isExpanded:Bool) {
        self.pharmacy = pharmacy
        var icon:UIImage?
        if isExpanded {
            addressLabel.isHidden =  false
            phoneLabel.isHidden = false
            mapImageView.isHidden = false

            icon = UIImage.fontAwesomeIcon(name: .arrowUp, style: .solid, textColor: Global.appColor, size: CGSize(width: 20, height: 20))
        } else {
            icon = UIImage.fontAwesomeIcon(name: .arrowDown, style: .solid, textColor: Global.appColor, size: CGSize(width: 20, height: 20))
            addressLabel.isHidden = true
            phoneLabel.isHidden = true
            mapImageView.isHidden = true

        }
        topButton.setImage(icon!)
        titleLabel.text = pharmacy.name
        districtLabel.text = pharmacy.district
        addressLabel.text = pharmacy.address
        phoneLabel.text = pharmacy.phone!.isEmpty ? "Tel:-" : pharmacy.phone
        

    }

    @objc func topButtonTouched(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.topButtonTouched(indexPath: indexPath)
        }
    }
    
    @objc func seeOnMapClicked() {
        print(#function)
        if let delegate = self.delegate, let pharmacy = self.pharmacy {
            delegate.openMap(pharmacy: pharmacy)
        }
    }
}

extension PharmacyCell {
    static let identifier = "PharmacyCell"
}


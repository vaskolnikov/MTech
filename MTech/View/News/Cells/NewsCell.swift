//
//  NewsCell.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCell: UICollectionViewCell {
   
    var posterImageView = UIImageView()
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    let padding:CGFloat = 8
    
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
        bgView.backgroundColor = SPNativeColors.customGray
        bgView.addShadow(offset: CGSize(width: 0, height: 3), color: Global.appColor, radius: 3, opacity: 0.65, cornerRadius: 8)
        
        
        posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 8
        bgView.addSubview(posterImageView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.font = Global.Font.Cell.title
        titleLabel.text = ""
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(dateLabel)
        dateLabel.font = Global.Font.Cell.subtitle
        dateLabel.textAlignment = .right

        dateLabel.text = ""
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            
            posterImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: 0),
            posterImageView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -padding),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 2 * padding),
            
            dateLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -padding),
            dateLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -2 * padding),

        ])

        
    }
    
    func setData(data:Article)  {
        //print(data)
        titleLabel.text = data.title
        dateLabel.text = data.formateDate()?.timeAgoSinceDate
        DispatchQueue.main.async {
            self.posterImageView.sd_setImage(with: URL(string: data.imageUrl), completed: nil)
        }
    }
}


extension NewsCell {
    static let identifier = "NewsCell"
}

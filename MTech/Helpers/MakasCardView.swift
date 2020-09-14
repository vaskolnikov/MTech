//
//  MakasCardView.swift
//  Makas
//
//  Created by Adem Özsayın on 15.05.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit


class MakasCardView: UIView {
        
    lazy var bg: SPView = {
        let v = SPView()
        return v
    }()
    
    lazy var imageView: SPImageView = {
        let i = SPImageView()
        i.frame = CGRect(x: self.frame.width - 60, y: self.frame.height - 60, width: 50, height: 50)
        return i
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .gray)
        s.startAnimating()
        s.frame = CGRect(x: (self.frame.size.width/2 ) - 15, y: (self.frame.height/2) - 10 , width: 30, height: 30)
        s.color = SPNativeColors.purple
        return s
    }()
    
    lazy var title: SPLabel =   {
        let l = SPLabel()
        l.frame = CGRect(x: 10, y: 10, width: 100 , height: 20)
        l.font = UIFont(name: "Montserrat-Bold", size: 14)
        return l
    }()
    
    lazy var count: SPLabel =   {
        let l = SPLabel()
        l.frame = CGRect(x: 10, y: 30, width: 100, height: 50)
        l.font = UIFont(name: "Montserrat-Bold", size: 30)
        l.textColor = SPNativeColors.purple
        return l
    }()
    
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    private func setupView() {
        self.addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 8, opacity: 0.3, cornerRadius: 8)
        self.backgroundColor = SPNativeColors.white
        
        self.addSubview(bg)
        bg.addSubview(spinner)
        bg.addSubview(title)
        bg.addSubview(count)
        bg.addSubview(imageView)
    }

    func setTitle(title: String, image: UIImage){
        self.title.text = title
        self.imageView.image = image
    }
    
    func setCount(count:Int){
        delay(0.8) {
            self.count.text = String(count)
            self.spinner.stopAnimating()
        }
    }

}

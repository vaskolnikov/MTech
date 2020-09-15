//
//  MenuViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 14.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

    var tblMenuOptions =  UITableView()

    lazy var btnCloseMenuOverlay : UIButton = {
        let overlayButton = UIButton()
        overlayButton.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        overlayButton.addTarget(self, action: #selector(onCloseMenuClick), for: .touchUpInside)
        return overlayButton
        
    }()
    
    var arrayMenuOptions = [Dictionary<String,String>]()

    
    lazy var btnMenu : SPButton = {
        let btn = SPButton()
        btn.addTarget(self, action: #selector(onCloseMenuClick), for: .touchUpInside)
        return btn
    }()
    
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(btnCloseMenuOverlay)
        tblMenuOptions = UITableView()
        tblMenuOptions.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: view.frame.height)
        tblMenuOptions.delegate = self
        tblMenuOptions.dataSource = self
        view.addSubview(tblMenuOptions)
        tblMenuOptions.register(UITableViewCell.self, forCellReuseIdentifier: "menu")
        tblMenuOptions.register(SocialCell.self, forCellReuseIdentifier: SocialCell.identifire)
        tblMenuOptions.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
     func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"haberler", "icon":""])
        arrayMenuOptions.append(["title":"Eczeneler", "icon":""])
        arrayMenuOptions.append(["title":"Profil", "icon":""])

        tblMenuOptions.reloadData()
    }


    
    
    @objc func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "menu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = .clear//SPNativeColors.customGray
        
        let iconImageView = SPImageView()
        iconImageView.frame = CGRect(x: 16, y: 10, width: 30, height: 30)
        cell.addSubview(iconImageView)
        
        let menuName = UILabel()
        menuName.frame = CGRect(x: 60, y: 10, width: cell.frame.width - 112, height: 30)
//        menuName.backgroundColor = SPNativeColors.orange
        menuName.font = Global.Font.Cell.boldTitle
        cell.addSubview(menuName)
        
//        var icon  = UIImage.fontAwesomeIcon(name: .newspaper, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
        var icon = UIImage.init(icon: .fontAwesomeSolid(.newspaper), size: CGSize(width: 35, height: 35), textColor: Global.appColor)

        var name: String = "Haberler"
        
        if indexPath.row == 0 {
            name = "Haberler"
            icon = UIImage.init(icon: .fontAwesomeSolid(.newspaper), size: CGSize(width: 35, height: 35), textColor: Global.appColor)
//            icon = UIImage.fontAwesomeIcon(name: .newspaper, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
        } else  if indexPath.row == 1 {
//            icon = UIImage.fontAwesomeIcon(name: .fileMedical, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
            icon = UIImage.init(icon: .fontAwesomeSolid(.fileMedical), size: CGSize(width: 35, height: 35), textColor: Global.appColor)

            name = "Eczaneler"

        } else if indexPath.row == 2 {
            icon = UIImage.init(icon: .fontAwesomeSolid(.user), size: CGSize(width: 35, height: 35), textColor: Global.appColor)
//            icon = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
            name = "Profilim"

        } else if indexPath.row == 3 {
            icon = UIImage.init(icon: .fontAwesomeSolid(.signOutAlt), size: CGSize(width: 35, height: 35), textColor: .red)
//            icon = UIImage.fontAwesomeIcon(name: .signOutAlt, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
            name = "Cikis"
        } else {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: SocialCell.identifire) as! SocialCell
            return cell
        }

        iconImageView.image = icon
        menuName.text = name
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = SPNativeColors.pink
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

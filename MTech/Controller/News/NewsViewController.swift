//
//  NewsViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import SwiftSoup


class NewsViewController: ViewController, XMLParserDelegate, SlideMenuDelegate {
    
    var myFeed : NSArray = []
    var feedImgs: [AnyObject] = []
    var url: URL!
    
    var collectionView = SPCollectionView()
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MTEK"
        setupUI()
        loadData()
        
        addLogoutButton()
        
        addSlideMenuButton()

        
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
       let topViewController : UIViewController = self.navigationController!.topViewController!
       print("View Controller is : \(topViewController) \n", terminator: "")
    
        if index == 3 {
            self.logout()
        } else {
        _ = self.tabBarController?.selectedIndex = Int(index)

        }
   }
   
   
   func addSlideMenuButton(){
       let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
       btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
       btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       btnShowMenu.addTarget(self, action: #selector(NewsViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
       let customBarItem = UIBarButtonItem(customView: btnShowMenu)
       self.navigationItem.leftBarButtonItem = customBarItem;
   }

   func defaultMenuImage() -> UIImage {
       var defaultMenuImage = UIImage()
       
       UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
       
       UIColor.black.setFill()
       UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
       UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
       UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
       
       UIColor.white.setFill()
       UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
       UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
       UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
       
       defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
       
       UIGraphicsEndImageContext()
      
       return defaultMenuImage;
   }
   
   @objc func onSlideMenuButtonPressed(_ sender : SPButton){
       if (sender.tag == 10)
       {
           // To Hide Menu If it already there
           self.slideMenuItemSelectedAtIndex(-1);
           
           sender.tag = 0;
           
           let viewMenuBack : UIView = view.subviews.last!
           
           UIView.animate(withDuration: 0.3, animations: { () -> Void in
               var frameMenu : CGRect = viewMenuBack.frame
               frameMenu.origin.x = -4 * UIScreen.main.bounds.size.width
               viewMenuBack.frame = frameMenu
               viewMenuBack.layoutIfNeeded()
               viewMenuBack.backgroundColor = UIColor.clear
               }, completion: { (finished) -> Void in
                   viewMenuBack.removeFromSuperview()
           })
           
           return
       }
       
       sender.isEnabled = false
       sender.tag = 10
       
       let menuVC : MenuViewController = MenuViewController()
       menuVC.btnMenu = sender
       menuVC.delegate = self
       self.view.addSubview(menuVC.view)
       self.addChild(menuVC)
       menuVC.view.layoutIfNeeded()
       
       
       menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
       
       UIView.animate(withDuration: 0.3, animations: { () -> Void in
           menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
           sender.isEnabled = true
           }, completion:nil)
   }
    
    
    
    func setupUI() {

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width , height: 340)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
    
        collectionView = SPCollectionView()
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setConstraints()
  
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
              collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
              collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
              collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
              collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
   
    
  
    
    func addLogoutButton() {
        let button = SPButton()
        
//        let logoutIcon = UIImage.fontAwesomeIcon(name: .signOutAlt, style: .solid, textColor: SPNativeColors.white, size: CGSize(width: 30, height: 30))
        let logoutIcon = UIImage.init(icon: .fontAwesomeSolid(.signOutAlt), size: CGSize(width: 35, height: 35), textColor: .red)

        button.setImage(logoutIcon)
        button.addTarget(self, action:#selector(logout), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
    }
    func loadData() {
        self.showLoading()
        url = URL(string: "https://www.donanimhaber.com/rss/tum/")!
        loadRss(url);
    }
    
    func loadRss(_ data: URL) {
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        print(myFeed.count)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.hideLoading()

        }
    }


}

extension NewsViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath as IndexPath) as! NewsCell
        
        let title = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String ?? ""
        let date =  (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String ?? ""
        let url = (feedImgs[indexPath.row] as? String)  ?? ""
        
        let article = Article(title: title, date: date, imageUrl: url)
        cell.setData(data: article)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "link")  {
            let tColor = Global.appColor
            let title = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String ?? ""


            let nav = UINavigationController(rootViewController: WebViewController(url:URL(string: url as! String)!,
                                                                                 title: title,
                                                                                 textColor:tColor,
                                                                                 barColor: UIColor.white))
            present(nav, animated: true, completion: nil)
        }
    }
    
    
}



//extension NewsViewController: SideMenuNavigationControllerDelegate {
//
//    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appearing! (animated: \(animated))")
//    }
//
//    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Appeared! (animated: \(animated))")
//    }
//
//    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappearing! (animated: \(animated))")
//    }
//
//    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
//        print("SideMenu Disappeared! (animated: \(animated))")
//    }
//}

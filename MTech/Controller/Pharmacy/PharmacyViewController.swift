//
//  PharmacyViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

class PharmacyViewController: ViewController {

    var networkManager: NetworkManager!

    var collectionView = SPCollectionView()
    
    var cellWidth:CGFloat{
        return collectionView.frame.size.width
    }
    var expandedHeight : CGFloat = 180
    var notExpandedHeight : CGFloat = 80

    var isExpanded = [Bool]()
    var selectedCity:String = "istanbul"
    var selectedDistrict:String = ""
    var isDistrictSelected:Bool = false
    var selectedLabel = SPLabel()
    
    var pharmacies:[Pharmacy] = []
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - *** lifecycles ***

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPharmacies(notification:)),
                                                     name: Notification.Name("refreshPharmacies"),
                                                     object: nil)
        self.title = "Eczaneler"
        
        let button = SPButton()
        
        let filterIcon = UIImage.fontAwesomeIcon(name: .filter, style: .solid, textColor: SPNativeColors.white, size: CGSize(width: 30, height: 30))
        button.setImage(filterIcon)
        button.addTarget(self, action:#selector(filterClicked), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
        
        
        
        setupUI()
//        isExpanded = Array(repeating: false, count: pharmacies.count)
        if isDistrictSelected {
            loadData(city: selectedCity, district: selectedDistrict)
        } else {
            loadData(city: selectedCity, district: "")
        }

    }
    
    
    
    // MARK: - *** setupUI ***

    func setupUI() {

        selectedLabel = SPLabel()
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedLabel)
        NSLayoutConstraint.activate([
                  selectedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                  selectedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                  selectedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                  selectedLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        selectedLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        
        showFilteredText()
     

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width , height: 340)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = SPCollectionView()
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = SPNativeColors.customGray
        collectionView.register(PharmacyCell.self, forCellWithReuseIdentifier: PharmacyCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        setConstraints()
    
          
      }
      
      func setConstraints() {
          NSLayoutConstraint.activate([
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
          ])
      }
    
    func showFilteredText() {
        if isDistrictSelected {
             selectedLabel.text = self.selectedCity + "," + self.selectedDistrict
         } else {
            selectedLabel.text = self.selectedCity.uppercased()
         }
    }
    
    
    // MARK: - *** loadData ***

    func loadData(city:String, district:String) {
        self.showLoading()
        networkManager.sendRequest(route: .getPharmacy(city: city, district: district), [Pharmacy].self) { [weak self] (result, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let error = error {
                print(error)
            }
            if let result = result {
                //print("loaded")
                self.pharmacies = result.data ?? []
                self.isExpanded = Array(repeating: false, count: self.pharmacies.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

        }
    }
    
    @objc func filterClicked() {
        let vc = FilterViewController(networkManager: networkManager)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func refreshPharmacies(notification: Notification) {
        
        
        if let selectedCity = notification.userInfo?["selectedCityStr"] as? String {
            self.selectedCity =  selectedCity
        }
        if let selectedDistrict = notification.userInfo?["selectedDistrict"] as? String{
            self.selectedDistrict =  selectedDistrict
            if selectedDistrict.isEmpty {
                self.isDistrictSelected = false
            } else {
                self.isDistrictSelected = true
            }
        }
        
          DispatchQueue.main.async {
            self.loadData(city: self.selectedCity, district: self.selectedDistrict)
            self.showFilteredText()
          }
      }
 

}

// MARK: - *** UICollectionViewDelegate,UICollectionViewDataSource  ***

extension PharmacyViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pharmacies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PharmacyCell.identifier, for: indexPath) as! PharmacyCell
        cell.indexPath = indexPath
        cell.delegate = self
        let pharmacy = pharmacies[indexPath.row]
       //configure Cell
        cell.configure(pharmacy:pharmacy,isExpanded: isExpanded[indexPath.row])


        return cell
    }
    
}

// MARK: - *** UICollectionViewDelegateFlowLayout  ***

extension PharmacyViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if isExpanded[indexPath.row] == true {
             return CGSize(width: cellWidth, height: expandedHeight)
        }else{
            return CGSize(width: cellWidth, height: notExpandedHeight)
        }

    }

}

// MARK: - *** PharmacyCellDelegate  ***

extension PharmacyViewController:PharmacyCellDelegate{
    func openMap(pharmacy:Pharmacy) {
        print(pharmacy)
        if let location = pharmacy.location{
            let longitude = location.components(separatedBy: ",")[0]
            let latitude = location.components(separatedBy: ",")[1]
            
            let latDouble = Double(latitude)
            let longDouble = Double(longitude)

            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=17&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)&zoom=17&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
                
//                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
//                    UIApplication.shared.open(urlDestination)
//                }
            }
            
        }
       
    }
    
    func topButtonTouched(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
              self.collectionView.reloadItems(at: [indexPath])
            }, completion: { success in
                print("success")
        })
    }
}



//
//  FilterViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 13.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import Eureka
import JGProgressHUD

protocol FilterViewDelegate:class {
    func applyTapped(city:String, district:String)
}


class FilterViewController: FormViewController {

    let hud = JGProgressHUD(style: .extraLight)

    var networkManager: NetworkManager!
    weak var delegate:FilterViewDelegate? = nil
    
    var cities:[City] = []
    var districts:[District] = []
    var selectedCity:City?
    var selectedDistrict:District?
    
    var selectedCityStr = ""
    var selectedDistrictStr = ""

    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filtreleme"
        
        let button = SPButton()
        button.setTitle("Uygula")
        button.addTarget(self, action:#selector(applyChanges), for: .touchDragInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
        addForm()
        selectedCity = nil
        getCities()
        
       
    }
    
    private func addForm() {
        
        form +++
            Section("Filtreleme")
            
            <<< PushRow<City>("City") {
                $0.title = "Şehir Seçiniz"
                $0.options = cities
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.displayValueFor = {
                    if let t = $0 {
                        return t.name
                    }
                    return nil
                }
                $0.selectorTitle = "Şehir Seçimi"
                }.onChange { (row) in
                    self.selectedCity = row.value
                    //self.newShop?.cityId = self.selectedCity?.id
                    self.getDistricts(city:self.selectedCity!)
                }.onPresent { form, selectorController in
                    selectorController.enableDeselection = false //pushta rowlar ayni ise deselect yapmamasi icin
                }
                
                <<< PushRow<District>("District") {
                    $0.title = "İlçe Seçiniz"
                    $0.options = districts
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                    $0.displayValueFor = {
                        if let t = $0 {
                            return t.name

                        }
                      return nil
                    }
                    //"$0.value = ""
                    $0.selectorTitle = "İlçe Seçimi"
                    }.onChange { row in
                        self.selectedDistrict = row.value
                    }

    }
    
    private func getCities() {
        self.showLoading()
        DispatchQueue.global().async {
            self.networkManager.getCities { [weak self] (result, error) in
                guard let self = self else { return }
                if error != nil {
                    self.hideLoading()
                }
                guard let result = result else {
                    return
                }
                self.cities = result
                 DispatchQueue.main.sync {
                    self.hideLoading()

                    // update UI
                    let cityRow = self.form.rowBy(tag: "City") as! PushRow<City>
                    cityRow.options = self.cities
                    cityRow.reload()
                }
            }
        }
    }
    
    private func getDistricts(city: City) {
        self.showLoading()
        self.districts =  []
        
        networkManager.sendRequest(route: .getDistricts(city: (city.name?.lowercased())!), [District].self) { [weak self] (result, error) in
            guard let self = self else {  return }
            if let error = error {
                print(error)
                self.hideLoading()
           }
            guard let result = result else {
                return
            }
            self.districts = result.data ?? []
            let district = self.form.rowBy(tag: "District") as! PushRow<District>
            district.options = self.districts
            district.value = nil
            DispatchQueue.main.async {
                district.reload()
                self.hideLoading()
            }
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss(afterDelay: 0.5)
        }
    }
    
    @objc func applyChanges() {
         
        if let selectedDist = self.selectedDistrict {
            self.selectedDistrict = selectedDist
        } else {
            self.selectedDistrict = nil
        }
        
        if let selectedCity = self.selectedCity {
            self.selectedCityStr = selectedCity.name!
        } else {
            self.selectedCityStr = "istanbul"
        }
        
        NotificationCenter.default.post(name: Notification.Name("refreshPharmacies"),
                                                   object: nil,
                                                   userInfo: ["selectedCityStr": selectedCityStr, "selectedDistrict": selectedDistrict as Any ])
        
        delegate?.applyTapped(city: self.selectedCityStr, district:(selectedDistrict?.name)! )
        
        pop()
    }
    
    @objc func pop(){
        navigationController?.popViewController(animated: true)
    }
    
        

}

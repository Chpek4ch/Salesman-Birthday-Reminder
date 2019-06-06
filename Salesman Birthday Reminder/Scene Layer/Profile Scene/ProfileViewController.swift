//
//  ProfileViewController.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/25/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseDatabase

class ProfileViewController: UIViewController {

  
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var placeAndDateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statTextField: UITextField!
    @IBOutlet weak var editPlaceAndDateButton: UIButton!
    @IBOutlet weak var editAddressButton: UIButton!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var datePlaceLabel: UILabel!
    
    let firebaseManager = FirebaseManager()
    var mainData: MainData?
    var index: Int = 0
    var id: String?
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action:#selector(goToEditReminder))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(goToBack))
        cancelButton.changeColor()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Profile"
        
            
       
        placeAndDateTextField.isEnabled = false
        addressTextField.isEnabled = false
        cityTextField.isEnabled = false
        statTextField.isEnabled = false
    
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(setDateOfBirth))
      
        datePlaceLabel.isUserInteractionEnabled = true
        datePlaceLabel.addGestureRecognizer(dateTap)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            setup()
        
            ConnectionManager.sharedInstance.observeReachability(self)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }

    //MARK: Objc func for selector

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func setDateOfBirth() {
        let alert = UIAlertController(title: "Choose Date", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        
        let pickerFrame = UIDatePicker(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        pickerFrame.datePickerMode = .date
        
        
        let date = inputFormatter.date(from: dateOfBirthLabel.text!)
        pickerFrame.setDate(date!, animated: false)
        
        alert.view.addSubview(pickerFrame)
        
        
        
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            
            
            let newDate = inputFormatter.string(from: pickerFrame.date)
            self.date = newDate
            self.datePlaceLabel.text = newDate
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
            
            
        }))
        self.present(alert,animated: true, completion: nil )
        
    }
    
    
    @objc func goToBack(){
        if !checkTextField() {
            return
        }
        
        if editPlaceAndDateButton.titleLabel!.text == "SAVE" {
            editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        }
        
        if editAddressButton.titleLabel!.text == "SAVE" {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.743842721, green: 0.15671134, blue: 0.07229528576, alpha: 1)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func goToEditReminder(){
        
        if !checkTextField() {
            return
        }
        
        if editPlaceAndDateButton.titleLabel!.text == "SAVE" {
            editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
            
        }
        
        if editAddressButton.titleLabel!.text == "SAVE" {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.743842721, green: 0.15671134, blue: 0.07229528576, alpha: 1)
            return
        }
        
        let detailScene = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        detailScene?.isNew = false
        detailScene?.index = index
        navigationController?.pushViewController(detailScene!, animated: true)
        
        
    }
    
    
    
    
    //MARK: Private -
    
    
    
    private func setup(){
        bottomView.dropShadow(0.6)
        editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
        editPlaceAndDateButton.layer.borderWidth = 1.2
        editAddressButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
        editAddressButton.layer.borderWidth = 1.2
       
        imageIcon.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageIcon.layer.borderWidth = 2.5
        imageIcon.layer.cornerRadius = imageIcon.frame.height/2
       
        let data = MainDataManager.shared.currentData
        if let index = data!.index(where: { $0.id == id! }) {
            self.index = index
        }
        let currentData = data![index]
        
               mainData = currentData
               cosmosView.rating = currentData.slider
               nameLabel.text = currentData.name
               professionLabel.text = currentData.profession + " " + currentData.company
               emailLabel.text = currentData.email
               genderLabel.text = currentData.gender
               phoneLabel.text = currentData.phone
               placeAndDateTextField.text = currentData.placeAndDate
               addressTextField.text = currentData.address
               cityTextField.text = currentData.city
               statTextField.text = currentData.stat
               ageLabel.text = currentData.age
               dateOfBirthLabel.text = currentData.dateOfBirth
               imageIcon.image = currentData.image
               datePlaceLabel.text = currentData.dateOfBirth
        
    }
    
    
    
    private func checkTextField() -> Bool {
        
        var isCheck = true
        
        if placeAndDateTextField.text! == "" || placeAndDateTextField.text == nil {
            editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            isCheck = false
        }
        
        if addressTextField.text! == "" || addressTextField.text == nil {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.743842721, green: 0.15671134, blue: 0.07229528576, alpha: 1)
              isCheck = false
        }
        
        if cityTextField.text! == "" || cityTextField.text == nil {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.743842721, green: 0.15671134, blue: 0.07229528576, alpha: 1)
              isCheck = false
        }
        if statTextField.text! == "" || statTextField.text == nil {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.743842721, green: 0.15671134, blue: 0.07229528576, alpha: 1)
              isCheck = false
        }
        
        return isCheck
    }
    
    //MARK: Action -
   
    
    
    @IBAction func editPlaceAndDateAction(_ sender: UIButton) {
        
        
        if sender.tag == 0 {
            placeAndDateTextField.isEnabled = true
            editPlaceAndDateButton.setTitle("SAVE", for: .normal)
            sender.tag = 1
        } else {
            if !checkTextField() {
                return
            }
            let eventID = MainDataManager.shared.currentData![index].id
            let userID = UserDataManager.shared.currentData!.id
          
            firebaseManager.updatePlaceAndDateFromDatabese(placeAndDateTextField.text! + ", " + datePlaceLabel.text!, userID!, eventID)
            
            mainData!.placeAndDate = placeAndDateTextField.text!
            MainDataManager.shared.currentData![index] = mainData!
            editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
            placeAndDateTextField.isEnabled = false
            editPlaceAndDateButton.setTitle("EDIT", for: .normal)
            sender.tag = 0
        }
     
    }
    @IBAction func editAddressAction(_ sender: UIButton) {
      
        
        if sender.tag == 0 {
            
            addressTextField.isEnabled = true
            cityTextField.isEnabled = true
            statTextField.isEnabled = true
            editAddressButton.setTitle("SAVE", for: .normal)
            sender.tag = 1
        } else {
            if !checkTextField() {
                return
            }
          
            let eventID = MainDataManager.shared.currentData![index].id
            let userID = UserDataManager.shared.currentData!.id
            let values = ["stat": statTextField.text,"address":addressTextField.text,"city": cityTextField.text]
            firebaseManager.updateAddressFromDatabese(values, userID!, eventID)
            
            mainData!.address = addressTextField.text!
            mainData!.city = cityTextField.text!
            mainData!.stat = statTextField.text!

            MainDataManager.shared.currentData![index] = mainData!

            editAddressButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
            addressTextField.isEnabled = false
            cityTextField.isEnabled = false
            statTextField.isEnabled = false
            editAddressButton.setTitle("EDIT", for: .normal)
            sender.tag = 0
        }
        
    }
    
    
    @IBAction func validTextField(_ sender: UITextField) {
        print(sender.tag)
        if sender.text!.isEmpty && sender.tag == 0 {
            editAddressButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else if sender.tag == 3 {
             if sender.text!.isEmpty {
                editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
             } else {
                editPlaceAndDateButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
            }
        } else if !sender.text!.isEmpty && sender.tag == 0 {
             editAddressButton.layer.borderColor = #colorLiteral(red: 0.2793346643, green: 0.3937796056, blue: 0.8557699919, alpha: 1)
        }
        
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
}

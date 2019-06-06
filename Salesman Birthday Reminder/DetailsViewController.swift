//
//  DetailsViewController.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 07/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseStorage

class DetailsViewController: UITableViewController {
    
    //Section 1
    @IBOutlet weak var imageIconView: UIImageView!
    
    //Section 2
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var importanceView: CosmosView!
    
    //Section 3
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateOfBirthdayLabel: UILabel!
    
    //Section 4
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statTextField: UITextField!
    
    let calendarEvent = CalendarManager()
    let firebaseManager = FirebaseManager()
    var mainData: MainData?
    var mainDataArray = MainDataManager.shared.currentData!
    var age: String!
    var dateString: String!
    var eventID: String!
    var imageURL: String!
    var oldStartDate: String!
    
    var isNew: Bool = true
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventID = String.random()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveReminder))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(goToBack))
        cancelButton.changeColor()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "New Event"
        
        let imageTap = UITapGestureRecognizer()
        let dateTap = UITapGestureRecognizer()
      
        
        imageTap.addTarget(self, action: #selector(setImageIcon))
        dateTap.addTarget(self, action: #selector(setDateOfBirth))
        imageIconView.isUserInteractionEnabled = true
        dateOfBirthdayLabel.isUserInteractionEnabled = true
        imageIconView.addGestureRecognizer(imageTap)
        dateOfBirthdayLabel.addGestureRecognizer(dateTap)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       
    
        
        if !isNew {
             navigationItem.title = "Edit Event"
        }
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    //MARK: Objc func for selector
    
    @objc func setImageIcon(){
        ImagePicker.showPicker(self)
    }
    
    @objc func setDateOfBirth(){
        
        let alert = UIAlertController(title: "Choose Date", message: "\n\n\n\n\n\n\n", preferredStyle: .alert)
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        
        let pickerFrame = UIDatePicker(frame: CGRect(x: 5, y: 20, width: 250, height: 120))
        pickerFrame.datePickerMode = .date
        if !isNew {
            
            let date = inputFormatter.date(from: dateOfBirthdayLabel.text!)
            pickerFrame.setDate(date!, animated: false)
        }
        alert.view.addSubview(pickerFrame)
        
        
        
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            
          
            let newDate = inputFormatter.string(from: pickerFrame.date)
            self.dateOfBirthdayLabel.text = newDate
            self.dateString = newDate
         
            let today = Date()
            let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let age = gregorian.components([.year], from: pickerFrame.date, to: today, options: [])
            self.age = "\(age.year!) Years"
           
      
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
            
            
        }))
        self.present(alert,animated: true, completion: nil )
        
    }
    
    
    @objc func saveReminder(){
        
        if !checkTextField() {
            return
        }


        mainData = MainData(name: nameTextField.text!, city: cityTextField.text!, age: age!, image: imageIconView.image! ,slider: importanceView.rating,profession: professionTextField.text! , company: companyTextField.text!,dateOfBirth: dateString!, email: emailTextField.text!, gender: genderTextField.text!, phone: phoneTextField.text!, placeAndDate: cityTextField.text!, address: streetTextField.text!, stat: statTextField.text!,id: eventID,url: imageURL)

        let values =  ["name": nameTextField.text!, "city": cityTextField.text!, "age": age!,"slider": importanceView.rating,"profession": professionTextField.text! , "company": companyTextField.text!,"dateOfBirth": dateString!, "email": emailTextField.text!, "gender": genderTextField.text!, "phone": phoneTextField.text!, "placeAndDate": cityTextField.text!, "street": streetTextField.text!, "stat": statTextField.text!,"id": eventID,"imagePath":imageURL] as [String : Any]

        let userID = UserDataManager.shared.currentData!.id

        if mainDataArray.count == 0 {
            MainDataManager.shared.currentData! = [mainData!]
        } else if mainDataArray.count != 0 && !isNew {
            let eventID = MainDataManager.shared.currentData![index].id
            mainData?.id = eventID
            MainDataManager.shared.currentData![index] = mainData!
        
            firebaseManager.changeDataFromDatabese(values, userID!, eventID)
            navigationController?.popViewController(animated: true)
            
            calendarEvent.editEvent(id:eventID,title: "Today is a birthday of \(self.nameTextField.text!)", description: "Work Place: \(companyTextField.text!), age: \(age!), city: \(cityTextField.text!)", startDate: dateString!)
            return

        } else {
            MainDataManager.shared.currentData!.append(mainData!)
        }

        firebaseManager.sendDataToDatabase(values, userID!, eventID, self)
       
        
        
        
        
       
        calendarEvent.addEventToCalendar(id:eventID , title: "Today is a birthday of \(self.nameTextField.text!)", description: "Work Place: \(companyTextField.text!), age: \(age!), city: \(cityTextField.text!)", startDate: dateString!) { (res, error) in
                if error == nil {
                    print(res)
                } else {
                    print(error)
                }
            
            }
        
        navigationController?.popViewController(animated: true)
    }
    @objc func goToBack(){
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Private -
    
    private func setup(){
        
        imageIconView.layer.cornerRadius = imageIconView.frame.height/2
        imageIconView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageIconView.layer.borderWidth = 2.5
        importanceView.rating = 3
        
        
        if mainDataArray.count != 0 && !isNew {
            let currentData = MainDataManager.shared.currentData![index]

            importanceView.rating = currentData.slider
            nameTextField.text = currentData.name
            professionTextField.text = currentData.profession
            companyTextField.text = currentData.company
            emailTextField.text = currentData.email
            genderTextField.text = currentData.gender
            phoneTextField.text = currentData.phone
            streetTextField.text = currentData.address
            cityTextField.text = currentData.city
            statTextField.text = currentData.stat
            dateOfBirthdayLabel.text = currentData.dateOfBirth
            dateString = currentData.dateOfBirth
            eventID = currentData.id
            age = currentData.age
            imageIconView.image = currentData.image
            imageURL = currentData.url
            oldStartDate = currentData.dateOfBirth
            
        }
        nameTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        professionTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
      //  companyTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        emailTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        genderTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        phoneTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        streetTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        cityTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
     //   statTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
     
    }
    
    
    private func checkTextField() -> Bool {
        
        
        var isCheck = true
        
        if nameTextField.text! == "" || nameTextField.text == nil {
            nameTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
             nameTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        if imageURL == nil {
                isCheck = false
                Alert.emptyImagelAlert(message: "Please add image", self)
                self.imageIconView.image = #imageLiteral(resourceName: "profile-placeholder")
        }
        
        if professionTextField.text! == "" ||  professionTextField.text == nil {
            professionTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            professionTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        
        if companyTextField.text! == "" || companyTextField.text == nil {
            companyTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            companyTextField.useUnderline(#colorLiteral(red: 0.9316040277, green: 0.9424723983, blue: 0.9692627788, alpha: 1))
        }
        
        if  !emailTextField.text!.isValidEmail() {
            emailTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            emailTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        
        if genderTextField.text! == "" || genderTextField.text == nil {
            genderTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            genderTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        
        
        if !phoneTextField.text!.isPhoneNumber {
            phoneTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            phoneTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }

        
        if streetTextField.text! == "" || streetTextField.text == nil {
            streetTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            streetTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        
        if cityTextField.text! == "" || cityTextField.text == nil {
            cityTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
            
        } else {
            cityTextField.useUnderline(#colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1))
        }
        if statTextField.text! == "" || statTextField.text == nil {
            statTextField.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            statTextField.useUnderline(#colorLiteral(red: 0.9316040277, green: 0.9424723983, blue: 0.9692627788, alpha: 1))
        }
        
        if dateOfBirthdayLabel.text! == "" || dateOfBirthdayLabel.text == nil || dateOfBirthdayLabel.text == "day/month/year"{
            dateOfBirthdayLabel.useUnderline(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            isCheck = false
        } else {
            dateOfBirthdayLabel.useUnderline(#colorLiteral(red: 0.9316040277, green: 0.9424723983, blue: 0.9692627788, alpha: 1))
        }
        
        
        
        return isCheck
    }
  
   

    //MARK: Actions -
    
    
   
    @IBAction func setGender(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 150)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: -150/2/2, width: 250, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose Gender", message: "", preferredStyle: .alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
   
    
}



extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK : ImagePickerDelegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       
        var data = Data()
        data = uiImage.jpeg(.lowest)!
        let dispatch = DispatchManager()
        dispatch.dispatchTrhead({
            self.firebaseManager.sendImageToFirebase(data, self.eventID) { (url) in
                self.imageURL = url
                print("Before \(self.imageURL!)")
                self.imageIconView.image = uiImage
                picker.dismiss(animated: false, completion: nil)
            }
        }) {
        }
        
      
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
}

extension DetailsViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
      
        return true
    }
    
}


extension DetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ["Male","Female","Transgender","They"][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genderTextField.text = ["Male","Female","Transgender","They"][row]
        self.view.endEditing(true)
    }
    
   
   
}

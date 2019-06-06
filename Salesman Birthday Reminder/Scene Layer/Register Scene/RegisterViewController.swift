//
//  RegisterViewController.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 09/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: PaddedTextField!
    @IBOutlet weak var passTextField: PaddedTextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let activity = ViewControllerUtils()
    let dispatch = DispatchManager()
    var firebaseManager: FirebaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        navigationItem.title = "Register"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: false)
        setup()
        
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager = FirebaseManager()
        //  self.hideKeyboard()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
     
    }
    
    //MARK: Private -
    
    private func setup(){
        emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.paddingPlaceholder()
        passTextField.paddingPlaceholder()
        passTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        passTextField.layer.borderWidth = 0.5
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        passTextField.layer.sublayerTransform = CATransform3DMakeTranslation(19, 0, 0)
        emailTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "email"))
        passTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "pass"))
        imageView.layer.cornerRadius = 3
    }
    
    
    
    //MARK: Action -
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        let email = emailTextField.text!
        let pass = passTextField.text!
        
        if !email.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        } else {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        }
        
        
        activity.showActivityIndicator(uiView: self.view)
        dispatch.dispatchTrhead({
            self.firebaseManager.signUpFromFirebase(self,email, pass)
        }) {
            self.activity.hideActivityIndicator(uiView: self.view)
        }
       
  
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}



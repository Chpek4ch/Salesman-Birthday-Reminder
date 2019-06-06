//
//  ForgotPassViewController.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 09/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit

class ForgotPassViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: PaddedTextField!
    
    var firebaseManager: FirebaseManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.paddingPlaceholder()
        emailTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "email"))
        
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        navigationItem.title = "Forgot Password"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        firebaseManager = FirebaseManager()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
   
    @IBAction func sendEmailAction(_ sender: Any) {
         let email = emailTextField.text!
        
        if !email.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        } else {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        }
        
        firebaseManager.callFIRPasswordReset(email: email, self)
        
    }
    @IBAction func setEmailText(_ sender: UITextField) {
        if !sender.text!.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        } else {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        }
    }
    
}


class PaddedTextField: UITextField {
    
   
        
        let padding = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 5)
        
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    
}


extension ForgotPassViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

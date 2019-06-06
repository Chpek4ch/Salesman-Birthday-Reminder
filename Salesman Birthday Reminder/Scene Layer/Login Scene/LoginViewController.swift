//
//  LoginViewController.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 04/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit




class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: PaddedTextField!
    @IBOutlet weak var passTextField: PaddedTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    
    
    let man = CalendarManager()
    let activity = ViewControllerUtils()
    let dispatch = DispatchManager()
    let userDefault = UserDefaultManager()
    var firebaseManager: FirebaseManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        navigationItem.title = "Sign In"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9357321858, green: 0.9450692534, blue: 0.9666672349, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
      
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseManager = FirebaseManager()
        setup()
         ConnectionManager.sharedInstance.observeReachability(self)
                    userDefault.getUser { (email, pass,isHave) in
                        if isHave {
                        self.sendFireBaseRequest(email,pass)
                        }
                    }
          self.navigationItem.setHidesBackButton(true, animated:true)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         emailTextField.text = ""
         passTextField.text = ""
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    //MARK: Objc func for selector
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: Private -
    
    
    
    private func setup(){
        emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        emailTextField.layer.borderWidth = 0.5
        emailTextField.paddingPlaceholder()
        passTextField.paddingPlaceholder()
        emailTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "email"))
        passTextField.leftView = UIImageView(image: #imageLiteral(resourceName: "pass"))
        passTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        passTextField.layer.borderWidth = 0.5
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(19, 0, 0)
        passTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        imageView.layer.cornerRadius = 3

    }
    
    private func checkButton(){
        if emailTextField.text == "" && passTextField.text == "" {
            logInButton.isEnabled = false
        } else {
            logInButton.isEnabled = true
        }
    }
    private func sendFireBaseRequest(_ email: String, _ pass: String){
        
        if ConnectionManager.sharedInstance.network == "3" {
            return
        }
       
        
        firebaseManager.signInFromFirebase(email, pass, {
            Alert.signInAlert(message: "The email or password is incorrect", self)
            return
        }) {
            
            UserDataManager.shared.currentData!.email = email
            UserDataManager.shared.currentData!.pass = pass
            let mainScene = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
            self.navigationController?.pushViewController(mainScene!, animated: true)
            self.userDefault.saveUser(email, pass)
        }
    }
    
 
    
    //MARK: Action -
    

    
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        let email = emailTextField.text!
        let pass = passTextField.text!
        
        if !email.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return
        } else {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        }
        
        self.sendFireBaseRequest(email,pass)
        
    }
    
    
    @IBAction func goToRegisterView(_ sender: Any) {
        let registScene = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        navigationController?.pushViewController(registScene!, animated: true)
    }
    @IBAction func gotoForgotPassView(_ sender: Any) {
        let forgotPassScene = storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as? ForgotPassViewController
        navigationController?.pushViewController(forgotPassScene!, animated: true)
    }
    
    @IBAction func emailTextField(_ sender: UITextField) {
        if !sender.text!.isValidEmail() {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            emailTextField.layer.borderColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        }
    }
    
    
}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkButton()
        
        return true
    }
    
}

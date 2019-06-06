//
//  FirebaseManager.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 08/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FirebaseManager {

    let databaseRef = Database.database().reference(fromURL: "https://birthday-calendar-a447b.firebaseio.com/")
    let storageRef = Storage.storage().reference(forURL: "gs://birthday-calendar-a447b.appspot.com/")
    let calendar = CalendarManager()
    
    //MARK: Public -
    
    public func sendImageToFirebase(_ data: Data,_ eventID: String,_ closure: @escaping (String)->())  {
      
                let storaChild = storageRef.child("images/icon").child(eventID)
        
                _ = storaChild.putData(data, metadata: nil, completion: { (metadata, error) in
        
                    let downURL = storaChild.downloadURL(completion: { (url, error) in
                        if error != nil {
                            return
                        } else {
                            closure("\(url!)")
                          
                        }
                   
                    })
            })
        
       
    }
    
    
    
    public func sendDataToDatabase(_ values: [String:Any],_ userID: String,_ eventID: String, _ vc: UIViewController){
        let usersChild = databaseRef.child("user").child(userID).child("data").child(eventID)
        usersChild.setValue(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            vc.dismiss(animated: true, completion: nil)
            
           
            print("Пользователь успешно сохранил объявление в Firebase")
    })
        
    }
    
    
    public func changeDataFromDatabese(_ values: [String:Any],_ userID: String,_ eventID: String){
        let userChild = databaseRef.child("user").child(userID).child("data").child(eventID)
        userChild.updateChildValues(values)
    }
    
    public func updatePlaceAndDateFromDatabese(_ placeAndDate: String,_ userID: String,_ eventID: String){
        let userChild = databaseRef.child("user").child(userID).child("data").child(eventID)
        userChild.updateChildValues(["placeAndDate": placeAndDate])
    }
    public func updateAddressFromDatabese(_ values: [String:Any],_ userID: String,_ eventID: String){
        let userChild = databaseRef.child("user").child(userID).child("data").child(eventID)
        userChild.updateChildValues(values)
    }
    
    public func removeDataFromDatabese(_ eventID: String, _ idData: String){
        let fb = databaseRef.child("user").child(eventID).child("data").child(idData)
        
        fb.removeValue { error, _ in
        }
    }
    
    public func loadDataFromDatabese(_ closure: @escaping ()->()){
        databaseRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String: [String: [String: Any]] ]else {
                return
            }
            
            if let user = dict["user"]  {
                    for values in user.values {
                          let email = values["email"] as? String
                        let userEmail = UserDataManager.shared.currentData!.email!
                            if email == userEmail {
                                let id = values["id"]
                                UserDataManager.shared.currentData!.id = "\(id!)"
                            }
                        }
                    }
            
            guard let user = dict["user"]![UserDataManager.shared.currentData!.id!]!["data"] as? [String:Any] else {
                return
            }
            
            for data in user {
                 let value = data.value as! [String:Any]
                 let imagePath = value["imagePath"] as! String
                 let imageURL = URL(string: imagePath)
                
                ImageLoader.image(for: imageURL!) { image in
                    if image == nil {
                        return
                    }
                    let mainData = MainData(name: value["name"]! as! String, city: value["city"]! as! String, age: value["age"]! as! String, image: image!,slider: value["slider"]! as! Double, profession: value["profession"]! as! String, company: value["company"]! as! String, dateOfBirth: value["dateOfBirth"]! as! String, email: value["email"]! as! String, gender: value["gender"]! as! String, phone: value["phone"]! as! String, placeAndDate: value["placeAndDate"]! as! String, address: value["street"]! as! String, stat: value["stat"]! as! String,id: value["id"]! as! String,url: value["imagePath"] as! String)
                    
                    
                    
                    
                    MainDataManager.shared.currentData!.append(mainData)
                    closure()
                   
                    
                }
                
               
                
                
                
        
            }
            
            
            
            
        })
    }
    
    
    
    public func logoutUser(){
        try! Auth.auth().signOut()
    }
    
    
    public func signInFromFirebase(_ email: String, _ pass: String,_ errorClosure : @escaping ()->(),_ userClosure : @escaping ()->()) {
        
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            
            if let _eror = error {
                //something bad happning
             
                print(_eror.localizedDescription )
                errorClosure()
            } else {
                //user registered successfully
                print(user)
                userClosure()
            }
        }
        
    }
    
    public func signUpFromFirebase(_ vc: UIViewController, _ email: String, _ pass: String) {
        

        Auth.auth().createUser(withEmail: email, password: pass) { (User, error) in
            if let _eror = error {
                Alert.registerAlert(message: "Something went wrong", vc)
                
                print(_eror.localizedDescription )
            } else {
                //user registered successfully
                self.signInFromFirebase(email, pass, {
                    Alert.signInAlert(message: "The email or password is incorrect", vc)
                    return
                }) {
                let mainScene = vc.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                vc.navigationController?.pushViewController(mainScene!, animated: true)
                UserDefaultManager().saveUser(email, pass)
                
                
            }
                
            }
        
        
        guard let uid = Auth.auth().currentUser?.uid else  {
            return
        }
        
        let values = ["email": email, "pass": pass, "id": uid]
        
        UserDataManager.shared.currentData?.email = email
        UserDataManager.shared.currentData?.pass = pass
        UserDataManager.shared.currentData?.id = uid
        
        
            let usersReference = self.databaseRef.child("user").child(uid)
        usersReference.setValue(values, withCompletionBlock: { (err, ref) in
            if err != nil {
               
                return
            }
            vc.dismiss(animated: true, completion: nil)
            print("Пользователь успешно сохранил объявление в Firebase")
        })
        print(uid)
        
        
    }
        
    }
    
    func callFIRPasswordReset(email: String,_ vc: UIViewController){
        //show loader
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            DispatchQueue.main.async {
                //hide loader
                
                
                
                if let error = error {
                    Alert.forgotAlert(message: "Something went wrong", vc)
                    
                    print(error.localizedDescription)
                }
                else {
                    //show alert here
                   
                    Alert.forgotAlert(message: "We send you an email with instructions on how to reset your password.", vc)
                }
            }
        }
    }
    
   
        
}


class ImageLoader {
    
    private static let cache = NSCache<NSString, NSData>()
    
    class func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            if let data = self.cache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
                return
            }
            
            guard let data = NSData(contentsOf: url) else {
                DispatchQueue.main.async { completionHandler(nil) }
                return
            }
            
            self.cache.setObject(data, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
        }
    }
    
}

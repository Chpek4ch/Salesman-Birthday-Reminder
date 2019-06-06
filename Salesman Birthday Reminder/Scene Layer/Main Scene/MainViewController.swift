//
//  ViewController.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/21/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseDatabase
import FirebaseAuth
import Firebase


class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
  
    let calendar = CalendarManager()
    let userDefault = UserDefaultManager()
    let firebaseManager = FirebaseManager()
    var image: UIImage?
    var sotredMainData = [MainData]()
    var isSorted = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let logoutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .done, target: self, action: #selector(logoutUser))
        
        searchBar.delegate = self
        firebaseManager.loadDataFromDatabese {
            self.sotredMainData = MainDataManager.shared.currentData!
            self.checkCount()
            self.calendar.checkEvent(id: MainDataManager.shared.currentData!.last!.id, title: "Today is a birthday of \(self.sotredMainData.last!.name)", description: "Work Place: \(self.sotredMainData.last!.profession), age: \(self.sotredMainData.last!.age), city: \(self.sotredMainData.last!.city)", startDate:  self.sotredMainData.last!.dateOfBirth)
            self.tableView.reloadData()
        }
        
        navigationItem.rightBarButtonItems = [ logoutButton,UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCell(_:))) ]
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ConnectionManager.sharedInstance.observeReachability(self)
        if !isSorted {
            self.sotredMainData = MainDataManager.shared.currentData!
        }
        self.checkCount()
        tableView.reloadData()
        self.navigationItem.setHidesBackButton(true, animated:true)
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    //MARK: Objc func for selector -
    
    @objc func logoutUser(){
        Alert.logoutAlert(message: "You will be returned to the login screen", self) {
            MainDataManager.shared.currentData!.removeAll()
            self.sotredMainData.removeAll()
            self.firebaseManager.logoutUser()
            self.userDefault.clearUser()
            let loginScene = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            self.navigationController?.pushViewController(loginScene!, animated: true)
        }
        
    }
    
  //MARK: Privat -
    
   private func checkCount() {
        if sotredMainData.count == 0 {
            searchBar.isHidden = true
        } else {
            searchBar.isHidden = false
        }
    }
  
    //MARK: Action -

    @IBAction func addCell(_ sender: Any) {
        
        let detailScene = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        navigationController?.pushViewController(detailScene!, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return sotredMainData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainViewCell
        cell.nameLabel.text = sotredMainData[indexPath.row].name
        cell.cityLabel.text = sotredMainData[indexPath.row].city
        
       
        
        if sotredMainData[indexPath.row].slider == 1 {
                cell.titleImageView.backgroundColor = #colorLiteral(red: 0.2785027027, green: 0.392806083, blue: 0.8564508557, alpha: 1)
        } else if sotredMainData[indexPath.row].slider == 2 {
                cell.titleImageView.backgroundColor = #colorLiteral(red: 0.4869785309, green: 0.6966556907, blue: 0.2566168308, alpha: 1)
        } else if sotredMainData[indexPath.row].slider == 3 {
                cell.titleImageView.backgroundColor = #colorLiteral(red: 0.8603747487, green: 0.7912797928, blue: 0.2836382091, alpha: 1)
        } else if sotredMainData[indexPath.row].slider == 4 {
                cell.titleImageView.backgroundColor = #colorLiteral(red: 0.8567560315, green: 0.4737914205, blue: 0.2811568677, alpha: 1)
        } else if sotredMainData[indexPath.row].slider == 5 {
                cell.titleImageView.backgroundColor = #colorLiteral(red: 0.858238101, green: 0.2842665315, blue: 0.2831082046, alpha: 1)
        }
        
        
        cell.iconImageView.image = sotredMainData[indexPath.row].image
        cell.cosmosView.rating = sotredMainData[indexPath.row].slider
        
        cell.workPlaceLabel.text = sotredMainData[indexPath.row].profession + " " + sotredMainData[indexPath.row].company
        cell.ageLabel.text = sotredMainData[indexPath.row].age
        cell.dateOfBirthLabel.text = sotredMainData[indexPath.row].dateOfBirth
        
        return cell
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        
        profileVC?.index = indexPath.row
        profileVC?.id = sotredMainData[indexPath.row].id
        navigationController?.pushViewController(profileVC!, animated: true)
    }
    
    
    //SWIPE RIGHT LEFT
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        Alert.deleteAlert(message: "Are you sure to want to Delete?", self, closure: {
            self.tableView.reloadSections([indexPath.section], with: .automatic)
            
            self.calendar.deleteEvent(id: self.sotredMainData[indexPath.row].id)
            let dateID = self.sotredMainData[indexPath.row].id
            let eventID = UserDataManager.shared.currentData!.id
            self.sotredMainData.remove(at: indexPath.row)
            MainDataManager.shared.currentData!.remove(at: indexPath.row)
            self.firebaseManager.removeDataFromDatabese(eventID!, dateID)
            self.checkCount()
     
            self.tableView.reloadData()
            
            
        }) {
            
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    
}


extension MainViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let array = MainDataManager.shared.currentData!
      
        if searchText == "" || searchText == nil {
            self.sotredMainData = array
            isSorted = false
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        } else {
            let dataSort = array.filter { $0.name.contains(searchText) || $0.placeAndDate.contains(searchText) || $0.email.contains(searchText) || $0.city.contains(searchText)}
            self.sotredMainData = dataSort
              isSorted = true
        }
          self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
  
    
  
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}



//
//  MainViewCell.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/21/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit
import Cosmos

class MainViewCell: UITableViewCell {

   
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var workPlaceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var viewForStar: UIView!
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
            iconImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            iconImageView.layer.borderWidth = 3.5
            iconImageView.layer.cornerRadius = iconImageView.frame.height/2
            contentsView.dropShadow(0.2)
         //   titleImageView.dropShadow(0.3)
            viewForStar.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgr"))
        
    }

 

    
}

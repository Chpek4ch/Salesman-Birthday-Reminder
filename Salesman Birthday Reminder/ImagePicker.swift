//
//  ImagePicker.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/22/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit


class ImagePicker {
    
    
    class func showPicker(_ vc: UIViewController){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        vc.present(imagePicker, animated: true, completion: nil)
    }
    
}

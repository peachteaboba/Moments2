//
//  AddEditViewController.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    // Variables ::::::::::::::::::::::::::::::::::::::::::::::::::
    var titleText = ""
    var picker = UIImagePickerController()
    var photo:UIImage?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var momentDetails:Moment?
    

    // Outlets ::::::::::::::::::::::::::::::::::::::::::::::::::::
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    

    // Delegates ::::::::::::::::::::::::::::::::::::::::::::::::::
    var addMomentDelegate: AddMomentDelegate?
    

    // Helper functions :::::::::::::::::::::::::::::::::::::::::::
    func handleImageViewTapped(){
        // Camera stuffs!
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            print("No Camera!")
            self.noCamera()
        }
    }
    
    // In case you're using the simulator..
    func noCamera(){
        
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        
        alertVC.addAction(okAction)
        
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // If there is no image when saving..
    func noImage(){
        
        let alertVC = UIAlertController(
            title: "No Image",
            message: "Must upload an image to submit!",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        
        alertVC.addAction(okAction)
        
        present(
            alertVC,
            animated: true,
            completion: nil)
    }


    // Cancel button pressed
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        // Pop view controller (it's returning the view controller being popped off)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // Done button pressed 
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {

        if self.photo != nil || self.momentDetails != nil {
            
            if self.momentDetails == nil {
                
                // Create Moment object :::::::::::::::::::::::::::::::
                let moment = NSEntityDescription.insertNewObject(forEntityName: "Moment",  into: context) as! Moment
                
                if let imageToSave = self.photo {
                    let data = UIImagePNGRepresentation(imageToSave)
                    moment.image = data as NSData?
                }
                moment.comment = self.commentField.text
                moment.timestamp = NSDate()
                // ::::::::::::::::::::::::::::::::::::::::::::::::::::
                
                // Run delegate's method to pass Moment object back to delegate VC
                self.addMomentDelegate?.AddEditViewController(controller: self, didFinishAddingMoment: moment)
                
                
            } else {
                
                // Moment is pre-populated and we are editing
                
                if let imageToSave = self.photo {
                    let data = UIImagePNGRepresentation(imageToSave)
                    self.momentDetails?.image = data as NSData?
                }
                
                self.momentDetails?.comment = self.commentField.text
                self.momentDetails?.timestamp = NSDate()
                
                
                
                
                // Run delegate's method to pass Moment object back to delegate VC
                self.addMomentDelegate?.AddEditViewController(controller: self, didFinishAddingMoment: self.momentDetails!)
                
            }
            
            
            
            // Pop view controller (it's returning the view controller being popped off)
            _ = self.navigationController?.popViewController(animated: true)
            
            
            
        } else {
            
            // No image..
            self.noImage()
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    // MARK: - VC lifecycle -----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.picker.delegate = self
        
        
        // Set the title label's text
        self.titleLabel.text = self.titleText
        
        
        
        
        // Assign event handler to image
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageViewTapped))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(imageViewTap)
        
        
        // Comment field styles
        self.commentField.layer.cornerRadius = 8
        self.commentField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 2, 0)
        
        
        
        
        
        if self.momentDetails != nil {
            
            // Editing... Populate data
            let image : UIImage = UIImage(data: momentDetails!.image as! Data)!
            self.imageView.image = image
            self.commentField.text = momentDetails?.comment
            self.commentField.becomeFirstResponder()
            self.photo = image
     
        } else {
            
            // Adding a new photo.. Open camera automatically
            self.handleImageViewTapped()
            
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    // MARK: - Image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel camera")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.photo = chosenImage
        
        self.imageView.image = self.photo
        
        self.commentField.becomeFirstResponder()
        
    }
    
    
    
    
    
    
    

}

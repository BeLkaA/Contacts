//
//  AddContactTableViewController.swift
//  Contacts
//
//  Created by Belka_Anton on 19.04.16.
//  Copyright © 2016 Belka_Anton. All rights reserved.
//

import UIKit
import CoreData

class AddContactTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
 
    var contact : Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func save(sender: UIBarButtonItem){
        let name = nameTextField.text
        let surname = surnameTextField.text
        let number = numberTextField.text
        
        if name == "" || surname == "" || number == ""{
            let allertController = UIAlertController(title: "Nope ;)", message: "Please put information in all fields)", preferredStyle: UIAlertControllerStyle.Alert)
            allertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(allertController, animated: true, completion: nil)
            
            return
            
        }
       
        if let manageObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: manageObjectContext) as! Contact
            
            contact.name = name!
            contact.surname = surname!
            contact.number = number!
            if let contactImage = imageView.image{
                contact.image = UIImagePNGRepresentation(contactImage)!
            }
            
            do {
                try manageObjectContext.save()
            }	catch {
                print(error)
                return
                
        }
        
      
        }
        
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

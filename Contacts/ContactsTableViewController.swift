//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Belka_Anton on 18.04.16.
//  Copyright © 2016 Belka_Anton. All rights reserved.
//

import UIKit
import CoreData
 
class ContactsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating  {
    
   
    var contacts: [Contact] = []
    var searchResult: [Contact] = []
    var fetchResultController: NSFetchedResultsController!
    var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false 
        searchController.searchBar.placeholder = "Search Contact"
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1)
    
    

        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                contacts = fetchResultController.fetchedObjects as! [Contact]
            } catch {
                print(error)
            }
        }

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if searchController.active{
            return false
        }else {
            return true
        }
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active{
            return searchResult.count
        } else {
            return contacts.count
        }
        
        
    }
    
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath ) as! CustomTableViewCell
        
       
        let contact = (searchController.active) ? searchResult[indexPath.row] : contacts[indexPath.row]
        
        
        //nastroika yacheiki
        cell.thumbnailImageView.image = UIImage(data: contact.image!)
        cell.nameLable.text = contact.name
        cell.surnameLabel.text = contact.surname
        cell.numberLabel.text = contact.number
        
        
        cell.thumbnailImageView.layer.cornerRadius = 12
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }
    
    
    
    
    
   
  
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            if let _newindexPath = newIndexPath{
                tableView.insertRowsAtIndexPaths([_newindexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _newindexPath = newIndexPath{
                tableView.deleteRowsAtIndexPaths([_newindexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _newindexPath = newIndexPath{
                tableView.reloadRowsAtIndexPaths([_newindexPath], withRowAnimation: .Fade)
            }
        default:
            tableView.reloadData()
            
        }
        contacts = controller.fetchedObjects as! [Contact]
        
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        
        let shareAction = UITableViewRowAction(style: .Default, title: "Share", handler: {(action, indexPath) -> Void in
            let defaultText = "Just cheking in at " +  self.contacts[indexPath.row].name
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        })
        
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action,indexPath) -> Void in
            self.contacts.removeAtIndex(indexPath.row)
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                let contactToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! Contact
                
                managedObjectContext.deleteObject(contactToDelete)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                do {
                    try managedObjectContext.save()
                }catch {
                    print(error)
                }
            }
        })
        
        
        shareAction.backgroundColor = UIColor(red: 202.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1)
        return [deleteAction,shareAction]
    }
    
    

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    
    
    
    
    
    
    // Override to support editing the table view.
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if searchController.active{
            tableView.tableHeaderView = nil
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        if segue.identifier == "ShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! DetailViewController
                destinationController.contact = (searchController.active) ? searchResult[indexPath.row] : contacts[indexPath.row]
               
            }
            
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
       
    }
    
    
    @IBAction func unwindToContacts(segue: UIStoryboardSegue){
        
        
    }
    
    //
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(searchText)
            tableView.reloadData()
             
        }
    }
    
    func filterContent(searchText: String){
        searchResult = contacts.filter({ (contact: Contact) -> Bool in
            let nameMatch = contact.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let surnameMatch = contact.surname.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let numberMatch = contact.number.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil || surnameMatch != nil || numberMatch != nil 
        })
    }
}

//
//  DetailViewController.swift
//  Contacts
//
//  Created by Belka_Anton on 18.04.16.
//  Copyright © 2016 Belka_Anton. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  

    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    var contact : Contact!
    var contactImage = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       // tableView.tableHeaderView  = nil
        contactImageView.image = UIImage(data: contact.image!)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }


    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContactCustomTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = contact.name
        case 1:
            cell.fieldLabel.text = "Surname"
            cell.valueLabel.text = contact.surname

        case 2:
            cell.fieldLabel.text = "Number"
            cell.valueLabel.text = contact.number
            
        
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""

        }
        
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
   
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

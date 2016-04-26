//
//  CustomTableViewCell.swift
//  Contacts
//
//  Created by Belka_Anton on 18.04.16.
//  Copyright © 2016 Belka_Anton. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

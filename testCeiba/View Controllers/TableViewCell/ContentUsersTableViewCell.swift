//
//  ContentUsersTableViewCell.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/20/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import UIKit

class ContentUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

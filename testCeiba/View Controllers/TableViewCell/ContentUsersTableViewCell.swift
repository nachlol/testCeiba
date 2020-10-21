//
//  ContentUsersTableViewCell.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/20/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import UIKit

protocol TablePostCellDelegate: AnyObject {
    func didTapPost(with userId:Int,index: Int)
}

class ContentUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    weak var delegate: TablePostCellDelegate?
    var id:Int = 0
    var index:IndexPath?
    
    @IBAction func didTapButton(_ sender:Any){
        delegate?.didTapPost(with: self.id,index: self.index!.row)
    }
    
    func configure(with id:Int,index:IndexPath){
        self.id = id
        self.index = index
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

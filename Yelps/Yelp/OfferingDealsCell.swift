//
//  OfferingDealsCell.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/24/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol OfferingDealsCellDelegate {
    @objc optional func offeringDealsCellDidSwitchChanged(_ offeringDealsCell: OfferingDealsCell)
}
class OfferingDealsCell: UITableViewCell {

    @IBOutlet weak var offeringDealsSwitch: UISwitch!
    
    weak var delegate: OfferingDealsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onChange(_ sender: UISwitch) {
        delegate?.offeringDealsCellDidSwitchChanged!(self)
    }

}

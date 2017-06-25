//
//  RadioButtonCell.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit
import DLRadioButton

@objc protocol RadioButtonCellDelegate {
    func radioButtonSelected(sender : RadioButtonCell);
}

class RadioButtonCell: UITableViewCell {
    
    weak var delegate : RadioButtonCellDelegate?
    
    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var radioButton: DLRadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonChanged(_ sender: DLRadioButton) {
        self.delegate?.radioButtonSelected(sender: self)
    }

}

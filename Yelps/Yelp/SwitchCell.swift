//
//  SwitchCell.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    func switchStateChanged(sender : SwitchCell, state : Bool)
}

class SwitchCell: UITableViewCell {
    
    weak var delegate : SwitchCellDelegate?
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    @IBAction func switchChanged(_ sender: UIButton) {
        UIView.transition(with: sender,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: {
                            sender.isSelected = !sender.isSelected
        }, completion: nil);
        
        self.delegate?.switchStateChanged(sender: self, state: sender.isSelected )
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

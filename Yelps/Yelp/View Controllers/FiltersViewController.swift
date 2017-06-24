//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/23/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    let categories = ["Java", "JavaScript", "Objective-C", "Python", "Ruby", "Swift"]
    
    var offeringDeals: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let filters = FilterDatas.sharedInstance
        filters.offeringDeals = offeringDeals

        delegate?.filtersViewControllerDidUpdate?(self)
        dismiss(animated: true, completion: nil)
    }

}

extension FiltersViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 3
        case 3:
            return categories.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferingDealsCell", for: indexPath) as! OfferingDealsCell
            cell.delegate = self
            return cell
            
//        case 1:
//            if (indexPath as NSIndexPath).row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
//                cell.onSwitch.isOn = switchOn
//                cell.delegate = self
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
//                let language = languages[(indexPath as NSIndexPath).row - 1]
//                cell.languageLabel.text = language
//                cell.checkImageView.isHidden = language != selectedLanguage
//                return cell
//            }
            
        default:
            return UITableViewCell()
        }
    }
}

extension FiltersViewController : OfferingDealsCellDelegate {
    func offeringDealsCellDidSwitchChanged(_ offeringDealsCell: OfferingDealsCell) {
        offeringDeals = offeringDealsCell.offeringDealsSwitch.isOn
    }
}

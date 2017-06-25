//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController)
}

class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var seeAll = false
    var bestMatchExpanded = false
    var sortByExpanded = false
    var distanceExpanded = false
    let distances = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    let sortBy = ["Best Match", "Distance", "Highest Rated"]
    var categorySelectedIndex = -1
    let categories: [[String: String]] =
        [["name" : "Afghan", "code": "afghani"],
         ["name" : "African", "code": "african"],
         ["name" : "American, New", "code": "newamerican"],
         ["name" : "American, Traditional", "code": "tradamerican"],
         ["name" : "Arabian", "code": "arabian"],
         ["name" : "Argentine", "code": "argentine"],
         ["name" : "Armenian", "code": "armenian"],
         ["name" : "Asian Fusion", "code": "asianfusion"],
         ["name" : "Asturian", "code": "asturian"],
         ["name" : "Australian", "code": "australian"],
         ["name" : "Austrian", "code": "austrian"],
         ["name" : "Baguettes", "code": "baguettes"],
         ["name" : "Bangladeshi", "code": "bangladeshi"],
         ["name" : "Barbeque", "code": "bbq"],
         ["name" : "Basque", "code": "basque"],
         ["name" : "Bavarian", "code": "bavarian"],
         ["name" : "Beer Garden", "code": "beergarden"],
         ["name" : "Beer Hall", "code": "beerhall"],
         ["name" : "Beisl", "code": "beisl"],
         ["name" : "Belgian", "code": "belgian"],
         ["name" : "Bistros", "code": "bistros"],
         ["name" : "Black Sea", "code": "blacksea"],
         ["name" : "Brasseries", "code": "brasseries"],
         ["name" : "Brazilian", "code": "brazilian"],
         ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
         ["name" : "British", "code": "british"],
         ["name" : "Buffets", "code": "buffets"],
         ["name" : "Bulgarian", "code": "bulgarian"],
         ["name" : "Burgers", "code": "burgers"],
         ["name" : "Burmese", "code": "burmese"],
         ["name" : "Cafes", "code": "cafes"],
         ["name" : "Cafeteria", "code": "cafeteria"],
         ["name" : "Cajun/Creole", "code": "cajun"],
         ["name" : "Cambodian", "code": "cambodian"],
         ["name" : "Canadian", "code": "New)"],
         ["name" : "Canteen", "code": "canteen"],
         ["name" : "Caribbean", "code": "caribbean"],
         ["name" : "Catalan", "code": "catalan"],
         ["name" : "Chech", "code": "chech"],
         ["name" : "Cheesesteaks", "code": "cheesesteaks"],
         ["name" : "Chicken Shop", "code": "chickenshop"],
         ["name" : "Chicken Wings", "code": "chicken_wings"],
         ["name" : "Chilean", "code": "chilean"],
         ["name" : "Chinese", "code": "chinese"],
         ["name" : "Comfort Food", "code": "comfortfood"],
         ["name" : "Corsican", "code": "corsican"],
         ["name" : "Creperies", "code": "creperies"],
         ["name" : "Cuban", "code": "cuban"],
         ["name" : "Curry Sausage", "code": "currysausage"],
         ["name" : "Cypriot", "code": "cypriot"],
         ["name" : "Czech", "code": "czech"],
         ["name" : "Czech/Slovakian", "code": "czechslovakian"],
         ["name" : "Danish", "code": "danish"],
         ["name" : "Delis", "code": "delis"],
         ["name" : "Diners", "code": "diners"],
         ["name" : "Dumplings", "code": "dumplings"],
         ["name" : "Eastern European", "code": "eastern_european"],
         ["name" : "Ethiopian", "code": "ethiopian"],
         ["name" : "Fast Food", "code": "hotdogs"],
         ["name" : "Filipino", "code": "filipino"],
         ["name" : "Fish & Chips", "code": "fishnchips"],
         ["name" : "Fondue", "code": "fondue"],
         ["name" : "Food Court", "code": "food_court"],
         ["name" : "Food Stands", "code": "foodstands"],
         ["name" : "French", "code": "french"],
         ["name" : "French Southwest", "code": "sud_ouest"],
         ["name" : "Galician", "code": "galician"],
         ["name" : "Gastropubs", "code": "gastropubs"],
         ["name" : "Georgian", "code": "georgian"],
         ["name" : "German", "code": "german"],
         ["name" : "Giblets", "code": "giblets"],
         ["name" : "Gluten-Free", "code": "gluten_free"],
         ["name" : "Greek", "code": "greek"],
         ["name" : "Halal", "code": "halal"],
         ["name" : "Hawaiian", "code": "hawaiian"],
         ["name" : "Heuriger", "code": "heuriger"],
         ["name" : "Himalayan/Nepalese", "code": "himalayan"],
         ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
         ["name" : "Hot Dogs", "code": "hotdog"],
         ["name" : "Hot Pot", "code": "hotpot"],
         ["name" : "Hungarian", "code": "hungarian"],
         ["name" : "Iberian", "code": "iberian"],
         ["name" : "Indian", "code": "indpak"],
         ["name" : "Indonesian", "code": "indonesian"],
         ["name" : "International", "code": "international"],
         ["name" : "Irish", "code": "irish"],
         ["name" : "Island Pub", "code": "island_pub"],
         ["name" : "Israeli", "code": "israeli"],
         ["name" : "Italian", "code": "italian"],
         ["name" : "Japanese", "code": "japanese"],
         ["name" : "Jewish", "code": "jewish"],
         ["name" : "Kebab", "code": "kebab"],
         ["name" : "Korean", "code": "korean"],
         ["name" : "Kosher", "code": "kosher"],
         ["name" : "Kurdish", "code": "kurdish"],
         ["name" : "Laos", "code": "laos"],
         ["name" : "Laotian", "code": "laotian"],
         ["name" : "Latin American", "code": "latin"],
         ["name" : "Live/Raw Food", "code": "raw_food"],
         ["name" : "Lyonnais", "code": "lyonnais"],
         ["name" : "Malaysian", "code": "malaysian"],
         ["name" : "Meatballs", "code": "meatballs"],
         ["name" : "Mediterranean", "code": "mediterranean"],
         ["name" : "Mexican", "code": "mexican"],
         ["name" : "Middle Eastern", "code": "mideastern"],
         ["name" : "Milk Bars", "code": "milkbars"],
         ["name" : "Modern Australian", "code": "modern_australian"],
         ["name" : "Modern European", "code": "modern_european"],
         ["name" : "Mongolian", "code": "mongolian"],
         ["name" : "Moroccan", "code": "moroccan"],
         ["name" : "New Zealand", "code": "newzealand"],
         ["name" : "Night Food", "code": "nightfood"],
         ["name" : "Norcinerie", "code": "norcinerie"],
         ["name" : "Open Sandwiches", "code": "opensandwiches"],
         ["name" : "Oriental", "code": "oriental"],
         ["name" : "Pakistani", "code": "pakistani"],
         ["name" : "Parent Cafes", "code": "eltern_cafes"],
         ["name" : "Parma", "code": "parma"],
         ["name" : "Persian/Iranian", "code": "persian"],
         ["name" : "Peruvian", "code": "peruvian"],
         ["name" : "Pita", "code": "pita"],
         ["name" : "Pizza", "code": "pizza"],
         ["name" : "Polish", "code": "polish"],
         ["name" : "Portuguese", "code": "portuguese"],
         ["name" : "Potatoes", "code": "potatoes"],
         ["name" : "Poutineries", "code": "poutineries"],
         ["name" : "Pub Food", "code": "pubfood"],
         ["name" : "Rice", "code": "riceshop"],
         ["name" : "Romanian", "code": "romanian"],
         ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
         ["name" : "Rumanian", "code": "rumanian"],
         ["name" : "Russian", "code": "russian"],
         ["name" : "Salad", "code": "salad"],
         ["name" : "Sandwiches", "code": "sandwiches"],
         ["name" : "Scandinavian", "code": "scandinavian"],
         ["name" : "Scottish", "code": "scottish"],
         ["name" : "Seafood", "code": "seafood"],
         ["name" : "Serbo Croatian", "code": "serbocroatian"],
         ["name" : "Signature Cuisine", "code": "signature_cuisine"],
         ["name" : "Singaporean", "code": "singaporean"],
         ["name" : "Slovakian", "code": "slovakian"],
         ["name" : "Soul Food", "code": "soulfood"],
         ["name" : "Soup", "code": "soup"],
         ["name" : "Southern", "code": "southern"],
         ["name" : "Spanish", "code": "spanish"],
         ["name" : "Steakhouses", "code": "steak"],
         ["name" : "Sushi Bars", "code": "sushi"],
         ["name" : "Swabian", "code": "swabian"],
         ["name" : "Swedish", "code": "swedish"],
         ["name" : "Swiss Food", "code": "swissfood"],
         ["name" : "Tabernas", "code": "tabernas"],
         ["name" : "Taiwanese", "code": "taiwanese"],
         ["name" : "Tapas Bars", "code": "tapas"],
         ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
         ["name" : "Tex-Mex", "code": "tex-mex"],
         ["name" : "Thai", "code": "thai"],
         ["name" : "Traditional Norwegian", "code": "norwegian"],
         ["name" : "Traditional Swedish", "code": "traditional_swedish"],
         ["name" : "Trattorie", "code": "trattorie"],
         ["name" : "Turkish", "code": "turkish"],
         ["name" : "Ukrainian", "code": "ukrainian"],
         ["name" : "Uzbek", "code": "uzbek"],
         ["name" : "Vegan", "code": "vegan"],
         ["name" : "Vegetarian", "code": "vegetarian"],
         ["name" : "Venison", "code": "venison"],
         ["name" : "Vietnamese", "code": "vietnamese"],
         ["name" : "Wok", "code": "wok"],
         ["name" : "Wraps", "code": "wraps"],
         ["name" : "Yugoslav", "code": "yugoslav"]]
    
    let saveFilters = SaveFilters.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        delegate?.filtersViewControllerDidUpdate?(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
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
            return 1;
        case 1:
            return self.distanceExpanded ? 5 : 1
        case 2:
            return self.sortByExpanded ? 3 : 1
        case 3:
            return self.seeAll ?  self.categories.count + 1 : 4
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let view = UIView();
        let label = UILabel()
        label.frame = CGRect(x: 10, y: 15, width: 320, height: 20)
        label.font =  UIFont.boldSystemFont(ofSize: 16)
        
        if section == 1 {
            label.text = "Distance"
        } else if section == 2 {
            label.text = "Sort By"
        } else if section == 3 {
            label.text = "Category"
        }
        view.addSubview(label)
        return view

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell;
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.switchButton.isSelected = self.saveFilters.offeringADeal
            cell.selectionStyle = .none
            return cell
        case 1:
            if self.distanceExpanded == false {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
                cell.expandLabel.text = self.distances[self.saveFilters.distanceSelectedIndex]
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as! RadioButtonCell
                cell.delegate = self
                cell.radioLabel.text = self.distances[indexPath.row]
                cell.radioButton.isSelected = self.saveFilters.distanceSelectedIndex == indexPath.row ? true : false
                cell.selectionStyle = .none
                return cell
            }
        case 2:
            if self.sortByExpanded == false {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
                cell.expandLabel.text = self.sortBy[self.saveFilters.sortBySelectedIndex]
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as! RadioButtonCell
                cell.delegate = self
                cell.radioLabel.text = self.sortBy[indexPath.row]
                cell.radioButton.isSelected = self.saveFilters.sortBySelectedIndex == indexPath.row ? true : false
                cell.selectionStyle = .none
                return cell
            }
        case 3:
            if self.seeAll == false {
                if indexPath.row >= 0 && indexPath.row < 3 {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                    
                    cell.selectionStyle = .none
                    cell.delegate = self
                    
                    
                    // set the lable text
                    cell.switchLabel.text = self.categories[indexPath.row]["name"]
                    
                    // set the switch state
                    if self.saveFilters.selectedCategories.contains(self.categories[indexPath.row]["code"]!) {
                        cell.switchButton.isSelected = true
                    } else {
                        cell.switchButton.isSelected = false
                    }
                    return cell
                } else {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeAllCell") as! SeeAllCell
                    cell.seeAllLabel.text =  "See All"
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                if indexPath.row >= 0 && indexPath.row < self.categories.count {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
                    
                    cell.selectionStyle = .none
                    cell.delegate = self
                    
                    // set the label text
                    cell.switchLabel.text = self.categories[indexPath.row]["name"]
                    
                    // set the switch state
                    if self.saveFilters.selectedCategories.contains(self.categories[indexPath.row]["code"]!) {
                        cell.switchButton.isSelected = true
                    } else {
                        cell.switchButton.isSelected = false
                    }
                    return cell
                } else {
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "SeeAllCell") as! SeeAllCell
                    cell.seeAllLabel.text =  "See Less"
                    cell.selectionStyle = .none
                    return cell
                }
            }

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Category"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if self.distanceExpanded == true {
                self.saveFilters.distanceSelectedIndex = indexPath.row
            }
            
            self.distanceExpanded = !self.distanceExpanded;
            
            let indexSet = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(indexSet, with: .fade)
            
        } else if indexPath.section == 2 {
            if self.sortByExpanded == true {
                self.saveFilters.sortBySelectedIndex = indexPath.row
            }
            
            self.sortByExpanded = !self.sortByExpanded;
            
            let indexSet = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(indexSet, with: .fade)
            
        } else if indexPath.section == 3 {
            if (self.seeAll == false && indexPath.row == 3) ||
                (self.seeAll == true) {
                self.seeAll = !self.seeAll
                let indexSet = IndexSet(integer: indexPath.section)
                self.tableView.reloadSections(indexSet, with: .fade)
            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FiltersViewController : SwitchCellDelegate {
    func switchStateChanged(sender: SwitchCell, state: Bool) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            if indexPath.section == 0 {
                self.saveFilters.offeringADeal = state
            } else if indexPath.section == 3 {
                if state == true {
                    self.saveFilters.selectedCategories.insert(self.categories[indexPath.row]["code"]!)
                } else {
                    self.saveFilters.selectedCategories.remove(self.categories[indexPath.row]["code"]!)
                }
            }
        }
    }
}

extension FiltersViewController: RadioButtonCellDelegate {
    func radioButtonSelected(sender: RadioButtonCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            if indexPath.section == 1 {
                self.saveFilters.distanceSelectedIndex = indexPath.row
                self.distanceExpanded = false
            } else if indexPath.section == 2 {
                self.saveFilters.sortBySelectedIndex = indexPath.row
                self.sortByExpanded = false
            }
            let indexSet = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(indexSet, with: .fade)
        }
    }
}

//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]?
    var searchBar: UISearchBar!
    
    var isMoreDataLoading = false
    var loadLimit = 20
    var loadMoreOffset = 21

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        // Perform the first search when the view controller first loads
        
        Business.search(with: searchBar.text!, sort: nil, categories: nil, deals: nil, offset: nil) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
    // Perform the search.
    fileprivate func doSearch(offset : Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.search(with: searchBar.text!, sort: nil, categories: nil, deals: nil, offset: offset) { (businesses, error) in
            self.isMoreDataLoading = false
            
            if error != nil || businesses == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                
                if offset == 0 {
                    self.businesses = businesses
                } else {
                    self.businesses?.append(contentsOf: businesses!)
                }
                
                self.tableView.reloadData()
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        
    }
    
    // enable inifite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // load more results
                doSearch(offset: loadMoreOffset)
                loadMoreOffset += loadLimit
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsToFilters" {
//            if let nvc = segue.destination as? UINavigationController, let filtersVC = nvc.topViewController as? FiltersViewController {
//                filtersVC.delegate = self
//            }
        }
    }

}

extension BusinessesViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        loadMoreOffset = loadLimit + 1
        doSearch(offset: 0)
    }
}

extension BusinessesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses?[indexPath.row]
        
        return cell
    }
}
//
//extension BusinessesViewController : FiltersViewControllerDelegate {
//    func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController) {
//        doSearch()
//    }
//}

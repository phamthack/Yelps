//
//  BusinessesViewController.swift
//  Yelp

import UIKit
import MBProgressHUD
import MapKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]?
    var searchBar: UISearchBar!
    
    var isMoreDataLoading = false
    var loadLimit = 20
    var loadMoreOffset = 21
    
    var nameToBusiness  = [String : Business] ()
    
    var saveFilters = SaveFilters.sharedInstance
    let distanceInMeters = [0, 483, 1609, 8047, 40000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        mapView.delegate = self
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.search(with: searchBar.text!, sort: nil, categories: nil, deals: nil, offset: nil, radius: nil) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
                self.mapViewReloadData()
                
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
        var radius : Int? = nil
        if self.saveFilters.distanceSelectedIndex > 0 {
            radius = self.distanceInMeters[self.saveFilters.distanceSelectedIndex]
        }
        
        Business.search(with: searchBar.text!, sort: YelpSortMode(rawValue: self.saveFilters.sortBySelectedIndex), categories: Array(self.saveFilters.selectedCategories), deals: self.saveFilters.offeringADeal, offset: offset, radius:radius) { (businesses, error) in
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
                self.mapViewReloadData()
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        }
        
    }
    
    func mapViewReloadData() {
        self.tableView.reloadData()
        
        // add annotations to map view
        var coordinate = CLLocationCoordinate2DMake(37.0,-122.0);
        var annotation = MKPointAnnotation()
        self.mapView.removeAnnotations(self.mapView.annotations);
        if let businesses = self.businesses {
            for business in businesses {
                if let lat = business.lat,
                    let lon = business.lon {
                    coordinate = CLLocationCoordinate2DMake(lat, lon)
                    annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = business.name
                    annotation.subtitle = business.address
                    
                    self.nameToBusiness[annotation.title! + annotation.subtitle!] = business
                    self.mapView.addAnnotation(annotation)
                    
                }
            }
            
            self.mapView.selectAnnotation(annotation, animated: true);
            let  viewRegion =
                MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
            let adjustedRegion = self.mapView.regionThatFits(viewRegion)
            self.mapView.setRegion(adjustedRegion, animated: true)
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
    
    @IBAction func mapButtonTapped(_ sender: UIBarButtonItem) {
        
        if sender.title == "Map" {
            let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            UIView.transition(from: self.tableView,
                              to: self.mapView,
                              duration: 0.5,
                              options: transitionParams,
                              completion: nil);
        } else {
            let transitionParams :  UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
            UIView.transition(from: self.mapView,
                              to: self.tableView,
                              duration: 0.5,
                              options: transitionParams,
                              completion: nil);
        }
        sender.title = sender.title == "List" ? "Map" : "List"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilterSegue" {
            if let nvc = segue.destination as? UINavigationController, let filtersVC = nvc.topViewController as? FiltersViewController {
                filtersVC.delegate = self
            }
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
        searchBar.resignFirstResponder()
        loadMoreOffset = loadLimit + 1
        doSearch(offset: 0)
    }
}

extension BusinessesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "loc")
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
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

extension BusinessesViewController : FiltersViewControllerDelegate {
    func filtersViewControllerDidUpdate(_ filtersViewController: FiltersViewController) {
        doSearch(offset: 0)
    }
}

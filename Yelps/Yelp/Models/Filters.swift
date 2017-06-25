//
//  Filters.swift
//  Yelp
//
//  Created by Phạm Thanh Hùng on 6/25/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import Foundation

// Model class that represents the user's save filters
class SaveFilters {
    
    var searchString: String?
    var offeringADeal = false;
    var distanceSelectedIndex = 0
    var sortBySelectedIndex = 0
    var selectedCategories = Set<String>()
    
    static let sharedInstance = SaveFilters()
    
}

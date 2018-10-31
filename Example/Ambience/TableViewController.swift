//
//  TableViewController.swift
//  Ambience_Example
//
//  Created by Tiago Mergulhão on 06/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GameplayKit

class TableViewController : UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if #available(iOS 11, *) {
            
            let searchController = UISearchController(searchResultsController: nil)
            
            searchController.searchResultsUpdater = self
            
            searchController.searchBar.placeholder = "Search for bookmarks content"
            searchController.obscuresBackgroundDuringPresentation = true
            definesPresentationContext = true
            
            navigationItem.searchController = searchController
        }
    }
    
    let cells : Array<String> = (Array(0...(GKRandomSource.sharedRandom().nextInt(upperBound: 40)))).map({
        
       _ in
        
        let random = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
        
        switch random {
        case 0:
            return "Cellwithimage"
        default:
            return "Cellwithtext"
        }
    })
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell!
        
        let random = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
        
        switch random {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row])
        default:
            let someCell = tableView.dequeueReusableCell(withIdentifier: "Cellwithtext") as! TextTableCell
            
            someCell.textView?.reinstateAmbience()
            
            cell = someCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
}

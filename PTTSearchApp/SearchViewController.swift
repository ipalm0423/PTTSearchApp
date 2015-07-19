//
//  ViewController.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/18.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit
import Foundation
import SugarRecord
import Foundation
import Alamofire
import AlamofireObjectMapper

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var hints = [String]()
    var histories = [SearchProfile]()
    var filtedHints = [String]()
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add searchBar
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "輸入你要查詢的內容"
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //test
        self.hints = ["1" , "2" , "3"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
//table View delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active {
            return self.filtedHints.count
        }
        return self.histories.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileTableViewCell
        
        if self.searchController.active {
            cell.MainLabel.text = self.filtedHints[indexPath.row]
        }else {
            cell.MainLabel.text = self.histories[indexPath.row].name
        }
        
        
        return cell
    }

    
    
    
//search view controll
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterHint()
        self.tableView.reloadData()
    }
    
    func searchScope() -> String {
        let scopes = self.searchController.searchBar.scopeButtonTitles as! [String]?
        let index = self.searchController.searchBar.selectedScopeButtonIndex
        if let selected = scopes {
            return selected[index]
        }
        return "all"
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadHints(searchText)
    }
    
    func filterHint() {
        self.filtedHints.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", self.searchController.searchBar.text)
        self.filtedHints = self.hints.filter { (hint) -> Bool in
            return searchPredicate.evaluateWithObject(hint)
        }
        self.tableView.reloadData()
    }
    
    
    
//Internet
    func loadHints(searchString: String) {
        let url = Singleton.sharedInstance.serverURL + "search/searchHint"
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : searchString]).responseObject { (response: mapHint?, error: NSError?) -> Void in
            println("got hint from server")
            if let suggestHint = response?.suggestHint {
                for hint in suggestHint {
                    if contains(self.hints, hint) {
                        //already in array
                    }else {
                        //add to array
                        self.hints += [hint]
                    }
                }
            }
            if error != nil {
                println(error)
            }
            self.filterHint()
        }
    }
    
    
    
    
    
    
    
    
    
    

}


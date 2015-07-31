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
import JDStatusBarNotification


class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var hints = [String]()
    var histories = [SearchResult]()
    var filtedHints = [String]()
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add searchBar
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.placeholder = "輸入你要查詢的內容"
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.scopeButtonTitles = ["帳號", "文章"]
        //self.navigationItem.titleView = self.searchController.searchBar
        //self.definesPresentationContext = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.loadHistoryHint()
        
        
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
        if self.searchController.active {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("HintCell") as! HintTableViewCell
            cell.MainLabel.text = self.filtedHints[indexPath.row]
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileTableViewCell
            cell.MainLabel.text = self.histories[indexPath.row].name
            return cell
        }
        
        
        
    }

    
    
    
//search view controll
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterHint()
        
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
        //update hint from server
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
    
    func addHintInArray(hint: String) {
        if contains(self.hints, hint) {
            //already in array
        }else {
            //add to array
            self.hints += [hint]
        }
    }
    
    
//Internet
    func loadHints(searchString: String) {
        let url = Singleton.sharedInstance.serverURL + "search/searchHint"
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : searchString]).responseObject { (response: mapHint?, error: NSError?) -> Void in
            println("got hint from server")
            if let suggestHint = response?.suggestHint {
                for hint in suggestHint {
                    self.addHintInArray(hint)
                }
            }
            if error != nil {
                println(error)
            }
            self.filterHint()
        }
    }
    
    
    
    
    
//core data
    func loadHistoryHint() {
        let loadhints = SearchHistroy.sorted(by: "searchTime", ascending: false).find()
        println("load history hints: ")
        print(loadhints.count)
        for var i = 0; i < loadhints.count; i++ {
            if let hint = loadhints.objectAtIndex(UInt(i)) as? SearchHistroy {
                self.addHintInArray(hint.hint)
            }
        }
    }
    
    
    
//navigation
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //save search history to core data
        if let hint:SearchHistroy = SearchHistroy.create() as? SearchHistroy {
            hint.hint = searchBar.text
            hint.searchTime = NSDate()
            hint.save()
        }
        self.addHintInArray(searchBar.text)
        
        //navi
        switch self.searchScope() {
        case "文章" :
            self.searchController.active = false
            self.performSegueWithIdentifier("TitleViewSegue", sender: self)
        case "帳號" :
            self.searchController.active = false
            self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
        default:
            println("error: different scope")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var url = Singleton.sharedInstance.serverURL + "search/"
        
        if segue.identifier == "ProfileViewSegue"{
            url += "searchProfile"
            //send to server
            if let destinationVC = segue.destinationViewController as? ProfileViewController {
                println("Show profile view")
                
                //搜尋帳號
                Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : self.searchController.searchBar.text]).responseObject { (response: mapProfile?, error: NSError?) -> Void in
                    println("got result from server")
                    if let resultProfileAccount = response?.account {
                        println("find profile: " + resultProfileAccount)
                        //有結果
                        destinationVC.tempProfile = response
                    }else {
                        //無結果
                        JDStatusBarNotification.showWithStatus("無結果", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
                    }
                    if error != nil {
                        println(error)
                    }
                }
            }
            
        }else if segue.identifier == "TitleViewSegue" {
            url += "searchArticle"
            //傳送給伺服器
            if self.searchScope() == "文章" {
                //搜尋文章, wait....
                /*
                Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : self.searchController.searchBar.text]).responseObject { (response: mapProfile?, error: NSError?) -> Void in
                    println("got result from server")
                    if let resultProfileAccount = response?.account {
                        //有結果
                        self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
                    }else {
                        //無結果
                        JDStatusBarNotification.showWithStatus("沒有搜尋結果", dismissAfter: 0.5)
                    }
                    if error != nil {
                        println(error)
                    }*/
                }
        }
    }
    
    
    
    
    

}


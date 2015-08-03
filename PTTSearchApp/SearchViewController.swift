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
    var histories = [SearchHistroy]()
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HintCell") as! HintTableViewCell
        if self.searchController.active {
            cell.MainLabel.text = self.filtedHints[indexPath.row]
        }else {
            cell.MainLabel.text = self.histories[indexPath.row].hint
        }
        return cell
        
        
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
        let loadhints = SearchHistroy.sorted(by: "searchTime", ascending: false).firsts(30).find()
        println("load history hints: ")
        print(loadhints.count)
        self.histories.removeAll(keepCapacity: false)
        for var i = 0; i < loadhints.count; i++ {
            if let hint = loadhints.objectAtIndex(UInt(i)) as? SearchHistroy {
                self.addHintInArray(hint.hint)
                self.histories += [hint]
            }
        }
        self.tableView.reloadData()
    }
    
    func saveHistoryHint(hint: String) {
        if let history:SearchHistroy = SearchHistroy.create() as? SearchHistroy {
            history.hint = hint
            history.searchTime = NSDate()
            history.scope = self.searchScope()
            history.save()
        }
        self.loadHistoryHint()
    }
    
    
    
//navigation
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //save search history to core data
        self.saveHistoryHint(searchBar.text)
        self.addHintInArray(searchBar.text)
        println("search for: " + searchBar.text)
        //navi
        switch self.searchScope() {
        case "文章" :
            self.searchController.active = false
            self.performSegueWithIdentifier("TitleViewSegue", sender: self)
            println("Show titles view")
        case "帳號" :
            self.searchController.active = false
            self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
            println("Show profile view")
        default:
            println("error: different scope")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.searchController.active == true {
            let hint = self.filtedHints[indexPath.row]
            self.saveHistoryHint(hint)
            println("search for: " + hint)
            //navi
            self.searchController.searchBar.text = hint
            println("search for: " + hint)
            switch self.searchScope() {
            case "文章" :
                self.searchController.active = false
                self.performSegueWithIdentifier("TitleViewSegue", sender: self)
                println("Show titles view")
            case "帳號" :
                self.searchController.active = false
                self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
                println("Show profile view")
            default:
                println("error: different scope")
            }
        }else {
            let selectHint = self.histories[indexPath.row]
            println("search for: " + selectHint.hint)
            switch selectHint.scope {
            case "帳號" :
                self.searchController.searchBar.text = selectHint.hint
                self.performSegueWithIdentifier("ProfileViewSegue", sender: self)
            case "文章" :
                self.searchController.searchBar.text = selectHint.hint
                self.performSegueWithIdentifier("TitleViewSegue", sender: self)
            default:
                println("unknow scope")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "ProfileViewSegue"{
            if let destinationVC = segue.destinationViewController as? ProfileViewController {
                let account = self.searchController.searchBar.text
                destinationVC.account = account
                //查看是否有舊檔案
                if let profile = SearchResult.by("account", equalTo: account).by("scope", equalTo: "帳號").find().firstObject() as? SearchResult {
                    //已經加入離線最愛
                    destinationVC.isFavor = true
                }
            }
            
        }else if segue.identifier == "TitleViewSegue" {
            
        }
    }
    
    
    
    
    

}


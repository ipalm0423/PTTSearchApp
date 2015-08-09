//
//  TitlesViewController.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/31.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import JDStatusBarNotification
import SugarRecord

class TitlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var hint = ""
    var scopes = ""
    var titles = [mapTitle]()
    var showIndicator = true {
        didSet {
            self.tableView.reloadData()
        }
    }
    var indicatorText = "搜尋中"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchTitle(self.hint, scopes: self.scopes, startRow: self.titles.count + 1, counts: 10)
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//table view delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            //indicator
            if self.titles.count > 0 && self.showIndicator == false {
                return 0
            }else {
                return 1
            }
        }
        
        return self.titles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            //indicator
            let cell = self.tableView.dequeueReusableCellWithIdentifier("IndicatorCell") as! IndicatorTableViewCell
            cell.indicator.startAnimating()
            cell.indicator.hidden = !self.showIndicator
            cell.indicatorLabel.text = self.indicatorText
            return cell
        }
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TitlesCell", forIndexPath: indexPath) as! TitlesTableViewCell
        let title = self.titles[indexPath.row]
        cell.titleLabel.text = title.title
        cell.subLabel.text = title.subTitle
        cell.accountLabel.text = title.account
        cell.pushLabel.text = title.pushes
        cell.timeLabel.text = Singleton.sharedInstance.NSDateToDaysString(title.time!)
        cell.boardLabel.text = "@" + title.board!
        //未來更新
        cell.setupIcon(nil)
        cell.setupPushLabelColor()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
//scroll view delegate
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset = scrollView.contentOffset
        var bounds = scrollView.bounds
        var size = scrollView.contentSize
        var inset = scrollView.contentInset
        
        var y = offset.y + bounds.height - inset.bottom
        var h = size.height
        
        if y > (h + 60) {
            
            self.searchTitle(self.hint, scopes: self.scopes, startRow: self.titles.count + 1, counts: 10)
        }
    }
    
    
    
    
//internet
    func searchTitle(hint: String, scopes: String, startRow: Int, counts: Int) {
        self.showIndicator = true
        self.indicatorText = "搜尋中"
        var url = Singleton.sharedInstance.serverURL + "search/searchArticle"
        println("search for title...")
        //搜尋帳號
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : hint,  "scope" : scopes, "startCount" : startRow, "counts" : counts]).responseObject { (response: mapTitles?, error: NSError?) -> Void in
            println("got feedback from server")
            self.showIndicator = false
            if let resultTitles = response?.titles {
                println("get " + resultTitles.count.description + " titles from server")
                if resultTitles.count == 0 {
                    self.indicatorText = "無搜尋結果"
                    return
                }
                //有結果
                self.titles += resultTitles
                
            }else {
                //無結果
                JDStatusBarNotification.showWithStatus("請檢查網路連線", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
                self.indicatorText = "請檢查網路"
            }
            
            self.tableView.reloadData()
            
            if error != nil {
                println(error)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ArticleViewSegue"{
            if let destinationVC = segue.destinationViewController as? ArticleViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let title = self.titles[indexPath.row]
                    destinationVC.tempTitle = title
                    //查看是否有舊檔案
                    if let result = SearchResult.by("uid", equalTo: title.uid!).find().firstObject() as? SearchResult {
                        //已經加入離線最愛
                        destinationVC.isFavor = true
                    }
                }
            }
            
        }
    }
    
    
    
    
}

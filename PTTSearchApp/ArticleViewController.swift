//
//  ArticleViewController.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/8/8.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import JDStatusBarNotification
import SugarRecord

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var uid = ""
    var tempTitle: mapTitle?
    var contents = [mapContent]()
    var pushes = [mapContent]()
    var showIndicator = true
    var indicatorText = "搜尋中"
    var showInformationRow = true {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if let title = tempTitle {
            self.searchArticle(title.uid!)
            self.navigationItem.title = title.board
        }else {
            self.searchTitle(self.uid)
            self.searchArticle(self.uid)
        }
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//table view delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.indicatorText == "搜尋中" && self.showIndicator == true {
                return 0
            }
            return 1
        case 1:
            return self.contents.count
        case 2:
            return self.pushes.count
        case 3:
            if self.contents.count > 0 && self.showInformationRow == false {
                return 0
            }else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("topArticleCell") as! ArticleTopTableViewCell
            if let title = self.tempTitle {
                var name = ""
                if let tempname = title.name {
                    name = tempname
                }
                cell.titleLabel.text = title.title
                cell.subLabel.text = title.subTitle
                cell.accountLabel.text = title.account! + " (" + name + ")"
                cell.timeLabel.text = Singleton.sharedInstance.NSDateToTWString(title.time!)
                cell.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds)
                //未來更新
                //cell.iconView.hidden = true
            }
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("contentArticleCell", forIndexPath: indexPath) as! ArticleContentTableViewCell
            let content = self.contents[indexPath.row]
            cell.contentLabel.text = content.content
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("pushArticleCell", forIndexPath: indexPath) as! ArticlePushTableViewCell
            let push = self.pushes[indexPath.row]
            cell.contentLabel.text = push.content
            cell.accountLabel.text = push.account
            cell.floorLabel.text = (indexPath.row + 1).description + "樓"
            cell.timeLabel.text = Singleton.sharedInstance.NSDateToTWString(push.time!)
            cell.setupPushLabelColor(push.subType!)
            cell.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds)
            return cell
        default:
            //indicator cell
            let cell = self.tableView.dequeueReusableCellWithIdentifier("IndicatorCell") as! IndicatorTableViewCell
            cell.indicator.startAnimating()
            cell.indicator.hidden = !self.showIndicator
            cell.indicatorLabel.text = self.indicatorText
            return cell
        }
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
            if self.contents.count > 0 {
               self.searchNewPushes(self.tempTitle!.uid!, startRow: self.pushes.count + 1)
            }else {
                if let title = self.tempTitle {
                    self.searchArticle(title.uid!)
                }
            }
            
        }
    }
    
    
    
    
    
//favor button
    @IBOutlet weak var favorButton: UIButton!
    var isFavor = false {
        didSet {
            if self.isFavor == true {
                self.favorButton.setImage(UIImage(named: "heart-black-vec-20"), forState: UIControlState.Normal)
                
            }else {
                self.favorButton.setImage(UIImage(named: "heart-vec-20"), forState: UIControlState.Normal)
                
            }
        }
    }
    
    
    @IBAction func favorButtonTouch(sender: AnyObject) {
        if let uid = self.tempTitle?.uid {
            //animate
            if self.isFavor == false {
                //儲存
                if self.saveNewTitle() {
                    self.isFavor = true
                    JDStatusBarNotification.showWithStatus("已加入最愛", dismissAfter: 1, styleName: JDStatusBarStyleSuccess)
                }
            }else {
                //刪除
                if self.deleteTitle(uid) {
                    self.isFavor = false
                    JDStatusBarNotification.showWithStatus("移除最愛", dismissAfter: 1, styleName: JDStatusBarStyleDark)
                }
            }
        }
        
    }
    
    
    
    
//core data
    func saveNewTitle() -> Bool {
        if let newTitle: SearchResult = SearchResult.create() as? SearchResult {
            let saveTitle = self.tempTitle!
            newTitle.uid = saveTitle.uid
            newTitle.scope = "文章"
            newTitle.saveTime = NSDate()
            newTitle.account = saveTitle.account
            newTitle.name = saveTitle.name
            newTitle.ip = saveTitle.ip
            newTitle.url = saveTitle.url
            newTitle.title = saveTitle.title
            newTitle.subTitle = saveTitle.subTitle
            newTitle.board = saveTitle.board
            newTitle.time = saveTitle.time
            newTitle.pushes = saveTitle.pushes
            newTitle.icon = saveTitle.icon
            newTitle.politic = saveTitle.politic
            newTitle.motheruid = saveTitle.motheruid
            newTitle.childuid = saveTitle.childuid
            newTitle.tag = saveTitle.tag
            
            return newTitle.save()
            
        }
        return false
    }
    
    
    func updateOldTitle(uid: String) {
        if let newTitle = SearchResult.by("uid", equalTo: uid).by("scope", equalTo: "文章").find().firstObject() as? SearchResult {
            
            let saveTitle = self.tempTitle!
            
            newTitle.beginWriting()
            newTitle.uid = saveTitle.uid
            newTitle.scope = "文章"
            newTitle.saveTime = NSDate()
            newTitle.account = saveTitle.account
            newTitle.name = saveTitle.name
            newTitle.ip = saveTitle.ip
            newTitle.url = saveTitle.url
            newTitle.title = saveTitle.title
            newTitle.subTitle = saveTitle.subTitle
            newTitle.board = saveTitle.board
            newTitle.time = saveTitle.time
            newTitle.pushes = saveTitle.pushes
            newTitle.icon = saveTitle.icon
            newTitle.politic = saveTitle.politic
            newTitle.motheruid = saveTitle.motheruid
            newTitle.childuid = saveTitle.childuid
            newTitle.tag = saveTitle.tag
            newTitle.endWriting()
            
        }
    }
    
    
    func deleteTitle(uid: String) -> Bool {
        if let title = SearchResult.by("uid", equalTo: uid).by("scope", equalTo: "文章").find().firstObject() as? SearchResult {
            title.beginWriting()
            title.delete()
            title.endWriting()
            return true
        }
        return false
    }
    
    
    
    
//internet
    func searchArticle(uid: String) {
        self.showIndicator = true
        self.indicatorText = "搜尋中"
        self.showInformationRow = true
        var url = Singleton.sharedInstance.serverURL + "article/uid"
        println("search for article in uid: " + uid)
        //搜尋帳號
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "uid" : uid]).responseObject { (response: mapContents?, error: NSError?) -> Void in
            
            if let contents = response {
                println("got feedback from server")
                self.showIndicator = false
                self.showInformationRow = false
                //have response
                //content to array
                if let resultContent = response?.contents {
                    println("get " + resultContent.count.description + " contents from server")
                    self.contents = resultContent
                }
                //pushes to array
                if let resultPushes = response?.pushes {
                    println("get " + resultPushes.count.description + " pushes from server")
                    if resultPushes.count == 0 {
                        self.indicatorText = "目前無人推文"
                        self.showInformationRow = true
                    }else {
                        self.pushes = resultPushes
                    }
                }
            }else {
                //無結果
                JDStatusBarNotification.showWithStatus("請檢查網路連線", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
                self.indicatorText = "請檢查網路"
                self.showIndicator = false
                self.showInformationRow = true
                return
            }
            self.tableView.reloadData()
            if error != nil {
                println(error)
            }
        }
    }
    
    func searchTitle(uid: String) {
        self.showIndicator = true
        self.indicatorText = "搜尋中"
        self.showInformationRow = true
        var url = Singleton.sharedInstance.serverURL + "article/title/uid"
        println("search for article in uid: " + uid)
        //搜尋帳號
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "uid" : uid]).responseObject { (response: mapTitle?, error: NSError?) -> Void in
            
            if let title = response {
                println("got feedback from server")
                self.showIndicator = false
                self.showInformationRow = false
                //have response
                self.tempTitle = title
            }else {
                //無結果
                JDStatusBarNotification.showWithStatus("請檢查網路連線", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
                self.indicatorText = "請檢查網路"
                self.showIndicator = false
                self.showInformationRow = true
                return
            }
            self.tableView.reloadData()
            if error != nil {
                println(error)
            }
        }
    }
    
    func searchNewPushes(uid: String, startRow: Int) {
        self.showIndicator = true
        self.indicatorText = "搜尋新推文"
        self.showInformationRow = true
        var url = Singleton.sharedInstance.serverURL + "article/uid"
        println("search for new push in uid: " + uid)
        //搜尋帳號
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "uid" : uid, "startRow" : startRow]).responseObject { (response: mapContents?, error: NSError?) -> Void in
            println("got feedback from server")
            self.showIndicator = false
            self.showInformationRow = false
            if let contents = response {
                //have response
                //pushes to array
                if let resultPushes = response?.pushes {
                    println("get " + resultPushes.count.description + " new pushes from server")
                    if resultPushes.count == 0 {
                        self.indicatorText = "沒有新的推文"
                        self.showInformationRow = true
                    }else {
                        self.pushes += resultPushes
                    }
                }
            }else {
                //無結果
                JDStatusBarNotification.showWithStatus("請檢查網路連線", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
                self.indicatorText = "請檢查網路"
                self.showIndicator = false
                self.showInformationRow  = true
                return
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

}

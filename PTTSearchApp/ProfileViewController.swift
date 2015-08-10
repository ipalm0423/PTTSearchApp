//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tempProfile: mapProfile?
    var account = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchProfile(self.account)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    
//table view delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let profile = self.tempProfile {
            switch section {
                
            case 1:
                return 2
            case 3:
                if let pushlist = profile.pushList {
                    return pushlist.count + 1
                }else {
                    return 1
                }
            case 2:
                if let articlelist = profile.articleList {
                    return articlelist.count + 1
                }else {
                    return 1
                }
                /* //未來加入comment功能
                case 4:
                if let commentlist = self.tempProfile?.commentList {
                return commentlist.count + 1
                }else {
                return 1
                }*/
            default:
                return 0
                
            }
        }
        // no profile
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.tempProfile != nil {
            return 4
        }
        //no profile
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let profile = self.tempProfile {
            var totalArticle = "0"
            var totalPush = "0"
            var onlineCount = "0"
            if let articles = profile.totalArticle {
                totalArticle = articles
            }
            if let pushes = profile.totalPush {
                totalPush = pushes
            }
            if let onlinecount = profile.onlineCount {
                onlineCount = onlinecount
            }
            switch indexPath.section {
            case 1:
                
                if indexPath.row == 0 {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("BasicProfileCell", forIndexPath: indexPath) as! BasicProfileTableViewCell
                    
                    cell.accountLabel.text = profile.account
                    cell.nameLabel.text = profile.name
                    cell.scoreLabel.text = profile.score
                    cell.lastOnlineLabel.text = "登入時間：" + Singleton.sharedInstance.NSDateToTWString(profile.lastOnline!)
                    cell.areaLabel.text = profile.ip
                    cell.onlineCountLabel.text = "上站次數：" + onlineCount
                    //未來更新
                    cell.setupIcon(nil)
                    
                    
                    return cell
                }else {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("ButtonProfileCell", forIndexPath: indexPath) as! ButtonProfileTableViewCell
                    
                    
                    cell.ArticleButton.setTitle(totalArticle, forState: UIControlState.Normal)
                    cell.PushButton.setTitle(totalPush, forState: UIControlState.Normal)
                    cell.setupButtonWidth()
                    return cell
                }
            case 3:
                
                let pushcount = profile.pushList!.count
                if indexPath.row == pushcount {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("MorePushCell") as! MorePushTableViewCell
                    return cell
                }else {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("PushCell", forIndexPath: indexPath) as! PushTableViewCell
                    let push = profile.pushList![indexPath.row]
                    cell.titleLabel.text = push.title
                    cell.pushLabel.text = push.content
                    cell.timeLabel.text = Singleton.sharedInstance.NSDateToDaysString(push.time!)
                    
                    return cell
                }
                
            case 2:
                let titlecount = profile.articleList!.count
                if indexPath.row == titlecount {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("MoreArticleCell") as! MoreArticleTableViewCell
                    return cell
                }else {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! TitleViewTableViewCell
                    let title = profile.articleList![indexPath.row]
                    cell.titleLabel.text = title.title
                    cell.subTitleLabel.text = title.subTitle
                    cell.accountLabel.text = title.account! + "(" + title.name! + ")"
                    cell.pushLabel.text = title.pushes
                    cell.timeLabel.text = Singleton.sharedInstance.NSDateToDaysString(title.time!)
                    cell.boardLabel.text = "@" + title.board!
                    //等未來更新
                    cell.setupIcon(nil)
                    cell.setupPushLabelColor()
                    return cell
                }
                /*
            case 4:
            等待未來更新
            */
                
            default:
                let cell = self.tableView.dequeueReusableCellWithIdentifier("MoreCommentCell", forIndexPath: indexPath) as! MoreCommentTableViewCell
                return cell
            }
        }else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("MoreCommentCell") as! MoreCommentTableViewCell
            cell.commentLabel.text = "無搜尋結果"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return nil
        case 2:
            return "歷史文章："
        case 3:
            return "歷史推文："
            /*
        case 4:
            return "網友評論："
            */
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                return 250
            }else {
                return 100
            }
        case 3:
            return 80
        case 2:
            return 100
            /*
        case 4:
            */
        default:
            return 80
        }
    }
    
    
    
    
//internet
    func searchProfile(account: String) {
        var url = Singleton.sharedInstance.serverURL + "search/searchProfile"
        println("search for profile...")
        //搜尋帳號
        Alamofire.request(.GET, url, parameters: ["agent" : "iphone", "hint" : account]).responseObject { (response: mapProfile?, error: NSError?) -> Void in
            println("got feedback from server")
            if let resultProfileAccount = response?.account {
                println("find profile: " + resultProfileAccount)
                //有結果
                self.tempProfile = response
                self.tableView.reloadData()
                self.updateOldProfile(resultProfileAccount)
            }else {
                //無結果
                JDStatusBarNotification.showWithStatus("無結果", dismissAfter: 1.0, styleName: JDStatusBarStyleWarning)
            }
            if error != nil {
                println(error)
            }
        }
    }
    
    
    
//button
    
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
        if let account = self.tempProfile?.account {
            //animate
            if self.isFavor == false {
                //儲存
                if self.saveNewProfile() {
                    self.isFavor = true
                    JDStatusBarNotification.showWithStatus("已加入最愛", dismissAfter: 1, styleName: JDStatusBarStyleSuccess)
                }
            }else {
                //刪除
                if self.deleteProfile(account) {
                    self.isFavor = false
                    JDStatusBarNotification.showWithStatus("移除最愛", dismissAfter: 1, styleName: JDStatusBarStyleDark)
                }
            }
        }
    }
    
    
    
    
    
//core data
    func saveNewProfile() -> Bool {
        if let profile:SearchResult = SearchResult.create() as? SearchResult {
            let saveProfile = self.tempProfile!
            profile.uid = saveProfile.uid
            profile.scope = "帳號"
            profile.account = saveProfile.account
            profile.name = saveProfile.name
            profile.ip = saveProfile.ip
            profile.icon = saveProfile.icon
            profile.saveTime = NSDate()
            profile.score = saveProfile.score
            profile.lastOnline = saveProfile.lastOnline
            profile.osArticle = saveProfile.osArticle
            profile.ofArticle = saveProfile.ofArticle
            profile.totalArticle = saveProfile.totalArticle
            profile.totalPush = saveProfile.totalPush
            profile.onlineCount = saveProfile.onlineCount
            profile.follower = saveProfile.follower
            profile.greenPush = saveProfile.greenPush
            profile.redPush = saveProfile.redPush
            
            return profile.save()
        }
        return false
    }
    
    func updateOldProfile(account: String) {
        if let profile = SearchResult.by("account", equalTo: account).by("scope", equalTo: "帳號").find().firstObject() as? SearchResult {
            
            let saveProfile = self.tempProfile!
            
            profile.beginWriting()
            profile.uid = saveProfile.uid
            profile.scope = "帳號"
            profile.account = saveProfile.account
            profile.name = saveProfile.name
            profile.ip = saveProfile.ip
            profile.icon = saveProfile.icon
            profile.saveTime = NSDate()
            profile.score = saveProfile.score
            profile.lastOnline = saveProfile.lastOnline
            profile.osArticle = saveProfile.osArticle
            profile.ofArticle = saveProfile.ofArticle
            profile.totalArticle = saveProfile.totalArticle
            profile.totalPush = saveProfile.totalPush
            profile.onlineCount = saveProfile.onlineCount
            profile.follower = saveProfile.follower
            profile.greenPush = saveProfile.greenPush
            profile.redPush = saveProfile.redPush
            profile.endWriting()
        }
        
    }
    
    func deleteProfile(account: String) -> Bool {
        if let profile = SearchResult.by("account", equalTo: account).by("scope", equalTo: "帳號").find().firstObject() as? SearchResult {
            profile.beginWriting()
            profile.delete()
            profile.endWriting()
            return true
        }
        return false
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
        
        
        if segue.identifier == "MorePushViewSegue"{
            if let destinationVC = segue.destinationViewController as? PushViewController {
                let account = self.account
                destinationVC.hint = account
                destinationVC.scopes = "push"
                destinationVC.navigationItem.title = "所有推文"
            }
            
        }else if segue.identifier == "MoreTitleViewSegue" {
            if let destinationVC = segue.destinationViewController as? TitlesViewController {
                let hint = self.account
                destinationVC.hint = hint
                destinationVC.scopes = "account"
                destinationVC.navigationItem.title = "所有文章"
            }
        }
    }
    
    
    
    
}

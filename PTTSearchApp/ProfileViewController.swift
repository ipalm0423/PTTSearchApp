//
//  ProfileViewController.swift
//  PTTSearchApp
//
//  Created by 陳冠宇 on 2015/7/31.
//  Copyright (c) 2015年 陳冠宇. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tempProfile: mapProfile?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
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
            case 2:
                if let pushlist = profile.pushList {
                    return pushlist.count + 1
                }else {
                    return 1
                }
            case 3:
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
            if let articles = profile.totalArticle {
                totalArticle = articles
            }
            if let pushes = profile.totalPush {
                totalPush = pushes
            }
            switch indexPath.section {
            case 1:
                
                if indexPath.row == 0 {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier("BasicProfileCell", forIndexPath: indexPath) as! BasicProfileTableViewCell
                    
                    cell.accountLabel.text = profile.account
                    cell.nameLabel.text = profile.name
                    cell.scoreLabel.text = profile.score
                    cell.lastOnlineLabel.text = Singleton.sharedInstance.NSDateToTWString(profile.lastOnline!)
                    cell.areaLabel.text = profile.ip
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
            case 2:
                
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
                
            case 3:
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
                    cell.pushLabel.text = title.totalPush
                    cell.timeLabel.text = Singleton.sharedInstance.NSDateToDaysString(title.time!)
                    cell.boardLabel.text = "@" + title.board!
                    //等未來更新
                    cell.setupIcon(nil)
                    
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
            return "歷史推文："
        case 3:
            return "歷史文章："
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
        case 2:
            return 80
        case 3:
            return 100
            /*
        case 4:
            */
        default:
            return 80
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

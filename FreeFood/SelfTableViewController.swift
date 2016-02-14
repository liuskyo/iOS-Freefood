//
//  SelfTableViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/23.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit

class SelfTableViewController: UITableViewController {
    var orgfoodInfromations:[PFObject]=[]//未經貼文期限篩選之cell陣列
    var foodInfromations:[PFObject]=[] //儲存 食物資訊cell的陣列

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        canDisplayBannerAds=true
    }
    
    
    override func viewDidAppear(animated: Bool) {

        
        let date = NSDate() //取得目前時間
        
        let query=PFQuery(className: "foodInfromation")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (array, error:NSError?) -> Void in
            //確認把陣列清空
            self.orgfoodInfromations=[]
            self.foodInfromations=[]
            
            
            self.orgfoodInfromations = array!
            
            //如果超過貼文期限則不貼文,把未過期資訊存入foodInfromations陣列中
            //並且把相同機器(uuid)的資料顯示出
            for(var i=0;i<self.orgfoodInfromations.count;i++){
                var deadLineDate:NSDate=self.orgfoodInfromations[i]["deadLine"] as! NSDate
                var uuid:String=(UIDevice.currentDevice().identifierForVendor?.UUIDString)!
                var objuuid:String=self.orgfoodInfromations[i]["uuid"] as! String
                if (deadLineDate.timeIntervalSince1970 >= date.timeIntervalSince1970 && uuid == objuuid){
                    self.foodInfromations.append(self.orgfoodInfromations[i])
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.foodInfromations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuse", forIndexPath: indexPath)

        cell.textLabel?.text=self.foodInfromations[indexPath.row]["foodName"] as! String
        var date:NSDate=self.foodInfromations[indexPath.row].valueForKey("deadLine") as! NSDate
        var dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="YYYY/MM/dd-hh:ss"
        cell.detailTextLabel?.text=("貼文期限:" + dateFormatter.stringFromDate(date))

        return cell
    }


    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue"){
            let sdvc=segue.destinationViewController as! SelfDetailViewController
            
            let indextpath=self.tableView.indexPathForCell(sender as! UITableViewCell)
            sdvc.cellID=self.foodInfromations[(indextpath?.row)!].objectId!
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

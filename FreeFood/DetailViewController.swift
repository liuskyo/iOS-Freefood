//
//  DetailViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/21.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var takeWayText: UITextView!
    @IBOutlet weak var deadLineLabel: UILabel!
    
    var cellID:String = "" //記錄foodinfromation objectID


    override func viewDidLoad() {
        super.viewDidLoad()
        //清空所有text 以免來不及顯示資料使用者會看到label之類的文字
        foodNameLabel.text=""
        nameLabel.text=""
        numberLabel.text=""
        addressLabel.text=""
        takeWayText.text=""
    
print(cellID)
        var query = PFQuery(className:"foodInfromation")
        query.getObjectInBackgroundWithId(cellID) {
            (foodInfromation: PFObject?, error: NSError?) -> Void in
            if error == nil && foodInfromation != nil {
                self.foodNameLabel.text=foodInfromation?.valueForKey("foodName") as! String
                self.nameLabel.text=foodInfromation?.valueForKey("name") as! String
                self.numberLabel.text=String(foodInfromation!.valueForKey("number") as! Int)
                self.addressLabel.text=foodInfromation?.valueForKey("address") as! String
                self.takeWayText.text=foodInfromation?.valueForKey("takeWay") as! String
                if(foodInfromation?.valueForKey("deadLine") != nil){
                    var date:NSDate=foodInfromation?.valueForKey("deadLine") as! NSDate
                    var dateFormatter=NSDateFormatter()
                    dateFormatter.dateFormat="YYYY/MM/dd-hh:ss"
                    self.deadLineLabel.text=dateFormatter.stringFromDate(date)
                }
                
            } else {
                print(error)
            }
        }
    canDisplayBannerAds=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

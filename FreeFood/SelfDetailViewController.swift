//
//  SelfDetailViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/27.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit

class SelfDetailViewController: ViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var foodNameText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var takeWayText: UITextView!
    @IBOutlet weak var deadLineDatepicker: UIDatePicker!
    var cellID:String = "" //記錄foodinfromation objectID
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //清空所有text 以免來不及顯示資料使用者會看到label之類的文字
        nameText.text=""
        foodNameText.text=""
        numberText.text=""
        addressText.text=""
        takeWayText.text=""
        
        
        
        var query = PFQuery(className:"foodInfromation")
        query.getObjectInBackgroundWithId(cellID) {
            (foodInfromation: PFObject?, error: NSError?) -> Void in
            if error == nil && foodInfromation != nil {
                self.foodNameText.text=foodInfromation?.valueForKey("foodName") as! String
                self.nameText.text=foodInfromation?.valueForKey("name") as! String
                self.numberText.text=String(foodInfromation!.valueForKey("number") as! Int)
                self.addressText.text=foodInfromation?.valueForKey("address") as! String
                self.takeWayText.text=foodInfromation?.valueForKey("takeWay") as! String
                if(foodInfromation?.valueForKey("deadLine") != nil){
                    var date:NSDate=foodInfromation?.valueForKey("deadLine") as! NSDate
                   self.deadLineDatepicker.date=date
                }
                
            } else {
                print(error)
            }
        }
    }
    
    
    
    @IBAction func plusButton(sender: UIButton) {
        var number:Int=Int(self.numberText.text!)!
        number=number+1
        self.numberText.text=String(number)
    }
    
    @IBAction func minusButton(sender: UIButton) {
        
        var number:Int=Int(self.numberText.text!)!
        if(number>0){
        number=number-1
        self.numberText.text=String(number)
        }
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="segue"){
            
            var query = PFQuery(className:"foodInfromation")
            query.getObjectInBackgroundWithId(cellID) {
                (foodInfromation: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let foodInfromation = foodInfromation {
                    foodInfromation["name"]=self.nameText.text
                    foodInfromation["foodName"]=self.foodNameText.text
                    foodInfromation["number"]=Int(self.numberText.text!)
                    foodInfromation["address"]=self.addressText.text
                    foodInfromation["takeWay"]=self.takeWayText.text
                    foodInfromation["deadLine"]=self.deadLineDatepicker.date
                    foodInfromation["uuid"]=UIDevice.currentDevice().identifierForVendor?.UUIDString
                    //利用geoCoder找出使用者輸入城市和經緯度
                    let geoCoder = CLGeocoder()
                    
                    geoCoder.geocodeAddressString(self.addressText.text!) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                        if error != nil{
                            print(error)
                            return
                        }
                        
                        if placemarks != nil && placemarks!.count > 0{
                            let placemark = placemarks?.first
                            //                print(placemark)
                            //                print(placemark?.country)
                            //                print(placemark?.administrativeArea)
                            //                print(placemark?.locality)
                            //                print(placemark?.subLocality)
                            
                            foodInfromation["city"]=placemark?.administrativeArea //城市
                            foodInfromation["area"]=placemark?.locality          //行政區
                            foodInfromation["lat"]=placemark?.location?.coordinate.latitude  //經度
                            foodInfromation["lng"]=placemark?.location?.coordinate.longitude //緯度
                            
                            foodInfromation.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                                print("Ifo has been saved")
                            }
                        }
                    foodInfromation.saveInBackground()
                }
            }
            
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //若使用者未輸入完整資料,跳出提示
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier=="segue"){
            
            
            if (nameText.text==""){
                let alert = UIAlertView()
                alert.title = "未輸入提供者名稱"
                alert.message = "請輸入提供者名稱"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }else if(foodNameText.text==""){
                let alert = UIAlertView()
                alert.title = "未輸入食物名稱"
                alert.message = "請輸入提供食物名稱"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }else if(numberText.text==""){
                let alert = UIAlertView()
                alert.title = "未輸入食物份數"
                alert.message = "請輸入提供食物份數"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }else if(addressText.text==""){
                let alert = UIAlertView()
                alert.title = "未輸入地址"
                alert.message = "請輸入提供地址"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }else if(takeWayText.text==""){
                let alert = UIAlertView()
                alert.title = "未輸入領取方式"
                alert.message = "請輸入食物領取方式"
                alert.addButtonWithTitle("Ok")
                alert.show()
                return false
            }
                
            else{
                return true
            }
        }else {
            return true
        }
        
    }
    
    //觸碰背景時,收回鍵盤
    @IBAction func TouchUpInsideBackground(sender: AnyObject) {
        nameText.resignFirstResponder()
        foodNameText.resignFirstResponder()
        numberText.resignFirstResponder()
        addressText.resignFirstResponder()
        takeWayText.resignFirstResponder()
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

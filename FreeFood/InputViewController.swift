//
//  InputViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/16.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit


class InputViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var foodNameText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var takeWayText: UITextView!
    @IBOutlet weak var deadLinePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
takeWayText.text="" //清空提供方式textfild
       
    }

    
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="segue"){
        
        //讓使用者輸入資料上傳parse
        let foodInfromation=PFObject(className: "foodInfromation")
        foodInfromation["name"]=nameText.text
        foodInfromation["foodName"]=foodNameText.text
        foodInfromation["number"]=Int(numberText.text!)
        foodInfromation["address"]=addressText.text
        foodInfromation["takeWay"]=takeWayText.text
        foodInfromation["deadLine"]=deadLinePicker.date
        foodInfromation["uuid"]=UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        //利用geoCoder找出使用者輸入城市和經緯度
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addressText.text!) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
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
        }
        
        //上傳parse
        foodInfromation.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            print("Ifo has been saved")
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

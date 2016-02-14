//
//  HomeTableViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/16.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit
import iAd


class HomeTableViewController: UITableViewController,CLLocationManagerDelegate {
    var orgfoodInfromations:[PFObject]=[]//未經貼文期限篩選之cell陣列
    var foodInfromations:[PFObject]=[] //儲存 食物資訊cell的陣列
    var cityfoodInfromations:[PFObject]=[]//儲存 同城市食物資訊cell陣列
    var chooseCity:Bool=true           //紀錄是否選擇同縣市資料
    var location:CLLocationManager!    //cllocation幫忙定位
    var city:String=""                 //使用者目前所在城市
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = CLLocationManager();
        location.delegate = self;
        
        location.requestAlwaysAuthorization()
        //詢問使用者是否同意給APP定位功能
        location.requestWhenInUseAuthorization();
        //開始接收目前位置資訊
        location.startUpdatingLocation();
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
            for(var i=0;i<self.orgfoodInfromations.count;i++){
                var deadLineDate:NSDate=self.orgfoodInfromations[i]["deadLine"] as! NSDate
            if (deadLineDate.timeIntervalSince1970 >= date.timeIntervalSince1970){
                self.foodInfromations.append(self.orgfoodInfromations[i])
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate //取得目前經緯度
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let geoCoder = CLGeocoder()
        
        //由經緯度取得目前所在城市
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)) { (placemarks:[CLPlacemark]?,error:NSError?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if placemarks != nil && placemarks!.count > 0{
                let placemark = placemarks?.first
                print(placemark?.locality)
                print(placemark?.administrativeArea)
                self.city=(placemark?.administrativeArea)!
                
                
                //存取相同城市食物資訊進cityfoodInfromations陣列中
                if(self.cityfoodInfromations==[] && self.foodInfromations != []){
                
                for (var i=0;i<self.foodInfromations.count;i++){
                    if(self.foodInfromations[i]["city"] != nil){
                    if(self.foodInfromations[i]["city"] as! String == self.city){
                    self.cityfoodInfromations.append(self.foodInfromations[i])
                    }
                    }
                    self.tableView.reloadData()
                    self.cityfoodInfromations==[]
                }
                
                }
                
            }
        }
        
      // NSThread.sleepForTimeInterval(5)
    }

    
    
    

    
   
    override func viewDidDisappear(animated: Bool) {
        location.stopUpdatingLocation()
    }
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.chooseCity==true){
            return cityfoodInfromations.count}  //如果選取相同縣市回傳較少比數cell
        else{
            return foodInfromations.count}
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:HomeTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuse", forIndexPath: indexPath) as! HomeTableViewCell
        if(self.chooseCity==true){
            cell.foodNameLabel.text=cityfoodInfromations[indexPath.row]["foodName"] as! String
            cell.nameLabel.text=cityfoodInfromations[indexPath.row]["name"] as! String
            cell.numberLabel.text=String(cityfoodInfromations[indexPath.row]["number"] as! Int)
            cell.addressLabel.text=cityfoodInfromations[indexPath.row]["address"] as! String
        }else{
      cell.foodNameLabel.text=foodInfromations[indexPath.row]["foodName"] as! String
      cell.nameLabel.text=foodInfromations[indexPath.row]["name"] as! String
      cell.numberLabel.text=String(foodInfromations[indexPath.row]["number"] as! Int)
      cell.addressLabel.text=foodInfromations[indexPath.row]["address"] as! String
        }
        return cell
    }
    

 
    @IBAction func touchDownChooseCityButton(sender: AnyObject) {
        self.chooseCity=true
        self.tableView.reloadData()
    }
    
    

    @IBAction func touchDownAllCityButton(sender: AnyObject) {
        self.chooseCity=false
        self.tableView.reloadData()
    }
    
    
    //傳送選取資料的objectID至DetailViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue"){
            let dvc=segue.destinationViewController as! DetailViewController
            
            let indextpath=self.tableView.indexPathForCell(sender as! UITableViewCell)
            dvc.cellID=self.foodInfromations[(indextpath?.row)!].objectId!
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

//
//  MapViewController.swift
//  FreeFood
//
//  Created by 劉天佑 on 2015/10/21.
//  Copyright © 2015年 劉天佑. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var orgfoodInfromations:[PFObject]=[]//未經貼文期限篩選之cell陣列
    var foodInfromations:[PFObject]=[] //儲存 食物資訊cell的陣列
    var location:CLLocationManager!    //cllocation幫忙定位
    var currentCoordinate:CLLocationCoordinate2D!
    var center:Bool=false //記錄中心點是否移至目前位置過

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        location = CLLocationManager();
        location.delegate = self;
        mapView.delegate=self
        location.requestAlwaysAuthorization()
        //詢問使用者是否同意給APP定位功能
        location.requestWhenInUseAuthorization();
        //開始接收目前位置資訊
        location.startUpdatingLocation();
        
self.mapView.showsUserLocation=true
canDisplayBannerAds=true
    }

    
    override func viewDidAppear(animated: Bool) {
        
        
        let date = NSDate() //取得目前時間
        
        let query=PFQuery(className: "foodInfromation")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (array, error:NSError?) -> Void in
            self.orgfoodInfromations = array!
            
            //如果超過貼文期限則不貼文,把未過期資訊存入foodInfromations陣列中
            for(var i=0;i<self.orgfoodInfromations.count;i++){
                var deadLineDate:NSDate=self.orgfoodInfromations[i]["deadLine"] as! NSDate
                if (deadLineDate.timeIntervalSince1970 >= date.timeIntervalSince1970){
                    self.foodInfromations.append(self.orgfoodInfromations[i])
                }
            }
            for(var i=0;i<self.foodInfromations.count;i++){
                var point=MKPointAnnotation()
                point.coordinate=CLLocationCoordinate2DMake(self.foodInfromations[i]["lat"] as! Double, self.foodInfromations[i]["lng"] as! Double)
                point.title=self.foodInfromations[i]["foodName"] as! String
                point.subtitle=self.foodInfromations[i]["address"] as! String
                self.mapView.addAnnotation(point)
            }
            
        }
        
    }
    

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        var annotationView=mapView.dequeueReusableAnnotationViewWithIdentifier("reuse")
        
        if (annotationView == nil){
            annotationView=MKAnnotationView(annotation: annotation, reuseIdentifier: "reuse")
        
        annotationView!.enabled=true
        annotationView!.canShowCallout=true
        annotationView!.rightCalloutAccessoryView=UIButton.init(type: UIButtonType.DetailDisclosure) as UIButton
       // annotationView.animatesDrop=true
        annotationView?.image=UIImage(named: "Pin_Icon.png")
        
        }else{annotationView?.annotation=annotation}

        return annotationView
        
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("touch")
        self.performSegueWithIdentifier("segue", sender: view)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segue"){
            let dvc=segue.destinationViewController as! DetailViewController
            
            //用所選取之annotation title,subtitle找出選擇之食物資訊,並傳遞objectId給detailviewcontroller
            var selctAnnotation:MKAnnotation=self.mapView.selectedAnnotations.first!
            for(var i=0;i<self.foodInfromations.count;i++){
                if((self.foodInfromations[i]["foodName"] as! String == selctAnnotation.title!!) && (self.foodInfromations[i]["address"] as! String == selctAnnotation.subtitle!!)){
                    dvc.cellID=self.foodInfromations[i].valueForKey("objectId") as! String
                }
            }

        }

    }
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate //取得目前經緯度
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentCoordinate=locValue
        
        //打開視窗地圖中心移至目前位置一次
        if(self.center==false){
        self.mapView.centerCoordinate=currentCoordinate
        self.center=true
        }
        location.stopUpdatingLocation()
        //self.mapView.centerCoordinate=CLLocationCoordinate2DMake(25.0335, 121.5651)

    }
    
    
    override func viewDidDisappear(animated: Bool) {
        location.stopUpdatingLocation()
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

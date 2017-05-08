//
//  MapViewController.swift
//  BDing
//
//  Created by MILAD on 5/1/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate,  CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cellView: DCBorderedView!
    
    @IBOutlet weak var titr: UILabel!
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var categoryIcon: UIImageView!
    
    @IBOutlet weak var distance: UILabel!
    
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var coin: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var container: UIView!
    
    
    
    var index : Int = 0
    
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    var pins : [MKPointAnnotation] = [MKPointAnnotation]()
    
    var aspect = 1.0
    var isBigger: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        
        cellView.alpha = 0
        
        let locManager = CLLocationManager()
        
        locManager.requestAlwaysAuthorization()
        
        currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            
            currentLocation = locManager.location!
            
        }
        
        centerMapOnLocation(location: currentLocation)
        
        setPins()
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        singleTap.numberOfTapsRequired = 1 // you can change this value
        cellView.isUserInteractionEnabled = true
        cellView.addGestureRecognizer(singleTap)
        
        index = 0
        
    }
    func setPins(){
        
        for obj in GlobalFields.BEACON_LIST_DATAS! {
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(obj.lat!)!, longitude: Double(obj.long!)!)
            
            let annoation = MKPointAnnotation()
            
            annoation.coordinate = location
            
            annoation.title = obj.title
            
            annoation.subtitle = obj.category_title
            
            pins.append(annoation)
            
        }
        
        
        for pin in pins {
            
            mapView.addAnnotation(pin)
            
        }
        
        
    }
    
    func tapDetected() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            let obj = GlobalFields.BEACON_LIST_DATAS![self.index]
            
            let image : UIImage = UIImage(named:"mal")!
            
            let result: UIImage? = LoadPicture().load(picModel: obj.url_icon!)
            
            if(result == nil){
                vc.setup(data: CustomerHomeTableCell.init(preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic))
            }else{
                vc.setup(data: CustomerHomeTableCell.init(preCustomerImage: result ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: image, customerDistanceToMe: "0", customerCoinValue: "0", customerCoinIcon: image, customerDiscountValue: obj.discount!, customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic))
            }

            
            self.navigationBar.alpha = 0
            
            self.mapView.alpha = 0
            
        }, completion: nil)
        
    }
    
    func deletSubView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "MapViewController"))! as! MapViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
        }, completion: nil)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"

        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        anView?.image = UIImage(named:"mapPin")
        
        anView?.frame.size.width = 40
        
        anView?.frame.size.height = 40
        
        anView?.canShowCallout = false

        anView?.alpha = 1
        
        return anView

        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("taaaapped")
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            let tit = view.annotation?.title
            
            let subT = view.annotation?.subtitle
            
            self.index = -1
            
            for j in 0...GlobalFields.BEACON_LIST_DATAS!.count - 1 {
                
                self.index = j
                
                var i = GlobalFields.BEACON_LIST_DATAS![j]
                
                if(tit! == i.title! && subT! == i.category_title!){
                    
                    self.cellView.alpha = 1
                    
                    self.titr.text = i.title
                    
                    self.categoryTitle.text = i.category_title
                    
                    self.coin.text = i.coin
                    
                    self.discount.text = i.discount
                    
                    self.distance.text = i.distance
                    
                    
                    var im : UIImage? = LoadPicture().load(picModel: i.url_icon!)
                    
                    if( im == nil ){
                        
                        request("http://"+(i.url_icon?.url)! ,method: .post ,parameters: BeaconPicRequestModel(CODE: i.url_icon?.code, FILE_TYPE: i.url_icon?.file_type).getParams(), encoding : JSONEncoding.default).responseJSON { response in
                            
                            if let image = response.result.value {
                                
                                let obj = PicDataModel.init(json: image as! JSON)
                                
                                let imageData = NSData(base64Encoded: (obj?.data!)!, options: .ignoreUnknownCharacters)
                                
                                var coding: String = (i.url_icon?.url)!
                                
                                coding.append((i.url_icon?.code)!)
                                
                                SaveAndLoadModel().save(entityName: "IMAGE", datas: ["imageCode": coding.md5() , "imageData": obj?.data!])
                                
                                LoadPicture.cache.setObject(imageData!, forKey: coding.md5() as AnyObject)
                                
                                var pic = UIImage(data: imageData as! Data)
                                
                                pic = pic?.imageWithColor(tintColor: UIColor.white)
                                
                                self.image.image = pic
                                
                                self.image.contentMode = UIViewContentMode.scaleAspectFill
                                
                            }
                        }
                        
                    }else{
                        
                        self.image.image = im
                        
                        self.image.contentMode = UIViewContentMode.scaleAspectFill

                        
                    }
                    
                    break
                    
                }
                
                
            }
            
            
            
        } , completion : nil)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("DESELECT")
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.cellView.alpha = 0
            
        } , completion : nil)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "AlarmViewController"))! as! AlarmViewController
            
            self.addChildViewController(vc)
            
            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
            
            self.container.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
        }, completion: nil)
    }

}
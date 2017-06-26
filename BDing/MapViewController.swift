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
    
    var pinsImage : [String : UIImage] = [String : UIImage]()
    
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
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.tapDetected))
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
        
            let obj = GlobalFields.BEACON_LIST_DATAS![self.index]
            
            let image : UIImage = UIImage(named:"mal")!
            
            let result: UIImage? = LoadPicture().load(picModel: obj.url_icon!)
            
            var catIcon : UIImage? = nil
            
            for cat in GlobalFields.CATEGORIES_LIST_DATAS! {
                
                if(cat.category_code == obj.category_id){
                    
                    LoadPicture().proLoad(view: nil ,picModel: cat.url_icon!){ resImage in
                     
                        catIcon = resImage
                        
                        var c1 : CGColor = UIColor(hex: "f5f7f8").cgColor
                        var c2 : CGColor = UIColor(hex: "7c1f72").cgColor
                        
                        let colorsString = cat.color_code?.characters.split(separator: "-").map(String.init)
                        
                        if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                            
                            c1 = UIColor(hex: (colorsString?[0])!).cgColor
                            
                            c2 = UIColor(hex: (colorsString?[1])!).cgColor
                            
                        }
                        
                        catIcon = self.setTintGradient(image: catIcon!, c: [c1,c2])
                        
                        if(result == nil){
                            
                            self.performSegue(withIdentifier: "mapDetailSegue", sender: CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: nil ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: catIcon!, customerDistanceToMe: String(describing: round((obj.distance ?? 0) * 100) / 100) , customerCoinValue: obj.coin ?? "0" , customerCoinIcon: image, customerDiscountValue: obj.discount! + "تا", customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! ,website: obj.cusomer_web! ,customerBigImages: obj.url_pic))
                            
                        }else{
                            
                            self.performSegue(withIdentifier: "mapDetailSegue", sender: CustomerHomeTableCell.init(uuidMajorMinorMD5: nil,preCustomerImage: result ,customerImage: obj.url_icon, customerCampaignTitle: obj.title!, customerName: obj.customer_title!, customerCategoryIcon: catIcon!, customerDistanceToMe: String(describing: round((obj.distance ?? 0) * 100) / 100) , customerCoinValue: obj.coin ?? "0" , customerCoinIcon: image, customerDiscountValue: obj.discount! + "تا", customerDiscountIcon: image, tell: obj.customer_tell! ,address: obj.customer_address! , text: obj.text! ,workTime: obj.customer_work_time! , website: obj.cusomer_web!,customerBigImages: obj.url_pic))
                            
                        }

                        
                        
                    }
                    
                }
                
            }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "mapDetailSegue"){
            
            (segue.destination as! DetailViewController).setup(data: sender as! CustomerHomeTableCell, isPopup: false, rect: nil)
            
        }
        
    }
    
    
    func setTintGradient(image: UIImage , c : [CGColor] ) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: image.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width : image.size.width, height : image.size.height)
        
        // Create gradient
        
        let colors = c as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)
        
        // Apply gradient
        
        context!.clip(to: rect, mask: image.cgImage!)
        context!.drawLinearGradient(gradient!, start: CGPoint(x:0, y:0), end: CGPoint(x:0,y: image.size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage!
        
    }
    
    
    
    func deletSubView(){
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        //////////////
        
        let tit = annotation.title
        
        let subT = annotation.subtitle
        
        self.index = -1
        
        for j in 0...GlobalFields.BEACON_LIST_DATAS!.count - 1 {
            
            self.index = j
            
            let i = GlobalFields.BEACON_LIST_DATAS![j]
            
            if(tit ?? "" == i.title ?? "" && subT ?? "" == i.category_title ?? ""){
                
                
                let reuseId = i.category_id
                
                var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId!)
                
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                for im in pinsImage {
                    
                    if(im.key == i.category_id){

                        anView?.image = im.value
                        
                        anView?.frame.size.width = 40
                        
                        anView?.frame.size.height = 40
                        
                        anView?.canShowCallout = false
                        
                        anView?.alpha = 1
                        
                        
                    }
                    
                }
                
                
                anView?.frame.size.width = 40
                
                anView?.frame.size.height = 40
                
                anView?.canShowCallout = false
                
                anView?.alpha = 1
                
                return anView
                
                
            }
            
            
        }
        
        //////////////
        
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
                    
                    self.coin.text = i.coin ?? "0"
                    
                    self.discount.text = i.discount! + "تا"
                    
                    self.distance.text = String(describing: round((i.distance ?? 0) * 100) / 100)
                    
                    
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
                    /////////
                    
                    
                    
                    
                    var catIcon : UIImage? = nil
                    
                    for cat in GlobalFields.CATEGORIES_LIST_DATAS! {
                        
                        if(cat.category_code == i.category_id){
                            
                            LoadPicture().proLoad(view : nil,picModel: cat.url_icon!){ resImage in
                                
                                catIcon = resImage
                                
                                var c1 : CGColor = UIColor(hex: "f5f7f8").cgColor
                                var c2 : CGColor = UIColor(hex: "7c1f72").cgColor
                                
                                let colorsString = cat.color_code?.characters.split(separator: "-").map(String.init)
                                
                                if(colorsString != nil && colorsString?[0] != nil && colorsString?[1] != nil){
                                    
                                    c1 = UIColor(hex: (colorsString?[0])!).cgColor
                                    
                                    c2 = UIColor(hex: (colorsString?[1])!).cgColor
                                    
                                }
                                
                                catIcon = self.setTintGradient(image: catIcon!, c: [c1,c2])
                                
                                self.categoryIcon.image = catIcon
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    ////////
                    
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
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

}

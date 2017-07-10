//
//  ViewController.swift
//  BDingTest
//
//  Created by Milad on 2/11/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

import Lottie

import CoreData

import CoreLocation

class ViewController: UIViewController , UIPageViewControllerDataSource{
    
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var vorudButton: UIButton!
    
    @IBOutlet weak var sabtButton: UIButton!
    
    @IBOutlet weak var loadingBackView: UIView!
    var pageViewController: UIPageViewController!
    
    var pageImages: Array<String> = []
    
    var bigTitles: Array<String> = []
    @IBOutlet weak var loginIcon: UIImageView!
    
    @IBOutlet weak var signUpIcon: UIImageView!
    var smallTitles: Array<String> = []
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var loginBool : Bool = false
    
    var animationView : LOTAnimationView?
    
    //---------------------------------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        signInPressing()
        
        self.pageImages = ["1", "2", "3", "4"]
        
        self.bigTitles = ["اطلاعات به موقع","کسب امتیاز","تخفیف یا خرید رایگان","بلوتوث ها روشن!"]
        
        self.smallTitles = ["فرقی نمی کنه کجای شهری. تو هر مکان اطلاعات مورد نیاز همونجا رو خواهی داشت"
            ,"به کمپین های دور و برت یه سر بزن و دینگ (امتیاز) بگیر"
            ,"تخفیف های دور و برتو  با امتیازهات مال خودت کن"
            ,"برای یک شروع هیجان انگیز آماده ای؟ بلوتوث دستگاه رو روشن کن"]
        
       
        
        // Create page view controller
        
        self.buttonsView.layer.zPosition = 1
        
        self.buttonsView.backgroundColor = UIColor(hex: "#2196f3")
        
        MyFont().setMediumFont(view: self.vorudButton, mySize: 13, mycolor: "#2196f3")
        
        MyFont().setMediumFont(view: self.sabtButton, mySize: 13, mycolor: "#2196f3")
        
        signUpIcon.image = signUpIcon.image?.imageWithColor(tintColor: UIColor.white)
        
        loginIcon.image = loginIcon.image?.imageWithColor(tintColor: UIColor.white)
        
        self.pageViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        self.pageViewController?.dataSource = self
        let startingViewController:PageContentViewController  = self.viewControllerAtIndex(index: 0)!
        let viewControllers:Array<PageContentViewController> = [startingViewController]
        self.pageViewController?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.pageViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
//        (0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)
        self.addChildViewController(pageViewController!)
        self.view.addSubview((pageViewController?.view)!)
        self.pageViewController?.didMove(toParentViewController: self)
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //---------------------------------------------------------------------------------------------------//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------------------------------//

    @IBAction func testing(_ sender: Any) {

    }

    //---------------------------------------------------------------------------------------------------//
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! PageContentViewController).pageIndex // This is the line you are looking for
        self.pageIndicator.currentPage = index
        self.pageIndicator.updateCurrentPageDisplay()
        if index == self.pageImages.count - 1 {
            
            return nil
        } else {
            
            index += 1
        }
        return viewControllerAtIndex(index: index)
    }
    
    
    //---------------------------------------------------------------------------------------------------//
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! PageContentViewController).pageIndex
        self.pageIndicator.currentPage = index
        self.pageIndicator.updateCurrentPageDisplay()
        if index == 0 {
            
            return nil
        } else {
            
            index -= 1
        }
        return self.viewControllerAtIndex(index: index)
        
    }
    
    //---------------------------------------------------------------------------------------------------//
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    
    //---------------------------------------------------------------------------------------------------//
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
    //---------------------------------------------------------------------------------------------------//
    
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController?{
        if((self.pageImages.count == 0) || (index > self.pageImages.count-1))
        {
            return nil
        }
        
        let pageContentViewController: PageContentViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.imageFile = self.pageImages[index]
        
        let s = self.bigTitles[index]
      
        print(s)
        
        pageContentViewController.bTitle = s
        
        pageContentViewController.sTitle = self.smallTitles[index]
        
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
        
    }
    
    //---------------------------------------------------------------------------------------------------//
    
    func signInPressing() {
        
        animationView = LOTAnimationView(name: "finall")
        
        animationView?.frame.size.height = 50
        
        animationView?.frame.size.width = 50
        
        animationView?.frame.origin.y = self.view.frame.height / 2 - 25
        
        animationView?.frame.origin.x = self.view.frame.width / 2 - 25
        
        animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        animationView?.alpha = 1
        
//        self.view.addSubview(loadingBackView)
        
        self.view.addSubview(animationView!)
        
        animationView?.layer.zPosition = 1
        
        animationView?.loopAnimation = true
        
        loadingBackView.layer.zPosition = 1
        
        loadingBackView.alpha = 1
        
        animationView?.play()
        
        requestForAutoLogin()
        
    }
    
    
    func requestForAutoLogin(){
        
        if((SaveAndLoadModel().load(entity: "USER")?.count)! <= 0){
            
            animationView?.pause()
            
            loadingBackView.alpha = 0
            
            animationView?.alpha = 0
            
            return
            
        }
        
        let model = SaveAndLoadModel().load(entity: "USER")?[0]
        
        if(model == nil){
            
            return
            
        }
        
        let user = model?.value(forKey: "user")
        
        let password = model?.value(forKey: "password")
        
        if(user == nil){
            
            return
            
        }

        
        let s = SignInRequestModel(USERNAME: user as! String!, PASSWORD: password as! String!)
        
        print(s.getParams())
        
        self.view.endEditing(true)
        
        request(URLs.signInUrl , method: .post , parameters: s.getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON -----------SIGNIN---------->>>> " )
                
                let obj = SignInResponseModel.init(json: JSON as! JSON)
                
                if ( obj.code == "200" ){
                
                    print("JSON -----------SIGNIN---------->>>> " )
                    
                    print(obj.token ?? "null")
                    
                    SaveAndLoadModel().deleteAllObjectIn(entityName: "USER")
                    
                    let b = SaveAndLoadModel().save(entityName: "USER", datas: ["user":s.USERNAME , "password":s.PASSWORD , "token":obj.token! , "userID" : obj.userID!])
                    
                    
                    ///
                    
                    self.loadTabView()
                    
                    
                    print(SaveAndLoadModel().load(entity: "USER")?.count ?? "nothing!")
                    
                    
                    self.loginBool = true
                    
                    self.goNextView()
                    
                    
                }else{
                    
                    self.loadingBackView.alpha = 0
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    self.view.endEditing(false)
                    
                }
                
            }
            
        }

        
    }
    
    func goNextView(){
        
        if(self.profileBool && self.beaconBool && self.catBool && self.loginBool){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
    
    func loadTabView() {
        
        // get profile
        
        request(URLs.getProfile , method: .post , parameters: ProfileRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PROFILE----------->>>> ")
                
                let obj = ProfileResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                
                    print("JSON ----------PROFILE----------->>>> ")
                    
                    GlobalFields.PROFILEDATA = obj?.data
                    
                    self.profileBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
        // get index Home
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestAlwaysAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location!
            
        }
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
        if(lat == "0" && long == "0"){
            
            long = String(51.4212297)
            
            lat = String(35.6329044)
            
        }
        
        print("lat and long")
        print(lat)
        print(long)
        
        print(BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : true))
        
        print()
        
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(allSearch : true), encoding: JSONEncoding.default).responseJSON { response in
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> " )
                
                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    print("JSON ----------BEACON----------->>>> " , JSON)
                    
                    let locManager = CLLocationManager()
                    
                    locManager.requestAlwaysAuthorization()
                    
                    var currentLocation = CLLocation()
                    
                    if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
                        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                        
                        currentLocation = locManager.location!
                        
                    }
                    
                    for o in (obj?.data)! {
                        
                        o.distance = currentLocation.distance(from: CLLocation.init(latitude: (Double(o.lat!))!, longitude: (Double(o.long!))!))/1000
                        
                    }
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                    self.beaconBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
        //get category
        
        print(CategoryRequestModel().getParams())
        
        request(URLs.getCategory , method: .post , parameters: CategoryRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------Category----------->>>> " )
                
                let obj = CategoryListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                
                    print("JSON ----------Category----------->>>> " )
                    
                    GlobalFields.CATEGORIES_LIST_DATAS = obj?.data
                    
                    self.catBool = true
                    
                    self.goNextView()
                    
                }
                
            }
            
        }
        
        
        
        request(URLs.getPayUuids , method: .post , parameters: PayUuidsRequestModel().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------PAY UUID----------->>>> ")
                
                let obj = PayUuidResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                
                    print("JSON ----------PAY UUID----------->>>> ")
                    
                    GlobalFields.PAY_UUIDS = obj?.result
                    
                }
                
            }
            
        }
        
        
        
    }

    

}































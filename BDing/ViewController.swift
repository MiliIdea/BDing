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
    
    var pageViewController: UIPageViewController!
    
    var pageImages: Array<String> = []
    
    var bigTitles: Array<String> = []
    @IBOutlet weak var loginIcon: UIImageView!
    
    @IBOutlet weak var signUpIcon: UIImageView!
    var smallTitles: Array<String> = []
    
    var beaconBool : Bool = false
    
    var catBool : Bool = false
    
    var profileBool : Bool = false
    
    var animationView : LOTAnimationView?
    
    //---------------------------------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        signInPressing()
        
        self.pageImages = ["1", "2", "4", "3"]
        
        self.bigTitles = ["سکه های رایگان","تخفیف یا خرید رایگان","اطلاعات بموقع!","بلوتوث های روشن"]
        
        self.smallTitles = [" .در شهر گشت و گذار کنید و سکه بگیرید"
            ,"با سکه‌های خود کوپن‌های تخفیف بگیرید یا با سکه‌ها خرید کنید."
            ,"فرقی نمی‌کند کجای شهر هستید، شما در هر مکان اطلاعات مورد نیاز همانجا را خواهید داشت."
            ,"برای یک شروع هیجان‌انگیز آماده‌ای؟ بلوتوث دستگاه رو روشن کن."]
        
       
        
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
        
        self.view.addSubview(animationView!)
        
        animationView?.layer.zPosition = 1
        
        animationView?.loopAnimation = true
        
        animationView?.play()
        
        requestForAutoLogin()
        
    }
    
    
    func requestForAutoLogin(){
        
        if((SaveAndLoadModel().load(entity: "USER")?.count)! <= 0){
            
            animationView?.pause()
            
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
                    
                    var recycle : Bool = true
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        while (recycle) {
                            
                            if(self.profileBool && self.beaconBool && self.catBool){
                                
                                recycle = false
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            if(recycle == false){
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                                
                                self.present(nextViewController, animated:true, completion:nil)
                                
                            }
                            
                        }
                    }
                    
                }else{
                    
                    self.animationView?.pause()
                    
                    self.animationView?.alpha = 0
                    
                    self.view.endEditing(false)
                    
                }
                
            }
            
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
        
//        long = String(51.4212297)
//        
//        lat = String(35.6329044)
        
        print("lat and long")
        print(lat)
        print(long)
        
        request(URLs.getBeaconList , method: .post , parameters: BeaconListRequestModel(LAT: lat, LONG: long, REDIUS: String(GlobalFields.BEACON_RANG), SEARCH: nil, CATEGORY: nil, SUBCATEGORY: nil).getParams(), encoding: JSONEncoding.default).responseJSON { response in
            
            if let JSON = response.result.value {
                
                print("JSON ----------BEACON----------->>>> " )
                
                let obj = BeaconListResponseModel.init(json: JSON as! JSON)
                
                if ( obj?.code == "200" ){
                    
                    print("JSON ----------BEACON----------->>>> " )
                    
                    GlobalFields.BEACON_LIST_DATAS = obj?.data
                    
                    self.beaconBool = true
                    
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































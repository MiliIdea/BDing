//
//  ViewController.swift
//  BDingTest
//
//  Created by Milad on 2/11/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit


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
    
    //---------------------------------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    

}































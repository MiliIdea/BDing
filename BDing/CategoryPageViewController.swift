//
//  CategoryPageViewController.swift
//  BDing
//
//  Created by MILAD on 4/3/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CellAnimator


class CategoryPageViewController: UIViewController , UIScrollViewDelegate ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewInScrollView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var patternView: UIView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var semicircularView: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var subCategoryIcon: UIImageView!
    
    @IBOutlet weak var subCategoryName: UITextView!
    
    var catIconPicModel : PicModel? = nil
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    
    //num of pattern images in background
    let xNum = 4
    
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
    var parentView : String = ""
    
    var color1 : CGColor? = nil
    
    var color2 : CGColor? = nil
    
    var nameTitle : String = ""
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
    let loading : UIActivityIndicatorView = UIActivityIndicatorView()
    
    //==================================================================//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        scrollView.addSubview(viewInScrollView)
        
        scrollView.contentSize = viewInScrollView.frame.size
        
        //set pattern in background
        
        // image is 400 * 252
        
        let wV = patternView.frame.width
        
        let hV = patternView.frame.height
        
        let hr = (252/400)*(wV/CGFloat(xNum))
        
        let wr = wV/CGFloat(xNum)
        
        for i in 0...xNum - 1{
            
            for j in 0...Int(floor(Double(hV/hr))) - 1{
                
                let image = UIImageView(frame: CGRect(x: CGFloat(i)*wr, y: CGFloat(j)*hr, width: wr, height: hr))
                
                image.image = UIImage(named: "bding_pattern_white")
                
                patternView.addSubview(image)
                
            }
            
        }

        self.cache = NSCache()
        
        heightOfSemiCircular = semicircularView.frame.height
        
        offsetOfsemiCircular = semicircularView.frame.origin.y
        
        // set table of page
        
        table.dataSource = self
        
        table.delegate = self
        
        table.isScrollEnabled = false
        
        table.rowHeight = self.view.frame.width * 8.5 / 32
        
        self.table.register(UINib(nibName: "IndexHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "indexHomeTableCellID")
        
        let sizeOfFooter: CGFloat = 55
        
        let heightOfTable = CGFloat(customerHomeTableCells.count * 70) - (self.view.frame.height - table.frame.origin.y - sizeOfFooter)/2
        
        let minHeightOfTable = self.view.frame.height - bottomView.frame.origin.y - sizeOfFooter
        
        let maxHeightOfTable = self.view.frame.height - (navigationBar.frame.height + navigationBar.frame.origin.y + table.frame.origin.y + sizeOfFooter)
        
        if(heightOfTable < minHeightOfTable){
            
            table.frame.size.height = minHeightOfTable
            
        }else if(heightOfTable > maxHeightOfTable){
            
            table.frame.size.height = maxHeightOfTable
            
        }else{
            
            table.frame.size.height = heightOfTable
            
        }
        
        MyFont().setBoldFont(view: subCategoryName, mySize: 14)
        
        self.subCategoryName.text = self.nameTitle
        
        LoadPicture().proLoad(view: self.subCategoryIcon, picModel: (catIconPicModel)!){ resImage in
            
            self.subCategoryIcon.image = resImage.imageWithColor(tintColor: UIColor.white)
            
            self.subCategoryIcon.contentMode = UIViewContentMode.scaleAspectFit
        }

        
        scrollViewDidScroll(self.scrollView)
    
        setGradientLayer()
        
        if(table != nil){
            
            loading.frame(forAlignmentRect: (table?.frame)!)
            
            loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            self.view?.addSubview(loading)
            
            loading.hidesWhenStopped = true
            
            loading.frame.origin.x = (view?.frame.width)! / 2
            
            loading.frame.origin.y = (view?.frame.height)! / 2
            
            loading.layer.zPosition = 1
        
            loading.startAnimating()
        }
        
        loading.startAnimating()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.table.delegate = self
        self.scrollView.delegate = self
        scrollViewDidScroll(scrollView)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setGradientLayer(){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = backgroundView.bounds
        
        gradientLayer.colors = [color1!, color2!]
        
        gradientLayer.startPoint = CGPoint(x: 0,y: 0.5)
        
        gradientLayer.endPoint = CGPoint(x: 1,y: 0.5)
        
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(customerHomeTableCells.count)
        
        return customerHomeTableCells.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "indexHomeTableCellID" , for: indexPath) as! IndexHomeTableViewCell
        
        let tableCell = customerHomeTableCells[indexPath.row]
        
        cell.customerName.text = tableCell.customerName
        cell.customerCampaignTitle.text = tableCell.customerCampaignTitle
        cell.customerDistanceToMe.text = tableCell.customerDistanceToMe
        cell.customerThumbnail.image = UIImage(named : "default")!
        if(tableCell.preCustomerImage == nil){
            DispatchQueue.main.async(execute: { () -> Void in
                autoreleasepool { () -> () in
                    
                    LoadPicture().proLoad(view: nil , picModel: tableCell.customerImage!){ resImage in
                        
                        self.customerHomeTableCells[indexPath.row].preCustomerImage = resImage
                        
                        cell.customerThumbnail.image = resImage
                        
                    }
                    
                }
            })
        }else{
            cell.customerThumbnail.image = tableCell.preCustomerImage
        }
        
        cell.customerThumbnail.contentMode = UIViewContentMode.scaleAspectFit
        cell.customerCampaignCoin.text = tableCell.customerCoinValue
        cell.customerCampaignDiscount.text = tableCell.customerDiscountValue
        
        ///////cat icon
        if(tableCell.customerCategoryIcon != nil){
            
            DispatchQueue.main.async(execute: { () -> Void in
                autoreleasepool { () -> () in
                    
                    cell.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
                    
                }
            })
            
        }else{
            if((GlobalFields.BEACON_LIST_DATAS?.count)! - 1 >= indexPath.row ){
                let cat = findCategory(catID: tableCell.categoryID)
                
                if(cat != nil){
                    
                    LoadPicture().proLoad(view: cell.customerCategoryThumbnail, picModel: (cat?.url_icon)!) { resImage in
                        
                        cell.customerCategoryThumbnail.image = resImage
                        
                        self.customerHomeTableCells[indexPath.row].customerCategoryIcon = resImage
                        
                        for c in self.customerHomeTableCells {
                            
                            c.customerCategoryIcon = resImage
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        cell.coinThumbnail.image = tableCell.customerCoinIcon
        cell.discountThumbnail.image = tableCell.customerDiscountIcon
        cell.setFirst(screenWidth: self.view.frame.width)
        
        return cell
        
    }
    
    func findCategory(catID : String!) -> CategoryListData?{
        
        for c in GlobalFields.CATEGORIES_LIST_DATAS! {
            
            if(c.category_code == catID){
                
                return c
                
            }
            
        }
        
        return nil
        
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformFlip, andDuration: 0.3)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.table.delegate = nil
        self.scrollView.delegate = nil
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.table.isScrollEnabled = true
        
        self.scrollView.isScrollEnabled = false
        
        
        let k: CGFloat = (offsetOfsemiCircular + heightOfSemiCircular) / (offsetOfsemiCircular + heightOfSemiCircular - (navigationBar.frame.height+navigationBar.frame.origin.y))
        
        var myPercentage = 1 - k * ( self.scrollView.contentOffset.y / (semicircularView.frame.origin.y + semicircularView.frame.height) )
        
        print("table" , self.table.contentOffset.y)

        print("scrollView" , self.scrollView.contentOffset.y)
        
        print("percentage" , myPercentage)
        
        print("navigation" , self.navigationBar.frame.height)
        
        if(self.table.contentOffset.y / 2 < (offsetOfsemiCircular + heightOfSemiCircular) - self.navigationBar.frame.height + self.navigationBar.frame.origin.y){
            
            self.scrollView.contentOffset.y = self.table.contentOffset.y / 2
            
        }else{
            
            myPercentage = 0
            
            self.scrollView.contentOffset.y = offsetOfsemiCircular
        
        }

        
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
 
        self.table.frame.size.height = self.view.frame.size.height - self.bottomView.frame.origin.y - self.table.frame.origin.y - 1.4 * (self.tabBarController?.tabBar.frame.height)! + self.scrollView.contentOffset.y
            
        
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "subCategoryDetailSegue", sender: table.cellForRow(at: indexPath))
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.table.deselectRow(at: indexPath, animated: true)
            
        }, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "subCategoryDetailSegue"){
            
            let nextVc = segue.destination as! DetailViewController
            
            nextVc.setup(data: self.customerHomeTableCells[(self.table.indexPath(for: (sender as! IndexHomeTableViewCell))?.row)!], isPopup: false, rect: nil)
            
        }
        
    }
    

    @IBAction func backButton(_ sender: Any) {

        _ = navigationController?.popViewController(animated: true)
        
    }

    
}

















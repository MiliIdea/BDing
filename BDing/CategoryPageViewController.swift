//
//  CategoryPageViewController.swift
//  BDing
//
//  Created by MILAD on 4/3/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

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
    
    var heightOfSemiCircular: CGFloat = 0.0
    
    var offsetOfsemiCircular: CGFloat = 0.0
    //num of pattern images in background
    let xNum = 4
    
    var customerHomeTableCells = [CustomerHomeTableCell]()
    
    var parentView : String = ""
    
    var color1 : CGColor? = nil
    
    var color2 : CGColor? = nil
    
    var cache: NSCache<AnyObject, AnyObject> = NSCache()
    
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
        
        
        scrollViewDidScroll(self.scrollView)
    
        setGradientLayer()
        
        
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
        
//        navigationBar.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(customerHomeTableCells.count)
        
        return customerHomeTableCells.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "categoryCell" , for: indexPath) as! IndexHomeTableViewCell
        
        let tableCell = customerHomeTableCells[indexPath.row]
        
        cell.customerName.text = tableCell.customerName
        cell.customerCampaignTitle.text = tableCell.customerCampaignTitle
        cell.customerDistanceToMe.text = tableCell.customerDistanceToMe
//        cell.customerThumbnail.image = UIImage(named:"profile_pic")!
        
        //if its not in db load this
        
        if(tableCell.preCustomerImage == nil){
            
            LoadPicture().proLoad(view: cell.customerThumbnail, picModel: tableCell.customerImage!){ resImage in
                
                self.customerHomeTableCells[indexPath.row].preCustomerImage = resImage
                
                cell.customerThumbnail.image = resImage
                
            }
            
        }else{
            
            cell.customerThumbnail.image = tableCell.preCustomerImage
            
            cell.customerThumbnail.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        
        
        
        cell.customerCampaignCoin.text = tableCell.customerCoinValue
        cell.customerCampaignDiscount.text = tableCell.customerDiscountValue
        cell.customerCategoryThumbnail.image = tableCell.customerCategoryIcon
        cell.coinThumbnail.image = tableCell.customerCoinIcon
        cell.discountThumbnail.image = tableCell.customerDiscountIcon
        
        cell.setFirst()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
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
            
//            self.table.frame.size.height += self.scrollView.contentOffset.y
            
            self.table.frame.size.height = self.view.frame.size.height - self.table.frame.origin.y - (self.tabBarController?.tabBar.frame.height)!
            
        }else{
            
            myPercentage = 0
        
        }
        
        
//        if(myPercentage < 0){
//            
//            myPercentage = 0
//            
//        }
        
        if(myPercentage > 1){
            
            myPercentage = 1
            
        }
        
        
        
        navigationBar.alpha = 1 - myPercentage
        
        semicircularView.frame.origin.y = offsetOfsemiCircular + (heightOfSemiCircular - (heightOfSemiCircular * (myPercentage)))
        
        semicircularView.frame.size.height = heightOfSemiCircular * (myPercentage)
            
        
        
//        bottomView.frame.origin.y = offsetOfsemiCircular + heightOfSemiCircular
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController"))! as! DetailViewController
//
//            self.addChildViewController(vc)
//            
//            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
//            
//            self.container.addSubview(vc.view)
//            
//            vc.didMove(toParentViewController: self)
            
            // add data
            
//            let data = self.customerHomeTableCells[indexPath.row]
//            
//            vc.setup(data: data , isPopup: false , rect: nil)
//            
//            vc.color1 = self.color1
//            
//            vc.color2 = self.color2
//            
//            vc.subCategoryName = self.subCategoryName.text
//            
//            vc.subCategoryIcon = self.subCategoryIcon.image
//            
//            vc.customerHomeTableCellsOfCategoryPage = self.customerHomeTableCells

//            self.navigationBar.alpha = 0
//            
//            self.table.alpha = 0
            
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
    
    
    
//    func deletSubView(cells: [CustomerHomeTableCell] , color1 : CGColor , color2 : CGColor , subCName : String , subCIcon : UIImage){
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CategoryPageViewController"))! as! CategoryPageViewController
//            
//            self.addChildViewController(vc)
//            
//            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
//            
//            self.container.addSubview(vc.view)
//            
//            vc.didMove(toParentViewController: self)
//            
//            vc.customerHomeTableCells = cells
//            
//            vc.setGradientLayer(color1: color1, color2: color2)
//            
//            vc.subCategoryName.text = subCName
//            
//            vc.subCategoryIcon.image = subCIcon
//            
//        }, completion: nil)
//        
//    }
    
    
//    func presentIndex(){
//        
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController"))! as! CategoryViewController
//            
//            self.addChildViewController(vc)
//            
//            vc.view.frame = CGRect(x:0,y: 0,width: self.container.frame.size.width, height: self.container.frame.size.height);
//            
//            self.container.addSubview(vc.view)
//            
//            vc.didMove(toParentViewController: self)
//        }, completion: nil)
//    }

    @IBAction func backButton(_ sender: Any) {
        
//        if(self.parent is CategoryViewController){
//         
//            let vc = self.parent as! CategoryViewController
//            
//            vc.deletSubView()
//            
//        }else{
//            presentIndex()
//        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }

    
}

















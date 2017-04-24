//
//  PageContentViewController.swift
//  BDingTest
//
//  Created by Milad on 2/12/17.
//  Copyright © 2017 Milad. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var introSlideImage: UIImageView!
    
    var pageIndex: Int!
    
    var imageFile: String!
    
    var bTitle: String!
    
    var sTitle: String!
    
    @IBOutlet weak var bigTitle: UILabel!

    @IBOutlet weak var smallTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.introSlideImage.image = UIImage(named: self.imageFile)
        
        bigTitle.text = bTitle
        
        MyFont().setBoldFont(view: bigTitle,mySize: 24 , mycolor: "#1665c1")
        
        
        smallTitle.text = sTitle
        
        MyFont().setLightFont(view: smallTitle, mySize: 15, mycolor: "#546e7a")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPageIndex() -> Int {
        return self.pageIndex
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

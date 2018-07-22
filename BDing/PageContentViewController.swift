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
    
    @IBOutlet weak var startButton: DCBorderedButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.introSlideImage.image = UIImage(named: self.imageFile)
        
        bigTitle.text = bTitle
        
        MyFont().setBoldFont(view: bigTitle,mySize: 24 , mycolor: "#F7941D")
        
        smallTitle.text = sTitle
        
//        smallTitleView.layer.cornerRadius = smallTitleView.frame.height / 2 - 2

       
        startButton.alpha = 0
        
            
        startButton.cornerRadius = startButton.frame.height / 2
        
//        MyFont().setLightFont(view: smallTitle, mySize: 15, mycolor: "#ffffff")
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if(pageIndex == 0){
            UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.startButton.alpha = 1
            },completion : nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPageIndex() -> Int {
        return self.pageIndex
    }
    
    
    @IBAction func startLogin(_ sender: Any) {
        
        
        
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

//
//  FAQViewController.swift
//  BDing
//
//  Created by MILAD on 8/15/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    var selectedPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        table.contentInset = UIEdgeInsets.zero
        
        self.table.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "FAQCell")
        
        if(GlobalFields.FAQs.count == 0){
            
            requestForFAQ()
            
        }
        
        
        table.dataSource = self
        table.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQTableViewCell

        cell.question.text = GlobalFields.FAQs[indexPath.row].title
        
        cell.result.text = GlobalFields.FAQs[indexPath.row].text
        
        cell.feleshIcon.image = UIImage.init(named: "leftFAQ-2")
        
        if(cell.isSelected == false){
            
            cell.result.frame.size.height = 0
            
            cell.result.alpha = 0
            
        }
        if(selectedPath != nil && selectedPath == indexPath){
            
            cell.result.frame.size.height = calculateHeightForString(inString: GlobalFields.FAQs[indexPath.row].text!)
            cell.result.frame.origin.y = cell.question.frame.origin.y + cell.question.frame.height
            cell.result.layer.zPosition = 1
            
            cell.result.alpha = 1
            
            cell.selectionStyle = .none
            
            cell.feleshIcon.image = UIImage.init(named: "downFAQ-1")
            
            cell.result.drawText(in: CGRect.init(x: cell.result.frame.origin.x + 10, y: cell.result.frame.origin.y, width: cell.result.frame.width - 20, height: cell.result.frame.height))
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectedPath == nil || selectedPath != indexPath){
        
            selectedPath = indexPath
        
            let cell = (self.table.cellForRow(at: indexPath) as! FAQTableViewCell)
            
            
            cell.result.frame.size.height = calculateHeightForString(inString: GlobalFields.FAQs[indexPath.row].text!)
            cell.result.frame.origin.y = cell.question.frame.origin.y + cell.question.frame.height
            cell.result.layer.zPosition = 1
            
            cell.result.alpha = 1
            
            cell.feleshIcon.image = UIImage.init(named: "downFAQ-1")
            
            cell.selectionStyle = .none
            
            cell.result.drawText(in: CGRect.init(x: cell.result.frame.origin.x + 10, y: cell.result.frame.origin.y, width: cell.result.frame.width - 20, height: cell.result.frame.height))
            
            self.table.beginUpdates()
            self.table.endUpdates()
            
            cell.result.frame.size.height = calculateHeightForString(inString: GlobalFields.FAQs[indexPath.row].text!)
            cell.result.frame.origin.y = cell.question.frame.origin.y + cell.question.frame.height
            cell.result.layer.zPosition = 1
            
            cell.result.alpha = 1
            
            cell.selectionStyle = .none
            
            cell.feleshIcon.image = UIImage.init(named: "downFAQ-1")
            
            cell.result.drawText(in: CGRect.init(x: cell.result.frame.origin.x + 10, y: cell.result.frame.origin.y, width: cell.result.frame.width - 20, height: cell.result.frame.height))
            
            self.table.beginUpdates()
            self.table.endUpdates()
            
            
        }else{
            
            selectedPath = nil
            
            let cell = (self.table.cellForRow(at: indexPath) as! FAQTableViewCell)
            
            cell.result.frame.size.height = 0
            cell.result.frame.origin.y = cell.question.frame.origin.y + cell.question.frame.height
            cell.result.layer.zPosition = 1
            cell.result.alpha = 0
            
            cell.selectionStyle = .none
            
            cell.feleshIcon.image = UIImage.init(named: "leftFAQ-2")
            
            self.table.beginUpdates()
            self.table.endUpdates()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        selectedPath = nil
        
        if(self.table.cellForRow(at: indexPath) != nil){
        
            let cell = (self.table.cellForRow(at: indexPath) as! FAQTableViewCell)
            
            cell.result.frame.size.height = 0
            
            cell.result.alpha = 0
            
            cell.feleshIcon.image = UIImage.init(named: "leftFAQ-2")
            
            self.table.beginUpdates()
            self.table.endUpdates()
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.selectedPath == nil || indexPath != selectedPath){
            
            return self.view.frame.width * 70 / 320
            
        }
        
        return self.view.frame.width * 70 / 320 + calculateHeightForString(inString: GlobalFields.FAQs[indexPath.row].text!)
    }
    
    func calculateHeightForString(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSFontAttributeName: UIFont(name: "IRANYekanMobileFaNum", size: CGFloat(15))]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width : self.view.frame.width - 20 ,height : CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        return requredSize.height  //to include button's in your tableview
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalFields.FAQs.count
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func requestForFAQ(){
        
        request(URLs.faq , method: .post , parameters: FAQRequestModel.init().getParams(), encoding: JSONEncoding.default).responseJSON { response in
            print()
            
            if let JSON = response.result.value {
                
                print("JSON ----------GO FAQ----------->>>> ")
                //create my coupon response model
                if(FAQResponseModel.init(json: JSON as! JSON)?.code == "5005"){
                    GlobalFields().goErrorPage(viewController: self)
                }
                if(FAQResponseModel.init(json: JSON as! JSON)?.code == "200"){
                    
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        if(FAQResponseModel.init(json: JSON as! JSON)?.data == nil){
                            
                            // data nadarim
                            
                        }else{
                            GlobalFields.FAQs = (FAQResponseModel.init(json: JSON as! JSON)?.data)!
                            
                            self.table.reloadData()
                            
                        }
                        
                    }, completion: nil)
                    
                }
                
                
                print(JSON)
                
            }
            
        }
        
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

//
//  inviteFriendsViewController.swift
//  BDing
//
//  Created by MILAD on 11/22/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import Lottie

class inviteFriendsViewController: UIViewController {

    
    @IBOutlet weak var lottieView: UIView!
    
    @IBOutlet weak var invitationCodeButton: DCBorderedButton!
    
    var animationView : LOTAnimationView?
    
    @IBOutlet weak var inviteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.invitationCodeButton.setTitle(GlobalFields.invitationCode, for: .normal)
        
        self.animationView = LOTAnimationView(name: "invite")
        
        self.animationView?.frame = self.lottieView.frame
        
        self.animationView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.animationView?.alpha = 1
        
        self.view.addSubview(self.animationView!)
        
        self.animationView?.loopAnimation = true
        
        self.animationView?.play()
        
        let s : String? = "شما می توانید با دعوت از دوستانتان و ثبت نام آنها با کد زیر در نرم افزار بی دینگ مقدار" + GlobalFields.invitationDing! + " دینگ هدیه بگیرید. دوستان شما هم مقدار " + GlobalFields.registered_with_invite_code! + " دینگ جایزه خواهند گرفت"
        
        self.inviteLabel.text = s
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareInvitationCode(_ sender: Any) {
        
        var myShare = "با کد زیر تو نرم افزار بی دینگ ثبت نام کن و " + GlobalFields.registered_with_invite_code! + " امتیاز بگیر." + "\n" + "میتونی با امتیازات کوپن های تخفیف هیجان انگیزی بدست بیاری :)"
        myShare.append("\n\n" + "کد معرف:" + GlobalFields.invitationCode! + "\n\n" + "لینک دانلود نسخه اندروید:")
        
        myShare.append("\n" + "https://goo.gl/H6E5Ha" + "\n" + "لینک دانلود نسخه ios: " + "\n" + "https://new.sibapp.com/applications/bding")

        let shareVC: UIActivityViewController = UIActivityViewController(activityItems: [myShare], applicationActivities: nil)
        
        self.present(shareVC, animated: true, completion: nil)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

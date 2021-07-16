//
//  ViewControllerPopUpDr.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/07/16.
//

import UIKit

class ViewControllerPopUpDr: CustomUIViewController {
    
    var strTitle = ""
    var strContent = ""
    var dKwh = 0.0
    var strBegin = ""
    var strEnd = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = strTitle
        lblContent.text = strContent
        
       
    }
    

   
     @IBAction func btnCheck(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
     }
     

}

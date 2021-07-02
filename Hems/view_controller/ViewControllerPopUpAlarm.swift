//
//  ViewControllerPopUpAlarm.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/01.
//

import UIKit

class ViewControllerPopUpAlarm: CustomUIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblAckResponse: UILabel!
    
    var strTitle = ""
    var strContent = ""
    var nAckResponse: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = strTitle
        lblContent.text = strContent
        
        switch (nAckResponse) {
        case 0:
            lblAckResponse.text = "승인 대기중"
            
        case 1:
            lblAckResponse.text = "승인함"
            
        case 2:
            lblAckResponse.text = "거절함"
            

        default:
            lblAckResponse.text = "미정"
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnConfirm(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

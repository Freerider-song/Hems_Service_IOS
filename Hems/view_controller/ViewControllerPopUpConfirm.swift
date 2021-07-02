//
//  ViewControllerPopUpConfirm.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/01.
//

import UIKit

class ViewControllerPopUpConfirm: CustomUIViewController {

    @IBOutlet var strMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strMessage.text = CaApp.m_Info.strMessage
        
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

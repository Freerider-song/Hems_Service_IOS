//
//  ViewControllerWaitingAck.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/25.
//

import UIKit

class ViewControllerWaitingAck: CustomUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnRequestAck(_ sender: UIButton) {
        CaApp.m_Engine.RequestAckMember(CaApp.m_Info.nSeqMember, true, self)
    }
    
    @IBAction func onBtnLogin(_ sender: UIButton) {
      //  UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}

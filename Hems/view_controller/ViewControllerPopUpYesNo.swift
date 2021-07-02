//
//  ViewControllerPopUpYesNo.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/01.
//

import UIKit

class ViewControllerPopUpYesNo: CustomUIViewController {

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
    @IBAction func onBtnYes(_ sender: UIButton) {
        CaApp.m_Info.bYes = true
        print("strstoryboardname: \(CaApp.m_Info.strStoryBoardName)")
        
        if CaApp.m_Info.strStoryBoardName == "" {
            self.dismiss(animated: true, completion: nil)}
        else {
            let storyboard = UIStoryboard(name: CaApp.m_Info.strStoryBoardName, bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: CaApp.m_Info.strViewControllerName) //as? ChangePasswordViewController
        view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)}
        
        CaApp.m_Info.strStoryBoardName = ""
        CaApp.m_Info.strViewControllerName = ""
    }
    
    @IBAction func onBtnNo(_ sender: UIButton) {
        CaApp.m_Info.bYes = false
        self.dismiss(animated: true, completion: nil)
    }
}

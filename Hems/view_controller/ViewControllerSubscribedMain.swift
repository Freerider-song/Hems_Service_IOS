//
//  ViewControllerSubscribedMain.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/25.
//

import UIKit

class ViewControllerSubscribedMain: CustomUIViewController {

    @IBOutlet var lblStep1: UILabel!
    @IBOutlet var lblStep2: UILabel!
    @IBOutlet var lblStep3: UILabel!
    
    @IBOutlet var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStep1.layer.masksToBounds = true
        lblStep1.layer.cornerRadius = 6

        lblStep2.layer.masksToBounds = true
        lblStep2.layer.cornerRadius = 6
        
        lblStep3.layer.masksToBounds = true
        lblStep3.layer.cornerRadius = 6
        
        viewMain.layer.masksToBounds = true
        viewMain.layer.cornerRadius = 8
        viewMain.layer.borderWidth = 3
        viewMain.layer.borderColor = UIColor.black.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerLogin")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}

//
//  ViewControllerPopUpLogOut.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/01.
//

import UIKit

class ViewControllerPopUpLogOut: CustomUIViewController {

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

    @IBAction func onBtnYes(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerLogin")
        
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onBtnNo(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

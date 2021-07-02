//
//  ViewControllerAlarmSettings.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/04.
//

import UIKit
import WebKit

class ViewControllerWeb: CustomUIViewController {

    @IBOutlet var webView: WKWebView!

    var strUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("strUrl=\(strUrl)")
        
        let encodedString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        let myRequest = URLRequest(url: url)
    
        webView?.load(myRequest)
        
    }
    
    @IBAction func onBtnMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

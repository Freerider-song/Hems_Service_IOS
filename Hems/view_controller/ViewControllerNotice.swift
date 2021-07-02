//
//  ViewControllerNotice.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/02.
//

import UIKit
import WebKit

class ViewControllerNotice: CustomUIViewController {

    @IBOutlet var viewTop: UIView!
    @IBOutlet var lblTimeCreated: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var webView: WKWebView!
    
    var strTitle = ""
    var strContent = ""
    var strCreated = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTop.layer.borderWidth = 1
        viewTop.layer.borderColor = UIColor(named: "hems_gray")?.cgColor
        
        lblTimeCreated.text = strCreated
        lblTitle.text = strTitle
        
        webView.scrollView.bounces = false
        webView.layer.masksToBounds = true
        
        loadHTMLStringImage()
    }
    
    func loadHTMLStringImage() -> Void {
        
       let htmlString = ("<meta name = \"viewport\" content = \"initial-scale = 1.0\" />") + strContent
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBtnMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

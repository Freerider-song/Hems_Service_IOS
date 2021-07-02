//
//  CaToast.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation
import UIKit

public class CaToast{
    
    func showWaitDialog(_ controller: AnyObject) {
        print("CaToast: ShowWaitDialog")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func dismissWaitDialog(_ controller: AnyObject) {
        print("CaToast: DismissWaitDialog")
        
        controller.dismiss(animated: false, completion: nil)
    }
    
    func showToast(controller: AnyObject, message : String, seconds: Double) {
        print("CaToast: ShowToast")
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}


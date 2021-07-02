//
//  ViewControllerChangePasswordAuth.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/04.
//

import UIKit

class ViewControllerChangePasswordAuth: CustomUIViewController {

    @IBOutlet var textName: UITextField!
    @IBOutlet var textPhone: UITextField!
    @IBOutlet var textAuthCode: UITextField!
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

    @IBAction func onBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRequestAuthCode(_ sender: UIButton) {
        var strMessage = ""
        
        if textName.text == "" {
            strMessage = "이름을 입력해주세요"
        }
        else if textPhone.text == "" {
            strMessage = "휴대폰 번호를 입력해주세요"
        }
        
        if strMessage == "" {
            CaApp.m_Engine.RequestAuthCode(textPhone.text!, true, self)
            return
        }
        
        CaApp.m_Info.strMessage = strMessage
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: false, completion: nil)
    }
    
    @IBAction func onCheckAuthCode(_ sender: UIButton) {
        if textAuthCode.text == "" {
            CaApp.m_Info.strMessage = "인증코드를 입력해 주세요"
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: false, completion: nil)
            return;
        }
        
        let nAuthCode = Int(textAuthCode.text!)
        
        CaApp.m_Engine.CheckAuthCode(textPhone.text!, nAuthCode!, 300, true, self)
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            
        case CaApp.m_Engine.API_REQUEST_AUTH_CODE:
            print("result of RequestAuthCode")
                
        case CaApp.m_Engine.API_CHECK_AUTH_CODE:
            print("result of CheckAuthCode")
            let jo:[String:Any] = Result.JSONResult
            let nResultCode: Int = jo["result_code"] as! Int
            
            if nResultCode == -2 {
                alert(title: "인증오류", message: "인증코드를 요청한 적이 없는 전화번호입니다", text: "확인")
            }
            else if nResultCode == 0 {
                alert(title: "인증오류", message: "인증코드 불일치", text: "확인")
            }
            else if nResultCode == 1 {
                print("인증됨")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerChangePassword")
                view.modalPresentationStyle = .fullScreen
                
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: true) {
                    pvc.present(view, animated: true, completion: nil)
                }
                
            }
            else if nResultCode == 2 {
                alert(title: "인증오류", message: "시간초과입니다", text: "확인")
            }
            
        default:
            print("Default!")
        }

    }

}

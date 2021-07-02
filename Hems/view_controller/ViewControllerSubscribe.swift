//
//  ViewControllerSubscribe.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/25.
//

import UIKit

class ViewControllerSubscribe: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var lblStep1: UILabel!
    @IBOutlet var lblStep2: UILabel!
    @IBOutlet var lblStep3: UILabel!
    
    @IBOutlet var textId: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textPasswordConfirm: UITextField!
    
    //var bKeyboardOn: Bool = false
    
    @IBAction func onCheck1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStep1.layer.masksToBounds = true
        lblStep1.layer.cornerRadius = 6

        lblStep2.layer.masksToBounds = true
        lblStep2.layer.cornerRadius = 6
        
        lblStep3.layer.masksToBounds = true
        lblStep3.layer.cornerRadius = 6
        
        textId.delegate = self
        textPassword.delegate = self
        textPasswordConfirm.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func keyboardWillAppear(_ sender: NotificationCenter) {
        print("keyboardWillAppear")
        
        if !bKeyboardOn {
            self.view.frame.origin.y -= 200
        }
        
        bKeyboardOn = true
    }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter) {
        print("keyboardWillDisappear")

        self.view.frame.origin.y = 0
        bKeyboardOn = false
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        return true
    }

    @IBAction func onCreateMember(_ sender: UIButton) {
        CaApp.m_Info.strMessage = ""
        
        if textId.text == "" {
            CaApp.m_Info.strMessage = "아이디를 입력해주세요"
        }
        else {
            if textPassword.text == "" || textPasswordConfirm.text == "" {
                CaApp.m_Info.strMessage = "새 비밀번호와 확인 비밀번호를 모두 입력해주세요"
            }
            else {
                if textPassword.text != textPasswordConfirm.text {
                    CaApp.m_Info.strMessage = "새 비밀번호와 확인 비밀번호가 서로 다릅니다. 다시 입력해주세요."
                }
            }
        }
        
        if (CaApp.m_Info.strMessage != "") {
            alert(title: "입력오류", message: CaApp.m_Info.strMessage, text: "확인")
            return
        }
        
        if CaApp.m_Info.bSubscribingAsMainMember {
            CaApp.m_Engine.CreateMemberMain(CaApp.m_Info.nSeqAptHoSubscribing, CaApp.m_Info.strMemberNameSubscribing, CaApp.m_Info.strPhoneSubscribing, textId.text!, textPassword.text!, false, self)
            
        }
        else {
            CaApp.m_Engine.CreateMemberSub(CaApp.m_Info.nSeqAptHoSubscribing, CaApp.m_Info.strMemberNameSubscribing, CaApp.m_Info.strPhoneSubscribing, textId.text!, textPassword.text!, false, self)
        }
        
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        
        case CaApp.m_Engine.API_CREATE_MEMBER_MAIN:
                let jo:[String:Any] = Result.JSONResult
                let nResultCode: Int = jo["result_code"] as! Int
                
            if nResultCode == 0 {
                let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerSubscribedMain")
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true, completion: nil)
            }
            else if nResultCode == 1 {
                showPopUpConfirm(message: "중복된 아이디가 있습니다")
            }
            else {
                showPopUpConfirm(message: "아이디 생성에 실패했습니다")
            }
            
        case CaApp.m_Engine.API_CREATE_MEMBER_SUB:
                let jo:[String:Any] = Result.JSONResult
                let nResultCode: Int = jo["result_code"] as! Int
                let nSeqMember: Int = jo["seq_member"] as! Int
            
            if nResultCode == 0 {
                
                CaApp.m_Engine.RequestAckMember(nSeqMember, false, self)
                
                let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerSubscribedSub")
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true, completion: nil)
            }
            else if nResultCode == 1 {
                showPopUpConfirm(message: "중복된 아이디가 있습니다")
            }
            else {
                showPopUpConfirm(message: "계정 생성에 실패했습니다")
            }
        case CaApp.m_Engine.API_REQUEST_ACK_MEMBER:
            print("response of RequestAckMember")
            
        default:
            print("unknown result")
        }
    }
    
}

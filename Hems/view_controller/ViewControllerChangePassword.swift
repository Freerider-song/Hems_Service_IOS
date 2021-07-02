//
//  ViewControllerChangePassword.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/03/04.
//

import UIKit

class ViewControllerChangePassword: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var textMemberId: UITextField!
    @IBOutlet var textPasswordNew: UITextField!
    @IBOutlet var textPasswordConfirm: UITextField!
    
    //var bKeyboardOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textMemberId.delegate = self
        textPasswordNew.delegate = self
        textPasswordConfirm.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
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
        print("touches began execute")
        
        self.view.frame.origin.y = 0
        bKeyboardOn = false

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRequestChangePassword(_ sender: UIButton) {
        
        CaApp.m_Info.strMessage = ""
        
        if textMemberId.text == "" {
            CaApp.m_Info.strMessage = "아이디를 입력해주세요"
        }
        else if textPasswordNew.text == "" || textPasswordConfirm.text == "" {
            CaApp.m_Info.strMessage = "새 비밀번호와 비밀번호 확인을 모두 입력해주세요"
        }
        else if textPasswordNew.text != textPasswordConfirm.text {
            CaApp.m_Info.strMessage = "새 비밀번호와 비밀번호 확인이 서로 다릅니다. 다시 입력해주세요"
        }
        
        if CaApp.m_Info.strMessage == "" {
            CaApp.m_Engine.ChangePasswordByMemberId(textMemberId.text!, textPasswordNew.text!, false, self)
        }
        else {
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: false, completion: nil)
        }
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
            
        case CaApp.m_Engine.API_CHANGE_PASSWORD_BY_MEMBER_ID:
            let jo:[String:Any] = Result.JSONResult
            let nSeqMember: Int = jo["seq_member"] as! Int
            
            if nSeqMember==0 {
                CaApp.m_Info.strMessage="비밀번호 변경에 실패했습니다"
            }
            else {
                CaApp.m_Info.strMessage="비밀번호 변경에 성공했습니다"
            }
            
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
            view.modalPresentationStyle = .overCurrentContext
            self.present(view, animated: false, completion: nil)
            
        default:
            print("unknown result code")
        }
    }
}

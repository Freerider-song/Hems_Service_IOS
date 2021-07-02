//
//  ViewControllerAuth.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/25.
//

import UIKit

class ViewControllerAuth: CustomUIViewController, UITextFieldDelegate {

    @IBOutlet var lblStep1: UILabel!
    @IBOutlet var lblStep2: UILabel!
    @IBOutlet var lblStep3: UILabel!
    
    @IBOutlet var textSite: UITextField!
    @IBOutlet var textDong: UITextField!
    @IBOutlet var textHo: UITextField!
    @IBOutlet var textName: UITextField!
    @IBOutlet var textPhone: UITextField!
    
    @IBOutlet var textAuthCode: UITextField!
    
    var pvSite = UIPickerView()
    var pvDong = UIPickerView()
    var pvHo = UIPickerView()
    
    var alSite: Array<CaItem> = Array()
    var alDong: Array<CaItem> = Array()
    var alHo: Array<CaItem> = Array()
    
    var nSeqSiteSelected: Int = 0
    var nSeqDongSelected: Int = 0
    
    //var restoreFrameValue: CGFloat = 0.0
    //var bKeyboardOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblStep1.layer.masksToBounds = true
        lblStep1.layer.cornerRadius = 6

        lblStep2.layer.masksToBounds = true
        lblStep2.layer.cornerRadius = 6
        
        lblStep3.layer.masksToBounds = true
        lblStep3.layer.cornerRadius = 6
        
        CaApp.m_Info.nSeqAptHoSubscribing = 0
        
        textSite.inputView = pvSite
        textDong.inputView = pvDong
        textHo.inputView = pvHo
        
        pvSite.delegate = self
        pvSite.dataSource = self
        
        pvDong.delegate = self
        pvDong.dataSource = self

        pvHo.delegate = self
        pvHo.dataSource = self
        
        pvSite.tag = 1
        pvDong.tag = 2
        pvHo.tag = 3
        
        CaApp.m_Engine.GetSiteList(false, self)
        
        textSite.delegate = self
        textDong.delegate = self
        textHo.delegate = self
        textName.delegate = self
        textPhone.delegate = self
        textAuthCode.delegate = self
        
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
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.frame.origin.y = 0
         bKeyboardOn = false
    }
    */
    
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

    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRequestAuthCode(_ sender: UIButton) {
        
        CaApp.m_Info.strMemberNameSubscribing = textName.text!
        CaApp.m_Info.strPhoneSubscribing = textPhone.text!
        
        var strMessage = ""
        
        if CaApp.m_Info.nSeqAptHoSubscribing == 0 {
    //        alert(title: "", message: "", text: "확인")
            strMessage = "거주하는 아파트의 동과 호를 선택해주세요"
        }
        else if textName.text == "" {
            strMessage = "이름을 입력해주세요"
        }
        else if textPhone.text == "" {
            strMessage = "휴대폰 번호를 입력해주세요"
        }
        
        if strMessage == "" {
            CaApp.m_Engine.RequestAuthCode(textPhone.text!, true, self)
            return
        }
        
        alert(title: "입력오류", message: strMessage, text: "확인")
       // print(strMessage)
        /*
        CaApplication.m_Info.strMessage = strMessage
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController") //as? ChangePasswordViewController
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: true, completion: nil)
        */
        
        
    }
    
    @IBAction func onCheckAuthCode(_ sender: UIButton) {
        let strAuthCode = textAuthCode.text
        
        print("length of auth code = \(strAuthCode!.count)")
        
        if strAuthCode!.count == 6 {
            let nAuthCode = Int(strAuthCode!)
            CaApp.m_Engine.CheckAuthCode(CaApp.m_Info.strPhoneSubscribing, nAuthCode!, 300, false, self)
        }
        else {
            alert(title: "인증번호 오류", message: "인증번호 6자리를 입력하세요", text: "확인")
        }
    }
    
    
    // ---------------------
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        
            case CaApp.m_Engine.API_GET_SITE_LIST:
                let jo:[String:Any] = Result.JSONResult
                
                var siteList: Array<[String:Any]> = Array()
                
                if jo["site_list"] != nil {
                    siteList = jo["site_list"] as! Array<[String:Any]>
                }
                
                for site in siteList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = site["seq_site"]! as! Int
                    
                    item.strName = site["name"]! as! String
                    
                    alSite.append(item)
                }
                

            case CaApp.m_Engine.API_GET_APT_DONG_LIST:
                let jo:[String:Any] = Result.JSONResult
                
                var dongList: Array<[String:Any]> = Array()
                
                if jo["dong_list"] != nil {
                    dongList = jo["dong_list"] as! Array<[String:Any]>
                }
                //초기화 작업
                alDong.removeAll()
                
                for dong in dongList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = dong["seq_dong"]! as! Int
                    
                    item.strName = dong["dong_name"]! as! String
                    
                    alDong.append(item)
                }
                
                
            case CaApp.m_Engine.API_GET_APT_HO_LIST:
                let jo:[String:Any] = Result.JSONResult
                var hoList: Array<[String:Any]> = Array()
                
                if jo["ho_list"] != nil {
                    hoList = jo["ho_list"] as! Array<[String:Any]>
                }
                
                alHo.removeAll()
                
                for ho in hoList {
                    let item:CaItem = CaItem()
                    
                    item.nSeq = ho["seq_ho"]! as! Int
                    
                    item.strName = ho["ho_name"]! as! String
                    
                    alHo.append(item)
                }
            
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
                    //print("인증됨")
                    //alert(title: "인증성공", message: "시간초과입니다", text: "확인")
                    CaApp.m_Engine.GetMemberCandidateInfo(CaApp.m_Info.nSeqAptHoSubscribing, textName.text!, textPhone.text!, true, self)
                }
                else if nResultCode == 2 {
                    alert(title: "인증오류", message: "시간초과입니다", text: "확인")
                }
                
            case CaApp.m_Engine.API_GET_MEMBER_CANDIDATE_INFO:
                
                let jo:[String:Any] = Result.JSONResult
                var bCandidate: Int = 0
                var nHoState: Int = 0
                bCandidate = jo["is_candidate"] as! Int
                nHoState = jo["ho_state"] as! Int
                
                if bCandidate == 1 {
                    if nHoState == 1 {
                        print("동의서에 명시된 세대 대표이며 아직 미등록 상태")
                        CaApp.m_Info.bSubscribingAsMainMember = true
                        CaApp.m_Info.nAuthType = CaApp.m_Engine.AUTH_TYPE_SUBSCRIBE
                       
                        let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerSubscribe")
                        view.modalPresentationStyle = .fullScreen
                        self.present(view, animated: true, completion: nil)
                    }
                    else if nHoState == 2 {
                        print("동일 정보로 이미 등록됨. 로그인 창으로.")
                        CaApp.m_Info.strMessage = "세대 대표로 이미 등록되어 있습니다. 로그인하세요."
                        alert(title: "", message: CaApp.m_Info.strMessage, text: "확인")
                        
                        //self.dismiss(animated: true, completion: nil)
                        /*
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                        */
                        
                    }
                    else if nHoState == 3 {
                        print("다른 분이 세대 대표로 이미 등록되어 잇음. 관리실 문의")
                        CaApp.m_Info.strMessage = "다른 분이 세대 대표로 이미 등록되어 있습니다. 관리실에 문의하세요."
                        alert(title: "", message: CaApp.m_Info.strMessage, text: "확인")
                        /*
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                         */
                    }
                    else {
                        print("unknown nHostate" + String(nHoState))
                    }
                    
                }
                else {
                    if nHoState == 1 {
                        print("세대 대표 먼저 등록해야함")
                        CaApp.m_Info.strMessage = "세대 대표자의 가입 이후에 가입하시기 바랍니다."
                        alert(title: "", message: CaApp.m_Info.strMessage, text: "확인")
                        
                        /*
                        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "D02PopUpViewController")
                        view.modalPresentationStyle = .overCurrentContext
                        self.present(view, animated: true, completion: nil)
                        */
                    }
                    else if nHoState == 3 {
                        print("세대원으로 가입 진행")
                        CaApp.m_Info.bSubscribingAsMainMember = false
                        CaApp.m_Info.nAuthType = CaApp.m_Engine.AUTH_TYPE_SUBSCRIBE
                       
                        let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerSubscribe")
                        view.modalPresentationStyle = .fullScreen
                        self.present(view, animated: true, completion: nil)

                    }
                }
                
                
            default:
                print("Default!")
        }
    }
    
    //---------------------------
}

extension ViewControllerAuth: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return alSite.count
        case 2:
            return alDong.count
        case 3:
            return alHo.count
        default:
            return 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        
        case 1:
            let item = alSite[row]
            return item.strName
            
        case 2:
            // 동이 존재하지 않는 단지가 존재
            if !alDong.isEmpty{
            let item = alDong[row]
            
                return item.strName}
            else {
                
                //dongTextField.text = ""
                //hoTextField.text = ""
                return "none"
            }
    
        case 3:
            if !alHo.isEmpty && !alDong.isEmpty{
            let item = alHo[row]
                return item.strName}
            else {
                //hoTextField.text = ""
                return "none"
            }
            
        default:
            return "Data not found"
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let item = alSite[row]
            
            nSeqSiteSelected = item.nSeq
           
            // to prevent mismatch on submission
            CaApp.m_Info.nSeqAptHoSubscribing = 0

            CaApp.m_Engine.GetAptDongList(nSeqSiteSelected, false, self)
            
            textSite.text = item.strName
            textSite.resignFirstResponder()
            CaApp.m_Info.strSiteName = item.strName
            
        case 2:
            if !alDong.isEmpty {
                let item = alDong[row]
                
                nSeqDongSelected = item.nSeq
                
                // to prevent mismatch on submission
                CaApp.m_Info.nSeqAptHoSubscribing = 0
                CaApp.m_Engine.GetAptHoList(nSeqSiteSelected, nSeqDongSelected, false, self)
                
                textDong.text = item.strName
                textDong.resignFirstResponder()
                CaApp.m_Info.strAptDongName = item.strName
            }
            else {
                alHo.removeAll()
                textDong.text = ""
                textDong.resignFirstResponder()}
                
        case 3:
            if !alHo.isEmpty && !alDong.isEmpty {
                let item = alHo[row]
                    
                CaApp.m_Info.nSeqAptHoSubscribing = item.nSeq
                    
                textHo.text = item.strName
                textHo.resignFirstResponder()
                CaApp.m_Info.strAptHoName = item.strName
            }
            else {
                CaApp.m_Info.nSeqAptHoSubscribing = 0
                textHo.text = ""
                textHo.resignFirstResponder()
            }
                
        default:
            print("Data Not found")
            
    }
}

}

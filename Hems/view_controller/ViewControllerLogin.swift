//
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import UIKit
import Firebase

class ViewControllerLogin: CustomUIViewController {

    var callback : ((String) -> Void)?
    
    var m_strId = ""
    var m_strPw = ""
    var m_strDeviceId = ""
    
    let toast: CaToast = CaToast()
    
    let m_Pref: CaPref = CaPref()
    
    @IBOutlet var textId: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var lblVersion: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("togdog Login viewDidLoad")
        
      //  btnChangePassword.isHidden = true
        
        if (Messaging.messaging().fcmToken != nil){
            CaApp.m_Info.strPushId = Messaging.messaging().fcmToken!
        }
        
        viewSetting()
        
        //저장된 로그인정보 확인
        let savedLoginId: String = m_Pref.getValue(m_GlobalEngine.PREF_MEMBER_ID, "")
        if savedLoginId != "" {
            textId.text = savedLoginId
        }
        
        let savedPassword: String = m_Pref.getValue(m_GlobalEngine.PREF_PASSWORD, "")
        if savedPassword != "" {
            textPassword.text = savedPassword
        }
    }
    
    func viewSetting() {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        lblVersion.text = version

        /*
        // 키보드 입력
        txtId.delegate = self
        txtPw.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name:UIResponder.keyboardWillShowNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)
 
 */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    @IBAction func btnLogin(_ sender: UIButton) {
        print("login pressed...id=\(textId.text!) password=\(textPassword.text!)")
        
        if textId.text == "" {
            alert(title: "로그인 실패", message: "아이디를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        if textPassword.text == "" {
            alert(title: "로그인 실패", message: "비밀번호를 입력해주시기 바랍니다.", text: "확인")
            return
        }
        
        m_strId = textId.text!
        m_strPw = textPassword.text!
        m_strDeviceId = CaApp.m_Info.strPushId
        
        CaApp.m_Engine.CheckLogin(textId.text!, textPassword.text!, self)
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        print("change password pressed...")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerChangePasswordAuth")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubscribe(_ sender: UIButton) {
        print("subscribe pressed...")
        let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerAuth")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }

    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case m_GlobalEngine.API_CHECK_LOGIN:
            parseResultCheckLogin(Result)
            break
            
        case m_GlobalEngine.API_GET_MEMBER_INFO:
            parseResultGetMemberInfo(Result)
            break
            
        default:
            print("unknown api code returned...")
            break
        }
        
    }
    
    func parseResultCheckLogin(_ Result: CaResult) {
        // 로그인 성공
        if Result.JSONResult["is_id_password_ok"]! as! Bool {
            print("Login: Login Success!")
            
            let jo:[String:Any] = Result.JSONResult
            
            // 로그인 정보 저장
            m_Pref.setValue(m_GlobalEngine.PREF_MEMBER_ID , m_strId)
            m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, m_strPw)
            
            let bNewVersionAvailable: Bool = jo["is_new_version_available"]! as! Bool
            let bMainMember: Bool = jo["is_main_member"]! as! Bool
            let nSeqMemberMain: Int = jo["seq_member_main"]! as! Int
            let nSeqMemberSub: Int = jo["seq_member_sub"]! as! Int
            
            CaApp.m_Info.strMemberId = m_strId
            CaApp.m_Info.strPassword = m_strPw
            CaApp.m_Info.nSeqMember = jo["seq_member"]! as! Int
            CaApp.m_Info.nSeqSite = jo["seq_site"]! as! Int
            CaApp.m_Info.bMainMember = bMainMember
            
            CaApp.m_Info.dtAuthRequested = jo["time_ack_request"]! as? Date
            CaApp.m_Info.dtAuthResponsed = jo["time_ack_response"]! as? Date
            
            CaApp.m_Info.nAckResponseCodeLatest
             = jo["ack_response_code_latest"]! as! Int
            CaApp.m_Info.nAckRequestTodayCount
             = jo["ack_request_today_count"] as! Int
            
            if bMainMember {
                if bNewVersionAvailable {
                    alert(title: "새 버전 출시", message: "새로운 버전이 있습니다. 앱 버전 업데이트를 진행해주세요!", text: "확인")
                }
                else {
                    CaApp.m_Engine.GetMemberInfo(CaApp.m_Info.nSeqMember, self)
                }
            }
            else {
                if CaApp.m_Info.nAckResponseCodeLatest == 1 {
                    if bNewVersionAvailable {
                        alert(title: "새 버전 출시", message: "새로운 버전이 있습니다. 앱 버전 업데이트를 진행해주세요!", text: "확인")
                    }
                    else {
                        CaApp.m_Engine.GetMemberInfo(CaApp.m_Info.nSeqMember, self)
                    }
                }
                else {
                    print("승인 대기중")
                    
                    let storyboard = UIStoryboard(name: "Subscribe", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerWaitingAck")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                }
            }
            
        } else {
            print("Login: Login Failed!")
            
            alert(title: "Login Failed", message: "일치하는 회원정보가 없습니다. 아이디나 비밀번호를 확인해주십시오.", text: "확인")
        }

    } // end of func
    
    func null2nil(value: Any?) -> Any? {
        if (value is NSNull) {
            return nil
        }
        else {
            return value
        }
    }
    
    func parseResultGetMemberInfo(_ Result: CaResult) {
        let jo:[String:Any] = Result.JSONResult
        let joMemberInfo:[String:Any] = Result.JSONResult["member_info"]! as! [String : Any]
        
        CaApp.m_Info.strDateCreated = joMemberInfo["time_created"] as! String
        CaApp.m_Info.dtModified = joMemberInfo["time_modified"] as? String ?? ""
        CaApp.m_Info.strLastLogin = joMemberInfo["time_last_login"] as! String
        CaApp.m_Info.dtChangePassword = joMemberInfo["time_change_password"] as! String
        
        CaApp.m_Info.bMainMember = joMemberInfo["member_main"]! as! Bool
        CaApp.m_Info.nSeqSite = joMemberInfo["seq_site"]! as! Int
        CaApp.m_Info.nSeqMember = joMemberInfo["seq_member"]! as! Int
        CaApp.m_Info.strMemberName = joMemberInfo["member_name"]! as! String
        CaApp.m_Info.strSiteName = joMemberInfo["site_name"]! as! String
        CaApp.m_Info.strSiteAddress = joMemberInfo["site_address"]! as! String
        CaApp.m_Info.nSiteBuiltYear = joMemberInfo["site_built_year"]! as! Int
        CaApp.m_Info.nSiteBuiltMonth = joMemberInfo["site_built_month"]! as! Int
        CaApp.m_Info.nSeqAptDong = joMemberInfo["seq_apt_dong"]! as! Int
        CaApp.m_Info.strAptDongName = joMemberInfo["apt_dong_name"]! as! String
        CaApp.m_Info.nSeqAptHo = joMemberInfo["seq_apt_ho"]! as! Int
        CaApp.m_Info.strAptHoName = joMemberInfo["apt_ho_name"]! as! String
        CaApp.m_Info.nAptHoArea = joMemberInfo["apt_ho_area"]! as! Int
        CaApp.m_Info.strPhone = joMemberInfo["phone_num"]! as! String
        
        // 현재 Null 값이 전송돼 오류가 발생하기에 주석처리 해놓음. 값이 없을 때 Null을 보내는 문제 상무님이랑 해결 필요
        //CaApp.m_Info.strMail = joMemberInfo["mail"]! as! String
        
        CaApp.m_Info.dThresholdUsageElec = joMemberInfo["threshold_usage_elec"]! as! Double
        CaApp.m_Info.dThresholdUsageWater = joMemberInfo["threshold_usage_water"]! as! Double
        CaApp.m_Info.dThresholdUsageGas = joMemberInfo["threshold_usage_gas"]! as! Double
        CaApp.m_Info.dThresholdUsageHeat = joMemberInfo["threshold_usage_heat"]! as! Double
        CaApp.m_Info.dThresholdUsageSteam = joMemberInfo["threshold_usage_steam"]! as! Double
        CaApp.m_Info.dThresholdWonElec = joMemberInfo["threshold_won_elec"]! as! Double
        CaApp.m_Info.dThresholdWonWater = joMemberInfo["threshold_won_water"]! as! Double
        CaApp.m_Info.dThresholdWonGas = joMemberInfo["threshold_won_gas"]! as! Double
        CaApp.m_Info.dThresholdWonHeat = joMemberInfo["threshold_won_heat"]! as! Double
        CaApp.m_Info.dThresholdWonSteam = joMemberInfo["threshold_won_steam"]! as! Double
        
        CaApp.m_Info.bNotiAll = joMemberInfo["noti_all"]! as! Bool
        CaApp.m_Info.bNotiUsageElec = joMemberInfo["noti_usage_elec"]! as! Bool
        CaApp.m_Info.bNotiUsageWater = joMemberInfo["noti_usage_water"]! as! Bool
        CaApp.m_Info.bNotiUsageGas = joMemberInfo["noti_usage_gas"]! as! Bool
        CaApp.m_Info.bNotiUsageHeat = joMemberInfo["noti_usage_heat"]! as! Bool
        CaApp.m_Info.bNotiUsageSteam = joMemberInfo["noti_usage_steam"]! as! Bool
        CaApp.m_Info.bNotiWonElec = joMemberInfo["noti_won_elec"]! as! Bool
        CaApp.m_Info.bNotiWonWater = joMemberInfo["noti_won_water"]! as! Bool
        CaApp.m_Info.bNotiWonGas = joMemberInfo["noti_won_gas"]! as! Bool
        CaApp.m_Info.bNotiWonHeat = joMemberInfo["noti_won_heat"]! as! Bool
        CaApp.m_Info.bNotiWonSteam = joMemberInfo["noti_won_steam"]! as! Bool
        CaApp.m_Info.nSiteReadDayElec = joMemberInfo["site_read_day_elec"]! as! Int
        CaApp.m_Info.nSiteReadDayWater = joMemberInfo["site_read_day_water"]! as! Int
        CaApp.m_Info.nSiteReadDayGas = joMemberInfo["site_read_day_gas"]! as! Int
        CaApp.m_Info.nSiteReadDayHeat = joMemberInfo["site_read_day_heat"]! as! Int
        CaApp.m_Info.nSiteReadDaySteam = joMemberInfo["site_read_day_steam"]! as! Int
        CaApp.m_Info.nSeqMeter = joMemberInfo["seq_meter"]! as! Int
        CaApp.m_Info.strMid = joMemberInfo["meter_id"]! as! String
       // CaApp.m_Info.strMeterMac = joMemberInfo["meter_mac_address"]! as! String
        CaApp.m_Info.strMeterMaker = joMemberInfo["meter_maker"]! as! String
        CaApp.m_Info.strMeterModel = joMemberInfo["meter_model"]! as! String
        CaApp.m_Info.nMeterState = joMemberInfo["meter_state"]! as! Int
        CaApp.m_Info.nMeterType = joMemberInfo["meter_type"]! as! Int
        CaApp.m_Info.nMeterValidInstr = joMemberInfo["meter_valid_instr_integer"]! as! Int
        CaApp.m_Info.dtMeterInstalled = joMemberInfo["time_meter_installed"] as? Date
        CaApp.m_Info.dtPriceModified = joMemberInfo["time_price_modified"] as? Date
        CaApp.m_Info.strPriceComment = joMemberInfo["price_comment"]! as! String
        CaApp.m_Info.nDiscountFamily = joMemberInfo["discount_id_family"]! as! Int
        CaApp.m_Info.nDiscountSocial = joMemberInfo["discount_id_social"]! as! Int
        
        // Family List
        var familyList: Array<[String:Any]> = Array()
        
        if jo["family_list"] != nil {
            familyList = jo["family_list"] as! Array<[String:Any]>
        }
        
        print("Login: Family count=" + String(familyList.count))
        
        CaApp.m_Info.alFamily.removeAll()
        
        for family in familyList {
            let ca_family:CaFamily = CaFamily()
            
            ca_family.nSeqMember = family["seq_member"]! as! Int
            ca_family.bMain = family["main_member"]! as! Bool
            ca_family.strName = family["member_name"]! as! String
            ca_family.strPhone = family["member_phone"]! as! String
            
            if family["time_last_login"] is NSNull {
                ca_family.strLastLogin = ""
            }
            else {
                ca_family.strLastLogin = family["time_last_login"] as! String
            }
            
            if ca_family.nSeqMember == CaApp.m_Info.nSeqMember {continue}
            
            CaApp.m_Info.alFamily.append(ca_family)
        }
        
        // Price List
        var priceList: Array<[String:Any]> = Array()
        
        if jo["price_list"] != nil {
            priceList = jo["price_list"] as! Array<[String:Any]>
        }
        
        CaApp.m_Info.alPrice.removeAll()
        
        for price in priceList {
            let ca_price:CaPrice = CaPrice()
            
            ca_price.nLevel = price["pTerm"]! as! Int
            ca_price.nFrom = price["nFrom"]! as! Int
            ca_price.nTo = price["nTo"]! as! Int
            ca_price.dBase = price["pBasic"]! as! Double
            ca_price.dHeight = price["fHeight"]! as! Double
            ca_price.dRate = price["pValue"]! as! Double
            ca_price.strInterval = price["Interval"]! as! String
            
            CaApp.m_Info.alPrice.append(ca_price)
        }
        
        // Discount family List
        var discountFamilyList: Array<[String:Any]> = Array()
        
        if jo["discount_family_list"] != nil {
            discountFamilyList = jo["discount_family_list"] as! Array<[String:Any]>
        }
        
        CaApp.m_Info.alDiscountFamily.removeAll()
        
        for discount in discountFamilyList {
            let ca_discount:CaDiscount = CaDiscount()
            
            ca_discount.nDiscountId = discount["discount_id"]! as! Int
            ca_discount.strDiscountName = discount["discount_name"]! as! String
            
            CaApp.m_Info.alDiscountFamily.append(ca_discount)
        }
        
        // Discount social List
        var discountSocialList: Array<[String:Any]> = Array()
        
        if jo["discount_social_list"] != nil {
            discountSocialList = jo["discount_social_list"] as! Array<[String:Any]>
        }
        
        CaApp.m_Info.alDiscountSocial.removeAll()
        
        for discount in discountSocialList {
            let ca_discount:CaDiscount = CaDiscount()
            
            ca_discount.nDiscountId = discount["discount_id"]! as! Int
            ca_discount.strDiscountName = discount["discount_name"]! as! String
            
            CaApp.m_Info.alDiscountSocial.append(ca_discount)
        }
        
        // Alarm List
        CaApp.m_Info.alAlarm.removeAll()
        
        if jo["alarm_list"] != nil {
            CaApp.m_Info.setAlarmList(jo["alarm_list"] as! Array<[String:Any]>)
        }
        
        // Notice List
        CaApp.m_Info.alNotice.removeAll()
        
        if jo["notice_top_list"] != nil || jo["notice_list"] != nil {
            CaApp.m_Info.setNoticeList(jo["notice_top_list"] as! Array<[String:Any]>, jo["notice_list"] as! Array<[String:Any]>)
        }
        
        // QnA List
        CaApp.m_Info.alQna.removeAll()
        
        if jo["qna_list"] != nil {
            CaApp.m_Info.setQnaList(jo["qna_list"] as! Array<[String:Any]>)
        }
        
        // 메인으로
        CaApp.m_Info.isLogin = true
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
}

//
//  ViewControllerSettings.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import UIKit

class FamilyCell: UITableViewCell {
    
    @IBOutlet var cellName: UILabel!
    @IBOutlet var cellPhone: UILabel!
    @IBOutlet var cellLoginDate: UILabel!
    @IBOutlet var cellCancelBtn: UIButton!
    
    @IBAction func onCancelBtnClicked(_ sender: UIButton) {
        let buttonTag = sender.tag
        print("tag is \(buttonTag)")
    }
}

class ViewControllerSettings: CustomUIViewController, UITextFieldDelegate {
    @IBOutlet var lblMemberId: UILabel!
    @IBOutlet var lblPwdChange: UILabel!
    @IBOutlet var lblMemberName: UILabel!
    @IBOutlet var lblApt: UILabel!
    @IBOutlet var lblDongHo: UILabel!
    @IBOutlet var textDiscountFamily: UITextField!
    @IBOutlet var textDiscountSocial: UITextField!
    
    @IBOutlet var btnAlarmAll: UIButton!
    
    @IBOutlet var btnAlarmUsageElec: UIButton!
    @IBOutlet var btnAlarmUsageWater: UIButton!
    @IBOutlet var btnAlarmUsageGas: UIButton!
    @IBOutlet var btnAlarmUsageHeat: UIButton!
    @IBOutlet var btnAlarmUsageSteam: UIButton!
    
    @IBOutlet var btnAlarmWonElec: UIButton!
    @IBOutlet var btnAlarmWonWater: UIButton!
    @IBOutlet var btnAlarmWonGas: UIButton!
    @IBOutlet var btnAlarmWonHeat: UIButton!
    @IBOutlet var btnAlarmWonSteam: UIButton!
    
    @IBOutlet var textAlarmUsageElec: UITextField!
    @IBOutlet var textAlarmUsageWater: UITextField!
    @IBOutlet var textAlarmUsageGas: UITextField!
    @IBOutlet var textAlarmUsageHeat: UITextField!
    @IBOutlet var textAlarmUsageSteam: UITextField!
    
    @IBOutlet var textAlarmWonElec: UITextField!
    @IBOutlet var textAlarmWonWater: UITextField!
    @IBOutlet var textAlarmWonGas: UITextField!
    @IBOutlet var textAlarmWonHeat: UITextField!
    @IBOutlet var textAlarmWonSteam: UITextField!
    
    @IBOutlet var tvFamily: UITableView!
    var discountFamilyPickerView = UIPickerView()
    var discountSocialPickerView = UIPickerView()
    
    var bAlarmAll = CaApp.m_Info.bNotiAll
    
    var bAlarmUsageElec = CaApp.m_Info.bNotiUsageElec
    var bAlarmUsageWater = CaApp.m_Info.bNotiUsageWater
    var bAlarmUsageGas = CaApp.m_Info.bNotiUsageGas
    var bAlarmUsageHeat = CaApp.m_Info.bNotiUsageHeat
    var bAlarmUsageSteam = CaApp.m_Info.bNotiUsageSteam
    
    var bAlarmWonElec = CaApp.m_Info.bNotiWonElec
    var bAlarmWonWater = CaApp.m_Info.bNotiWonWater
    var bAlarmWonGas = CaApp.m_Info.bNotiWonGas
    var bAlarmWonHeat = CaApp.m_Info.bNotiWonHeat
    var bAlarmWonSteam = CaApp.m_Info.bNotiWonSteam
    
    var dThresholdUsageElec = CaApp.m_Info.dThresholdUsageElec
    var dThresholdUsageWater = CaApp.m_Info.dThresholdUsageWater
    var dThresholdUsageGas = CaApp.m_Info.dThresholdUsageGas
    var dThresholdUsageHeat = CaApp.m_Info.dThresholdUsageHeat
    var dThresholdUsageSteam = CaApp.m_Info.dThresholdUsageSteam
    
    var dThresholdWonElec = CaApp.m_Info.dThresholdWonElec
    var dThresholdWonWater = CaApp.m_Info.dThresholdWonWater
    var dThresholdWonGas = CaApp.m_Info.dThresholdWonGas
    var dThresholdWonHeat = CaApp.m_Info.dThresholdWonHeat
    var dThresholdWonSteam = CaApp.m_Info.dThresholdWonSteam
    
    var nDiscountFamily = CaApp.m_Info.nDiscountFamily
    var nDiscountSocial = CaApp.m_Info.nDiscountSocial
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMemberId.text = "아이디 : \(CaApp.m_Info.strMemberId)"
        lblPwdChange.text = "비밀번호 변경일 : \(CaApp.m_Info.dtChangePassword)"
        lblMemberName.text = "이름 : \(CaApp.m_Info.strMemberName)"
        lblApt.text = "단지 : \(CaApp.m_Info.strSiteName)"
        lblDongHo.text = "동호수 : \(CaApp.m_Info.strAptDongName)동 \(CaApp.m_Info.strAptHoName)호"
        
        textDiscountSocial.inputView = discountSocialPickerView
        textDiscountFamily.inputView = discountFamilyPickerView
        
        if !CaApp.m_Info.bMainMember {
            textDiscountFamily.inputView = nil
            textDiscountSocial.inputView = nil
            textDiscountSocial.isUserInteractionEnabled = false
            textDiscountFamily.isUserInteractionEnabled = false
        }
        
        discountFamilyPickerView.delegate = self
        discountSocialPickerView.delegate = self
        
        discountFamilyPickerView.tag = 2
        discountSocialPickerView.tag = 3
        
        textDiscountFamily.delegate = self
        textDiscountSocial.delegate = self
        
        textAlarmUsageElec.delegate = self
        textAlarmUsageWater.delegate = self
        textAlarmUsageGas.delegate = self
        textAlarmUsageHeat.delegate = self
        textAlarmUsageSteam.delegate = self
        textAlarmWonElec.delegate = self
        textAlarmWonWater.delegate = self
        textAlarmWonGas.delegate = self
        textAlarmWonHeat.delegate = self
        textAlarmWonSteam.delegate = self
        
        setAlarmInfo()
        
        tvFamily.delegate = self
        tvFamily.dataSource = self
        
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


    @IBAction func btnMain(_ sender: UIButton) {
        print("main button clicked...")
   
        if isSettingChanged() {
            processSettingChange()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        print("btnMenu called...")
        
        if isSettingChanged() {
            processSettingChange()
        }
        
    }
    
    @IBAction func onBtnChangePassword(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerChangePasswordAuth")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onBtnAlarmAll(_ sender: UIButton) {
        bAlarmAll = !bAlarmAll
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmUsageElec(_ sender: UIButton) {
        bAlarmUsageElec = !bAlarmUsageElec
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmUsageWater(_ sender: UIButton) {
        bAlarmUsageWater = !bAlarmUsageWater
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmUsageGas(_ sender: UIButton) {
        bAlarmUsageGas = !bAlarmUsageGas
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmUsageHeat(_ sender: UIButton) {
        bAlarmUsageHeat = !bAlarmUsageHeat
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmUsageSteam(_ sender: UIButton) {
        bAlarmUsageSteam = !bAlarmUsageSteam
        setAlarmInfo()
    }
   
    @IBAction func onBtnAlarmWonElec(_ sender: UIButton) {
        bAlarmWonElec = !bAlarmWonElec
        setAlarmInfo()
    }

    @IBAction func onBtnAlarmWonWater(_ sender: UIButton) {
        bAlarmWonWater = !bAlarmWonWater
        setAlarmInfo()
    }
    
    @IBAction func onBtnAlarmWonGas(_ sender: UIButton) {
        bAlarmWonGas = !bAlarmWonGas
        setAlarmInfo()
    }

    @IBAction func onBtnAlarmWonHeat(_ sender: UIButton) {
        bAlarmWonHeat = !bAlarmWonHeat
        setAlarmInfo()
    }

    @IBAction func onBtnAlarmWonSteam(_ sender: UIButton) {
        bAlarmWonSteam = !bAlarmWonSteam
        setAlarmInfo()
    }
    
    @IBAction func onBtnSave(_ sender: UIButton) {
        if isSettingChanged() {
            processSettingChange()
        }
        else {
            showPopUpConfirm(message: "변경된 설정값이 없습니다")
        }
    }
    
    func setAlarmInfo() {
        if (bAlarmAll) {
            btnAlarmAll.setImage(UIImage(named: "check_yes.png"), for: .normal)
            
            if (bAlarmUsageElec) {
                btnAlarmUsageElec.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageElec.setImage(UIImage(named: "check_no.png"), for: .normal)
            }

            if (bAlarmUsageWater) {
                btnAlarmUsageWater.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageWater.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmUsageGas) {
                btnAlarmUsageGas.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageGas.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmUsageHeat) {
                btnAlarmUsageHeat.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageHeat.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmUsageSteam) {
                btnAlarmUsageSteam.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageSteam.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmWonElec) {
                btnAlarmWonElec.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonElec.setImage(UIImage(named: "check_no.png"), for: .normal)
            }

            if (bAlarmWonWater) {
                btnAlarmWonWater.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonWater.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmWonGas) {
                btnAlarmWonGas.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonGas.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmWonHeat) {
                btnAlarmWonHeat.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonHeat.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            if (bAlarmWonSteam) {
                btnAlarmWonSteam.setImage(UIImage(named: "check_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonSteam.setImage(UIImage(named: "check_no.png"), for: .normal)
            }
            
            textAlarmUsageElec.isUserInteractionEnabled = true
            textAlarmUsageWater.isUserInteractionEnabled = true
            textAlarmUsageGas.isUserInteractionEnabled = true
            textAlarmUsageHeat.isUserInteractionEnabled = true
            textAlarmUsageSteam.isUserInteractionEnabled = true
            
            textAlarmWonElec.isUserInteractionEnabled = true
            textAlarmWonWater.isUserInteractionEnabled = true
            textAlarmWonGas.isUserInteractionEnabled = true
            textAlarmWonHeat.isUserInteractionEnabled = true
            textAlarmWonSteam.isUserInteractionEnabled = true
        }
        else {
            btnAlarmAll.setImage(UIImage(named: "check_no.png"), for: .normal)
            
            if (bAlarmUsageElec) {
                btnAlarmUsageElec.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageElec.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }

            if (bAlarmUsageWater) {
                btnAlarmUsageWater.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageWater.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmUsageGas) {
                btnAlarmUsageGas.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageGas.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmUsageHeat) {
                btnAlarmUsageHeat.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageHeat.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmUsageSteam) {
                btnAlarmUsageSteam.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmUsageSteam.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmWonElec) {
                btnAlarmWonElec.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonElec.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }

            if (bAlarmWonWater) {
                btnAlarmWonWater.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonWater.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmWonGas) {
                btnAlarmWonGas.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonGas.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmWonHeat) {
                btnAlarmWonHeat.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonHeat.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            if (bAlarmWonSteam) {
                btnAlarmWonSteam.setImage(UIImage(named: "check_disabled_yes.png"), for: .normal)
            }
            else {
                btnAlarmWonSteam.setImage(UIImage(named: "check_disabled_no.png"), for: .normal)
            }
            
            textAlarmUsageElec.isUserInteractionEnabled = false
            textAlarmUsageWater.isUserInteractionEnabled = false
            textAlarmUsageGas.isUserInteractionEnabled = false
            textAlarmUsageHeat.isUserInteractionEnabled = false
            textAlarmUsageSteam.isUserInteractionEnabled = false
            
            textAlarmWonElec.isUserInteractionEnabled = false
            textAlarmWonWater.isUserInteractionEnabled = false
            textAlarmWonGas.isUserInteractionEnabled = false
            textAlarmWonHeat.isUserInteractionEnabled = false
            textAlarmWonSteam.isUserInteractionEnabled = false
        }
        
        textAlarmUsageElec.text = CaInfo.fmt1(value: dThresholdUsageElec)
        textAlarmUsageWater.text = CaInfo.fmt1(value: dThresholdUsageWater)
        textAlarmUsageGas.text = CaInfo.fmt1(value: dThresholdUsageGas)
        textAlarmUsageHeat.text = CaInfo.fmt1(value: dThresholdUsageHeat)
        textAlarmUsageSteam.text = CaInfo.fmt1(value: dThresholdUsageSteam)
        
        textAlarmWonElec.text = CaInfo.fmt0(value: Int(dThresholdWonElec))
        textAlarmWonWater.text = CaInfo.fmt0(value: Int(dThresholdWonWater))
        textAlarmWonGas.text = CaInfo.fmt0(value: Int(dThresholdWonGas))
        textAlarmWonHeat.text = CaInfo.fmt0(value: Int(dThresholdWonHeat))
        textAlarmWonSteam.text = CaInfo.fmt0(value: Int(dThresholdWonSteam))
        
        textDiscountFamily.text = CaApp.m_Info.alDiscountFamily[nDiscountFamily].strDiscountName
        textDiscountSocial.text = CaApp.m_Info.alDiscountSocial[nDiscountSocial].strDiscountName
    }
    
    func isSettingChanged() -> Bool {
        dThresholdUsageElec = Double(textAlarmUsageElec.text!)!
        dThresholdUsageWater = Double(textAlarmUsageWater.text!)!
        dThresholdUsageGas = Double(textAlarmUsageGas.text!)!
        dThresholdUsageHeat = Double(textAlarmUsageHeat.text!)!
        dThresholdUsageSteam = Double(textAlarmUsageSteam.text!)!
        
        dThresholdWonElec = Double(textAlarmWonElec.text!.replacingOccurrences(of: ",", with: ""))!
        dThresholdWonWater = Double(textAlarmWonWater.text!.replacingOccurrences(of: ",", with: ""))!
        dThresholdWonGas = Double(textAlarmWonGas.text!.replacingOccurrences(of: ",", with: ""))!
        dThresholdWonHeat = Double(textAlarmWonHeat.text!.replacingOccurrences(of: ",", with: ""))!
        dThresholdWonSteam = Double(textAlarmWonSteam.text!.replacingOccurrences(of: ",", with: ""))!
        
        if bAlarmAll != CaApp.m_Info.bNotiAll {return true}
        
        if bAlarmUsageElec != CaApp.m_Info.bNotiUsageElec {return true}
        if bAlarmUsageWater != CaApp.m_Info.bNotiUsageWater {return true}
        if bAlarmUsageGas != CaApp.m_Info.bNotiUsageGas {return true}
        if bAlarmUsageHeat != CaApp.m_Info.bNotiUsageHeat {return true}
        if bAlarmUsageSteam != CaApp.m_Info.bNotiUsageSteam {return true}

        if bAlarmWonElec != CaApp.m_Info.bNotiWonElec {return true}
        if bAlarmWonWater != CaApp.m_Info.bNotiWonWater {return true}
        if bAlarmWonGas != CaApp.m_Info.bNotiWonGas {return true}
        if bAlarmWonHeat != CaApp.m_Info.bNotiWonHeat {return true}
        if bAlarmWonSteam != CaApp.m_Info.bNotiWonSteam {return true}
        
        if nDiscountFamily != CaApp.m_Info.nDiscountFamily {return true}
        if nDiscountSocial != CaApp.m_Info.nDiscountSocial {return true}
         
        if abs(dThresholdUsageElec - CaApp.m_Info.dThresholdUsageElec) > 0.1 {return true}
        if abs(dThresholdUsageWater - CaApp.m_Info.dThresholdUsageWater) > 0.1 {return true}
        if abs(dThresholdUsageGas - CaApp.m_Info.dThresholdUsageGas) > 0.1 {return true}
        if abs(dThresholdUsageHeat - CaApp.m_Info.dThresholdUsageHeat) > 0.1 {return true}
        if abs(dThresholdUsageSteam - CaApp.m_Info.dThresholdUsageSteam) > 0.1 {return true}
        
        if Int(dThresholdWonElec) != Int(CaApp.m_Info.dThresholdWonElec) {return true}
        if Int(dThresholdWonWater) != Int(CaApp.m_Info.dThresholdWonWater) {return true}
        if Int(dThresholdWonGas) != Int(CaApp.m_Info.dThresholdWonGas) {return true}
        if Int(dThresholdWonHeat) != Int(CaApp.m_Info.dThresholdWonHeat) {return true}
        if Int(dThresholdWonSteam) != Int(CaApp.m_Info.dThresholdWonSteam) {return true}
         
        return false
     }
    
    func requestChangeMemberSettings() {
        CaApp.m_Engine.ChangeMemberSettings(CaApp.m_Info.nSeqMember, bAlarmAll ? 1 : 0,
            bAlarmUsageElec ? 1 : 0, bAlarmUsageWater ? 1 : 0, bAlarmUsageGas ? 1 : 0, bAlarmUsageHeat ? 1 : 0, bAlarmUsageSteam ? 1 : 0,
            bAlarmWonElec ? 1 : 0, bAlarmWonWater ? 1 : 0, bAlarmWonGas ? 1 : 0, bAlarmWonHeat ? 1 : 0, bAlarmWonSteam ? 1 : 0,
            dThresholdUsageElec, dThresholdUsageWater, dThresholdUsageGas, dThresholdUsageHeat, dThresholdUsageSteam,
            dThresholdWonElec, dThresholdWonWater, dThresholdWonGas, dThresholdWonHeat, dThresholdWonSteam,
            nDiscountFamily, nDiscountSocial, true, self)
    }
    
    func processSettingChange() {
    
        let msg = UIAlertController(title: "확인", message: "변경한 설정값을 저장하시겠습니까?", preferredStyle: .alert)
                
        let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    self.requestChangeMemberSettings()
                })
                
        let NO = UIAlertAction(title: "아니요", style: .default, handler: { (action) -> Void in self.dismiss(animated: true, completion: nil)})
                
        msg.addAction(YES)
        msg.addAction(NO)

        self.present(msg, animated: true, completion: nil)
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_CHANGE_MEMBER_SETTINGS:
            print("Result of ChangeMemberSettings received...")
            let jo:[String:Any] = Result.JSONResult
            
            let nSeqMember = jo["seq_member"] as! Int
            
            if nSeqMember == 0 {
                CaApp.m_Info.strMessage = "설정값 저장에 실패했습니다"
                let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
                
                view.modalPresentationStyle = .overCurrentContext
                self.present(view, animated: false, completion: nil)
            }
            else {
                CaApp.m_Info.bNotiAll = bAlarmAll
                CaApp.m_Info.bNotiUsageElec = bAlarmUsageElec
                CaApp.m_Info.bNotiUsageWater = bAlarmUsageWater
                CaApp.m_Info.bNotiUsageGas = bAlarmUsageGas
                CaApp.m_Info.bNotiUsageHeat = bAlarmUsageHeat
                CaApp.m_Info.bNotiUsageSteam = bAlarmUsageSteam
                CaApp.m_Info.bNotiWonElec = bAlarmWonElec
                CaApp.m_Info.bNotiWonWater = bAlarmWonWater
                CaApp.m_Info.bNotiWonGas = bAlarmWonGas
                CaApp.m_Info.bNotiWonHeat = bAlarmWonHeat
                CaApp.m_Info.bNotiWonSteam = bAlarmWonSteam
                
                CaApp.m_Info.dThresholdUsageElec = dThresholdUsageElec
                CaApp.m_Info.dThresholdUsageWater = dThresholdUsageWater
                CaApp.m_Info.dThresholdUsageGas = dThresholdUsageGas
                CaApp.m_Info.dThresholdUsageHeat = dThresholdUsageHeat
                CaApp.m_Info.dThresholdUsageSteam = dThresholdUsageSteam
                CaApp.m_Info.dThresholdWonElec = dThresholdWonElec
                CaApp.m_Info.dThresholdWonWater = dThresholdWonWater
                CaApp.m_Info.dThresholdWonGas = dThresholdWonGas
                CaApp.m_Info.dThresholdWonHeat = dThresholdWonHeat
                CaApp.m_Info.dThresholdWonSteam = dThresholdWonSteam
                
                CaApp.m_Info.nDiscountFamily = nDiscountFamily
                CaApp.m_Info.nDiscountSocial = nDiscountSocial
                
                showPopUpConfirm(message: "설정값 저장에 성공했습니다")
            }
            
        case CaApp.m_Engine.API_RESPONSE_ACK_MEMBER:
            print("Result of ResponseAckMember Received...")
            let jo:[String:Any] = Result.JSONResult
            
            let nResultCode = jo["result_code"] as! Int
            if nResultCode == 1 {
                let nAckType = jo["ack_type"] as! Int// 1=승인 2=거절 3= 철회
                
                if nAckType == 3 {
                    let nSeqMemberSub = jo["seq_member_sub"] as! Int
                    
                    if CaApp.m_Info.removeFamilyMember(nSeqMemberSub){
                        self.tvFamily.reloadData()
                    }
                }
            }
            
        default:
            print("Unknown result type")
        }
    }
    
    func requestAckCancel(_ nSeqMemberSub: Int) {
        CaApp.m_Engine.ResponseAckMember(nSeqMemberSub, 3, false, self)
    }

    func processAckCancel(_ nSeqMemberSub: Int, _ strNameSub: String) {

        let msg = UIAlertController(title: "확인", message: "\(strNameSub)님의 승인을 철회하시겠습니까?", preferredStyle: .alert)
                
                let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                    self.requestAckCancel(nSeqMemberSub)
                })
                
                let NO = UIAlertAction(title: "아니요", style: .cancel)
                
                msg.addAction(YES)
                msg.addAction(NO)

                self.present(msg, animated: true, completion: nil)
    }
    
}

//picker view 설정
extension ViewControllerSettings: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 2:
            return CaApp.m_Info.alDiscountFamily.count
            
        case 3:
            return CaApp.m_Info.alDiscountSocial.count
            
        default:
            return 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1:
            return 2
        
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 2:
            
            let family = CaApp.m_Info.alDiscountFamily[row]
            return family.strDiscountName
    
        case 3:
            
            let social = CaApp.m_Info.alDiscountSocial[row]
            return social.strDiscountName
            
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 2:
            let family = CaApp.m_Info.alDiscountFamily[row]
            nDiscountFamily = row
            textDiscountFamily.text = family.strDiscountName
            textDiscountFamily.resignFirstResponder()
        case 3:
            let social = CaApp.m_Info.alDiscountSocial[row]
            nDiscountSocial = row
            textDiscountSocial.text = social.strDiscountName
            textDiscountSocial.resignFirstResponder()
            
        default:
            print("Data Not found")
            
        }
    }

}

//table view setting
extension ViewControllerSettings: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApp.m_Info.alFamily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "FamilyCell", for: indexPath) as! FamilyCell
        let Family = CaApp.m_Info.alFamily[indexPath.row]
        
        if Family.strLastLogin != "" {
            let dtTimeUpdate: Date = CaApp.m_Info.dfStd.date(from: Family.strLastLogin)!
            myCell.cellLoginDate.text = CaApp.m_Info.dfMMddHHmmss.string(from: dtTimeUpdate)
        }
        else {
            myCell.cellLoginDate.text = ""
        }
        
        myCell.cellName.text = Family.strName
        myCell.cellPhone.text = Family.strPhone
        myCell.cellCancelBtn.layer.cornerRadius = 10
    
        if !CaApp.m_Info.bMainMember {
            myCell.cellCancelBtn.isHidden = true
        }
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
        let Family = CaApp.m_Info.alFamily[indexPath.row]
        
        processAckCancel(Family.nSeqMember, Family.strName)

    }
    
}

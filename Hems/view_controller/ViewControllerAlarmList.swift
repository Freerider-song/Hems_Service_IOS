//
//  ViewControllerAlarmList.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import UIKit

class AlarmCell : UITableViewCell {
    @IBOutlet var ivNew: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblContent: UILabel!
    @IBOutlet var lblTimeCreated: UILabel!
    @IBOutlet var lblAckResponse: UILabel!
}

class ViewControllerAlarmList: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tvAlarm: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvAlarm.delegate = self
        tvAlarm.dataSource = self
        
        //tvAlarm.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApp.m_Info.alAlarm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        
        let alarm = CaApp.m_Info.alAlarm[indexPath.row]
        
        myCell.contentView.backgroundColor = UIColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        myCell.layer.backgroundColor = CGColor(red: 18/255, green: 189/255, blue: 195/255, alpha: 1)
        
        myCell.lblTitle.text = alarm.strTitle
        myCell.lblContent.text = alarm.strContent
        myCell.lblTimeCreated.text = alarm.strDateCreated
        
        if alarm.bRead {
            myCell.ivNew.isHidden = true
        }
        else {
            myCell.ivNew.isHidden = false
        }
        
        if alarm.isRequestAck() {
            switch (alarm.nResponse) {
            case 0:
                myCell.lblAckResponse.text = "승인 대기중"
                
            case 1:
                myCell.lblAckResponse.text = "승인함"
                
            case 2:
                myCell.lblAckResponse.text = "거절함"
                
            default:
                myCell.lblAckResponse.text = "미정"
            }
            
            myCell.lblAckResponse.isHidden = false
        }
        else {
            myCell.lblAckResponse.isHidden = true
        }
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        let alarm = CaApp.m_Info.alAlarm[indexPath.row]
        
        alarm.bRead = true
        alarm.bReadStateChanged = true
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        alarm.dtRead = dateFormatter.string(from: now)
        setAlarmReadStateToDb()
        tableView.reloadData()
        
        if alarm.isRequestAck() && alarm.nResponse == 0 {
            // alert
            
            let msg = UIAlertController(title: "\(alarm.strTitle)", message: "\(alarm.strContent)", preferredStyle: .alert)
                    
                    //Alert에 부여할 Yes이벤트 선언
                    let YES = UIAlertAction(title: "승인", style: .default, handler: { (action) -> Void in
                        CaApp.m_Engine.ResponseAckMember(alarm.nSeqMemberAckRequester, 1, true, self)
                    })
                    
                    //Alert에 부여할 No이벤트 선언
                    let NO = UIAlertAction(title: "거절", style: .default, handler: { (action) -> Void in
                        CaApp.m_Engine.ResponseAckMember(alarm.nSeqMemberAckRequester, 2, true, self)
                    })
                    
                    //Alert에 이벤트 연결
                    msg.addAction(YES)
                    msg.addAction(NO)

                    //Alert 호출
                    self.present(msg, animated: true, completion: nil)
        }
        else {
            
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view = storyboard.instantiateViewController(identifier: "ViewControllerPopUpAlarm") as? ViewControllerPopUpAlarm
            view?.strTitle = alarm.strTitle
            view?.strContent = alarm.strContent
            view?.nAckResponse = alarm.nResponse
            view?.modalPresentationStyle = .overCurrentContext
            self.present(view!, animated: false, completion: nil)
        }
    }
    
    //tableview cell 높이 자동 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func btnMain(_ sender: UIButton) {
        print("main button clicked...")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        print("menu button clicked...")
    }
    
    func setAlarmReadStateToDb() {
        let strSeqAlarmList = CaApp.m_Info.getAlarmReadListString()
        
        print("alarm read list = \(strSeqAlarmList)")
        
        if !strSeqAlarmList.isEmpty {
            CaApp.m_Engine.SetAlarmListAsRead(CaApp.m_Info.nSeqMember, strSeqAlarmList, false, self)
        }
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_RESPONSE_ACK_MEMBER:
            print("Result of ResponseAckMember Received...")
            let jo:[String:Any] = Result.JSONResult
                
            let nResultCode = jo["result_code"] as! Int
            if nResultCode == 1 {
                let nAckType = jo["ack_type"] as! Int// 1=승인 2=거절 3= 철회
                let nSeqMemberSub = jo["seq_member_sub"] as! Int
                let strNameSub = jo["name_sub"] as! String
                let strPhoneSub = jo["phone_sub"] as! String
                    
                CaApp.m_Info.setResponseCodeForMemberSub(nSeqMemberSub, nAckType)
                    
                if nAckType == 1 {
                    let ca_family: CaFamily = CaFamily()
                    ca_family.nSeqMember = nSeqMemberSub
                    ca_family.strName = strNameSub
                    ca_family.strPhone = strPhoneSub
                    ca_family.bMain = false
                        
                    CaApp.m_Info.alFamily.append(ca_family)
                }
            }
            
        case CaApp.m_Engine.API_SET_ALARM_LIST_AS_READ:
            print("Result of SetAlarmListAsRead Received...")
            let jo:[String:Any] = Result.JSONResult
            let result = jo["result_code"] as! Int
            print("result is \(result)")
            
        default:
            print("Unknown type result received : \(Result.callback)")
        }
    }
    
}

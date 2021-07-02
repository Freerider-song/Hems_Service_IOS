//
//  ViewControllerNoticeList.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import UIKit

class NoticeCell : UITableViewCell {
    @IBOutlet var ivNew: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTimeCreated: UILabel!
}

class ViewControllerNoticeList: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tvNotice: UITableView!
    
    var dataArray:Array<[String:Any]> = []
    
    var dtCreatedMax = Int(CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtNoticeCreatedMaxForNextRequest!))
 
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvNotice.delegate = self
        tvNotice.dataSource = self
        
       // tvNotice.layer.cornerRadius = 10
    }
    
    //색션의 row 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApp.m_Info.alNotice.count
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell
        
        let notice = CaApp.m_Info.alNotice[indexPath.row]
        
        myCell.lblTitle?.text = notice.strTitle
        myCell.lblTimeCreated.text = notice.strDateCreated
       
        if notice.bRead {
            myCell.ivNew.isHidden = true
        }
        else {
            myCell.ivNew.isHidden = false
        }
        
        if notice.bTop == true {
            myCell.contentView.layer.backgroundColor = UIColor(named: "hems_gray")?.cgColor
        }
        else {
           // myCell.contentView.layer.borderWidth = 0
        }
  
        return myCell
    }
    
    //셀 선택했을시 notice로 넘어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "ViewControllerNotice") as? ViewControllerNotice
        
        let notice = CaApp.m_Info.alNotice[indexPath.row]
        
        // CaInfo에 있는 정보까지 수정이 되는 건지는 모르겠다. check필요
        notice.bRead = true
        notice.bReadStateChanged = true
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        notice.dtRead = dateFormatter.string(from: now)
        setNoticeReadStateToDb()
        tableView.reloadData()
      
        //noticeViewController로 정보 전달
        view?.strTitle = notice.strTitle
        view?.strContent = notice.strContent
        view?.strCreated = notice.strDateCreated
        
        //화면전환
        view?.modalPresentationStyle = .fullScreen
        self.present(view!, animated: true, completion: nil)
        
    }
    //추가 데이터 로드
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
        {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = tvNotice.contentSize.height - 1
            
            if offsetY > contentHeight - scrollView.frame.height
            {
                if !fetchingMore
                {   print("fetch more")
                    fetchingMore = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        //var dtCreatedMax = Int(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!))
                            let strTimeMax = CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtNoticeCreatedMaxForNextRequest!)
                            print("strTimeMax=\(strTimeMax)")
                                                    //self.getNoticeList(Int(CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtNoticeCreatedMaxForNextRequest!))!, 10, false)
                            //self.getNoticeList(Int(strTimeMax)!, 10, false)
                            CaApp.m_Engine.GetNoticeList(CaApp.m_Info.nSeqMember, strTimeMax, 10, false, self)
                        if self.dataArray.isEmpty {
                            self.fetchingMore = true
                        }
                        self.fetchingMore = false
                        self.tvNotice.reloadData()
        
                    })
                        
                    }
                    
            }
  
        }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setNoticeReadStateToDb() {
        let strSeqNoticeList = CaApp.m_Info.getNoticeReadListString()
        
        if strSeqNoticeList.isEmpty {
            return
        }
        else {
            CaApp.m_Engine.SetNoticeListAsRead(CaApp.m_Info.nSeqMember, strSeqNoticeList, false, self)
        }
    }
    
    /*
    func getNoticeList(_ timeCreatedMax: Int, _ countNotice: Int, _ bShowWaitDialog:Bool) {
   //     CaApp.m_Engine.GetNoticeList(CaApp.m_Info.nSeqMember, timeCreatedMax, countNotice, bShowWaitDialog, self)
    }
    */
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_GET_NOTICE_LIST:
            print("Result of API_GET_NOTICE_LIST received...")
            
            let jo:[String:Any] = Result.JSONResult
            
            dataArray = jo["notice_list"] as! Array<[String:Any]>
            
            if jo["notice_top_list"] != nil || jo["notice_list"] != nil {
                CaApp.m_Info.setNoticeList(jo["notice_top_list"] as! Array<[String:Any]>, jo["notice_list"] as! Array<[String:Any]>)
            }
        
        case CaApp.m_Engine.API_SET_NOTICE_LIST_AS_READ:
            print("Result of API_SET_NOTICE_LIST_AS_READ received...")
            
        default:
            print("Default!")
        }
    }
    
    @IBAction func btnMain(_ sender: UIButton) {
        print("main button clicked...")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    
    @IBAction func btnMenu(_ sender: Any) {
    }
}

//
//  ViewControllerDemandResponse.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/07/02.
//

import UIKit

class DrCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTimeCreated: UILabel!
    @IBOutlet weak var lblKwh: UILabel!
    @IBOutlet weak var lblTimeBeginEnd: UILabel!
    @IBOutlet weak var ivNew: UIImageView!
}

class ViewControllerDemandResponse: CustomUIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tvDr: UITableView!
    
    
    var dataArray:Array<[String:Any]> = []
    
    var dtCreatedMax = Int(CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtDrCreatedMaxForNextRequest!))
 
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDr.delegate = self
        tvDr.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CaApp.m_Info.alDr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "DrCell", for: indexPath) as! DrCell
        
        let dr = CaApp.m_Info.alDr[indexPath.row]
        
        Cell.lblTitle.text = dr.strTitle
        Cell.lblTimeCreated.text = dr.strDateCreated
        Cell.lblContent.text = dr.strContent
        Cell.lblKwh.text = String(format: "0.1f",dr.dKwh)
        
        let dtBegin: Date = CaApp.m_Info.dfStd.date(from: dr.strDateBegin)!
        let dtEnd: Date = CaApp.m_Info.dfStd.date(from: dr.strDateEnd)!
        Cell.lblTimeBeginEnd.text = "▶ 감축기간: \(CaApp.m_Info.dfMMddHHmm.string(from:dtBegin)) ~ \(CaApp.m_Info.dfMMddHHmm.string(from:dtEnd))"
        
        return Cell
    }
    
    //셀 선택했을시 notice로 넘어가기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //선택된 셀 음영 제거
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "ViewControllerPopUpDr") as? ViewControllerPopUpDr
        
        let dr = CaApp.m_Info.alDr[indexPath.row]
        
        // CaInfo에 있는 정보까지 수정이 되는 건지는 모르겠다. check필요
        dr.bRead = true
        dr.bReadStateChanged = true
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dr.strDateRead = dateFormatter.string(from: now)
        setNoticeReadStateToDb()
        tableView.reloadData()
      
        //noticeViewController로 정보 전달
        view?.strTitle = dr.strTitle
        view?.strContent = dr.strContent
        view?.dKwh = dr.dKwh
    
        view?.strBegin = dr.strDateBegin
        view?.strEnd = dr.strDateEnd
        
       
        //화면전환
        view?.modalPresentationStyle = .overCurrentContext
        self.present(view!, animated: false, completion: nil)
        
    }
    
    //추가 데이터 로드
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
        {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = tvDr.contentSize.height - 1
            
            if offsetY > contentHeight - scrollView.frame.height
            {
                if !fetchingMore
                {   print("fetch more")
                    fetchingMore = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        //var dtCreatedMax = Int(CaApplication.m_Info.dfyyyyMMddHHmmss.string(from: CaApplication.m_Info.dtNoticeCreatedMaxForNextRequest!))
                            let strTimeMax = CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtDrCreatedMaxForNextRequest!)
                            print("strTimeMax=\(strTimeMax)")
                                                    //self.getNoticeList(Int(CaApp.m_Info.dfyyyyMMddHHmmss.string(from: CaApp.m_Info.dtNoticeCreatedMaxForNextRequest!))!, 10, false)
                            //self.getNoticeList(Int(strTimeMax)!, 10, false)
                            CaApp.m_Engine.GetDrList(CaApp.m_Info.nSeqMember, strTimeMax, 10, false, self)
                        if self.dataArray.isEmpty {
                            self.fetchingMore = true
                        }
                        self.fetchingMore = false
                        self.tvDr.reloadData()
        
                    })
                        
                    }
                    
            }
  
        }
    

    func setNoticeReadStateToDb() {
        let strSeqDrList = CaApp.m_Info.getNoticeReadListString()
        
        if strSeqDrList.isEmpty {
            return
        }
        else {
            CaApp.m_Engine.SetDrListAsRead(CaApp.m_Info.nSeqMember, strSeqDrList, false, self)
        }
    }

    //여기 다시해야댐!
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_GET_DR_LIST:
            print("Result of API_GET_DR_LIST received...")
            
            let jo:[String:Any] = Result.JSONResult
            
            dataArray = jo["dr_list"] as! Array<[String:Any]>
            
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
        let storyboard = UIStoryboard(name: "Main",bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    


}

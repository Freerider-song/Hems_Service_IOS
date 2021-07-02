//
//  ViewControllerSideMenu.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/22.
//

import UIKit

class ViewControllerSideMenu: UIViewController {

    @IBOutlet var lblApt: UILabel!
    @IBOutlet var lblDongHo: UILabel!
    @IBOutlet var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblApt.text = CaApp.m_Info.strSiteName
        lblDongHo.text = CaApp.m_Info.strAptDongName + "동 " + CaApp.m_Info.strAptHoName + "호"
        lblName.text = CaApp.m_Info.strMemberName + " 님"
        // Do any additional setup after loading the view.
    }
    
    // Navigation bar 숨김
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onMain(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onUsageDay(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerUsageDay")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onUsageWeek(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerUsageWeek")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onUsageMonth(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerUsageMonth")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onUsageYear(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerUsageYear")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onAlarmList(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerAlarmList")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onNoticeList(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerNoticeList")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerSettings")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
    @IBAction func onLogOut(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpLogOut")
        view.modalPresentationStyle = .overFullScreen
        self.present(view, animated: false, completion: nil)
    }
    
    
}

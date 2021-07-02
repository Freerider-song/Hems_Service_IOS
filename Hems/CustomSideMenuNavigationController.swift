//
//  CustomSideMenuNavigationController.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/22.
//

import Foundation
import SideMenu

class CustomSideMenuNavigationController: SideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메뉴 띄울 때 View 옆으로 밀리지 않게
        self.presentationStyle = .menuSlideIn
        // 메뉴 왼쪽에서 나오게
        self.leftSide = true
        // 메뉴가 화면의 80%만큼 차지하게
        self.menuWidth = self.view.frame.width * 0.8
    }
}

//
//  CaEnergy.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import Foundation

public class CaEnergy {
    public var m_strName: String = ""
    public var m_strFileNameActive1: String = ""
    public var m_strFileNameActive2: String = ""
    public var m_strFileNameActive3: String = ""
    public var m_strFileNameInactive1: String = ""
    public var m_strFileNameInactive2: String = ""
    public var m_strFileNameInactive3: String = ""
    
    public var m_nLevel: Int = 1 // 1=blue, 2=gray, 3=red
    public var m_dUsageCurr: Double = 0.0
    public var m_dWonCurr: Double = 0.0
    public var m_dUsageExpected: Double = 0.0
    public var m_dWonExpected: Double = 0.0
    public var m_nReadDay: Int = 1
}

//
//  CaAlarm.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation

public class CaAlarm {
    
    public var nSeqAlarm: Int = 0
    public var nAlarmType: Int = m_GlobalEngine.ALARM_TYPE_UNKNOWN
    public var nSeqMemberAckRequester: Int = 0
    public var nResponse: Int = 1
    public var strTitle: String = ""
    public var strContent: String = ""
    
    public var strDateCreated: String = ""
    public var dtRead: String = ""
    public var bRead: Bool = true
    
    public var bReadStateChanged: Bool = false
    
    public func isRequestAck() -> Bool {
        return nAlarmType == m_GlobalEngine.ALARM_TYPE_REQUEST_ACK_MEMBER
    }
    
    /*public func getTimeCreated() -> String {
        if dtCreated == nil {return ""}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtCreated!)
    }*/
}

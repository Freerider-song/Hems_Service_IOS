//
//  CaNotice.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation

public class CaNotice{
    
    public var nSeqNotice: Int = 0
    public var strTitle: String = ""
    public var strContent: String = ""
    public var bTop: Bool = false
    
    //public var dtCreated: Date? = nil
    public var strDateCreated: String = ""
    public var dtRead: String = ""
    public var bRead: Bool = false
    
    public var bReadStateChanged: Bool = false
    
    /*public func getTimeCreated() -> String {
        if dtCreated == nil {return "날짜없음"}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtCreated!)
    }*/
    
}

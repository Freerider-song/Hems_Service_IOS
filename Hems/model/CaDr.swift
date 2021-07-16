//
//  CaDr.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/07/16.
//

import Foundation

public class CaDr {
    public var nSeqDr: Int = 0
    public var strTitle: String = ""
    public var strContent: String = ""
    public var dKwh : Double = 0.0

    //public var dtCreated: Date? = nil
    public var strDateCreated: String = ""
    public var strDateBegin: String = ""
    public var strDateEnd: String = ""
    public var strDateRead: String = ""
    public var bRead: Bool = false

    public var bReadStateChanged: Bool = false

    /*public func getTimeCreated() -> String {
        if dtCreated == nil {return "날짜없음"}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateformatter.string(from: dtCreated!)
    }*/
}

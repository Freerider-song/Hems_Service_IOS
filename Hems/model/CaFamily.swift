//
//  CaFamily.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation

public class CaFamily {
    public var nSeqMember: Int = 0
    public var bMain: Bool = false
    public var strName: String = ""
    public var strPhone: String = ""
    public var strLastLogin: String = ""
    
    /*public func getLastLogin() -> String {
        if strLastLogin == nil {return ""}
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd HH:mm:ss"
        
        return dateformatter.string(from: strLastLogin!)
    }*/
}

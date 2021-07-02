//
//  CaPref.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation

public class CaPref {
    
    public func setValue (_ key:String, _ value:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func getValue (_ key:String, _ dftValue:String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? dftValue
    }
}

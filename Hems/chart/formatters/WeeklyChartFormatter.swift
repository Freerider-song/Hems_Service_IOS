//
//  WeeklyChartFormatter.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/22.
//


import UIKit
import Foundation
import Charts

@objc(WeeklyChartFormatter)
public class WeeklyChartFormatter: NSObject, IAxisValueFormatter{
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch (value) {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return ""
        }

        
    }
}

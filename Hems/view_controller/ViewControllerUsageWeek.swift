//
//  ViewControllerUsageWeek.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import UIKit
import Charts

class ViewControllerUsageWeek: CustomUIViewController {

    @IBOutlet var textDate: UITextField!
    
    @IBOutlet var ivEnergyType: UIImageView!
    @IBOutlet var lblEnergyName: UILabel!
    
    @IBOutlet var m_ChartUsage: LineChartView!
    @IBOutlet var m_ChartWon: LineChartView!
    @IBOutlet var lblUsageTotalCurr: UILabel!
    @IBOutlet var lblUsageTotalDelta: UILabel!
    @IBOutlet var lblWonTotalCurr: UILabel!
    @IBOutlet var lblWonTotalDelta: UILabel!
    
    var m_strUsageUnit: String = " kWh"
    
    let m_DatePicker = UIDatePicker()
    
    var m_data:[String:Any] = [:]
    var m_dataArray:Array<[String:Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ivEnergyType.image=UIImage(named: CaApp.m_Info.m_EnergyManager.getFileName())
        lblEnergyName.text=CaApp.m_Info.m_EnergyManager.getName()
        if CaApp.m_Info.m_EnergyManager.m_nActiveIndex != 0 {
                m_strUsageUnit = " m3"
        }
        
        initDatePicker()
        initChartUsage()
        initChartWon()
        
        let date = Date()
        let cal = Calendar.current
    
        textDate.text = CaApp.m_Info.dfyyyyMMStd.string(from: date)
        
        let nYear = cal.component(.year, from: date)
        let nMonth = cal.component(.month, from: date)

        getUsageListWeekly(nYear, nMonth, false)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnMain(_ sender: UIButton) {
        
        print("main button clicked...")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
    }
    
    func getUsageListWeekly(_ nYear: Int, _ nMonth: Int, _ bShowWaitDialog: Bool) {
        let nEnergyType = CaApp.m_Info.m_EnergyManager.m_nActiveIndex
        switch (nEnergyType) {
        case 0:
            CaApp.m_Engine.GetUsageListWeeklyElec(CaApp.m_Info.nSeqAptHo, nYear, nMonth, bShowWaitDialog, self)

        case 1:
            CaApp.m_Engine.GetUsageListWeeklyWater(CaApp.m_Info.nSeqAptHo, nYear, nMonth, bShowWaitDialog, self)
            
        case 2:
            CaApp.m_Engine.GetUsageListWeeklyGas(CaApp.m_Info.nSeqAptHo, nYear, nMonth, bShowWaitDialog, self)
            
        case 3:
            CaApp.m_Engine.GetUsageListWeeklyHeat(CaApp.m_Info.nSeqAptHo, nYear, nMonth, bShowWaitDialog, self)
            
        case 4:
            CaApp.m_Engine.GetUsageListWeeklySteam(CaApp.m_Info.nSeqAptHo, nYear, nMonth, bShowWaitDialog, self)
            
        default:
            print("unknown energy type : \(nEnergyType)")
        }
        
    }
    
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_GET_USAGE_LIST_WEEKLY_ELEC,
             CaApp.m_Engine.API_GET_USAGE_LIST_WEEKLY_WATER,
             CaApp.m_Engine.API_GET_USAGE_LIST_WEEKLY_GAS,
             CaApp.m_Engine.API_GET_USAGE_LIST_WEEKLY_HEAT,
             CaApp.m_Engine.API_GET_USAGE_LIST_WEEKLY_STEAM:
            m_data = Result.JSONResult
            m_dataArray = m_data["list_usage"] as! Array<[String:Any]>
                
            fillChartUsage()
            fillChartWon()
            
            fillUsageSummary()

            default:
                print("Default!")
        }
    }
    
    func initDatePicker(){
        //Formate Date
        m_DatePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            m_DatePicker.preferredDatePickerStyle = .wheels
        }
        
        m_DatePicker.locale = Locale(identifier: "ko")
        m_DatePicker.backgroundColor = UIColor.white
        m_DatePicker.maximumDate = Date()
        //Minimum date = 2000/01/01
        let dateMinString: String = "20190101"
        let dateMin: Date = CaApp.m_Info.dfyyyyMMdd.date(from: dateMinString)!
        m_DatePicker.minimumDate = dateMin
        
       //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerDone));
        let btnSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancel));

        toolbar.setItems([btnDone, btnSpace, btnCancel], animated: false)
        
        textDate.inputAccessoryView = toolbar
        textDate.inputView = m_DatePicker
    }
    
    @objc func datePickerDone(){

        textDate.text = CaApp.m_Info.dfyyyyMMStd.string(from: m_DatePicker.date)
        
        self.view.endEditing(true)
        
        let cal = Calendar.current
        
        let nYear = cal.component(.year, from: m_DatePicker.date)
        let nMonth = cal.component(.month, from: m_DatePicker.date)

        getUsageListWeekly(nYear, nMonth, true)
    }

    @objc func datePickerCancel(){
        self.view.endEditing(true)
    }
 
    func initChartUsage() {
        m_ChartUsage.doubleTapToZoomEnabled = false
        m_ChartUsage.pinchZoomEnabled = false
        m_ChartUsage.drawBordersEnabled = false
        
        // x축 값
        let xAxis = m_ChartUsage.xAxis
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = m_ChartUsage.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = m_ChartUsage.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        
        let l = m_ChartUsage.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        m_ChartUsage.rightAxis.enabled = false
    }
    
    func initChartWon() {
        m_ChartWon.doubleTapToZoomEnabled = false
        m_ChartWon.pinchZoomEnabled = false
        m_ChartWon.drawBordersEnabled = false
        
        // x축 값
        let xAxis = m_ChartWon.xAxis
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = m_ChartWon.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = m_ChartWon.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        
        let l = m_ChartWon.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        m_ChartWon.rightAxis.enabled = false
    }
    
    func fillChartUsage() {
        
        var currDataEntry: [ChartDataEntry] = []
        
        for data in m_dataArray {
            let dx = Double(data["unit"]! as! Int)
            let dy = Double(data["usage_curr"]! as! Double)
            
            print("x=\(dx), y=\(dy)")
            
            let currData = ChartDataEntry(x: dx, y: dy)
            
            currDataEntry.append(currData)
            
            let leftAxisFormatter = NumberFormatter()
            leftAxisFormatter.positiveSuffix = " kWh"
            leftAxisFormatter.numberStyle = .decimal
            
            m_ChartUsage.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        }
        
        m_ChartUsage.xAxis.setLabelCount(m_dataArray.count, force: true)
        
        let curr = LineChartDataSet(entries: currDataEntry, label: "조회일")
        
        curr.setColor(UIColor(named: "hems_brown")!)
        curr.drawCirclesEnabled = true
        curr.lineWidth = 2
        curr.setCircleColor(UIColor(named: "hems_brown")!)
        
        let chartData = LineChartData(dataSets: [curr])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        // X축 간격
        m_ChartUsage.xAxis.granularity = m_ChartUsage.xAxis.axisMaximum / Double(m_dataArray.count)
        m_ChartUsage.xAxis.granularityEnabled = true
        m_ChartUsage.xAxis.labelCount = m_dataArray.count
        
        // X축 Label
        let frm:WeeklyChartFormatter = WeeklyChartFormatter()
        m_ChartUsage.xAxis.valueFormatter = frm
        
        m_ChartUsage.animate(yAxisDuration: 2.0)
        m_ChartUsage.xAxis.axisMinimum = 0.0
        
        m_ChartUsage.data = chartData
    }
    
    func fillChartWon() {
        var currDataEntry: [ChartDataEntry] = []
        
        for data in m_dataArray {
            let dx = Double(data["unit"]! as! Int)
            let dy = Double(data["won_curr"]! as! Double)
            
            print("x=\(dx), y=\(dy)")
            
            let currData = ChartDataEntry(x: dx, y: round(dy))
            
            currDataEntry.append(currData)
            
            let leftAxisFormatter = NumberFormatter()
            leftAxisFormatter.positiveSuffix = " 원"
            leftAxisFormatter.numberStyle = .decimal
            
            m_ChartWon.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        }
        
        m_ChartWon.xAxis.setLabelCount(m_dataArray.count, force: true)
        
        let curr = LineChartDataSet(entries: currDataEntry, label: "조회일")
        
        curr.setColor(UIColor(named: "hems_brown")!)
        curr.drawCirclesEnabled = true
        curr.lineWidth = 2
        curr.setCircleColor(UIColor(named: "hems_brown")!)
        
        let chartData = LineChartData(dataSets: [curr])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        // X축 간격
        m_ChartWon.xAxis.granularity = m_ChartUsage.xAxis.axisMaximum / Double(m_dataArray.count)
        m_ChartWon.xAxis.granularityEnabled = true
        m_ChartWon.xAxis.labelCount = m_dataArray.count
        
        // X축 Label
        let frm:WeeklyChartFormatter = WeeklyChartFormatter()
        m_ChartWon.xAxis.valueFormatter = frm
        
        m_ChartWon.animate(yAxisDuration: 2.0)
        m_ChartWon.xAxis.axisMinimum = 0.0
        
        m_ChartWon.data = chartData
    }

    func fillUsageSummary() {
        let dUsageTotalCurr = m_data["total_usage_curr"]! as! Double
        let dUsageTotalPrev = m_data["total_usage_prev"]! as! Double
        let dWonTotalCurr = m_data["total_won_curr"]! as! Double
        let dWonTotalPrev = m_data["total_won_prev"]! as! Double
        
        lblUsageTotalCurr.text = String(format: "%.1f", dUsageTotalCurr) + m_strUsageUnit
        lblWonTotalCurr.text = CaInfo.fmt0(value: dWonTotalCurr) + " 원"
        
        let dDeltaUsage:Double = (dUsageTotalCurr-dUsageTotalPrev)
        let dDeltaWon:Double = (dWonTotalCurr-dWonTotalPrev)
        
        if dDeltaUsage < 0 {
            lblUsageTotalDelta.textColor = .blue
        }
        else {
            lblUsageTotalDelta.textColor = .red
        }

        lblUsageTotalDelta.text = String(format: "%.1f", dDeltaUsage) + m_strUsageUnit
        
        if dDeltaWon < 0 {
            lblWonTotalDelta.textColor = .blue
        } else {
            lblWonTotalDelta.textColor = .red
        }
        
        lblWonTotalDelta.text = String(format: "%.1f", dDeltaWon) + " 원"
    }
}

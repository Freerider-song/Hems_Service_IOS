//
//  ViewControllerUsageDay.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import UIKit
import Charts

class ViewControllerUsageDay: CustomUIViewController {

    @IBOutlet var ivEnergyType: UIImageView!
    @IBOutlet var lblEnergyName: UILabel!
    
    @IBOutlet var textDate: UITextField!
    
    @IBOutlet var btnShowUsage: UIButton!
    @IBOutlet var btnShowWon: UIButton!
    
    @IBOutlet var m_Chart: HorizontalBarChartView!
    
    @IBOutlet var lblUsageTotalCurr: UILabel!
    @IBOutlet var lblUsageTotalDelta: UILabel!
    @IBOutlet var lblWonTotalCurr: UILabel!
    @IBOutlet var lblWonTotalDelta: UILabel!
    
    var m_strUsageUnit: String = " kWh"
    var m_bShowUsage = true
    
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
        
        print("togdog UsageDay viewDidLoad")
        
        initChart()
        
        let date = Date()
        let cal = Calendar.current
    
        textDate.text = CaApp.m_Info.dfyyyyMMddStd.string(from: date)
        
        let nYear = cal.component(.year, from: date)
        let nMonth = cal.component(.month, from: date)
        let nDay = cal.component(.day, from: date)

        getUsageListDaily(nYear, nMonth, nDay, false)
    }
    
    func getUsageListDaily(_ nYear: Int, _ nMonth: Int, _ nDay: Int, _ bShowWaitDialog: Bool) {
        let nEnergyType = CaApp.m_Info.m_EnergyManager.m_nActiveIndex
        switch (nEnergyType) {
        case 0:
            CaApp.m_Engine.GetUsageListDailyElec(CaApp.m_Info.nSeqAptHo, nYear, nMonth, nDay, bShowWaitDialog, self)

        case 1:
            CaApp.m_Engine.GetUsageListDailyWater(CaApp.m_Info.nSeqAptHo, nYear, nMonth, nDay, bShowWaitDialog, self)
            
        case 2:
            CaApp.m_Engine.GetUsageListDailyGas(CaApp.m_Info.nSeqAptHo, nYear, nMonth, nDay, bShowWaitDialog, self)
            
        case 3:
            CaApp.m_Engine.GetUsageListDailyHeat(CaApp.m_Info.nSeqAptHo, nYear, nMonth, nDay, bShowWaitDialog, self)
            
        case 4:
            CaApp.m_Engine.GetUsageListDailySteam(CaApp.m_Info.nSeqAptHo, nYear, nMonth, nDay, bShowWaitDialog, self)
            
        default:
            print("unknown energy type : \(nEnergyType)")
        }
        
    }
    
    func initChart() {
        // Zoom 안 되게
        m_Chart.doubleTapToZoomEnabled = false
        m_Chart.pinchZoomEnabled = false
        m_Chart.drawBarShadowEnabled = false

        // Marker 설정
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = m_Chart
        marker.minimumSize = CGSize(width: 80, height: 40)
        m_Chart.marker = marker
        m_Chart.backgroundColor = .white
        
        // x축 값
        let xAxis = m_Chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        
        // y축 값
        let leftAxis = m_Chart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = m_Chart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        let l = m_Chart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4

        m_Chart.fitBars = true
        m_Chart.rightAxis.enabled = false
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
 
    override func onResult(_ Result: CaResult) {
        switch Result.callback {
        case CaApp.m_Engine.API_GET_USAGE_LIST_DAILY_ELEC,
             CaApp.m_Engine.API_GET_USAGE_LIST_DAILY_WATER,
             CaApp.m_Engine.API_GET_USAGE_LIST_DAILY_GAS,
             CaApp.m_Engine.API_GET_USAGE_LIST_DAILY_HEAT,
             CaApp.m_Engine.API_GET_USAGE_LIST_DAILY_STEAM:
            m_data = Result.JSONResult
            m_dataArray = m_data["list_usage"] as! Array<[String:Any]>
                
            fillChart()
            fillUsageSummary()

            default:
                print("Default!")
        }
    }
    
    func fillChart() {
        
        // (barWidth + barSpace) * 2 + groupSpace = 1
        let groupSpace = 0.4
        let barSpace = 0.1
        let barWidth = 0.2
        
        var currDataEntry: [BarChartDataEntry] = []
        var prevDataEntry: [BarChartDataEntry] = []
        
        // x축 label
        let formatter:DailyChartFormatter = DailyChartFormatter()
        
        var reversedArray: Array<[String:Any]> = []
        
        // currDataEntry와 prevDataEntry에 데이터가 들어간 순서대로 Chart를 Draw함.
        // 근데 Chart를 Draw할 때, 아래에서 위로 Draw함. 왜 이렇게 만들었는지는 모르지만 우리는 위에서부터 0시~23시 순서로
        // Draw해야 하기에 Entry에 데이터를 넣는 순서를 바꿀 필요가 있음.
        // 마찬가지로, DailyChartFormatter가 "(24-i)시" 를 리턴하는 이유임
        for i in 0 ..< m_dataArray.count {
            reversedArray.append(m_dataArray[m_dataArray.count - (i+1)])
        }
        
        print(reversedArray.description)
        
        // 사용량 보여줄 때
        if m_bShowUsage {
            for data in reversedArray {
                // x에 23-unit해놨는데 그냥 unit도 상관없는 듯
                let currData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["usage_curr"]! as! Double)*1000)/1000)
                let prevData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["usage_prev"]! as! Double)*1000)/1000)
                
                currDataEntry.append(currData)
                prevDataEntry.append(prevData)
                
                // 단위 붙이기
                let leftAxisFormatter = NumberFormatter()
                
                leftAxisFormatter.positiveSuffix = m_strUsageUnit
                leftAxisFormatter.numberStyle = .decimal
                
                m_Chart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
            }
        }
        else {
            // 금액 보여줄 때
            for data in reversedArray {
                let currData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["won_curr"]! as! Double)*1000)/1000)
                let prevData = BarChartDataEntry(x: 23 - Double(data["unit"]! as! Int), y: round((data["won_prev"]! as! Double)*1000)/1000)
                
                currDataEntry.append(currData)
                prevDataEntry.append(prevData)
                
                let leftAxisFormatter = NumberFormatter()
                
                leftAxisFormatter.positiveSuffix = " 원"
                leftAxisFormatter.numberStyle = .decimal
                
                m_Chart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
            }
        }
        
        // 0시 ~ 24시 -> 25개. -> dataArray.count + 1
        m_Chart.xAxis.setLabelCount(m_dataArray.count+1, force: true)
        
        let curr = BarChartDataSet(entries: currDataEntry, label: "조회일")
        curr.setColor(UIColor(named: "hems_green")!)
        let prev = BarChartDataSet(entries: prevDataEntry, label: "조회전일")
        prev.setColor(UIColor(named: "hems_gray")!)
        
        let chartData = BarChartData(dataSets: [curr, prev])
        
        chartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        chartData.barWidth = barWidth
        
        // Data Grouping
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
        // X축 간격
        m_Chart.xAxis.granularity = m_Chart.xAxis.axisMaximum / Double(m_dataArray.count+1)
        m_Chart.xAxis.granularityEnabled = true
        m_Chart.xAxis.labelCount = m_dataArray.count+1
        // X축 Label
        m_Chart.xAxis.valueFormatter = formatter
        
        m_Chart.animate(yAxisDuration: 2.5)
        
        m_Chart.xAxis.axisMinimum = 0.0
        m_Chart.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(m_dataArray.count)
        
        m_Chart.data = chartData
        
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

        textDate.text = CaApp.m_Info.dfyyyyMMddStd.string(from: m_DatePicker.date)
        
        self.view.endEditing(true)
        
        let cal = Calendar.current
        
        let nYear = cal.component(.year, from: m_DatePicker.date)
        let nMonth = cal.component(.month, from: m_DatePicker.date)
        let nDay = cal.component(.day, from: m_DatePicker.date)

        getUsageListDaily(nYear, nMonth, nDay, true)
    }

    @objc func datePickerCancel(){
        self.view.endEditing(true)
    }
    
    @IBAction func onShowUsage(_ sender: UIButton) {
        if m_bShowUsage { return }
        
        m_bShowUsage = true
        btnShowUsage.setTitleColor(.white, for: .normal)
        btnShowWon.setTitleColor(.lightGray, for: .normal)

        fillChart()
    }
    
    @IBAction func onShowWon(_ sender: UIButton) {
        if !m_bShowUsage { return }
        
        m_bShowUsage = false
        btnShowUsage.setTitleColor(.lightGray, for: .normal)
        btnShowWon.setTitleColor(.white, for: .normal)

        fillChart()
    }
}

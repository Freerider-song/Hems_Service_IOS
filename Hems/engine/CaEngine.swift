//
//  CaEngine.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/16.
//

import Foundation

public class CaEngine
{
    public let API_CHECK_LOGIN: Int = 1001
    public let API_GET_MEMBER_INFO: Int = 1002
    public let API_GET_CURRENT_USAGE_ALL: Int = 1003
    public let API_GET_USAGE_LIST_DAILY_ELEC: Int = 1004
    public let API_GET_USAGE_LIST_DAILY_WATER: Int = 1005
    public let API_GET_USAGE_LIST_DAILY_GAS: Int = 1006
    public let API_GET_USAGE_LIST_DAILY_HEAT: Int = 1007
    public let API_GET_USAGE_LIST_DAILY_STEAM: Int = 1008
    public let API_GET_USAGE_LIST_WEEKLY_ELEC: Int = 1009
    public let API_GET_USAGE_LIST_WEEKLY_WATER: Int = 1010
    public let API_GET_USAGE_LIST_WEEKLY_GAS: Int = 1011
    public let API_GET_USAGE_LIST_WEEKLY_HEAT: Int = 1012
    public let API_GET_USAGE_LIST_WEEKLY_STEAM: Int = 1013
    public let API_GET_USAGE_LIST_MONTHLY_ELEC: Int = 1014
    public let API_GET_USAGE_LIST_MONTHLY_WATER: Int = 1015
    public let API_GET_USAGE_LIST_MONTHLY_GAS: Int = 1016
    public let API_GET_USAGE_LIST_MONTHLY_HEAT: Int = 1017
    public let API_GET_USAGE_LIST_MONTHLY_STEAM: Int = 1018
    public let API_GET_USAGE_LIST_YEARLY_ELEC: Int = 1019
    public let API_GET_USAGE_LIST_YEARLY_WATER: Int = 1020
    public let API_GET_USAGE_LIST_YEARLY_GAS: Int = 1021
    public let API_GET_USAGE_LIST_YEARLY_HEAT: Int = 1022
    public let API_GET_USAGE_LIST_YEARLY_STEAM: Int = 1023
    public let API_GET_SITE_LIST: Int = 1024
    public let API_GET_APT_DONG_LIST: Int = 1025
    public let API_GET_APT_HO_LIST: Int = 1026
    public let API_GET_MEMBER_CANDIDATE_INFO: Int = 1027
    public let API_REQUEST_AUTH_CODE: Int = 1028
    public let API_CHECK_AUTH_CODE: Int = 1029
    public let API_CREATE_MEMBER_MAIN: Int = 1030
    public let API_CREATE_MEMBER_SUB: Int = 1031
    public let API_REQUEST_ACK_MEMBER: Int = 1032
    public let API_RESPONSE_ACK_MEMBER: Int = 1033
    public let API_GET_ALARM_LIST: Int = 1034
    public let API_SET_ALARM_LIST_AS_READ: Int = 1035
    public let API_GET_UNREAD_ALARM_COUNT: Int = 1036
    public let API_GET_NOTICE_LIST: Int = 1037
    public let API_SET_NOTICE_LIST_AS_READ: Int = 1038
    public let API_GET_UNREAD_NOTICE_COUNT: Int = 1039
    public let API_CHANGE_PASSWORD: Int = 1040
    public let API_CHANGE_PASSWORD_BY_MEMBER_ID: Int = 1041
    public let API_CHANGE_MEMBER_SETTINGS: Int = 1042
    
    //Auth Type
    public let AUTH_TYPE_UNKNOWN: Int = 1000
    public let AUTH_TYPE_SUBSCRIBE: Int = 1001
    public let AUTH_TYPE_CHANGE_PASSWORD: Int = 1002
    
    //Alarm 정보
    public let ALARM_TYPE_UNKNOWN: Int = 0
    public let ALARM_TYPE_REQUEST_ACK_MEMBER = 1001
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_ACCEPTED = 1002
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_REJECTED = 1003
    public let ALARM_TYPE_RESPONSE_ACK_MEMBER_CANCELED = 1004
    public let ALARM_TYPE_NOTI_KWH = 1101
    public let ALARM_TYPE_NOTI_WON = 1102
    public let ALARM_TYPE_NOTI_PRICE_LEVEL = 1103
    public let ALARM_TYPE_NOTI_USAGE = 1104
    public let ALARM_TYPE_NOTI_TRANS = 1110
    
    //Pref 정보
    public let PREF_MEMBER_ID: String = "MEMBER_ID"
    public let PREF_PASSWORD: String = "PASSWORD"
    
    let NO_CMD_ARGS: Dictionary<String,Any> = [String:Any]()
    
    init() {
    }
    
    // ShowWaitDialog를 Root View가 아닌, 다른 View 띄우자마자 호출하면 View가 사라지는 문제가 있음
    // 따라서, View가 바로 호출될 때 실행되는 API (ex.GetUsageOfOneDay)는, 유동적으로 ShowWaitDialog를 호출해야 됨
    // View가 호출될 떄는 ShowWaitDialog를 False로, 이후 다시 호출될 떄는 True로 함
    func executeCommand(_ Arg: CaArg, _ nCallMethod: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        // nCallMethod: 어떤 api인지 알려주는 거
        let Task: CaTask = CaTask(Arg, nCallMethod, bShowWaitDialog, viewControl) //Catask api통신위해 만든 객체
        _ = Task.run() //서버와 연결
        //bshowwaitdialog 로딩중인 dialog을 보여주느냐 마느냐, true이면 api 통신중에 동그라미가 보임, 통신이 끝나면 동그라미가 사라지는데
        //그과정 다른 view까지 삭제됨. view를 띄우면서 api를 호출할땐 false, view를 띄우지 않고, 기존 뷰에서 업데이트만 할때는 새로고침하면 그대로 보여주면됨 true
    }
    
    func CheckLogin(_ strMemberId: String, _ strPassword: String, _ viewControl: AnyObject) {
        print("CaEngine: CheckLogin Called")
        
        let Arg = CaArg("CheckLogin", NO_CMD_ARGS)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
        Arg.addArg("DeviceId", CaApp.m_Info.strPushId)
       // Arg.addArg("DeviceId", "test_device_id")
        Arg.addArg("Os", "IOS")
        Arg.addArg("Version", 1911181)
        
        executeCommand(Arg, API_CHECK_LOGIN, true, viewControl)
    }
    
    func GetMemberInfo(_ nSeqMember: Int, _ viewControl: AnyObject) {
        print("CaEngine: GetMemberInfo Called")
        
        let Arg = CaArg("GetMemberInfo", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        
        executeCommand(Arg, API_GET_MEMBER_INFO, true, viewControl)
    }
    
    func GetCurrentUsageAll(_ nSeqHo: Int, _ strTo: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject){
        print("CaEngine: GetCurrentUsageAll Called : SeqHo=\(nSeqHo) To=\(strTo)")
        
        let Arg = CaArg("GetCurrentUsageAll", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("To", strTo)
        
        executeCommand(Arg, API_GET_CURRENT_USAGE_ALL, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListDailyElec(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListDailyElec Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth) Day=\(nDay)")
        
        let Arg = CaArg("GetUsageListDailyElec", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, API_GET_USAGE_LIST_DAILY_ELEC, bShowWaitDialog, viewControl)
    }

    func GetUsageListDailyWater(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListDailyWater Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth) Day=\(nDay)")
        
        let Arg = CaArg("GetUsageListDailyWater", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, API_GET_USAGE_LIST_DAILY_WATER, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListDailyGas(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListDailyGas Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth) Day=\(nDay)")
        
        let Arg = CaArg("GetUsageListDailyGas", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, API_GET_USAGE_LIST_DAILY_GAS, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListDailyHeat(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListDailyHeat Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth) Day=\(nDay)")
        
        let Arg = CaArg("GetUsageListDailyHeat", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, API_GET_USAGE_LIST_DAILY_HEAT, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListDailySteam(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int, _ nDay: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListDailySteam Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth) Day=\(nDay)")
        
        let Arg = CaArg("GetUsageListDailySteam", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        Arg.addArg("Day", nDay)
        
        executeCommand(Arg, API_GET_USAGE_LIST_DAILY_STEAM, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListWeeklyElec(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListWeeklyElec Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListWeeklyElec", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_WEEKLY_ELEC, bShowWaitDialog, viewControl)
    }

    func GetUsageListWeeklyWater(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListWeeklyWater Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListWeeklyWater", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_WEEKLY_WATER, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListWeeklyGas(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListWeeklyGas Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListWeeklyGas", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_WEEKLY_GAS, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListWeeklyHeat(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListWeeklyHeat Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListWeeklyHeat", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_WEEKLY_HEAT, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListWeeklySteam(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListWeeklySteam Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListWeeklySteam", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_WEEKLY_STEAM, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListMonthlyElec(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListMonthlyElec Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListMonthlyElec", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_MONTHLY_ELEC, bShowWaitDialog, viewControl)
    }

    func GetUsageListMonthlyWater(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListMonthlyWater Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListMonthlyWater", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_MONTHLY_WATER, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListMonthlyGas(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListMonthlyGas Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListMonthlyGas", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_MONTHLY_GAS, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListMonthlyHeat(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListMonthlyHeat Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListMonthlyHeat", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_MONTHLY_HEAT, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListMonthlySteam(_ nSeqHo: Int, _ nYear: Int, _ nMonth: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListMonthlySteam Called : SeqHo=\(nSeqHo) Year=\(nYear) Month=\(nMonth)")
        
        let Arg = CaArg("GetUsageListMonthlySteam", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        Arg.addArg("Month", nMonth)
        
        executeCommand(Arg, API_GET_USAGE_LIST_MONTHLY_STEAM, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListYearlyElec(_ nSeqHo: Int, _ nYear: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListYearlyElec Called : SeqHo=\(nSeqHo) Year=\(nYear)")
        
        let Arg = CaArg("GetUsageListYearlyElec", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, API_GET_USAGE_LIST_YEARLY_ELEC, bShowWaitDialog, viewControl)
    }

    func GetUsageListYearlyWater(_ nSeqHo: Int, _ nYear: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListYearlyWater Called : SeqHo=\(nSeqHo) Year=\(nYear)")
        
        let Arg = CaArg("GetUsageListYearlyWater", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, API_GET_USAGE_LIST_YEARLY_WATER, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListYearlyGas(_ nSeqHo: Int, _ nYear: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListYearlyGas Called : SeqHo=\(nSeqHo) Year=\(nYear)")
        
        let Arg = CaArg("GetUsageListYearlyGas", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, API_GET_USAGE_LIST_YEARLY_GAS, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListYearlyHeat(_ nSeqHo: Int, _ nYear: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListYearlyHeat Called : SeqHo=\(nSeqHo) Year=\(nYear)")
        
        let Arg = CaArg("GetUsageListYearlyHeat", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, API_GET_USAGE_LIST_YEARLY_HEAT, bShowWaitDialog, viewControl)
    }
    
    func GetUsageListYearlySteam(_ nSeqHo: Int, _ nYear: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUsageListYearlySteam Called : SeqHo=\(nSeqHo) Year=\(nYear)")
        
        let Arg = CaArg("GetUsageListYearlySteam", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Year", nYear)
        
        executeCommand(Arg, API_GET_USAGE_LIST_YEARLY_STEAM, bShowWaitDialog, viewControl)
    }
    
    func GetSiteList(_ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetSiteList Called :")
        
        let Arg = CaArg("GetSiteList", NO_CMD_ARGS)
        
        executeCommand(Arg, API_GET_SITE_LIST, bShowWaitDialog, viewControl)
    }

    func GetAptDongList(_ nSeqSite: Int,
                        _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetAptDongList Called : SeqSite=\(nSeqSite)")
        
        let Arg = CaArg("GetAptDongList", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        
        executeCommand(Arg, API_GET_APT_DONG_LIST, bShowWaitDialog, viewControl)
    }

    func GetAptHoList(_ nSeqSite: Int, _ nSeqDong: Int,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetAptHoList Called : SeqSite=\(nSeqSite) SeqDong=\(nSeqDong)")
        
        let Arg = CaArg("GetAptHoList", NO_CMD_ARGS)
        Arg.addArg("SeqSite", nSeqSite)
        Arg.addArg("SeqDong", nSeqDong)
        
        executeCommand(Arg, API_GET_APT_HO_LIST, bShowWaitDialog, viewControl)
    }
    
    func RequestAuthCode(_ strPhone: String,
                        _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: RequestAuthCode Called : Phone=\(strPhone)")
        
        let Arg = CaArg("RequestAuthCode", NO_CMD_ARGS)
        Arg.addArg("Phone", strPhone)
        
        executeCommand(Arg, API_REQUEST_AUTH_CODE, bShowWaitDialog, viewControl)
    }
    
    func CheckAuthCode(_ strPhone: String, _ nAuthCode: Int, _ nSecTimeLimit: Int,
                        _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: CheckAuthCode Called : Phone=\(strPhone) AuthCode=\(nAuthCode)  SecTimeLimit=\(nSecTimeLimit)")
        
        let Arg = CaArg("CheckAuthCode", NO_CMD_ARGS)
        Arg.addArg("Phone", strPhone)
        Arg.addArg("AuthCode", nAuthCode)
        Arg.addArg("SecTimeLimit", nSecTimeLimit)
        
        executeCommand(Arg, API_CHECK_AUTH_CODE, bShowWaitDialog, viewControl)
    }
    
    func GetMemberCandidateInfo(_ nSeqHo: Int, _ strName: String, _ strPhone: String,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetMemberCandidateInfo Called : SeqHo=\(nSeqHo) Name=\(strName) Phone=\(strPhone)")
        
        let Arg = CaArg("GetMemberCandidateInfo", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
        
        executeCommand(Arg, API_GET_MEMBER_CANDIDATE_INFO, bShowWaitDialog, viewControl)
    }
    
    func CreateMemberMain(_ nSeqHo: Int, _ strName: String, _ strPhone: String, _ strMemberId: String, _ strPassword: String,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: CreateMemberMain Called : SeqHo=\(nSeqHo) Name=\(strName) Phone=\(strPhone) MemberId=\(strMemberId) Password=\(strPassword)")
        
        let Arg = CaArg("CreateMemberMain", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
        
        executeCommand(Arg, API_CREATE_MEMBER_MAIN, bShowWaitDialog, viewControl)
    }
    
    func CreateMemberSub(_ nSeqHo: Int, _ strName: String, _ strPhone: String, _ strMemberId: String, _ strPassword: String,
                               _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: CreateMemberSub Called : SeqHo=\(nSeqHo) Name=\(strName) Phone=\(strPhone) MemberId=\(strMemberId) Password=\(strPassword)")
        
        let Arg = CaArg("CreateMemberSub", NO_CMD_ARGS)
        Arg.addArg("SeqHo", nSeqHo)
        Arg.addArg("Name", strName)
        Arg.addArg("Phone", strPhone)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("Password", strPassword)
        
        executeCommand(Arg, API_CREATE_MEMBER_SUB, bShowWaitDialog, viewControl)
    }

    func RequestAckMember(_ nSeqMemberAckRequester: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: RequestAckMember Called : SeqMemberAckRequester=\(nSeqMemberAckRequester)")
        
        let Arg = CaArg("RequestAckMember", NO_CMD_ARGS)
        Arg.addArg("SeqMemberAckRequester", nSeqMemberAckRequester)
        
        executeCommand(Arg, API_REQUEST_ACK_MEMBER, bShowWaitDialog, viewControl)
    }
    
    func ResponseAckMember(_ nSeqMemberSub: Int, _ nAck: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: ResponseAckMember Called : SeqMemberSub=\(nSeqMemberSub)")
        
        let Arg = CaArg("ResponseAckMember", NO_CMD_ARGS)
        Arg.addArg("SeqMemberSub", nSeqMemberSub)
        Arg.addArg("Ack", nAck)
        
        executeCommand(Arg, API_RESPONSE_ACK_MEMBER, bShowWaitDialog, viewControl)
    }

    func GetAlarmList(_ nSeqMember: Int, _ nCountMax: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetAlarmList Called : SeqMember=\(nSeqMember) CountMax=\(nCountMax)")
        
        let Arg = CaArg("GetAlarmList", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("CountMax", nCountMax)
        
        executeCommand(Arg, API_GET_ALARM_LIST, bShowWaitDialog, viewControl)
    }
    
    func SetAlarmListAsRead(_ nSeqMember: Int, _ strSeqAlarmList: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: SetAlarmListAsRead Called : SeqMember=\(nSeqMember) SeqAlarmList=\(strSeqAlarmList)")
        
        let Arg = CaArg("SetAlarmListAsRead", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("SeqAlarmList", strSeqAlarmList)
        
        executeCommand(Arg, API_SET_ALARM_LIST_AS_READ, bShowWaitDialog, viewControl)
    }
    
    func GetUnreadAlarmCount(_ nSeqMember: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUnreadAlarmCount Called : SeqMember=\(nSeqMember)")
        
        let Arg = CaArg("GetUnreadAlarmCount", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        
        executeCommand(Arg, API_GET_UNREAD_ALARM_COUNT, bShowWaitDialog, viewControl)
    }

    func GetNoticeList(_ nSeqMember: Int, _ strTimeCreatedMax: String, _ nCountNotice: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetNoticeList Called : SeqMember=\(nSeqMember) TimeCreatedMax=\(strTimeCreatedMax) CountNotice=\(nCountNotice)")
        
        let Arg = CaArg("GetNoticeList", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("TimeCreatedMax", strTimeCreatedMax)
        Arg.addArg("CountNotice", nCountNotice)
        
        executeCommand(Arg, API_GET_NOTICE_LIST, bShowWaitDialog, viewControl)
    }
    
    func SetNoticeListAsRead(_ nSeqMember: Int, _ strSeqNoticeList: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: SetNoticeListAsRead Called : SeqMember=\(nSeqMember) SeqNoticeList=\(strSeqNoticeList)")
        
        let Arg = CaArg("SetNoticeListAsRead", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("SeqNoticeList", strSeqNoticeList)
        
        executeCommand(Arg, API_SET_NOTICE_LIST_AS_READ, bShowWaitDialog, viewControl)
    }
    
    func GetUnreadNoticeCount(_ nSeqMember: Int, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: GetUnreadNoticeCount Called : SeqMember=\(nSeqMember)")
        
        let Arg = CaArg("GetUnreadNoticeCount", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        
        executeCommand(Arg, API_GET_UNREAD_NOTICE_COUNT, bShowWaitDialog, viewControl)
    }

    func ChangePassword(_ nSeqMember: Int, _ strPasswordNew: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: ChangePassword Called : SeqMember=\(nSeqMember) PasswordNew=\(strPasswordNew)")
        
        let Arg = CaArg("ChangePassword", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("PasswordNew", strPasswordNew)
        
        executeCommand(Arg, API_CHANGE_PASSWORD, bShowWaitDialog, viewControl)
    }

    func ChangePasswordByMemberId(_ strMemberId: String, _ strPasswordNew: String, _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: ChangePasswordByMemberId Called : MemberId=\(strMemberId) PasswordNew=\(strPasswordNew)")
        
        let Arg = CaArg("ChangePasswordByMemberId", NO_CMD_ARGS)
        Arg.addArg("MemberId", strMemberId)
        Arg.addArg("PasswordNew", strPasswordNew)
        
        executeCommand(Arg, API_CHANGE_PASSWORD_BY_MEMBER_ID, bShowWaitDialog, viewControl)
    }

    func ChangeMemberSettings(_ nSeqMember: Int, _ nNotiAll: Int, _ nNotiUsageElec: Int, _ nNotiUsageWater: Int, _ nNotiUsageGas: Int, _ nNotiUsageHeat: Int, _ nNotiUsageSteam: Int,  _ nNotiWonElec: Int, _ nNotiWonWater: Int, _ nNotiWonGas: Int, _ nNotiWonHeat: Int, _ nNotiWonSteam: Int, _ dThresholdUsageElec: Double, _ dThresholdUsageWater: Double, _ dThresholdUsageGas: Double, _ dThresholdUsageHeat: Double, _ dThresholdUsageSteam: Double, _ dThresholdWonElec: Double, _ dThresholdWonWater: Double, _ dThresholdWonGas: Double, _ dThresholdWonHeat: Double, _ dThresholdWonSteam: Double, _ nDiscountFamily: Int, _ nDiscountSocial: Int,
                              _ bShowWaitDialog: Bool, _ viewControl: AnyObject) {
        print("CaEngine: ChangeMemberSettings Called : SeqMember=\(nSeqMember) NotiAll=\(nNotiAll) NotiUsageElec=\(nNotiUsageElec) NotiUsageWater=\(nNotiUsageWater) NotiUsageGas=\(nNotiUsageGas) NotiUsageHeat=\(nNotiUsageHeat) NotiUsageSteam=\(nNotiUsageSteam) NotiWonElec=\(nNotiWonElec) NotiWonWater=\(nNotiWonWater) NotiWonGas=\(nNotiWonGas) NotiWonHeat=\(nNotiWonHeat) NotiWonSteam=\(nNotiWonSteam) ThresholdUsageElec=\(dThresholdUsageElec) ThresholdUsageWater=\(dThresholdUsageWater) ThresholdUsageGas=\(dThresholdUsageGas) ThresholdUsageHeat=\(dThresholdUsageHeat) ThresholdUsageSteam=\(dThresholdUsageSteam) ThresholdWonElec=\(dThresholdWonElec) ThresholdWonWater=\(dThresholdWonWater) ThresholdWonGas=\(dThresholdWonGas) ThresholdWonHeat=\(dThresholdWonHeat) ThresholdWonSteam=\(dThresholdWonSteam) DiscountFamily=\(nDiscountFamily) DiscountSocial=\(nDiscountSocial)")
        
        let Arg = CaArg("ChangeMemberSettings", NO_CMD_ARGS)
        Arg.addArg("SeqMember", nSeqMember)
        Arg.addArg("NotiAll", nNotiAll)
        Arg.addArg("NotiUsageElec", nNotiUsageElec)
        Arg.addArg("NotiUsageWater", nNotiUsageWater)
        Arg.addArg("NotiUsageGas", nNotiUsageGas)
        Arg.addArg("NotiUsageHeat", nNotiUsageHeat)
        Arg.addArg("NotiUsageSteam", nNotiUsageSteam)
        Arg.addArg("NotiWonElec", nNotiWonElec)
        Arg.addArg("NotiWonWater", nNotiWonWater)
        Arg.addArg("NotiWonGas", nNotiWonGas)
        Arg.addArg("NotiWonHeat", nNotiWonHeat)
        Arg.addArg("NotiWonSteam", nNotiWonSteam)
        Arg.addArg("ThresholdUsageElec", dThresholdUsageElec)
        Arg.addArg("ThresholdUsageWater", dThresholdUsageWater)
        Arg.addArg("ThresholdUsageGas", dThresholdUsageGas)
        Arg.addArg("ThresholdUsageHeat", dThresholdUsageHeat)
        Arg.addArg("ThresholdUsageSteam", dThresholdUsageSteam)
        Arg.addArg("ThresholdWonElec", dThresholdWonElec)
        Arg.addArg("ThresholdWonWater", dThresholdWonWater)
        Arg.addArg("ThresholdWonGas", dThresholdWonGas)
        Arg.addArg("ThresholdWonHeat", dThresholdWonHeat)
        Arg.addArg("ThresholdWonSteam", dThresholdWonSteam)
        Arg.addArg("DiscountFamily", nDiscountFamily)
        Arg.addArg("DiscountSocial", nDiscountSocial)
        
        executeCommand(Arg, API_CHANGE_MEMBER_SETTINGS, bShowWaitDialog, viewControl)
    }
}

var m_GlobalEngine = CaEngine()

//
//  CaEnergyManager.swift
//  Hems
//
//  Created by (주)에너넷 on 2021/02/18.
//

import Foundation

public class CaEnergyManager {
    public var m_nActiveIndex = 0 // 0=전기, 1=수도, 2=가스, 3=난방, 4=온수
    public var m_alEnergy: Array<CaEnergy> = Array()
    
    init() {
        
        let energyElec:CaEnergy = CaEnergy()
        energyElec.m_strName = "전기"
        energyElec.m_strFileNameActive1 = "blue2_f_elec.png"
        energyElec.m_strFileNameActive2 = "gray_f_elec.png"
        energyElec.m_strFileNameActive3 = "red2_f_elec.png"
        energyElec.m_strFileNameInactive1 = "blue2_o_elec.png"
        energyElec.m_strFileNameInactive2 = "gray_o_elec.png"
        energyElec.m_strFileNameInactive3 = "red2_o_elec.png"
        m_alEnergy.append(energyElec)
        
        let energyWater:CaEnergy = CaEnergy()
        energyWater.m_strName = "수도"
        energyWater.m_strFileNameActive1 = "blue2_f_water.png"
        energyWater.m_strFileNameActive2 = "gray_f_water.png"
        energyWater.m_strFileNameActive3 = "red2_f_water.png"
        energyWater.m_strFileNameInactive1 = "blue2_o_water.png"
        energyWater.m_strFileNameInactive2 = "gray_o_water.png"
        energyWater.m_strFileNameInactive3 = "red2_o_water.png"
        m_alEnergy.append(energyWater)
        
        let energyGas:CaEnergy = CaEnergy()
        energyGas.m_strName = "가스"
        energyGas.m_strFileNameActive1 = "blue2_f_gas.png"
        energyGas.m_strFileNameActive2 = "gray_f_gas.png"
        energyGas.m_strFileNameActive3 = "red2_f_gas.png"
        energyGas.m_strFileNameInactive1 = "blue2_o_gas.png"
        energyGas.m_strFileNameInactive2 = "gray_o_gas.png"
        energyGas.m_strFileNameInactive3 = "red2_o_gas.png"
        m_alEnergy.append(energyGas)
        
        let energyHeat:CaEnergy = CaEnergy()
        energyHeat.m_strName = "난방"
        energyHeat.m_strFileNameActive1 = "blue2_f_heat.png"
        energyHeat.m_strFileNameActive2 = "gray_f_heat.png"
        energyHeat.m_strFileNameActive3 = "red2_f_heat.png"
        energyHeat.m_strFileNameInactive1 = "blue2_o_heat.png"
        energyHeat.m_strFileNameInactive2 = "gray_o_heat.png"
        energyHeat.m_strFileNameInactive3 = "red2_o_heat.png"
        m_alEnergy.append(energyHeat)
        
        let energySteam:CaEnergy = CaEnergy()
        energySteam.m_strName = "온수"
        energySteam.m_strFileNameActive1 = "blue2_f_steam.png"
        energySteam.m_strFileNameActive2 = "gray_f_steam.png"
        energySteam.m_strFileNameActive3 = "red2_f_steam.png"
        energySteam.m_strFileNameInactive1 = "blue2_o_steam.png"
        energySteam.m_strFileNameInactive2 = "gray_o_steam.png"
        energySteam.m_strFileNameInactive3 = "red2_o_steam.png"
        m_alEnergy.append(energySteam)
        
    }
    
    public func getFileName(_ nIndex: Int) -> String {
        
        let energy:CaEnergy = m_alEnergy[nIndex]
        
        if (m_nActiveIndex == nIndex) {
            if energy.m_nLevel == 1 { return energy.m_strFileNameActive1 }
            if energy.m_nLevel == 2 { return energy.m_strFileNameActive2 }
            if energy.m_nLevel == 3 { return energy.m_strFileNameActive3 }
        }
        else {
            if energy.m_nLevel == 1 { return energy.m_strFileNameInactive1 }
            if energy.m_nLevel == 2 { return energy.m_strFileNameInactive2 }
            if energy.m_nLevel == 3 { return energy.m_strFileNameInactive3 }
        }
        
        return ""
    }
    
    public func getFileName() -> String {
        
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        
        if energy.m_nLevel == 1 { return energy.m_strFileNameActive1 }
        if energy.m_nLevel == 2 { return energy.m_strFileNameActive2 }
        if energy.m_nLevel == 3 { return energy.m_strFileNameActive3 }
      
        return ""
    }
    
    public func getName() -> String {
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        return energy.m_strName
    }
    
    public func getUsageCurr() -> Double {
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        return energy.m_dUsageCurr
    }
    
    public func getWonCurr() -> Double {
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        return energy.m_dWonCurr
    }

    public func getWonExpected() -> Double {
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        return energy.m_dWonExpected
    }
    
    public func getReadDay() -> Int {
        let energy:CaEnergy = m_alEnergy[m_nActiveIndex]
        return energy.m_nReadDay
    }
}

//
//  ServiceTypeModel.swift
//  IGHCare
//
//  Created by HICDAC on 18/09/24.
//

import Foundation
struct ServiceTypeModel{
    var moduleId="",moduleName="",gnumisValid="",seatId="",moduleType="",entryDate=""
    
    init(){}
    
    init(json:JSON){
        moduleId = json["GNUM_MODULE_ID"].stringValue
        moduleName = json["GSTR_MODULE_NAME"].stringValue
        gnumisValid = json["GNUM_ISVALID"].stringValue
        seatId = json["GNUM_SEAT_ID"].stringValue
        moduleType = json["GNUM_MODULE_TYPE"].stringValue
        entryDate = json["GDT_ENTRY_DATE"].stringValue
    }
}

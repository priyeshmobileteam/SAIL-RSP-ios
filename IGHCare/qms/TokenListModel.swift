//
//  TokenListModel.swift
//  IGHCare
//
//  Created by HICDAC on 01/10/24.
//
import Foundation
struct TokenListModel{
    var TOKEN_NO=""
    var SERVICE_ID=""
    var TOKEN_STATUS=""
    var COUNTER_NO=""
    var COUNTER_NAME=""
    var HOSP_CODE=""
    var HOSP_NAME=""
    
    init(){}
    
    init(json:JSON){
        TOKEN_NO = json["TOKEN_NO"].stringValue
        SERVICE_ID = json["SERVICE_ID"].stringValue
        TOKEN_STATUS = json["TOKEN_STATUS"].stringValue
        COUNTER_NO = json["COUNTER_NO"].stringValue
        COUNTER_NAME = json["COUNTER_NAME"].stringValue
        HOSP_CODE = json["HOSP_CODE"].stringValue
        HOSP_NAME = json["HOSP_NAME"].stringValue
       
    }
}

//
//  SmartDetailModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 26/02/24.
//

import Foundation
struct SmartDetailModel
{
    var testcode: String = ""
    var testname: String = ""
    var parametercode: String = ""
    var parametername: String = ""
    var value: String = ""
    var standardrange: String = ""
    var entrydate: String = ""
    var gnum_preference_order: String = ""
    var unit: String = ""
    var isOutOfRange: String = ""
    var isHighOrLow: String = ""
    
    
    init(){
        
    }
    
    init(json:JSON){
        testcode = json["testcode"].stringValue
        testname = json["testname"].stringValue
        parametercode = json["parametercode"].stringValue
        parametername = json["parametername"].stringValue
        value = json["value"].stringValue
        standardrange = json["standardrange"].stringValue
        entrydate = json["entrydate"].stringValue
        gnum_preference_order = json["gnum_preference_order"].stringValue
        unit = json["unit"].stringValue
        isOutOfRange = json["isOutOfRange"].stringValue
        isHighOrLow = json["isHighOrLow"].stringValue
        
    }
}

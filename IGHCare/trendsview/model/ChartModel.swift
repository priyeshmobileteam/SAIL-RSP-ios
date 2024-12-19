//
//  ChartModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 28/02/24.
//

import Foundation
struct ChartModel
{
    var entryDate: String = ""
    var testName: String = ""
    var value: String = ""
    var range: String = ""
    var isOutOfRange: String = ""
    init(){}
    init(json:JSON){
        entryDate = json["ENTRYDATE"].stringValue
        testName = json["TESTNAME"].stringValue
        value = json["VALUE"].stringValue
        range = json["RANGE"].stringValue
        isOutOfRange = json["isOutOfRange"].stringValue
        
    }
}

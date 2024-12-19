//
//  NadfModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/11/23.
//

import Foundation
struct NadfModel{
    var seqNo="",item="",nadfQty=""
    
    init(){}
    
    init(json:JSON){
        seqNo = json["SEQNO"].stringValue
        item = json["ITM"].stringValue
        nadfQty = json["NADF_QTY"].stringValue
       
    }
}

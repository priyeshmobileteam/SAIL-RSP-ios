//
//  SampleWiseModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/02/24.
//

import Foundation

struct SampleWiseModel
{
    var rn: String = ""
    var sampleno: String = ""
    var issamplenoempty: String = ""
    var acceptancedatetime: String = ""
    var requisitiondate: String = ""
    var collectiondate: String = ""
    var resultentrydate: String = ""
    var resultvalidationdate: String = ""
    var hospdetails: String = ""
    var reqno: String = ""
    var name: String = ""
    
    init(){
        
    }
    
    init(json:JSON){
        rn = json["rn"].stringValue
        sampleno = json["sampleno"].stringValue
        issamplenoempty = json["issamplenoempty"].stringValue
        acceptancedatetime = json["acceptancedatetime"].stringValue
        requisitiondate = json["requisitiondate"].stringValue
        collectiondate = json["collectiondate"].stringValue
        resultentrydate = json["resultentrydate"].stringValue
        resultvalidationdate = json["resultvalidationdate"].stringValue
        hospdetails = json["hospdetails"].stringValue
        reqno = json["reqno"].stringValue
        name = json["name"].stringValue
    }
}

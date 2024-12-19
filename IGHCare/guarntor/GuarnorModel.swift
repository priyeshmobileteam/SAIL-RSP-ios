//
//  GuarnorModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 21/11/23.
//

import Foundation
struct GuarnorModel{
    var patientName="",cr="",adm="",adm_date="",bill_no="",bill_date="",bill_amt="",guarntor_status=""
    
    init(){}
    
    init(json:JSON){
        patientName = json["PATIENT_NAME"].stringValue
        cr = json["CR"].stringValue
        adm = json["ADM"].stringValue
        adm_date = json["ADM_DATE"].stringValue
        bill_no = json["BILL_NO"].stringValue
        bill_date = json["BILL_DATE"].stringValue
        bill_amt = json["BILL_AMT"].stringValue
        guarntor_status = json["GUAR_STATUS"].stringValue
        
    }
}

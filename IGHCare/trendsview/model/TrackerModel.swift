//
//  TrackerModel.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 22/02/24.
//

import Foundation

struct TrackerModel
{
    var srNO: String = ""
    var reqDate: String = ""
    var deptName: String = ""
    var testName: String = ""
    var status: String = ""
    var testResults: String = ""
    var hivtnumReqDno: String = ""
    var sampleNoLabNo: String = ""
    var labName: String = ""
    var sampleCollectionDate: String = ""
    var patName: String = ""
    var patCrNo: String = ""
    var packagingListDate: String = ""
    var requisitonDate: String = ""
    var resultEntryDate: String = ""
    var resultValidationDate: String = ""
    var reportGenerationDate: String = ""
    var acceptanceDate: String = ""
    var gnumSamoleCode: String = ""
    var statusNo: String = ""
    var hospitalCode: String = ""
    var hospitalName: String = ""
    var reportPrintDate: String = ""
    init(){}
    init(json:JSON){
        srNO = json["SR_NO"].stringValue
        reqDate = json["REQDATE"].stringValue
        deptName = json["DEPT_NAME"].stringValue
        testName = json["TESTNAME"].stringValue
        status = json["STATUS"].stringValue
        testResults = json["TEST_RESULTS"].stringValue
        
        hivtnumReqDno = json["HIVTNUM_REQ_DNO"].stringValue
        sampleNoLabNo = json["SAMPLENO_LABNO"].stringValue
        labName = json["LABNAME"].stringValue
        sampleCollectionDate = json["SAMPLE_COLLECTION_DATE"].stringValue
        patName = json["PATNAME"].stringValue
        patCrNo = json["PATCRNO"].stringValue
        
        packagingListDate = json["PACKING_LIST_DATE"].stringValue
        requisitonDate = json["REQUISITION_DATE"].stringValue
        resultEntryDate = json["RESULT_ENTRY_DATE"].stringValue
        resultValidationDate = json["RESULT_VALIDATION_DATE"].stringValue
        reportGenerationDate = json["REPORT_GENERATION_DATE"].stringValue
        acceptanceDate = json["ACCPETANCE_DATE"].stringValue
        
        gnumSamoleCode = json["GNUM_SAMPLE_CODE"].stringValue
        statusNo = json["STATUS_NO"].stringValue
        hospitalCode = json["HOSPITALCODE"].stringValue
        hospitalName = json["HOSPITAL_NAME"].stringValue
        reportPrintDate = json["REPORT_PRINT_DATE"].stringValue
        
    }
}

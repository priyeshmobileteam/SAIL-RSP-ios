//
//  SubCategoryModel.swift
//  IGHCare
//
//  Created by HICDAC on 24/10/24.
//

import Foundation
struct SubCategoryModel{
        var subCategoryName: String = ""
        var subCategoryId: String = ""
        var entryDate: String = ""
     

        init(){}
        
        init(json:JSON){
            subCategoryName = json["GSTR_SUBCATEGORY_NAME"].stringValue
            subCategoryId = json["GNUM_SUBCATEGORY_ID"].stringValue
            entryDate = json["GDT_ENTRY_DATE"].stringValue
        }
   
    
}

//
//  CategoryModel.swift
//  IGHCare
//
//  Created by HICDAC on 24/10/24.
//

import Foundation
struct CategoryModel{
        var categoryName: String = ""
        var categoryId: String = ""
        var entryDate: String = ""
     

        init(){}
        
        init(json:JSON){
            categoryName = json["GSTR_CATEGORY_NAME"].stringValue
            categoryId = json["GNUM_CATEGORY_ID"].stringValue
            entryDate = json["GDT_ENTRY_DATE"].stringValue
        }
   
    
}

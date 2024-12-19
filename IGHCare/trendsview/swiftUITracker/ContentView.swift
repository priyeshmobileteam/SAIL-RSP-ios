//
//  ContentView.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 23/02/24.
//

import SwiftUI

struct ContentView: View {
    var position: Int
    var arrData: [TrackerModel]
    
    // Initialize ContentView with position and an array of TrackerModel
    init(position: Int, arrData: [TrackerModel]) {
        self.position = position
        self.arrData = arrData
    }
    var body: some View {
        ScrollView{
            //                ItemInfoView()
            //                Divider()
            VStack(spacing:0){
                if(arrData[0].statusNo == "56"){
                    if(arrData[0].requisitonDate.isEmpty){
                        TrackProgressView(date: arrData[0].requisitonDate, status:  AppConstant.REQUISTION_RAISED+"(Appointment Pending)", icon: "r.circle.fill", isFirst: true, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                    }else{
                        TrackProgressView(date: arrData[0].requisitonDate, status:  AppConstant.REQUISTION_RAISED+"(Appointment Pending)", icon: "r.circle.fill", isFirst: true, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                    }
                }else{
                    if(arrData[0].requisitonDate.isEmpty){
                        TrackProgressView(date: arrData[0].requisitonDate, status:  AppConstant.REQUISTION_RAISED, icon: "r.circle.fill", isFirst: true, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                    }else{
                        TrackProgressView(date: arrData[0].requisitonDate, status:  AppConstant.REQUISTION_RAISED, icon: "r.circle.fill", isFirst: true, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                    }
                }
                
                if(arrData[0].gnumSamoleCode == "-1"){
                    if(arrData[0].sampleCollectionDate.isEmpty){
                        TrackProgressView(date: arrData[0].sampleCollectionDate, status: "Patient Accepted", icon: "s.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                    }else{
                        TrackProgressView(date: arrData[0].sampleCollectionDate, status: "Patient Accepted", icon: "s.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                    }
                }else{
                    if(arrData[0].sampleCollectionDate.isEmpty){
                        TrackProgressView(date: arrData[0].sampleCollectionDate, status: AppConstant.SAMPLE_COLLECTED, icon: "s.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                    }else{
                        TrackProgressView(date: arrData[0].sampleCollectionDate, status: AppConstant.SAMPLE_COLLECTED, icon: "s.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                    }
                }
                
                
                if(arrData[0].packagingListDate.isEmpty){
                    TrackProgressView(date: arrData[0].packagingListDate, status:  AppConstant.PACKING_LIST_GENERATED, icon: "p.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].packagingListDate, status:  AppConstant.PACKING_LIST_GENERATED, icon: "p.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                }
                if(arrData[0].acceptanceDate.isEmpty){
                    TrackProgressView(date: arrData[0].acceptanceDate, status:  AppConstant.SAMPLE_ACCEPTED, icon: "s.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].acceptanceDate, status:  AppConstant.SAMPLE_ACCEPTED, icon: "s.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                }
                if(arrData[0].resultEntryDate.isEmpty){
                    TrackProgressView(date: arrData[0].resultEntryDate, status:  AppConstant.RESULT_ENTERED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].resultEntryDate, status:  AppConstant.RESULT_ENTERED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                }
                if(arrData[0].resultValidationDate.isEmpty){
                    TrackProgressView(date: arrData[0].resultValidationDate, status:  AppConstant.RESULT_VALIDTED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].resultValidationDate, status:  AppConstant.RESULT_VALIDTED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                }
                if(arrData[0].reportGenerationDate.isEmpty){
                    TrackProgressView(date: arrData[0].reportGenerationDate, status: AppConstant.REPORT_GENERATED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].reportGenerationDate, status: AppConstant.REPORT_GENERATED, icon: "r.circle.fill", isFirst: false, isLast: false,state: .completed).previewLayout(.sizeThatFits)
                }
                
                if(arrData[0].reportPrintDate.isEmpty){
                    TrackProgressView(date: arrData[0].reportPrintDate, status:  AppConstant.REPORT_PRINTED, icon: "r.circle.fill", isFirst: false, isLast: true,state: .upcoming).previewLayout(.sizeThatFits)
                }else{
                    TrackProgressView(date: arrData[0].reportPrintDate, status:  AppConstant.REPORT_PRINTED, icon: "r.circle.fill", isFirst: false, isLast: true,state: .completed).previewLayout(.sizeThatFits)
                }
                
            }.padding(.all,8)
        }
    }
}

//


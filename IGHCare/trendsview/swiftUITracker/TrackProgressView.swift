//
//  TrackProgressView.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 23/02/24.
//

import SwiftUI
enum TrackingState{
    case isInProgress
    case completed
    case upcoming
}

struct TrackProgressView: View {
    var date: String
    var status: String
    var icon:String
    
    var isFirst: Bool
    var isLast: Bool
    
    var state:TrackingState
    var body: some View {
        HStack{
            Text(date).frame(width: 80)
                .opacity(self.state == .upcoming ? 0.5 : 1.0)
                .font(.system(size: 12))
            ZStack{
                VStack{
                    Rectangle()
                        .frame(width: 5,height: 30)
                        .foregroundColor(Color.blue.opacity(0.2))
                        .opacity(self.isFirst ? 0.0 : 1.0)
                    Rectangle()
                        .frame(width: 5,height: 30)
                        .foregroundColor(Color.blue.opacity(0.2))
                        .opacity(self.isLast ? 0.0 : 1.0)
                }
                Circle().frame(width: 35,height: 35)
                    .foregroundColor(Color.blue.opacity(0.5))
                    .opacity(self.state == .isInProgress ? 1.0 : 0.0)
                
                Circle().frame(width: 12,height: 12)
                    .foregroundColor(Color.blue.opacity(0.8))
            }
            .opacity(self.state == .upcoming ? 0.5 : 1.0)
            HStack{
                Image(systemName: icon)
                    .font(.title).foregroundColor(.blue)
                Text(status)
                    .font(.system(size: 13))
                Spacer()
            }.padding(.all,8)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
                .opacity(self.state == .upcoming ? 0.5 : 1.0)
            Spacer()
        }
    }
}

//struct TrackProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackProgressView(date: "May 12", status: AppConstant.REQUISTION_RAISED, icon: "a.circle.fill", isFirst: false, isLast: false,state: .upcoming).previewLayout(.sizeThatFits)
//        }
//}

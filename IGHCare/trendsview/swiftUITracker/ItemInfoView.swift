//
//  ItemInfoView.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 23/02/24.
//

import SwiftUI

struct ItemInfoView: View {
    var body: some View {
        ZStack{
            HStack{
                Circle().frame(width: 60,height: 60)
                    .foregroundColor(Color.gray.opacity(0.2))
                Image(systemName: "cart.fill").font(.largeTitle)
            }
        }
        Text("Sample Accepted").font(.title).padding(.all).foregroundColor(Color.blue)
            .background(Color.gray.opacity(0.2))
        Spacer()
        
    }
}

struct ItemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ItemInfoView().previewLayout(.sizeThatFits)
    }
}


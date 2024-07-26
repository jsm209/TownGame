//
//  ResourceSummaryView.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/24/24.
//

import SwiftUI

struct ResourceSummaryView: View {
    
    var sfName: String = ""
    var label: String = ""
    var color: Color = .black
    
    
    
    var body: some View {
        VStack{
            Image(systemName: sfName)
                .padding(.bottom, 5)
                .foregroundColor(color)
            Text(label)
        }
        .padding()
    }
}

#Preview {
    ResourceSummaryView(sfName: "person.3", label: "100")
}

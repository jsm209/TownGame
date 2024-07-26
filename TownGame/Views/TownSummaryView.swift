//
//  TownSummaryView.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/24/24.
//

import SwiftUI

struct TownSummaryView: View {
    var body: some View {
        VStack {
            Text("Fisherling")
            Text("Village")
            HStack {
                ResourceSummaryView(sfName: "dollarsign.circle", label: "10")
                ResourceSummaryView(sfName: "building.columns", label: "10")
            }
            Spacer()
            HStack {
                ResourceSummaryView(sfName: "person.3", label: "24")
                ResourceSummaryView(sfName: "person.3", label: "2", color: .red)
                ResourceSummaryView(sfName: "house", label: "8")
                ResourceSummaryView(sfName: "building.2", label: "2")
            }
        }
        
    }
}

#Preview {
    TownSummaryView()
}

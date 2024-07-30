//
//  TownSummaryView.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/24/24.
//

import SwiftUI

struct TownSummaryView: View {
    
    @ObservedObject var viewModel = TownSummaryViewModel()
    
    var body: some View {
        VStack {
            Text("Fisherling")
            Text("Village")
            Text("Year \(viewModel.turnNumber)")
            HStack {
                ResourceSummaryView(sfName: "dollarsign.circle", label: viewModel.currentResources.money.description)
                ResourceSummaryView(sfName: "building.columns", label: viewModel.currentResources.control.description)
            }
            Spacer()
            HStack {

            }
            HStack {
                ResourceSummaryView(sfName: "person.3", label: viewModel.currentHousingString)
                ResourceSummaryView(sfName: "person.3", label: viewModel.currentResources.redPeople.description, color: .red)

                VStack{
                    Button("+") { viewModel.buySellHouses(1) }
                    ResourceSummaryView(sfName: "house", label: viewModel.currentResources.houses.description)
                    Button("-") { viewModel.buySellHouses(-1) }
                }
                VStack{
                    Button("+") { viewModel.buySellWorkplaces(1) }
                    ResourceSummaryView(sfName: "building.2", label: viewModel.currentResources.workplaces.description)
                    Button("-") { viewModel.buySellWorkplaces(-1) }
                }

            }
            Spacer()
            Button("End Turn") {
                viewModel.endTurn()
            }
        }
        
    }
}

#Preview {
    TownSummaryView()
}

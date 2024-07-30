//
//  TownSummaryViewModel.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/29/24.
//

import Foundation


class TownSummaryViewModel: ObservableObject {
    
    @Published public var turnNumber = 1
    private var turnService = TurnService()
    @Published var currentResources: ResourceSnapshotModel
    
    var currentHousingString: String {
        return "\(currentResources.people) / \(turnService.PEOPLE_PER_HOUSE * currentResources.houses)"
    }
    
    init(initialResources: ResourceSnapshotModel = ResourceSnapshotModel()) {
        self.currentResources = initialResources
    }
    
    func endTurn() {
        let updatedResources = turnService.getResourceChange(currentState: self.currentResources)
        self.currentResources = updatedResources
        self.turnNumber += 1
    }
    
    func buySellHouses(_ changeAmount: Int) {
        let updatedResources = turnService.buySellHouses(changeAmount: changeAmount, currentState: self.currentResources)
        self.currentResources = updatedResources
    }
    
    func buySellWorkplaces(_ changeAmount: Int) {
        let updatedResources = turnService.buySellWorkplaces(changeAmount: changeAmount, currentState: self.currentResources)
        self.currentResources = updatedResources
    }
}

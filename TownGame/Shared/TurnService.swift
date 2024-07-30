//
//  TurnService.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/25/24.
//

import Foundation

class TurnService {
    
    public let PEOPLE_PER_HOUSE = 4 // max people that can live in a house
    private let PEOPLE_PER_WORKPLACE = 10 // max people that can work at a workplace
    private let MAX_MONEY_PER_WORKER = 10 // max revenue per day per worker
    private let BABY_PROBABILITY_WHEN_EMPLOYED = 0.03 // odds of having a child when unemployed
    private let BABY_PROBABILITY_WHEN_UNEMPLOYED = 0.06 // odds of having a child when employed
    private let RED_PERSON_REFORM_PROBABILITY = 0.6 // odds a red person will reform themselves with available housing
    private let RED_PERSON_DEFECT_PROBABILITY = 0.9 // odds a normal person will turn red when homeless
    private let PERSON_NATURAL_DEATH_PROBABILITY = 0.01 // odds a person will die from old age, accidents, etc.
    private let UNRULY_POPULATION_THRESHOLD = 0.05 // max percentage of people/red people allowed before control deteriorates
    private let CONTROL_INTEREST_RATE = 0.05 // during peace the control level will rise by this percentage rate amount
    
    private let COST_PER_HOUSE = 10
    private let COST_PER_WORKPLACE = 50
    
    func getResourceChange(currentState: ResourceSnapshotModel) -> ResourceSnapshotModel {
        
        // 1% of population is culled
        var updatedPeople = currentState.people - Int(floor(Double(currentState.people) * PERSON_NATURAL_DEATH_PROBABILITY))
        var updatedRedPeople = currentState.redPeople - Int(floor(Double(currentState.redPeople) * PERSON_NATURAL_DEATH_PROBABILITY))
  
        
        // Working and reproduction
        let maximumWorkCapacity = currentState.workplaces * PEOPLE_PER_WORKPLACE
        let workers = min(updatedPeople, maximumWorkCapacity)
        let nonWorkers = updatedPeople - workers
        
        let totalNewBabies = calculateNewBabies(workers: workers, nonWorkers: nonWorkers)
        let updatedMoney = currentState.money + calculateWorkerRevenue(workers: workers)
        
        // Determine change in control
        let updatedControl = calculateNewControlAmount(
            people: updatedPeople,
            redPeople: updatedRedPeople,
            control: currentState.control
        )
        
        
        // Rebalancing Red People and People Populations
        let maximumPopulationCapacity = currentState.houses * PEOPLE_PER_HOUSE
        var possibleChangeInRedPeople = (maximumPopulationCapacity - updatedPeople) * -1
        
        if (possibleChangeInRedPeople > 0) {
            // changeInRedPeople positive means there is not enough housing, so people will defect
            possibleChangeInRedPeople = Int(floor(Double(possibleChangeInRedPeople) * RED_PERSON_DEFECT_PROBABILITY))
        } else {
            // changeInRedPeople negative or zero means there is enough housing, so red people will reform
            possibleChangeInRedPeople = Int(floor(Double(possibleChangeInRedPeople) * RED_PERSON_REFORM_PROBABILITY))
        }
        
        if updatedRedPeople + possibleChangeInRedPeople >= 0 {
            updatedRedPeople = max(0, updatedRedPeople + possibleChangeInRedPeople)
            updatedPeople = max(0, updatedPeople - possibleChangeInRedPeople)
        } else {
            // only subtract the red people that we actually have, if we have them
            updatedPeople = max(0, updatedPeople - updatedRedPeople)
            updatedRedPeople = 0
        }
        print("possibleChangeInRedPeople: \(possibleChangeInRedPeople)")

        updatedPeople = updatedPeople + totalNewBabies
        
        // TODO: I want updated people to increase for the start of next turn BEFORE red people are recalculated again...
        
        
        let newState = ResourceSnapshotModel(
            money: updatedMoney,
            control: updatedControl,
            people: updatedPeople,
            redPeople: updatedRedPeople,
            houses: currentState.houses,
            workplaces: currentState.workplaces
        )

        return newState
    }
    
    func buySellHouses(changeAmount: Int, currentState: ResourceSnapshotModel) -> ResourceSnapshotModel {
        var updatedHouses = currentState.houses
        var updatedMoney = currentState.money
        
        // can only BUY houses if we can afford it
        // and can only SELL houses if we have them
        if changeAmount > 0 && currentState.money >= changeAmount * COST_PER_HOUSE {
            updatedHouses += changeAmount
            updatedMoney -= changeAmount * COST_PER_HOUSE
        } else if changeAmount < 0 && currentState.houses > 0 {
            updatedHouses += changeAmount
            updatedMoney -= changeAmount * COST_PER_HOUSE
        }
        
        let newState = ResourceSnapshotModel(
            money: updatedMoney,
            control: currentState.control,
            people: currentState.people,
            redPeople: currentState.redPeople,
            houses: updatedHouses,
            workplaces: currentState.workplaces
        )

        return newState
    }
    
    func buySellWorkplaces(changeAmount: Int, currentState: ResourceSnapshotModel) -> ResourceSnapshotModel {
        var updatedWorkplaces = currentState.workplaces
        var updatedMoney = currentState.money
        
        // can only BUY houses if we can afford it
        // and can only SELL houses if we have them
        if changeAmount > 0 && currentState.money >= changeAmount * COST_PER_WORKPLACE {
            updatedWorkplaces += changeAmount
            updatedMoney -= changeAmount * COST_PER_WORKPLACE
        } else if changeAmount < 0 && currentState.workplaces > 0 {
            updatedWorkplaces += changeAmount
            updatedMoney -= changeAmount * COST_PER_WORKPLACE
        }
        
        let newState = ResourceSnapshotModel(
            money: updatedMoney,
            control: currentState.control,
            people: currentState.people,
            redPeople: currentState.redPeople,
            houses: currentState.houses,
            workplaces: updatedWorkplaces
        )

        return newState
    }
    
    private func calculateNewBabies(workers: Int, nonWorkers: Int) -> Int {
        let newBabiesFromWorkers = Double(workers) * BABY_PROBABILITY_WHEN_EMPLOYED
        let newBabiesFromNonWorkers = Double(nonWorkers) * BABY_PROBABILITY_WHEN_UNEMPLOYED
        let totalNewBabies = Int(ceil(newBabiesFromWorkers + newBabiesFromNonWorkers))
        print("babies from workers: \(newBabiesFromWorkers)"  )
        print("babies from unemployed: \(newBabiesFromNonWorkers)")
        print("total new babies: \(totalNewBabies)")
        return totalNewBabies
    }
    
    private func calculateWorkerRevenue(workers: Int) -> Int {
        var revenue = 0
        for _ in 0..<workers {
            // each worker generates 1-10 units of money
            revenue += Int.random(in: 1...MAX_MONEY_PER_WORKER)
        }
        return revenue
    }
    
    private func calculateNewControlAmount(people: Int, redPeople: Int, control: Int) -> Int {
        let unrulyPopulationThreshold = Int(floor(Double(people) * UNRULY_POPULATION_THRESHOLD))
        var updatedControl = control
        if (redPeople > unrulyPopulationThreshold) {
            updatedControl -= (redPeople - unrulyPopulationThreshold)
        } else {
            updatedControl += Int(floor(Double(control) * CONTROL_INTEREST_RATE))
        }
        return updatedControl
    }
    
}

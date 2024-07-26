//
//  TurnService.swift
//  TownGame
//
//  Created by Maza, Joshua on 7/25/24.
//

import Foundation

class TurnService {
    
    let PEOPLE_PER_HOUSE = 4 // max people that can live in a house
    let PEOPLE_PER_WORKPLACE = 10 // max people that can work at a workplace
    let MAX_MONEY_PER_WORKER = 10 // max revenue per day per worker
    let BABY_PROBABILITY_WHEN_EMPLOYED = 0.25 // odds of having a child when unemployed
    let BABY_PROBABILITY_WHEN_UNEMPLOYED = 0.5 // odds of having a child when employed
    let RED_PERSON_REFORM_PROBABILITY = 0.6 // odds a red person will reform themselves with available housing
    let RED_PERSON_DEFECT_PROBABILITY = 0.9 // odds a normal person will turn red when homeless
    let PERSON_NATURAL_DEATH_PROBABILITY = 0.01 // odds a person will die from old age, accidents, etc.
    let UNRULY_POPULATION_THRESHOLD = 0.05 // max percentage of people/red people allowed before control deteriorates
    let CONTROL_INTEREST_RATE = 0.05 // during peace the control level will rise by this percentage rate amount
    
    
    func getResourceChange(currentState: ResourceSnapshotModel) -> ResourceSnapshotModel {
        
        // 1% of population is culled
        var updatedPeople = currentState.people - Int(floor(Double(currentState.people) * PERSON_NATURAL_DEATH_PROBABILITY))
        var updatedRedPeople = currentState.redPeople - Int(floor(Double(currentState.redPeople) * PERSON_NATURAL_DEATH_PROBABILITY))
  
        
        // Working and reproduction
        let maximumWorkCapacity = currentState.workplaces * PEOPLE_PER_WORKPLACE
        let workers = min(updatedPeople, maximumWorkCapacity)
        let nonWorkers = updatedPeople - workers
        
        let totalNewBabies = calculateNewBabies(workers: workers, nonWorkers: nonWorkers)
        let updatedMoney = calculateWorkerRevenue(workers: workers)
        
        // Determine change in control
        let updatedControl = calculateNewControlAmount(
            people: updatedPeople,
            redPeople: updatedRedPeople,
            control: currentState.control
        )
        
        
        // Rebalancing Red People and People Populations
        let maximumPopulationCapacity = currentState.houses * PEOPLE_PER_HOUSE
        var changeInRedPeople = (maximumPopulationCapacity - updatedPeople) * -1
        
        if (changeInRedPeople > 0) {
            // changeInRedPeople positive means there is not enough housing, so people will defect
            changeInRedPeople = Int(floor(Double(changeInRedPeople) * RED_PERSON_DEFECT_PROBABILITY))
        } else {
            // changeInRedPeople negative or zero means there is enough housing, so red people will reform
            changeInRedPeople = Int(floor(Double(changeInRedPeople) * RED_PERSON_REFORM_PROBABILITY))
        }
        updatedRedPeople += changeInRedPeople
        updatedPeople -= changeInRedPeople
        
        
        var newState = ResourceSnapshotModel(
            money: updatedMoney,
            control: updatedControl,
            people: updatedPeople,
            redPeople: updatedRedPeople,
            houses: currentState.houses,
            workplaces: currentState.workplaces
        )

        return newState
    }
    
    private func calculateNewBabies(workers: Int, nonWorkers: Int) -> Int {
        let newBabiesFromWorkers = Double(workers) * BABY_PROBABILITY_WHEN_EMPLOYED
        let newBabiesFromNonWorkers = Double(nonWorkers) * BABY_PROBABILITY_WHEN_UNEMPLOYED
        let totalNewBabies = Int(newBabiesFromWorkers + newBabiesFromNonWorkers)
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

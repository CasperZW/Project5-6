//
//  HealthStore.swift
//  PijnApp
//
//  Created by Casper on 16/11/2021.
//

import Foundation
import HealthKit

//HealthStore
//Deze class wordt gebruikt voor het ophalen van het aantal gezette stappen.
//Hierbij wordt gebruik gemaakt van HealthKit en de code is hierop gebaseerd.
//Voor meer informatie over HealthKit: https://developer.apple.com/documentation/healthkit

//Alles wat nodig is voor ophalen stappen
extension Date{
    static func mondayAt12AM() -> Date{
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore{
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        query?.initialResultsHandler = {
            query, statisticsCollection, error in completion(statisticsCollection)
        }
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    func requestAuthorization(completion: @escaping(Bool) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false)}
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (succes, error) in
            completion(succes)
        }
    }
}

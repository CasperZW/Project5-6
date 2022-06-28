//
//  Data.swift
//  PijnApp
//
//  Created by Casper on 26/11/2021.
//

import Foundation

//Alle data die opgeslagen wordt
struct MoreData: Codable, Equatable{
    var pain: Double?
    var tiredness: Double?
    var stress: Double?
}

struct DataItem: Identifiable, Codable, Equatable{
    var id = UUID()
    var date: Date
    var pain: Double?
    var sleep: Double?
    var tiredness: Double?
    var stress: Double?
    
    var moreInfo = [MoreData]()
    
    var morningComment: String?
    var eveningComment: String?
    var stepsToday: Double?
    
}

public class Data: ObservableObject{
    @Published var lineSetting = false
    @Published var items = [DataItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([DataItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}


//
//  Step.swift
//  PijnApp
//
//  Created by Casper on 17/11/2021.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

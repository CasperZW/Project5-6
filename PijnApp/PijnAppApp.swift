//
//  PijnAppApp.swift
//  PijnApp
//
//  Created by Casper on 29/10/2021.
//

import SwiftUI

@main
struct PijnAppApp: App {
    init() {
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                print("Family: \(family) Font names: \(names)")
            }
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}

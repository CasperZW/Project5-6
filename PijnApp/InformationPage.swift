//
//  InformationPage.swift
//  PijnApp
//
//  Created by Casper on 10/12/2021.
//

import SwiftUI

//Pagina die de informatie weergeeft die gekozen is in 'InformationTab'
struct InformationPage: View {
    let informationTitle: String
    let information: String
    var body: some View {
        Text(informationTitle)
        Text(information)
            .preferredColorScheme(.light)
    }
        
}

struct InformationPage_Previews: PreviewProvider {
    static var previews: some View {
        InformationPage(informationTitle: "test", information: "test")
    }
}

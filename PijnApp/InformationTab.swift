//
//  InformationTab.swift
//  PijnApp
//
//  Created by Casper on 10/12/2021.
//

import SwiftUI

//InformationTab/InformationPage
//Dit is een lijst met alle onderwerpen waarover informatie gegeven wordt.
//Op ieder onderwerp kan gedrukt worden om naar die pagina te gaan met verdere informatie over dat onderwerp.

struct infoStruct: Hashable{
    var informationTitle: String
    var information: String
}

struct InformationTab: View {
    // Tabjes voor informatie
    let themes = [infoStruct(informationTitle: "Hoe werkt de app?", information: "test"), infoStruct(informationTitle: "Pijn", information: "test"), infoStruct(informationTitle: "Slaap", information: "test"), infoStruct(informationTitle: "Slaap", information: "test"), infoStruct(informationTitle: "Stappen", information: "test")]
    @State private var showInformation = false
    @State private var informationTitle = ""
    @State private var information = ""
    var body: some View {
        
        NavigationLink(destination: InformationPage(informationTitle: informationTitle, information: information), isActive: $showInformation){EmptyView()}
            ZStack{
                Image("background")
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                List{
                    ForEach(themes, id: \.self){ theme in
                        Button{
                            informationTitle = theme.informationTitle
                            information = theme.information
                            showInformation.toggle()
                        } label: {
                            HStack{
                                Text("\(theme.informationTitle)")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                }
            }
            
        .navigationBarTitle("Informatie")
            .preferredColorScheme(.light)
    }
}

struct InformationTab_Previews: PreviewProvider {
    static var previews: some View {
        InformationTab()
    }
}

//
//  ContentView.swift
//  PijnApp
//
//  Created by Casper on 05/11/2021.
//

// Dit is mijn eerste project in SwiftUI dus ik verwacht nog veel fouten/bugs/onduidelijkheden. Mocht er iets niet duidelijk zijn of je heb je andere vragen, neem dan zeker contact met mij op: casper@deleeuwvanweenen.nl

import SwiftUI

//ContentView
//Dit is de 'main' pagina van de app vanaf hier kom je bij alle andere pagina's van de app.
//Hier is een ViewModifier gemaakt, deze modifier wordt op alle knoppen toegepast zodat ze allemaal hetzelfde design hebben.
//Al deze knoppen worden in een HStack en VStack geplaatst, dit zorgt ervoor dat ze mooi naast/onder elkaar staan.
//Als er een knop wordt ingedrukt wordt een NavigationLink geactiveerd die de gebruiker naar de volgende pagina stuurt.

//Viewmodifier voor de opties op het main scherm
struct OptionDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Franklin Gothic Demi", size: 25))
            .frame(width: 170, height: 220, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .frame(width: 180, height: 230, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.black)
            .shadow(color: .gray, radius: 2, x: 2, y: 2)
    }
}

// Zo kan je het "optiondesign" makkelijk toevoegen aan een button
extension View {
    func optionDesign() -> some View {
        self.modifier(OptionDesign())
    }
}

struct ContentView: View {
    
    @StateObject var data = Data()  //Alle opgeslagen data
    
    @State private var newMeasurement = false   //toont het 'nieuwe meting' scherm als dit true is
    @State private var measurement = false      //toont het 'metingen' scherm als dit true is
    var body: some View {
        NavigationView{
            ZStack{
                Image("background")
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                VStack{
                    VStack{
                        Text("Welkom")
                            .font(.custom("Franklin Gothic Demi", size: 50))
                        Text("Maak een keuze")
                            .font(.custom("Bahnschrift", size: 18))
                    }
                    .padding()
                    .frame(width: UIScreen.screenWidth, height: 200, alignment: .leading)
                    VStack{
                        HStack{
                            // Knop naar 'Informatie/Nieuw' pagina
                            NavigationLink(destination: InformationTab(), label: {
                                VStack{
                                    Image("nieuws")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                    Text("Nieuws")
                                        .padding()
                                }
                                .optionDesign()
                            })
                            // Knop naar 'Instellingen' pagina
                            NavigationLink(destination: Settings(data: self.data), label: {
                                VStack{
                                    Image("instellingen")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                    Text("Instellingen")
                                        .padding()
                                }
                                .optionDesign()
                            })
                        }
                        HStack{
                            // Knop naar 'Nieuwe meting' pagina
                            Button(action: {newMeasurement.toggle()}, label: {
                                VStack{
                                    Image("plus")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                    Text("Nieuwe \n meting")
                                        .padding()
                                }
                                .optionDesign()
                            })
                            // Knop naar 'Metingen' pagina
                            NavigationLink(destination: Measurements(data: self.data), label: {
                                VStack{
                                    Image("metingen")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                    Text("  Vorige \nMetingen")
                                        .padding()
                                }
                                .optionDesign()
                            })                        }
                    }
                Spacer()
                }
            }.sheet(isPresented: $newMeasurement){
                NewMeasurement(data: self.data)
            }
            .navigationBarTitle(Text("Terug"))
            .navigationBarHidden(true)
            
            .onAppear{
                NotificationManager.instance.requestAuthorization() //Vraag om toestemming voor notificaties
                NotificationManager.instance.scheduleMorningNotification() //Plan een notificatie in de ochtend
                NotificationManager.instance.scheduleEveningNotification() //Plan een notificatie in de avond
                UIApplication.shared.applicationIconBadgeNumber = 0 //Zet het Badge nummer op 0, dit zorgt ervoor dat de rode cirkel met een 1 weg gaat nadat je de app hebt geopend.
                
            }
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

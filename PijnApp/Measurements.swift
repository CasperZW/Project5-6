//
//  Measurements.swift
//  PijnApp
//
//  Created by Casper on 28/11/2021.
//

import SwiftUI

//Measurements
//Hier wordt doormiddel van een 'List' alle gegevens weergegeven.
//Er wordt met een ForEach alle items langsgelopen en in duidelijke tekstvorm afgebeeld.
//Hier wordt ook de .onDelete modifier toegepast om makkelijk items te verwijderen.
//Als er 3 of meer items zijn toegevoegd wordt een knop zichtbaar om naar de grafiek te gaan.

struct Measurements: View {
    @ObservedObject var data: Data
    @State private var showGraph = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationLink(destination: MeasurementsGraph(measurements: data), isActive: $showGraph){ EmptyView()}
        ZStack{
                VStack{
                    List{
                        ForEach((data.items).reversed()){ item in   //Ga alle items in de array langs en kijk welke data is ingevuld en dus getoond kan worden.
                            let unWrappedDate = Text(item.date, style: .date).bold()
                            let enter = Text("\n")
                            
                            let unWrappedPain = item.pain != nil ? Text("Pijn: \(item.pain!, specifier: "%.0f")\n") : Text("")
                            let unWrappedSleep = item.sleep != nil ? Text("Slaap: \(item.sleep!, specifier: "%.0f")\n") : Text("")
                            let unWrappedTiredness = item.tiredness != nil ? Text("Vermoeidheid: \(item.tiredness!, specifier: "%.0f")\n") : Text("")
                            let unWrappedStress = item.stress != nil ? Text("Stress: \(item.stress!, specifier: "%.0f")\n") : Text("")
                            let unWrappedSteps = item.stepsToday != nil ? Text("Stappen: \(item.stepsToday!, specifier: "%.0f")\n") : Text("")
                            let unWrappedMorningComment = item.morningComment != nil ? Text("Opmerking in de ochtend: \"\(item.morningComment!)\"\n") : Text("")
                            let unWrappedEveningComment = item.eveningComment != nil ? Text("Opmerking in de avond: \"\(item.eveningComment!)\"\n") : Text("")
                            
                            Text("") + unWrappedDate + enter + unWrappedPain + unWrappedSleep + unWrappedTiredness + unWrappedStress + unWrappedSteps + unWrappedMorningComment + unWrappedEveningComment
                            
                            //Text("Slaap: \(item.sleep, specifier: "%.0f")  \nVermoeidheid: \(item.tiredness, specifier: "%.0f") \nStress: \(item.stress, specifier: "%.0f") \nStappen: \(item.stepsToday) ")
                        }
                        .onDelete { index in    //Hiermee kunnen items verwijderd worden
                            // get the item from the reversed list
                            let theItem = data.items.reversed()[index.first!]
                            // get the index of the item from the viewModel, and remove it
                            if let ndx = data.items.firstIndex(of: theItem) {
                                data.items.remove(at: ndx)
                            }
                        }
                    }
            }
            .navigationBarTitle("Metingen")
            .navigationBarItems(trailing: EditButton())
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    if (data.items.count >= 3){ //Geef de knop om de grafiek te zien pas weer als er meer dan 3 metingen zijn gedaan
                        Button(){
                            self.showGraph = true
                        } label: {
                            Image("graph")
                                .resizable()
                                .scaledToFit()
                                .padding(35)
                                
                        }
                        .frame(width: 120, height: 120, alignment: .center)
                        .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .shadow(color: .gray, radius: 2, x: 0, y: 5)                    .padding()
                                    )
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct Measurements_Previews: PreviewProvider {
    static var previews: some View {
        Measurements(data: Data())
    }
}

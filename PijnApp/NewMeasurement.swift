//
//  NewMeasurement.swift
//  PijnApp
//
//  Created by Casper on 29/10/2021.
//

import SwiftUI
import HealthKit

//NewMeasurement
//Deze pagina komt als 'sheet' naar boven als er op 'nieuwe meting wordt gedrukt.
//Alle vragen die aan de gebruiker gesteld worden staan in een 'Form'.
//Bovenaan die 'Form' staat een 'Picker' met de vraag "Ochtend of Avond?".
//Gebaseerd op die keuze laat de 'Form' andere vragen zien.
//Om het aantal stappen van die dag op te halen wordt er gebruik gemaakt van de class: HealthStore.

struct NewMeasurement: View {
    //Alle data die nodig is / ingevuld moet worden
    @ObservedObject var data: Data
    @Environment(\.presentationMode) var presentationMode
    @State private var pain: Double = 1
    @State private var sleep: Double = 1
    @State private var tiredness: Double = 1
    @State private var stress: Double = 1
    @State private var morningComment: String = ""
    @State private var eveningComment: String = ""
    @State private var stepsToday: Double = 0
    @State private var morningOrEvening: String = checkMorningOrEvening()
    @State private var dayOptions = ["Ochtend", "Avond"]
    
    
    
    private var healthStore: HealthStore?   //Healthstore is nodig voor het ophalen van het aantal gezette stappen
    //@State private var steps: [Step] = [Step]()
    init(data: Data){
        healthStore = HealthStore()
        self.data = data
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){    //Haalt het aantal stappen van vandaag op
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            stepsToday = Double(count ?? 0)
            
            //let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            //steps.append(step)
        }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Picker("Ochtend of Avond?", selection: $morningOrEvening){  //Keuze uit ochtendmetign of avondmeting.
                    ForEach(dayOptions, id: \.self){
                            Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                morningOrEvening == "Ochtend" ? Section(header: Text("Hoe goed heeft u geslapen vanacht?")){
                    HStack{
                        Text("0")
                        Slider(value: $sleep, in: 0...10, step: 1)
                        Text("10")
                    }
                } : nil
                morningOrEvening == "Avond" ? Section(header: Text("Hoeveel pijn ervaart u op dit moment?")){
                    HStack{
                        Text("0")
                        Slider(value: $pain, in: 0...10, step: 1)
                        Text("10")
                    }
                } : nil
                morningOrEvening == "Avond" ? Section(header: Text("Hoe vermoeid bent u op dit moment?")){
                    HStack{
                        Text("0")
                        Slider(value: $tiredness, in: 0...10, step: 1)
                        Text("10")
                    }
                } : nil
                morningOrEvening == "Avond" ? Section(header: Text("Hoeveel stress ervaart u op dit moment?")){
                    HStack{
                        Text("0")
                        Slider(value: $stress, in: 0...10, step: 1)
                        Text("10")
                    }
                } : nil
                morningOrEvening == "Avond" ? Section(header: Text("Aantal stappen vandaag")){
                    HStack{
                        stepsToday != 0 ? Text("\(stepsToday, specifier: "%.0f")") : Text("Onbekend")
                        Spacer()
                        Image(systemName: "info.circle").foregroundColor(.blue)
                    }
                    
                }
                .onAppear { //Vraag om toestemming voor het ophalen van het aantal stappen
                    if let healthStore = healthStore {
                        healthStore.requestAuthorization{ succes in
                            if succes {
                                healthStore.calculateSteps { statisticsCollection in
                                    if let statisticsCollection = statisticsCollection {
                                        updateUIFromStatistics(statisticsCollection)
                                    }
                                }
                            }
                        }
                    }
                } : nil
                morningOrEvening == "Avond" ? Section(header: Text("Overige opmerkingen:")){
                    TextField("", text: $eveningComment)
                } : nil
                morningOrEvening == "Ochtend" ? Section(header: Text("Overige opmerkingen:")){
                    TextField("", text: $morningComment)
                } : nil
                
                Section(header: Text("")){
                    HStack{
                        Spacer()
                        Button("Meting opslaan"){   //Slaat de meting op en gaat terug naar het main scherm
                            var item = isInArray()
                            if morningOrEvening == "Ochtend"{
                                item.sleep = self.sleep
                                item.morningComment = (morningComment != "" ? self.morningComment : nil)
                            } else {
                                item.pain = self.pain
                                item.tiredness = self.tiredness
                                item.stress = self.stress
                                item.eveningComment = (eveningComment != "" ? self.eveningComment : nil)
                                item.stepsToday = self.stepsToday
                            }
                            self.data.items.append(item)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    
                }
                
            }
            .navigationBarTitle("Nieuwe meting")
            .navigationBarItems(leading: Button("Terug"){
                self.presentationMode.wrappedValue.dismiss()
            }.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
        }
        .preferredColorScheme(.light)
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {  //Kijkt of 2 dagen dezelfde dag zijn
        //let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if Calendar.current.isDate(date1, inSameDayAs: date2) {
            return true
        } else {
            return false
        }
    }
    
    func isInArray() -> DataItem{   //Kijkt of vandaag al een meting is gedaan zodat deze vervangen wordt.
        for item in data.items {
            if isSameDay(date1: Date(), date2: item.date){
                let _ = print("ja")
                if let index = data.items.firstIndex(of: item) {
                    data.items.remove(at: index)
                }
                return item
            }
        }
        return DataItem(date: Date(), pain: nil, sleep: nil, tiredness: nil, stress: nil, morningComment: nil, eveningComment: nil, stepsToday: nil)
    }
    
    static func checkMorningOrEvening() -> String{  //Kijkt of het ochtend of avond is en kiest hiermee welk scherm getoond wordt.
        let calendar = Calendar.current
                  let now = Date()
                  let four_morning = calendar.date(
                    bySettingHour: 4,
                    minute: 0,
                    second: 0,
                    of: now)!

                  let two_midday = calendar.date(
                    bySettingHour: 14,
                    minute: 30,
                    second: 0,
                    of: now)!
                  if now >= four_morning && now <= two_midday{
                      return "Ochtend"
                  }
            return "Avond"
    }
    
}



struct NewMeasurement_Previews: PreviewProvider {
    static var previews: some View {
        NewMeasurement(data: Data())
    }
}

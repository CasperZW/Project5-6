//
//  Settings.swift
//  PijnApp
//
//  Created by Casper on 07/12/2021.
//

import SwiftUI

//Settings
//Bestaat uit een 'Form' met daarin:
//Een knop om testdate toe te voegen, dit zijn random getallen tussen 0-10 (of 0-12000 voor stappen).
//Een knop voor rechte grafieklijnen, dit veranderd de variabele 'lineSetting' die wordt gebruikt in MeasurementGraph.

struct Settings: View {
    @ObservedObject var data: Data
    @State private var morningNotificationTime = Date()
    var body: some View {
        Form{
            Section(footer: Text("Let op dit verwijderd alle data!")){  //Voegt data toe om alles goed te testen. dit moet verwijder worden als de app echt gebruikt gaat worden
                Button("Klik hier om testdata toe te voegen"){
                    data.items.removeAll()
                    for number in -10...0 {
                        let date = Date()
                        let fakeDate = Calendar.current.date(byAdding: .day, value: number, to: date)
                        data.items.append(DataItem(date: fakeDate!, pain: round(Double.random(in: 0...10)), sleep: round(Double.random(in: 0...10)), tiredness: round(Double.random(in: 0...10)), stress: round(Double.random(in: 0...10)), morningComment: nil, eveningComment: nil, stepsToday: round(Double.random(in: 0...12000))))
                    }
                }
            }
            Section{    //Optie om de grafieklijnen niet vloeind maar recht te maken
                Toggle("Rechte grafieklijnen", isOn: $data.lineSetting)
            }
            //Section{
                //DatePicker("Tijd ochtendmelding", selection: $morningNotificationTime, displayedComponents: .hourAndMinute)
            //}
        }
        .navigationBarTitle("Instellingen")
        .preferredColorScheme(.light)
    }
        
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(data: Data())
    }
}

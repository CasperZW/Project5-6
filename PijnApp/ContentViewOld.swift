//
//  ContentView.swift
//  PijnApp
//
//  Created by Casper on 29/10/2021.
//

import SwiftUI

struct ContentViewOld: View {
    @State private var newMeasurement = false
    var body: some View {
        ZStack{
            Image("achtergrond")
            VStack{
                Spacer()
                Spacer()
                VStack{
                Text("Welkom")
                    .font(.largeTitle)
                Text("\nKlik op de + om een meting toe te voegen")
                    .font(.subheadline)
                }
                .frame(width: 300, height: 120, alignment: .center)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                Spacer()
                HStack{
                    Spacer()
                    Spacer()
                    Button("+"){
                        newMeasurement.toggle()
                    }
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .frame(width: 75, height: 75, alignment: .center)
                    .background(Color.blue)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Spacer().frame(width: 450, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Spacer()
            }
        }.sheet(isPresented: $newMeasurement){
            NewMeasurement()
        }
    }
}

struct ContentViewOld_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewOld()
    }
}

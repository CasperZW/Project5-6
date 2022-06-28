//
//  Measurement.swift
//  PijnApp
//
//  Created by Casper on 16/11/2021.
//

import SwiftUI
import SwiftUICharts
import HealthKit

//MeasurementsGraph
//Hier wordt gebruik gemaakt van de SwiftUICharts package.
//Voor meer informatie over deze package kijk op https://github.com/willdale/SwiftUICharts
//Er is hier gekozen voor een MultiLineChart.
//Deze is weer opgebouwd uit normale LineCharts.
//Voor iedere soort informatie is daarvoor een LineChart gemaakt.
//Ook is voor iedere soort een knop gemaakt om deze aan of uit te zetten.

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct MeasurementsGraph: View{
    
    //@ObservedObject var measurements: Data
    @ObservedObject var measurements: Data
    public init(measurements: Data){
        self.measurements = measurements
    }
    
    @State private var showPain = true
    @State private var showSleep = true
    @State private var showStress = true
    @State private var showTiredness = true
    @State private var showSteps = true
    
    @State private var showGraph = true
    
    var body: some View {
        ZStack{
            Image("achtergrond")
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack{
                Text("Metingen")
                    .bold()
                    .font(.system(size: 35))
                    .padding()
                
                let painDataPoints = addPainData()
                let painData = LineDataSet(dataPoints: painDataPoints,
                legendTitle: "Pijn",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: (measurements.lineSetting == true ? .line : .curvedLine)))

                let stressDataPoints = addStressData()
                let stressData = LineDataSet(dataPoints: stressDataPoints,
                legendTitle: "Stress",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: (measurements.lineSetting == true ? .line : .curvedLine), strokeStyle: Stroke(dash: [6])))
                
                let sleepDataPoints = addSleepData()
                let sleepData = LineDataSet(dataPoints: sleepDataPoints,
                legendTitle: "Slaap",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .yellow), lineType: (measurements.lineSetting == true ? .line : .curvedLine), strokeStyle: Stroke(dash: [6])))
                
                let tirednessDataPoints = addTirednessData()
                let tirednessData = LineDataSet(dataPoints: tirednessDataPoints,
                legendTitle: "Vermoeidheid",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: (measurements.lineSetting == true ? .line : .curvedLine), strokeStyle: Stroke(dash: [6])))
                
                let stepsDataPoints = addStepsData()
                let stepsData = LineDataSet(dataPoints: stepsDataPoints,
                legendTitle: "Stappen",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .orange), lineType: (measurements.lineSetting == true ? .line : .curvedLine), strokeStyle: Stroke(dash: [6])))
                
                let emptyData = LineDataSet(dataPoints: painDataPoints,
                legendTitle: "Pijn",
                pointStyle: PointStyle(),
                style: LineStyle(lineColour: ColourStyle(colour: .clear), lineType: (measurements.lineSetting == true ? .line : .curvedLine)))
                
                let allData = MultiLineDataSet(dataSets: [
                    (showPain == true ? painData : emptyData),
                    (showSleep == true ? sleepData : emptyData),
                    (showStress == true ? stressData : emptyData),
                    (showTiredness == true ? tirednessData : emptyData),
                    (showSteps == true ? stepsData : emptyData)
                ])
                
                let gridStyleY  = GridStyle(numberOfLines: 11,
                                           lineColour   : Color(.lightGray).opacity(0.5),
                                           lineWidth    : 1,
                                           dash         : [8],
                                           dashPhase    : 0)
                let gridStyleX  = GridStyle(numberOfLines: measurements.items.count,
                                           lineColour   : Color(.lightGray).opacity(0.5),
                                           lineWidth    : 1,
                                           dash         : [8],
                                           dashPhase    : 0)
                
                let chartStyle = LineChartStyle(
                                            xAxisGridStyle      : gridStyleX,
                                            xAxisLabelPosition  : .bottom,
                                            xAxisLabelColour    : Color.primary,
                                            xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                            xAxisTitle          : "Datum",
                                            
                                            yAxisGridStyle      : gridStyleY,
                                            yAxisLabelPosition  : .leading,
                                            yAxisLabelColour    : Color.primary,
                                            yAxisNumberOfLabels : 11
                )
                
                let data = MultiLineChartData(dataSets: allData,
                    chartStyle: chartStyle)
                
                if showGraph {
                    MultiLineChart(chartData: data)
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data)
                        //.legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                        .padding()
                } else {
                    Text("")
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                }
                
                
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ]
                
                LazyVGrid(columns: columns){
                    Button{
                        showPain.toggle()
                        reloadGraph()
                    } label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.red)
                                .frame(width: 40, height: 3)
                            Text("Pijn").font(.system(size: 14)).frame(width: 100, alignment: .leading).foregroundColor(showPain ? .blue : .gray)
                        }
                    }
                    Button{
                        showSleep.toggle()
                        reloadGraph()
                    } label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.clear)
                                .frame(width: 40, height: 3)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [5])))
                                .foregroundColor(Color.yellow)
                            Text("Slaap").font(.system(size: 14)).frame(width: 100, alignment: .leading).foregroundColor(showSleep ? .blue : .gray)
                        }
                    }
                    Button{
                        showStress.toggle()
                        reloadGraph()
                    } label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.clear)
                                .frame(width: 40, height: 3)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [5])))
                                .foregroundColor(Color.blue)
                            Text("Stress").font(.system(size: 14)).frame(width: 100, alignment: .leading).foregroundColor(showStress ? .blue : .gray)
                        }
                    }
                    Button{
                        showTiredness.toggle()
                        reloadGraph()
                    } label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.clear)
                                .frame(width: 40, height: 3)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [5])))
                                .foregroundColor(Color.green)
                            Text("Vermoeidheid").font(.system(size: 14)).frame(width: 100, alignment: .leading).foregroundColor(showTiredness ? .blue : .gray)
                        }
                    }
                    Button{
                        showSteps.toggle()
                        reloadGraph()
                    } label: {
                        HStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.clear)
                                .frame(width: 40, height: 3)
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                            .stroke(style: StrokeStyle(lineWidth: 3, dash: [5])))
                                .foregroundColor(Color.orange)
                            Text("Stappen").font(.system(size: 14)).frame(width: 100, alignment: .leading).foregroundColor(showSteps ? .blue : .gray)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
    func reloadGraph(){
        showGraph = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            showGraph = true
        }
    }
    
    func addPainData() -> [LineChartDataPoint]{
        var painDataPoints: [LineChartDataPoint] = []
        for measurement in measurements.items {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let shortDate = formatter.string(from: measurement.date)
            if ( measurement.pain != nil ){
                painDataPoints.append(LineChartDataPoint(value: measurement.pain!, xAxisLabel: "\(shortDate)", description: "\(shortDate)"))
            }
        }
        return painDataPoints
    }
    
    func addSleepData() -> [LineChartDataPoint]{
        var sleepDataPoints: [LineChartDataPoint] = []
        for measurement in measurements.items {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let shortDate = formatter.string(from: measurement.date)
            if ( measurement.sleep != nil ){
                sleepDataPoints.append(LineChartDataPoint(value: measurement.sleep!, xAxisLabel: "\(shortDate)", description: "\(shortDate)"))
            }
        }
        return sleepDataPoints
    }
    
    func addStressData() -> [LineChartDataPoint]{
        var stressDataPoints: [LineChartDataPoint] = []
        for measurement in measurements.items {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let shortDate = formatter.string(from: measurement.date)
            if ( measurement.stress != nil ){
                stressDataPoints.append(LineChartDataPoint(value: measurement.stress!, xAxisLabel: "\(shortDate)", description: "\(shortDate)"))
            }
        }
        return stressDataPoints
    }
    
    func addTirednessData() -> [LineChartDataPoint]{
        var tirednessDataPoints: [LineChartDataPoint] = []
        for measurement in measurements.items {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let shortDate = formatter.string(from: measurement.date)
            if ( measurement.tiredness != nil ){
                tirednessDataPoints.append(LineChartDataPoint(value: measurement.tiredness!, xAxisLabel: "\(shortDate)", description: "\(shortDate)"))
            }
        }
        return tirednessDataPoints
    }
    
    func addStepsData() -> [LineChartDataPoint]{
        var stepsDataPoints: [LineChartDataPoint] = []
        for measurement in measurements.items {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            let shortDate = formatter.string(from: measurement.date)
            if ( measurement.stepsToday != nil ){
                var steps = measurement.stepsToday!
                if (steps >= 10000){
                    steps = 10000
                }
                stepsDataPoints.append(LineChartDataPoint(value: (steps / 1000), xAxisLabel: "\(shortDate)", description: "\(shortDate)"))
            }
        }
        return stepsDataPoints
    }
}

struct MeasurementsGraph_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementsGraph(measurements: Data())
    }
}

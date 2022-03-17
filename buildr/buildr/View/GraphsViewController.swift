//
//  File.swift
//  buildr
//
//  Created by Eli Yazdi on 3/16/22.
//

import Foundation
import UIKit
import Charts

class GraphsViewController : UIViewController{
//    @IBOutlet var accelChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        AccelChart.delegate = self
//        updateGraph()
    }
    
    func updateGraph(){
//        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
//        
//        
//        //here is the for loop
//        var t : Double = 0
//        for entry in PlateInterface.shared.data {
//
//            let value = ChartDataEntry(x: t, y: Double(entry.accelX!)) // here we set the X and Y status in a data chart entry
//            t += 100
//            lineChartEntry.append(value) // here we add it to the data set
//        }
//
//        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Accel X") //Here we convert lineChartEntry to a LineChartDataSet
//        line1.colors = [NSUIColor.blue] //Sets the colour to blue
//
//        let data = LineChartData() //This is the object that will be added to the chart
//        data.addDataSet(line1) //Adds the line to the dataSet
//        print(data)
        

//        accelChart.data = data //finally - it adds the chart data to the chart and causes an update
//        accelChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    
}

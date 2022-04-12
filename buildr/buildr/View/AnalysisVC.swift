//
//  AnalysisVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/7/22.
//

import Foundation
import UIKit
import Charts

class AnalysisVC : UIViewController{
    
    @IBOutlet weak var barPathChart: LineChartView!
    @IBOutlet weak var rawDataChart: LineChartView!
    @IBOutlet weak var timeUnderTensionLabel: UILabel!
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var romLabel: UILabel!
    
    var modelRepData : [Float] = []
    var testRepData : [Float] = []
    var rawData: [SensorData] = []
    
    var showingModelRep : Bool = false
    let data1 = LineChartData()
    let data2 = LineChartData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var testRepEntries  = [ChartDataEntry]()
        var modelRepEntries = [ChartDataEntry]()
        var rawDataEntries = [ChartDataEntry]()
        
        
        var t : Double = 0
        for entry in testRepData {

            let testRepValue = ChartDataEntry(x: t, y: Double(entry))
            t += 0.3
            testRepEntries.append(testRepValue)
        }
        
        t = 0
        for entry in modelRepData{
            let modelRepValue = ChartDataEntry(x: t, y: Double(entry))
            t += 0.3
            modelRepEntries.append(modelRepValue)
        }
        
        t = 0
        for entry in rawData{
            let rawDataValue = ChartDataEntry(x: t, y: Double(entry.accelY!))
            t+=0.1
            rawDataEntries.append(rawDataValue)
        }

        let testRepLine = LineChartDataSet(entries: testRepEntries, label: "Bar Path")
        testRepLine.colors = [NSUIColor.blue]
        testRepLine.circleRadius = 0
        testRepLine.drawValuesEnabled = false
        
        
        let rawDataLine = LineChartDataSet(entries: rawDataEntries, label: "Accel Y")
        rawDataLine.colors = [NSUIColor.blue]
        rawDataLine.circleRadius = 0
        rawDataLine.drawValuesEnabled = false
        
        let modelRepLine = LineChartDataSet(entries: modelRepEntries, label: "Model Rep")
        modelRepLine.colors = [NSUIColor.purple]
        modelRepLine.circleRadius = 0
        modelRepLine.drawValuesEnabled = false

//        let data = LineChartData()
        data1.addDataSet(testRepLine)
        data2.addDataSet(modelRepLine)
        
        let rawDataData = LineChartData()
        rawDataData.addDataSet(rawDataLine)
        
        barPathChart.drawGridBackgroundEnabled = false
        barPathChart.data = data1
        
        rawDataChart.drawGridBackgroundEnabled = false
        rawDataChart.data = rawDataData
        
        timeUnderTensionLabel.text = "Time under tension: " + String(format: "%.0f", Double(testRepData.count) * 0.3) + "s"
        
        
        for i in stride(from: 0, to: modelRepData.count - 1, by : 1){
            modelRepData[i] = abs(modelRepData[i])
        }
        for i in stride(from: 0, to: testRepData.count - 1, by : 1){
            testRepData[i] = abs(testRepData[i])
        }
        let modelRepMax = modelRepData.max()
        let testRepMax = testRepData.max()
        print(modelRepMax!)
        print(testRepMax!)
        romLabel.text = "Range of motion: " + String(format: "%.0f", min(100, (testRepMax!/modelRepMax!) * 100)) + "%"
    }
    
    
    @IBAction func chartAction(_ sender: Any) {
        if(!showingModelRep){
            barPathChart.data = data2
            chartButton.setTitle("Show Test Rep", for: .normal)
            showingModelRep = true
        }else{
            barPathChart.data = data1
            chartButton.setTitle("Show Model Rep", for: .normal)
            showingModelRep = false
        }
        
    }
}

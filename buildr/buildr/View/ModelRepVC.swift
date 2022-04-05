//
//  ModelRepVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/5/22.
//

import Foundation
import UIKit
import Charts

class ModelRepVC: UIViewController, PlateInterfaceDelegate{

    var plate : PlateInterface?
    var exercise : String = "Bench Press"
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var chart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = exercise
        
        plate?.interfaceDelegate = self
    }
    
    @IBAction func startButton(_ sender: Any) {
        if(!plate!.recording){
            plate?.startRecording()
            button.setTitle("Stop", for: .normal)
        }else{
            plate?.stopRecording()
            button.setTitle("Start", for: .normal)
        }
    }
    
    func didFinishRecording(displacements: [Float], rawData: [SensorData]) {
        //here is the for loop
        var t : Double = 0
        var DEntries  = [ChartDataEntry]()
        
//        DEntries.append(ChartDataEntry(x: 0, y: 0))
        for entry in displacements {

            let DValue = ChartDataEntry(x: t, y: -Double(entry))
//            let DValue = ChartDataEntry(x: t, y: Double(entry.accelY!))
            t += 0.1
            DEntries.append(DValue)
        }

        let DLine = LineChartDataSet(entries: DEntries, label: "Accel X")
        DLine.colors = [NSUIColor.blue]
        DLine.circleRadius = 0
        DLine.drawValuesEnabled = false
        

        let data = LineChartData()
        data.addDataSet(DLine)
        
        chart.drawGridBackgroundEnabled = false
        chart.data = data
    }
}

//
//  RecordingVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/7/22.
//

import Foundation
import UIKit

class RecordingVC : UIViewController, PlateInterfaceDelegate{
    
    var plate : PlateInterface?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var exercise : String = "Bench Press"
    var modelRep : [Float] = []
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var countdown = 5
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Your sensor plate is ready! You may now perform a set of " + exercise
        label.text = ""
        
        plate?.interfaceDelegate = self
    }
    
    
    @IBAction func startButtonAction(_ sender: Any) {
        if(!plate!.recording){
            startButton.isEnabled = false
            label.text = String(countdown)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }else{
            plate?.stopRecording()
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    func didFinishRecording(displacements: [Float], rawData: [SensorData]) {
        let analysisVC = self.storyboard?.instantiateViewController(withIdentifier: "AnalysisVC") as! AnalysisVC
        analysisVC.modelRepData = self.modelRep
        analysisVC.testRepData = displacements
        analysisVC.rawData = rawData
        
        self.navigationController?.pushViewController(analysisVC, animated: true)
    }
    
    @objc func timerAction(){
        if(countdown == 0){
            timer.invalidate()
            plate?.startRecording()
            startButton.setTitle("Stop", for: .normal)
            countdown = 5
            label.text = "Recording"
            startButton.isEnabled = true
        }else{
            countdown -= 1
            label.text = String(countdown)
        }
    }
    
    
}

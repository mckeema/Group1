//
//  ModelRepVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/5/22.
//

import Foundation
import UIKit

class ModelRepVC: UIViewController, PlateInterfaceDelegate{

    var plate : PlateInterface?
    var exercise : String = "Bench Press"
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var countdown = 5
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = exercise
        
        plate?.interfaceDelegate = self
        
        label.text = ""
    }
    
    @IBAction func startButton(_ sender: Any) {
        if(!plate!.recording){
            button.isEnabled = false
            label.text = String(countdown)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }else{
            plate?.stopRecording()
            button.setTitle("Start", for: .normal)
        }
    }
    
    func didFinishRecording(displacements: [Float], rawData: [SensorData]) {
        let recordingVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordingVC") as! RecordingVC
        recordingVC.exercise = self.exercise
        recordingVC.modelRep = displacements
        recordingVC.plate = self.plate
        self.navigationController?.pushViewController(recordingVC, animated: true)
    }
    
    @objc func timerAction(){
        if(countdown == 0){
            timer.invalidate()
            plate?.startRecording()
            button.setTitle("Stop", for: .normal)
            countdown = 5
            label.text = "Recording"
            button.isEnabled = true
        }else{
            countdown -= 1
            label.text = String(countdown)
        }
    }
}

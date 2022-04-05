//
//  WelcomeVC.swift
//  buildr
//
//  Created by Eli Yazdi on 3/17/22.
//

import Foundation
import UIKit

class SelectionVC : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var plate : PlateInterface?
    var pickerData: [String] = [String]()
    var selected : String = "Bench Press"
    
    @IBOutlet weak var exerciseSelector: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Bench Press", "Squat", "Deadlift", "Overhead Press"]
        
        exerciseSelector.delegate = self
        exerciseSelector.dataSource = self
    }
    
    
    @IBAction func continueBttn(_ sender: Any) {
        let modelRepVC = self.storyboard?.instantiateViewController(withIdentifier: "ModelRepVC") as! ModelRepVC
        modelRepVC.plate = plate
        modelRepVC.exercise = selected
        self.navigationController?.pushViewController(modelRepVC, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selected = pickerData[row]
    }
    
}

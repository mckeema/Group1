//
//  PairingVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/2/22.
//

import Foundation
import UIKit

class PairingVC: UIViewController{
    
    @IBOutlet weak var inputField: UITextField!
    @IBAction func inputChanged(_ sender: Any) {
        if(inputField.text?.count == 4){
            PlateInterface.shared.connectWithPin(inputField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

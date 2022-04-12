//
//  PairingVC.swift
//  buildr
//
//  Created by Eli Yazdi on 4/2/22.
//

import Foundation
import UIKit

class PairingVC: UIViewController, PlateConnectionDelegate{
    
    
    var plate = PlateInterface()
    
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBAction func inputChanged(_ sender: Any) {
        if(inputField.text?.count == 4){
            connectingLabel.isHidden = false
            plate.connectWithPin(inputField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plate.connectionDelegate = self
        
        
    }
    
    func plateDidConnnect() {
        let selectionVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        selectionVC.plate = plate
        print("Connected (delegate)")
        connectingLabel.text = "Connected!"
        self.navigationController?.pushViewController(selectionVC, animated: true)
    }
    
}

//
//  ViewController.swift
//  buildr
//
//  Created by Eli Yazdi on 3/15/22.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var centralManager: CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

}

extension ViewController :  CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
           central.scanForPeripherals(withServices: nil, options: nil)
           print("Scanning...")
        }
    }
        
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      guard peripheral.name != nil else {return}
      
      if peripheral.name! == "Sensor Plate" {
      
        print("Sensor Found!")
        //stopScan
        cbCentralManager.stopScan()
        
        //connect
        cbCentralManager.connect(peripheral, options: nil)
        self.peripheral = peripheral
       
            }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      //discover all service
      
      peripheral.discoverServices(nil)
      peripheral.delegate = self

    }
}

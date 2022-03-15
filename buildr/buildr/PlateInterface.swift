//
//  PlateInterface.swift
//  buildr
//
//  Created by Eli Yazdi on 3/15/22.
//

import Foundation
import CoreBluetooth

final class PlateInterface: CBPeripheralDelegate, CBCentralManagerDelegate{
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    static let shared = PlateInterface()
    
    private init(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
}

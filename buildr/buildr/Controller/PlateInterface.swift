
//  ViewController.swift
//  buildr
//
//  Created by Eli Yazdi on 3/15/22.


import UIKit
import CoreBluetooth

final class PlateInterface: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    static let shared = PlateInterface()

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var rxCharacteristic: CBCharacteristic!
    private var recording : Bool = false
    var data : [SensorData] = []
    
    private var PIN : String?
    var connected : Bool = false
    
    private override init(){}
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", CBUUIDs.PlateServiceUUID);
            centralManager.scanForPeripherals(withServices: [CBUUIDs.PlateServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {


        // Connect!
        if(peripheral.name == PIN){
            self.centralManager.stopScan()

            // Copy the peripheral instance
            self.peripheral = peripheral
            self.peripheral.delegate = self
            self.centralManager.connect(self.peripheral, options: nil)
        }
        

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Plate")
            connected = true
            peripheral.discoverServices([CBUUIDs.PlateServiceUUID])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == CBUUIDs.PlateServiceUUID {
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([CBUUIDs.PlateCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == CBUUIDs.PlateCharacteristicUUID {
                    print("Sensor data characteristic found")
                    rxCharacteristic = characteristic

                    peripheral.setNotifyValue(true, for: rxCharacteristic!)
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {


        guard characteristic == rxCharacteristic,

        let characteristicValue = characteristic.value else { return }
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: characteristicValue, options: []) as? [String: Any] {
                // try to read out a string array
                var plateData : SensorData
                plateData = SensorData(accelX: Float(((json["accel"] as? [String: NSNumber])!)["y"]!),
                                       accelY: Float(((json["accel"] as? [String: NSNumber])!)["x"]!),
                                       accelZ: Float(((json["accel"] as? [String: NSNumber])!)["z"]!),
                                       gyroX: Float(((json["gyro"] as? [String: NSNumber])!)["x"]!),
                                       gyroY: Float(((json["gyro"] as? [String: NSNumber])!)["y"]!),
                                       gyroZ: Float(((json["gyro"] as? [String: NSNumber])!)["z"]!),
                                       vibration: 0)
                
                if recording{data.append(plateData)}
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
//        print("Value Recieved: \((characteristicASCIIValue as String))")
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral{
            print("Disconnected")
            self.peripheral = nil
            centralManager.scanForPeripherals(withServices: [CBUUIDs.PlateServiceUUID],
                                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func startRecording(){
        recording = true
        data = []
    }
    
    func stopRecording(){
        recording = false
    }


    func connectWithPin(_ pin : String){
        self.PIN = pin
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

}

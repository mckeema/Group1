//
//  ViewController.swift
//  buildr
//
//  Created by Eli Yazdi on 3/15/22.
//

import UIKit
import CoreBluetooth
import Charts

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate{
    
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var rxCharacteristic: CBCharacteristic!
    private var recording : Bool = false
    var data : [SensorData] = []
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBAction func benchPressButton(_ sender: Any) {
        exerciseLabel.text = "Bench Press"
    }
    @IBAction func squatButton(_ sender: Any) {
        exerciseLabel.text = "Squat"
    }
    @IBAction func dlButton(_ sender: Any) {
        exerciseLabel.text = "Deadlift"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
    
    @IBAction func StartButton(_ sender: Any) {
        startRecording()
        startButtonOutlet.isEnabled = false
        stopButtonOutlet.isEnabled = true
    }
    
    
    @IBAction func StopButton(_ sender: Any) {
        stopRecording()
        var accelXEntries  = [ChartDataEntry]()
        var accelYEntries  = [ChartDataEntry]()
        var accelZEntries  = [ChartDataEntry]()
        stopButtonOutlet.isEnabled = false
        startButtonOutlet.isEnabled = true
        
        
        //here is the for loop
        var t : Double = 0
        for entry in data {

            let accelXValue = ChartDataEntry(x: t, y: Double(entry.accelX!))
            let accelYValue = ChartDataEntry(x: t, y: Double(entry.accelY!))
            let accelZValue = ChartDataEntry(x: t, y: Double(entry.accelZ!))
            t += 100
            accelXEntries.append(accelXValue)
            accelYEntries.append(accelYValue)
            accelZEntries.append(accelZValue)
        }

        let accelXLine = LineChartDataSet(entries: accelXEntries, label: "Accel X")
        accelXLine.colors = [NSUIColor.blue]
        accelXLine.circleRadius = 0
        accelXLine.drawValuesEnabled = false
        
        let accelYLine = LineChartDataSet(entries: accelYEntries, label: "Accel Y")
        accelYLine.colors = [NSUIColor.purple]
        accelYLine.circleRadius = 0
        accelYLine.drawValuesEnabled = false
        
        let accelZLine = LineChartDataSet(entries: accelZEntries, label: "Accel Z")
        accelZLine.colors = [NSUIColor.red]
        accelZLine.circleRadius = 0
        accelZLine.drawValuesEnabled = false

        let data = LineChartData()
        data.addDataSet(accelXLine)
        data.addDataSet(accelYLine)
        data.addDataSet(accelZLine)
        
        chartView.drawGridBackgroundEnabled = false
        chartView.data = data
        
    }
    
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

        print("Found")
        
        // We've found it so stop scan
        self.centralManager.stopScan()

        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self

        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Plate")
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
                    statusLabel.text = "Connected"
                    startButtonOutlet.isEnabled = true
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
            startButtonOutlet.isEnabled = false
            stopButtonOutlet.isEnabled = false
            self.peripheral = nil
            centralManager.scanForPeripherals(withServices: [CBUUIDs.PlateServiceUUID],
                                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            statusLabel.text = "Connecting..."
        }
    }
    
    func startRecording(){
        recording = true
        data = []
        statusLabel.text = "Recording"
    }
    
    func stopRecording(){
        recording = false
        statusLabel.text = "Connected"
    }
    
}

//
//  SensorData.swift
//  buildr
//
//  Created by Eli Yazdi on 3/16/22.
//

import Foundation

struct SensorData{
    struct accel{
        var x: Float?
        var y: Float?
        var z: Float?
    }
    struct gyro{
        var x: Float?
        var y: Float?
        var z: Float?
    }
    var vibration: Float?
}

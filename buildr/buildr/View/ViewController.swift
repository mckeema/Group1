//
//  ViewController.swift
//  buildr
//
//  Created by Eli Yazdi on 3/15/22.
//

import UIKit

class ViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func StartButton(_ sender: Any) {
        PlateInterface.shared.startRecording()
    }
    
    
    @IBAction func StopButton(_ sender: Any) {
        PlateInterface.shared.stopRecording()
        let graphsView = GraphsViewController()
        self.present(graphsView, animated: true)
    }
    
}

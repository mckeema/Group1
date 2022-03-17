//
//  WelcomeVC.swift
//  buildr
//
//  Created by Eli Yazdi on 3/17/22.
//

import Foundation
import UIKit

class WelcomeVC : UIViewController{
    
    @IBAction func continueBttn(_ sender: Any) {
        let selectionVC = SelectionVC()
        self.navigationController?.pushViewController(selectionVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
    }
    
    
}

//
//  MapViewController.swift
//  Places
//
//  Created by Luis on 10/13/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var place : Place!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Mapa: "+place.name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

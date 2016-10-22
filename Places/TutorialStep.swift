//
//  TutorialStep.swift
//  Places
//
//  Created by Luis on 10/21/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import Foundation
import UIKit

class TutorialStep: NSObject {
    var index = 0
    var heading = ""
    var content = ""
    var image : UIImage!
    
    init(index: Int, heading: String, content: String, image: UIImage){
        self.index = index
        self.heading = heading
        self.content = content
        self.image = image
        
    }
}

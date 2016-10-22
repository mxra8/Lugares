//
//  TutorialContentViewController.swift
//  Places
//
//  Created by Luis on 10/21/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    
    
    var tutoritalStep: TutorialStep!
    @IBOutlet var pageContent: UIPageControl!
    
    @IBOutlet var nexButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.tutoritalStep.heading
        self.contentImageView.image = self.tutoritalStep.image
        self.contentLabel.text = self.tutoritalStep.content
        self.pageContent.currentPage = self.tutoritalStep.index
        
        switch self.tutoritalStep.index {
        case 0...1:
            self.nexButton.setTitle("Siguiente", for: .normal)
        case 2:
            self.nexButton.setTitle("Empezar", for: .normal)
        default:
            break
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextPress(_ sender: UIButton) {
        
        switch self.tutoritalStep.index {
        case 0...1:
            let pageVC = parent as! TutorialViewController
            
            pageVC.forward(toIndex: self.tutoritalStep.index)
        case 2:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "hasViewTutorial")
            
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    
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

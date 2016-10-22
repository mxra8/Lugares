//
//  TutorialViewController.swift
//  Places
//
//  Created by Luis on 10/21/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    
    var tutorialSteps : [TutorialStep] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstStep = TutorialStep(index: 0, heading: "Personaliza", content: "Crea y ve lugares", image: #imageLiteral(resourceName: "tuto-intro-1"))
        self.tutorialSteps.append(firstStep)
        
        let secondStep = TutorialStep(index: 1, heading: "Encuentra", content: "Úbica y encuentra tus lugares favoritos", image: #imageLiteral(resourceName: "tuto-intro-2"))
        self.tutorialSteps.append(secondStep)
        
        let thirdStep = TutorialStep(index: 2, heading: "Descubre", content: "Descubre lugares increibles", image: #imageLiteral(resourceName: "tuto-intro-3"))
        self.tutorialSteps.append(thirdStep)
        
        dataSource = self
        
        if let startVC = self.pageViewController(atIndex: 0){
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
        
        

        // Do any additional setup after loading the view.
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

extension TutorialViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContentViewController).tutoritalStep.index
        index += 1
        
        
        return self.pageViewController(atIndex: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialContentViewController).tutoritalStep.index
        index -= 1
        
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(atIndex: Int) -> TutorialContentViewController? {
        if atIndex == NSNotFound || atIndex < 0 || atIndex >= self.tutorialSteps.count {
            return nil
        }
        
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughtPageContent") as? TutorialContentViewController {
            
            pageContentVC.tutoritalStep = self.tutorialSteps[atIndex]
            
            return pageContentVC
        }
        
        print("mxra8:3")
        
        return nil
    }
    
    func forward(toIndex: Int) {
        if let nextVC = self.pageViewController(atIndex: toIndex + 1) {
            self.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.tutorialSteps.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageContentVC  = storyboard?.instantiateViewController(withIdentifier: "WalkthroughtPageContent") as? TutorialContentViewController {
            if let tutorialStep = pageContentVC.tutoritalStep {
                return pageContentVC.tutoritalStep.index
            }
        }
        
        return 0
    }*/
}

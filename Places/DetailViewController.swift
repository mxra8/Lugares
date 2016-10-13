//
//  DetailViewController.swift
//  Mis Recetas
//
//  Created by Luis on 9/28/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var ratingButton: UIButton!
    
    var place : Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = place.name
        
        self.placeImageView.image = self.place.image
        
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destination = segue.destination as! MapViewController
            destination.place = self.place
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func close(segue: UIStoryboardSegue){
        if let reviewVC = segue.source as? ReviewViewController {
            if let rating = reviewVC.ratingSelected {
                self.ratingButton.setImage(UIImage(named: rating), for: .normal)
            }
        }
    }
    
    

}

extension DetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailViewCell", for: indexPath) as! PlaceDetailViewCell
        
        cell.backgroundColor = UIColor.clear
        
        
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Nombre: "
                cell.valueLabel.text = self.place.name
            case 1:
                cell.keyLabel.text = "Tiempo: "
                cell.valueLabel.text = self.place.type
            case 2:
                cell.keyLabel.text = "Localización: "
                cell.valueLabel.text = self.place.location
            case 3:
                cell.keyLabel.text = "Telefono: "
                cell.valueLabel.text = self.place.telephone
            case 4:
                cell.keyLabel.text = "Web: "
                cell.valueLabel.text = self.place.website
            default:
                break
            }
        
        
        
        return cell;
    }
    /*
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case 1:
            title = "Ingredientes"
        case 2:
            title = "Pasos"
        default:
            break
        }
        
        return title;
    }
 */
    
    
}

extension DetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            self.performSegue(withIdentifier: "showMap", sender: nil)
            
        default:
            break;
        }
    }

}

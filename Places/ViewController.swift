//
//  ViewController.swift
//  Mis Recetas
//
//  Created by Luis on 9/22/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var places : [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        var place = Place(name: "Alexanderplatz", type: "Plaza", location: "10178 Berlin, Germany", image: #imageLiteral(resourceName: "alexanderplatz"), telephone: "(915) 098 65 74", website: "http://diario.mx")
        places.append(place)
        
        place = Place(name: "Atomium", type: "Museo", location: "Avenue de l'Atomium, 1020 Bruxelles, Belgium", image: #imageLiteral(resourceName: "atomium"), telephone: "(915) 098 65 75", website: "http://mobile.diario.mx")
        places.append(place)
        
        place = Place(name: "Big Ben", type: "Monumento", location: "London SW1A 0AA, United Kingdom", image: #imageLiteral(resourceName: "bigben"), telephone: "(915) 098 65 76", website: "http://google.com")
        places.append(place)
        
        place = Place(name: "Cristo Redentor", type: "Monumento", location: "Parque Nacional da Tijuca - Alto da Boa Vista, Rio de Janeiro - RJ, Brazil", image: #imageLiteral(resourceName: "cristoredentor"), telephone: "(915) 098 65 77", website: "http://facebook.com")
        places.append(place)
        
        place = Place(name: "Torre Eiffel", type: "Monumento", location: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France", image: #imageLiteral(resourceName: "torreeiffel"), telephone: "(915) 098 65 78", website: "http://twitter.com")
        places.append(place)
        
        place = Place(name: "Muralla China", type: "Monumento", location: "Great Wall, Mutianyu Beijing China", image: #imageLiteral(resourceName: "murallachina"), telephone: "(915) 098 65 79", website: "http://github.com")
        places.append(place)
        
        place = Place(name: "Torre de Pisa", type: "Monumento", location: "836 Avenida Campo Rico, San Juan, PR 00924, Puerto Rico", image: #imageLiteral(resourceName: "torrepisa"), telephone: "(915) 098 65 80", website: "http://bitbucket.com")
        places.append(place)
        
        place = Place(name: "La Seu de Mallorca", type: "Monumento", location: "La Seu Plaza de la Seu 5 07001 Palma Baleares, España", image: #imageLiteral(resourceName: "mallorca"), telephone: "(915) 098 65 81", website: "http://slack.com")
        places.append(place)
        
        // navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        let cellID = "PlaceCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlaceCell
        
        cell.thumbnailImageView.image = place.image
        cell.nameLabel.text = place.name
        cell.timeLabel.text = place.type
        cell.ingridientsLabel.text = place.location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            self.places.remove(at: indexPath.row)
        }
        
        //self.tableView.reloadData()
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Compartir
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let place = self.places[indexPath.row]
            
            let shareDefaultText = "Estoy visitando \(place.name) en la App del cusro de iOS 10"
            let activityController = UIActivityViewController(activityItems: [shareDefaultText, place.image], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            
        }
        
        shareAction.backgroundColor = UIColor(red: 30.0/255.0, green: 164.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        // Borrar
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.places.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        return [shareAction, deleteAction]
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedPlace = self.places[indexPath.row]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.place = selectedPlace
                
            }
            
        }
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
    }
    
    
}


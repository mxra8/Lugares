//
//  ViewController.swift
//  Mis Recetas
//
//  Created by Luis on 9/22/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var places : [Place] = []
    var searchResults : [Place] = []
    var fetchResultsController : NSFetchedResultsController<Place>!
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar lugares"
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.barTintColor = UIColor.darkGray
        
        
        
        
        let fetchRequest : NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                self.places = fetchResultsController.fetchedObjects!
                
                let defaults = UserDefaults.standard
                if !defaults.bool(forKey: "hasLoadedDefaultInfo") {
                    self.loadDefaultData()
                    defaults.set(true, forKey: "hasLoadedDefaultInfo")
                }
                
                if self.places.count < 6 {
                    //self.loadDefaultData()
                }
                
            } catch {
                print ("Error \(error)")
            }
            
        }
        
        
        /*
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            let request : NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
            //let request : NSFetchRequest<Place> = Place.fetchRequest() as! NSFetchRequest<Place>
            do {
                self.places = try context.fetch(request)
                //self.tableView.reloadData()
                
            } catch {
                print("Error \(error)")
            }
        }
 */
        
        
        // navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        
        let hasViewTutorial = defaults.bool(forKey: "hasViewTutorial")
        
        if hasViewTutorial {
            return
        }
        
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughtController") as? TutorialViewController {
            self.present(pageVC, animated: true, completion: nil)
        }
    }
    
    func loadDefaultData() {
        let names = ["Alexanderplatz", "Atomium", "Big Ben", "Gran Muralla", "Torre Eiffel", "Torre de Pisa"]
        let types = ["Plaza", "Museo", "Monumento", "Monumento", "Monumento", "Monumento"]
        let locations = ["10178 Berlin, Avenue de l'Atomium, 1020 Bruxelles, Belgium", "London SW1A 0AA, United Kingdom", "Parque Nacional da Tijuca - Alto da Boa Vista, Rio de Janeiro - RJ, Brazil", "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France", "Great Wall, Mutianyu Beijing China", "836 Avenida Campo Rico, San Juan, PR 00924, Puerto Rico"]
        let telephones = ["(915) 098 65 74", "(915) 098 65 74", "(915) 098 65 74", "(915) 098 65 74", "(915) 098 65 74", "(915) 098 65 74"]
        let websites = ["http://diario.mx", "http://mobile.diario.mx", "http://google.com", "http://facebook.com", "http://twitter.com", "http://github.com"]
        let images = [#imageLiteral(resourceName: "alexanderplatz"), #imageLiteral(resourceName: "atomium"), #imageLiteral(resourceName: "bigben"), #imageLiteral(resourceName: "murallachina"), #imageLiteral(resourceName: "torreeiffel"), #imageLiteral(resourceName: "torrepisa")]
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            
            
            for i in 0..<names.count {
                let place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place
                
                place?.name = names[i]
                place?.type = types[i]
                place?.location = locations[i]
                place?.telephone = telephones[i]
                place?.website = websites[i]
                place?.rating = "rating"
                
                place?.image = UIImagePNGRepresentation(images[i]) as NSData?
            }
            
            do {
                try context.save()
            } catch {
                print("Error al guardar")
            }
        }
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
        if self.searchController.isActive {
            return self.searchResults.count
        } else {
            return self.places.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place : Place!
        
        if self.searchController.isActive {
            place = self.searchResults[indexPath.row]
        } else {
            place = self.places[indexPath.row]
        }
        
        
        
        let cellID = "PlaceCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlaceCell
        
        cell.thumbnailImageView.image = UIImage(data: place.image! as Data)
        cell.nameLabel.text = place.name
        cell.timeLabel.text = place.type
        cell.ingridientsLabel.text = place.location
        
        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            self.places.remove(at: indexPath.row)
        }
        
        //self.tableView.reloadData()
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }*/
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Compartir
        let shareAction = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            
            let place : Place!
            
            if self.searchController.isActive {
                place = self.searchResults[indexPath.row]
            } else {
                place = self.places[indexPath.row]
            }
            
            let shareDefaultText = "Estoy visitando \(place.name) en la App del cusro de iOS 10"
            let activityController = UIActivityViewController(activityItems: [shareDefaultText, UIImage(data: place.image! as Data)!], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            
        }
        
        shareAction.backgroundColor = UIColor(red: 30.0/255.0, green: 164.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        // Borrar
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            /*
            self.places.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
 */
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                let context = container.viewContext
                let placeToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(placeToDelete)
                
                do {
                    try context.save()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        return [shareAction, deleteAction]
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let place : Place!
                
                if self.searchController.isActive {
                    place = self.searchResults[indexPath.row]
                } else {
                    place = self.places[indexPath.row]
                }
                
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.place = place
                
            }
            
        }
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToMainViewController" {
            if let addPlaceVC = segue.source as? AddPlaceTableViewController {
                if let newPlace = addPlaceVC.place {
                    self.places.append(newPlace)
                
                    //self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.places.filter({ (place) -> Bool in
            let nameToFind = place.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return nameToFind != nil
        })
        
        
        
    }
    
    
}

extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .right)
            }
            
        case .move:
            if let indexPath = indexPath,
                let newIndexPath = newIndexPath {
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
        
        self.places = controller.fetchedObjects as! [Place]
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}



extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
}


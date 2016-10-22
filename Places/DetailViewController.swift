//
//  DetailViewController.swift
//  Mis Recetas
//
//  Created by Luis on 9/28/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var ratingButton: UIButton!
    
    var place : Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = place.name
        
        self.placeImageView.image = UIImage(data: self.place.image! as Data)
        
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let image = UIImage(named: self.place.rating!)
        self.ratingButton.setImage(image, for: .normal)
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
                self.place.rating = rating
                self.ratingButton.setImage(UIImage(named: self.place.rating!), for: .normal)
                
                if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                    let context = container.viewContext
                    do {
                        try context.save()
                    } catch {
                        print("Error: \(error)")
                    }
                }
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
        case 3:
            let alertController = UIAlertController(title: "Contactar con: \(self.place.name)", message: "¿Cómo quieres contactar con el número \(self.place.telephone!)", preferredStyle: .actionSheet)
            
            let callAction = UIAlertAction(title: "Llamar", style: .default, handler: { (action) in
                if let phoneURL = URL(string: "tel://\(self.place.telephone!)") {
                    let app = UIApplication.shared
                    
                    if app.canOpenURL(phoneURL) {
                        app.open(phoneURL, options: [:], completionHandler: nil)
                    }
                }
            })
            alertController.addAction(callAction)
            
            let smsAction = UIAlertAction(title: "Mensaje", style: .default, handler: { (action) in
                if MFMessageComposeViewController.canSendText() {
                    let msg = "Hola desde la app de Places created by mxra8 en iOS 10"
                    let msgVC = MFMessageComposeViewController()
                    msgVC.body = msg
                    msgVC.recipients = [self.place.telephone!]
                    msgVC.messageComposeDelegate = self
                    self.present(msgVC, animated: true, completion: nil)
                }
            })
            alertController.addAction(smsAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        case 4:
            if let websiteURL = URL(string: self.place.website!) {
                let app = UIApplication.shared
                if app.canOpenURL(websiteURL){
                    app.open(websiteURL, options: [:], completionHandler: nil)
                }
                
            }
        default:
            break;
        }
    }

}

extension DetailViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        print(result)
    }
}

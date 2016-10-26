//
//  DiscoverTableViewController.swift
//  Places
//
//  Created by Luis on 10/25/16.
//  Copyright © 2016 DmxDigital. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var imageCache: NSCache = NSCache<CKRecordID, NSURL>()
    var lastCursor : CKQueryCursor?
    var hasLoadedInfo: Bool = false
    
    
    var places : [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        spinner.hidesWhenStopped = true
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.gray
        self.refreshControl?.backgroundColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(DiscoverTableViewController.loadDataFromiCloud), for: .valueChanged)
        
        self.loadDataFromiCloud()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromiCloud() {
        /*
        self.places.removeAll()
        self.tableView.reloadData()
        */
        let iCloudContainer = CKContainer.default()
        let publicDB = iCloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Place", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 3
        
        if self.lastCursor != nil {
            queryOperation.cursor = self.lastCursor
        } else if hasLoadedInfo {
            self.refreshControl?.endRefreshing()
            return
            //self.places.removeAll()
            //self.tableView.reloadData()
        }
        
        queryOperation.recordFetchedBlock = { (record: CKRecord?) in
            if let record = record {
                self.places.append(record)
            }
            
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            self.hasLoadedInfo = true
            self.lastCursor = cursor
            
            OperationQueue.main.addOperation({ 
                self.spinner.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            })
        }
        
        publicDB.add(queryOperation)
        
        
        
        // Load with Convenience API
        /*
        publicDB.perform(query, inZoneWith: nil) { (results, error) in
            print("Consulta de Lugares completada")
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            if let results = results {
                self.places = results
                
                OperationQueue.main.addOperation({ 
                    self.tableView.reloadData()
                })
            }
        }
        */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath)

        // Configure the cell...
        
        let place = self.places[indexPath.row]
        if let name = place.object(forKey: "name") as? String {
            cell.textLabel?.text = name
        }
        
        cell.imageView?.image = #imageLiteral(resourceName: "murallachina")
        
        if let imageFileURL = self.imageCache.object(forKey: place.recordID) {
            print("Imagen cargada de caché")
            cell.imageView?.image = UIImage(data: NSData(contentsOf: imageFileURL as URL) as! Data)
        } else {
            let publicDB = CKContainer.default().publicCloudDatabase
            let fetchImageOperation = CKFetchRecordsOperation(recordIDs: [place.recordID])
            
            fetchImageOperation.desiredKeys = ["image"]
            fetchImageOperation.queuePriority = .veryHigh
            fetchImageOperation.perRecordCompletionBlock = { (record: CKRecord?, recordID: CKRecordID?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                if let record = record {
                    OperationQueue.main.addOperation({
                        if let image = record.object(forKey: "image") {
                            let imageAsset = image as! CKAsset
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: place.recordID)
                            cell.imageView?.image = UIImage(data: NSData(contentsOf: imageAsset.fileURL) as! Data)
                        }
                    })
                }
            }
            /*
             if let image = place.object(forKey: "image") {
             let imageAsset = image as! CKAsset
             cell.imageView?.image = UIImage(data: NSData(contentsOf: imageAsset.fileURL) as! Data)
             }*/
            
            publicDB.add(fetchImageOperation)
        }
        
        

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

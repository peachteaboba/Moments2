//
//  ViewController.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
import CoreData

class MomentsViewController: UITableViewController, AddMomentDelegate, ShowDetailsDelegate, RefreshDataDelegate {

    
    // MARK: - Global Variables -----------------------------------------------------------------------------------------

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var momentsArray:[Moment] = []
    var imagesArray:[UIImage] = []
  

    // MARK: - UI Lifecycle ---------------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch all moments
        self.fetchAllMoments(state: "init")

        // Assign event handler for pull to refresh
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    // MARK: - Outlets and Actions --------------------------------------------------------------------------------------
    // Add button is pressed (Segues to the AddEditVC)
    @IBAction func handleAddButtonPressed(_ sender: UIBarButtonItem) {
        
        // Load up instance of destination nav controller
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditNC") as! UINavigationController
        
        // Target nav controller's VC and downcast as custom VC
        let vc = nvc.topViewController as! AddEditViewController
        
        // Setting data in destination VC
        vc.titleText = "Add a new moment"
        vc.addMomentDelegate = self
        
        // Make the transition
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

    
    
    // MARK: - Table view protocol methods -------------------------------------------------------------------------------
    // How many rows?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.momentsArray.count
    }
    
    // What does each row look like?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MomentTableViewCell

        // Set the model 
        cell.model = self.momentsArray[indexPath.row]
        
        // Set the image
        cell.myAwesomeImageView.image = self.imagesArray[indexPath.row]

        // Set the cell's delegate
        cell.showDetailsDelegate = self
    
        // Styles ----------------
        if(indexPath.row % 2 == 0){
            cell.myCrazyBackgroundView.backgroundColor = self.UIColorFromRGB(0x1C1C1C)
        } else {
            cell.myCrazyBackgroundView.backgroundColor = self.UIColorFromRGB(0x1F1F1F)
        }
    
        return cell
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.context.delete(self.momentsArray[indexPath.row])
        if self.context.hasChanges {
            do {
                try self.context.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        
        self.fetchAllMoments(state: "delete", index: indexPath.row)
        
        // Update cache and reload data
        self.momentsArray.remove(at: indexPath.row)
        self.imagesArray.remove(at: indexPath.row)
        self.tableView.reloadData()
        
    }
    
    // Clicked on a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Showing the details page when the row is tapped
        self.ShowDetailsPage(didFinishShowingMoment: self.momentsArray[indexPath.row], idx: indexPath.row)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Add Moment Protocol Method ----------------------------------------------------------------------
    func AddEditViewController(controller: AddEditViewController, didFinishAddingMoment moment: Moment) {

        if self.context.hasChanges {
            do {
                try self.context.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }

        // Add the new moment to the cache
        self.momentsArray.insert(moment, at: 0)
        
        // Add the new image to the front of the images array
        let image : UIImage = UIImage(data: moment.image as! Data)!
        self.imagesArray.insert(image, at: 0)

        // Reload table 
        self.tableView.reloadData()
    }
    

    
    
    
    
    
    // Helper functions :::::::::::::::::::::::::::::::::::::::::::
    func refresh(sender:AnyObject) {
        self.fetchAllMoments(state: "init")
        
        self.refreshControl?.endRefreshing()
    }
    
    
    func fetchAllMoments(state:String, index:Int? = nil) {
        let userRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Moment")
        do {
            let results = try context.fetch(userRequest)
            let tempArr = results as! [Moment]
            self.momentsArray = tempArr.reversed()
            
            // Convert NSData to UIImage and save in array ----------------------------------------
            if state == "init" {
                // Cache all images
                for moment in self.momentsArray {
                    // Assign the images in the cell
                    let image : UIImage = UIImage(data: moment.image as! Data)!
                    self.imagesArray.append(image)
                }
            }

        } catch {
            print("\(error)")
        }
        // Reload TV data
        self.tableView.reloadData()
    }
    
    


    
    
    // MARK: - Show Details Protocol Method ----------------------------------------------------------------------
    func ShowDetailsPage(didFinishShowingMoment moment: Moment, idx: Int) {
        
        // Load up instance of destination nav controller
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsNC") as! UINavigationController
        
        // Target nav controller's VC and downcast as custom VC
        let vc = nvc.topViewController as! ShowDetailsViewController
        
        // Setting data in destination VC
        vc.moment = moment
        vc.idx = idx
        vc.refreshDelegate = self
       
        
        // Make the transition
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    // MARK: - Refresh Data Protocol Method ----------------------------------------------------------------------
    func RefreshData(data: Moment, idx: Int) {

        // Use the data that you got back to update cache
        self.momentsArray[idx] = data
        
        // Update the editied image
        let image : UIImage = UIImage(data: data.image as! Data)!
        self.imagesArray[idx] = image
        
        // Reload data
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Helper Functions -------------------------------------------------------------------------------
    
    // Helper function to set colors with Hex values
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    


}


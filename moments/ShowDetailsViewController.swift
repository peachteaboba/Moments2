//
//  ShowDetailsViewController.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
import CoreData


class ShowDetailsViewController: UIViewController, AddMomentDelegate {
    
    
    // Variables --------------------------------------------------------------------------
    var moment:Moment?
    var idx:Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // Delegates
    var refreshDelegate: RefreshDataDelegate?
    
    
    
    
    
    // Outlets and Actions ----------------------------------------------------------------
    @IBAction func handelCancelButtonPressed(_ sender: UIBarButtonItem) {
        
        // Trigger delegate's protocol method
        self.refreshDelegate?.RefreshData(data: self.moment!, idx: self.idx!)
        
        // Pop view controller (it's returning the view controller being popped off)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    @IBAction func handelEditButtonPressed(_ sender: UIBarButtonItem) {
        
        // Load up instance of destination nav controller
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: "AddEditNC") as! UINavigationController
        
        // Target nav controller's VC and downcast as custom VC
        let vc = nvc.topViewController as! AddEditViewController
        
        // Setting data in destination VC
        vc.titleText = "Editing an existing moment"
        vc.addMomentDelegate = self
        vc.momentDetails = self.moment
        
        // Make the transition
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    // Delegate Protocol Methods
    func AddEditViewController(controller: AddEditViewController, didFinishAddingMoment moment: Moment) {
        
        print("done editing moment!")
        
        if self.context.hasChanges {
            do {
                try self.context.save()
                print("Success")
            } catch {
                print("\(error)")
            }
        }
        
        // Apply the changes to the current vc elements
        self.commentTextLabel.text = moment.comment
        
        let image : UIImage = UIImage(data: moment.image as! Data)!
        self.largeImage.image = image
//        self.largeImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        self.timeLabel.text = self.timeAgoSinceDate(date: (moment.timestamp)!, numericDates: true)

        
        
        // Set the new data 
        self.moment = moment
        
    }
    
    
    
    
    
    
    
    // MARK: - VC lifecycle ---------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set content
        let image : UIImage = UIImage(data: moment!.image as! Data)!
        self.largeImage.image = image
//        self.largeImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        self.commentTextLabel.text = moment?.comment
        self.timeLabel.text = self.timeAgoSinceDate(date: (moment?.timestamp)!, numericDates: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    // Helper Methods ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

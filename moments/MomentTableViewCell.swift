//
//  MomentTableViewCell.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {
    
    
    // Delegates -----------------------------
    var showDetailsDelegate: ShowDetailsDelegate?   // <----------------- (not being used)
    
    
    // Outlets & Actions ---------------------
    @IBOutlet weak var myAwesomeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var myCrazyBackgroundView: UIView!
   

    
    
    // Model -------------------------------
    private var _model:Moment?
    var model : Moment {
        set{
            _model = newValue
            
            // call function to set some controls
            setControls()
        }
        get {
            return _model!
        }
    }
    
    
    
    
    
    // Helper functions -----------------------
    func setControls(){
        
        // Assign the image in the cell
//        let image : UIImage = UIImage(data: _model!.image as! Data)!
//        self.myAwesomeImageView?.image = image
//        self.myAwesomeImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
        
        
        
        
        
        // Set the title text
        self.titleLabel.text = self._model?.comment
        
        // Set time
        self.timeLabel.text = self.timeAgoSinceDate(date: (self._model?.timestamp)!, numericDates: false)
         
    }
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

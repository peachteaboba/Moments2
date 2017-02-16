//
//  ShowDetailsDelegate.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
protocol ShowDetailsDelegate: class {
    
    func ShowDetailsPage(didFinishShowingMoment moment: Moment, idx: Int)
    
}


//
//  refreshDataDelegate.swift
//  moments
//
//  Created by Andy Feng on 12/8/16.
//  Copyright © 2016 Andy Feng. All rights reserved.
//

import UIKit
protocol RefreshDataDelegate: class {
    
    func RefreshData(data: Moment, idx: Int)
    
}

//
//  ScheduleView.swift
//  OpenStackSummit
//
//  Created by Claudio on 10/13/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import AFHorizontalDayPicker
import SwiftSpinner

class ScheduleView: UIView {
    @IBOutlet var view: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("ScheduleView", owner: self, options: nil)
        addSubview(self.view)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayPicker: AFHorizontalDayPicker!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
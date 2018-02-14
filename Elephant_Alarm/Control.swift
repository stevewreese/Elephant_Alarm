//
//  Control.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

//delegates of teh control
protocol ControlDelegate: class
{
    func saved(theIndex index: Int)

}


class Control
{
    weak var delegate: ControlDelegate? = nil
    init()
    {
        
    }
    
    func alarmSaved(AlarmIndex: Int)
    {
        delegate?.saved(theIndex: AlarmIndex)
    }

}

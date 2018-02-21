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
    func saved(theIndex index: Int, clock theTime: time, day Days: String)

}


class Control
{
    weak var delegate: ControlDelegate? = nil
    var theModel: Model = Model()
    
    init()
    {
        
    }
    
    func alarmSaved(AlarmIndex: Int, secs: Int, days: String)
    {
        delegate?.saved(theIndex: AlarmIndex, clock: theModel.calcTime(seconds: secs), day: days)
    }
    
    func getTime(secs: Int) -> time
    {
        return theModel.calcTime(seconds: secs)
    }
    
    func export(theViews: Array<AlarmView>)
    {
        theModel.export(views: theViews)
    }
    func startUp() -> Array<imported>
    {
        return theModel.startUp()
    }
    
    func alarmsTriggered(theViews: Array<AlarmView>) -> Array<String>
    {
        return theModel.checkAlarms(views: theViews)
    }
    
    func convertDays(days: String) -> Int
    {
        return theModel.getDayNumber(day: days)
    }

}

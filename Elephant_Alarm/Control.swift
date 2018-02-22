//
//  Control.swift
//  Elephant_Alarm
//  control the flow on info between the views and and model
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

//delegates of the control
protocol ControlDelegate: class
{
    func saved(theIndex index: Int, clock theTime: time, day Days: String)

}


class Control
{
    weak var delegate: ControlDelegate? = nil
    var theModel: Model = Model()
    
    //triggered when the save/back button is press in the alarm view
    func alarmSaved(AlarmIndex: Int, secs: Int, days: String)
    {
        delegate?.saved(theIndex: AlarmIndex, clock: theModel.calcTime(seconds: secs), day: days)
    }
    
    //get the number of seconds and returns a struct with the hour minute and seconds of the time
    func getTime(secs: Int) -> time
    {
        return theModel.calcTime(seconds: secs)
    }
    //tells the model to start the export
    func export(theViews: Array<AlarmView>)
    {
        theModel.export(views: theViews)
    }
    //tell the model to load the save data
    func startUp() -> Array<imported>
    {
        return theModel.startUp()
    }
    //tells the model to start counting the events
    func alarmsTriggered(theViews: Array<AlarmView>) -> Array<String>
    {
        return theModel.checkAlarms(views: theViews)
    }
    //converts the string day to a Int sunday = 1 monday = 2 tuesday = 3 wednesday = 4 thurs = 5 fri = 6 sat = 7
    func convertDays(days: String) -> Int
    {
        return theModel.getDayNumber(day: days)
    }

}

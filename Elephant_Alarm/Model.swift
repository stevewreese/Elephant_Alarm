//
//  Model.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import Foundation

struct time {
    var hour: String = ""
    var min: String = ""
    var sec: String = ""
    var timeDay: String = ""
    
}
struct imported
{
    var label: String
    var time: String
    init(label: String, time: String)
    {
        self.label = label
        self.time = time
    }
}



class Model
{
    let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    var filePath: String = ""
    
    init()
    {
        filePath = documentsPath + "/file.txt"
    }
    
    func calcTime(seconds : Int) -> time
    {
        var theTime = time()
        var alarmHour = seconds/3600
        var alarmMinute = seconds % 3600/60
        var alarmSec = seconds%60
        var addZeroMin: String = ""
        var addZeroHour: String = ""
        var addZeroSec: String = ""
        var timeOfDay: String = ""
        if(alarmHour > 12)
        {
            timeOfDay = "PM"
            alarmHour = alarmHour - 12
        }
        else if(alarmHour == 12)
        {
            timeOfDay = "PM"
        }
        else{
            timeOfDay = "AM"
            if(alarmHour == 0)
            {
                alarmHour = 12
            }
        }
        if(alarmMinute < 10)
        {
            addZeroMin = "0"
        }
        if(alarmHour < 10)
        {
            addZeroHour = "0"
        }
        if(alarmSec < 10)
        {
            addZeroSec = "0"
        }
        theTime.hour = "\(addZeroHour)\(alarmHour)"
        theTime.min = "\(addZeroMin)\(alarmMinute)"
        theTime.sec = "\(addZeroSec)\(alarmSec)"
        theTime.timeDay = timeOfDay
        return theTime
    }
    
    func export(views: Array<AlarmView>)
    {
        var toExport: String = ""
        for view in views {
            toExport = "\(toExport)\(view.EventName)_\(view.seconds)#"
            

            
        }
        print(toExport)
        let theNSExport: NSString = toExport as NSString
        print(theNSExport)
        try! theNSExport.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)

    }
    
    func startUp() ->Array<imported>
    {
        let listener: NSString = try! NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        let items = listener.components(separatedBy: "#")
        var importList : Array<imported> = Array()
        for item in items{
            
            let comp = item.components(separatedBy: "_")
            if(comp.count > 1)
            {
                var importStuff = imported(label: comp[0], time: comp[1])
                print("Cat heard \(comp[0])")
                print("Cat heard \(comp[1])")
                importList.append(importStuff)
            }

        }
        return importList
        
    }
}


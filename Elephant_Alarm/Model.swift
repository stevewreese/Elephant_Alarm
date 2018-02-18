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
    var day: String
    init(label: String, time: String, day: String)
    {
        self.label = label
        self.time = time
        self.day = day
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
            toExport = "\(toExport)\(view.EventName)_\(view.seconds)_\(view.Week_Day)#"
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
                var importStuff = imported(label: comp[0], time: comp[1], day: comp[2])
                print("Cat heard \(comp[0])")
                print("Cat heard \(comp[1])")
                importList.append(importStuff)
            }

        }
        return importList
        
    }
    
    func checkAlarms(views: Array<AlarmView>) -> Array<String>
    {
        var eventlist: Array<String> = Array()
        for view in views
        {
            if(checkClock(view: view))
            {
                eventlist.append(view.EventName)
            }
        }
        return eventlist
    }
    
    func checkClock(view: AlarmView) -> Bool
    {
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date as Date)
        hour = changeTimeZone(time: hour, zone: "\(view.TimeZone)")
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        
        let day = calendar.component(.weekday, from: date as Date)
        let alarmDay = getDayNumber(day: "\(view.Week_Day)")
        let currentDate = seconds + minutes * 60 + hour * 3600
        if(day >= alarmDay)
        {
            if(currentDate < view.seconds && day == alarmDay)
            {
                return false
            }
            else{
                return true
            }
        }
        else
        {
            return false
        }
        
        
        
    }
    
    //get the Number value of the day of the week
    func getDayNumber(day: String) -> Int
    {
        switch(day) {
        case "Saturday" :
            return 7
        case "Sunday"  :
            return 1
        case "Monday" :
            return 2
        case "Tuesday"  :
            return 3
        case "Wednesday" :
            return 4
        case "Thursday"  :
            return 5
        case "Friday" :
            return 6
        default:
            return 0
        }
    }
    
    //hacky work around to change time zone.
    func changeTimeZone(time: Int, zone: String) -> Int
    {
        //Hawaii, Alaska, Pacific, Mountain, Central, Eastern
        switch(zone) {
        case "Mountain" :
            return time
        case "Hawaii"  :
            return time - 3
        case "Alaska" :
            return time - 2
        case "Pacific" :
            return time - 1
        case "Central":
            return time + 1
        case "Eastern"  :
            return time + 2
        default:
            return time
        }
    }
}


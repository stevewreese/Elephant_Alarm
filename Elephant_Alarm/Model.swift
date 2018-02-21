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
    var zone: String
    var repeating: Int
    var date: String
    init(label: String, time: String, day: String, zone: String, repeating: Int, date: String)
    {
        self.label = label
        self.time = time
        self.day = day
        self.zone = zone
        self.repeating = repeating
        self.date = date
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
    
    func convertDays(days: [String]) -> String
    {
        var toReturn = ""
        for day in days{
            toReturn = toReturn + day
        }
        return toReturn
    }
    
    func export(views: Array<AlarmView>)
    {
        var toExport: String = ""
        for view in views {
            toExport = "\(toExport)\(view.EventName)_\(view.seconds)_\(view.Week_Day)_\(view.date)_\(view.TimeZone)_\(view.repeatVal)#"
        }
        print(toExport)
        let theNSExport: NSString = toExport as NSString
        print(theNSExport)
        try! theNSExport.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)

    }
    
    func convertToDigits(days: [String]) -> String
    {
        var result = ""
        var i = 0
        for day in days
        {
            if(i < days.count)
            {
                
                if(day == "")
                {
                    result = result + "0,"
                }
                else{
                    result = result + "1,"
                }
            }
            else{
                if(day == "")
                {
                    result = result + "0"
                }
                else{
                    result = result + "0"
                }
            }
            i = i + 1
        }
        return result
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
                var importStuff = imported(label: comp[0], time: comp[1], day: comp[2], zone: comp[4], repeating: Int (comp[5])!, date: comp[3])
//
                importList.append(importStuff)
            }

        }
        return importList
        
    }
    
    func checkAlarms(views: Array<AlarmView>) -> Array<String>
    {
        var eventlist: Array<String> = Array()
        var result : String = ""
        for view in views
        {
            let theTime = calcTime(seconds: view.seconds)
            var timesFired = timesAlerted(view: view) + view.timesTriggered
            view.timesTriggered = timesFired
            if(timesFired != 0)
            {
                if(!view.completed)
                {
                    result = "\(view.EventName) \(view.date) times fired: \(timesFired)"
                    eventlist.append(result)
                }
                
            }
            
        }
        return eventlist
    }
    
    func timesAlerted(view: AlarmView)-> Int
    {
        var date : Date? = nil
        date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        
        var viewDate = formatter.date(from: view.date)
        viewDate?.addTimeInterval(TimeInterval(view.seconds))
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date as! Date)
        hour = changeTimeZone(time: hour, zone: "\(view.TimeZone)")
        let minutes = calendar.component(.minute, from: date as! Date)
        let seconds = calendar.component(.second, from: date as! Date)
        
        let day = calendar.component(.weekday, from: date as! Date)
        let alarmDay = getDayNumber(day: "\(view.Week_Day)")
        let currentDate = seconds + minutes * 60 + hour * 3600
        let calendarNS = NSCalendar.current
        if(date! > viewDate!)
        {
            
            

                if(view.repeatVal == 0)
                {
                    let components = calendarNS.dateComponents([.day], from: viewDate!, to: date!)
                    return components.day! + 1
                }
                else if(view.repeatVal == 1)
                {
                    let components = calendarNS.dateComponents([.hour], from: viewDate!, to: date!)
                    return components.hour!
                }
                else
                {
                    let components = calendarNS.dateComponents([.minute], from: viewDate!, to: date!)
                    return components.minute!
                }
        
            
        }
        if(date! == viewDate!)
        {
            if(currentDate < view.seconds)
            {
                if(view.repeatVal == 0)
                {
                    return 1
                }
                else if(view.repeatVal == 1)
                {
                    let components = calendarNS.dateComponents([.hour], from: viewDate!, to: date!)
                    return components.hour!
                }
                else
                {
                    let components = calendarNS.dateComponents([.minute], from: viewDate!, to: date!)
                    return components.minute!
                }
            }
            
        }
        return 0
        
    }
    
    //TODO: fix this for time
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


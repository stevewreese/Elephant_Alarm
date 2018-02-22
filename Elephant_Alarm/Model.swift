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
    var week: String
    init(label: String, time: String, day: String, zone: String, repeating: Int, date: String, week: String)
    {
        self.label = label
        self.time = time
        self.day = day
        self.zone = zone
        self.repeating = repeating
        self.date = date
        self.week = week
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
            toExport = "\(toExport)\(view.EventName)_\(view.seconds)_\(view.Week_Day)_\(view.date)_\(view.TimeZone)_\(view.repeatVal)_\(convertToStringDigits(days: view.daysOfWeek))#"
        }
        //
       // 02.14.2018
        print(toExport)
        let theNSExport: NSString = toExport as NSString
        print(theNSExport)
        try! theNSExport.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)

    }
    
    
    
    func convertToDigits(week: String) -> [Int]
    {
        var result : [Int] = [0, 0, 0, 0, 0, 0, 0]
        let days = week.components(separatedBy: ",")
        var i = 0
        for day in days
        {
            if(day == "1")
            {
                result[i] = 1
            }
            i = i + 1
        }
        return result
    }
    
    func startUp() ->Array<imported>
    {
        var importList : Array<imported> = Array()
        do{
            let listener: NSString = try NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            let items = listener.components(separatedBy: "#")
            
            for item in items{
                
                let comp = item.components(separatedBy: "_")
                if(comp.count > 1)
                {
                    var importStuff = imported(label: comp[0], time: comp[1], day: comp[2], zone: comp[4], repeating: Int (comp[5])!, date: comp[3], week: comp[6])
                    //
                    importList.append(importStuff)
                }
                
            }
        }
        catch
        {
            
        }
        
        return importList
        
    }
    
    func checkAlarms(views: Array<AlarmView>) -> Array<String>
    {
        var eventlist: Array<String> = Array()
        var result : String = ""
        for view in views
        {
            var timesFired = 0
            let theTime = calcTime(seconds: view.seconds)
            if(!view.empty)
            {
                timesFired = timesAlerted(view: view) + view.timesTriggered
                view.timesTriggered = timesFired
            }
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
        let changeZone = changeTimeZone(zone: "\(view.TimeZone)")
        date?.addTimeInterval(changeZone)
        let day = calendar.component(.weekday, from: viewDate as! Date)
        //let currentDate = seconds + minutes * 60 + hour * 3600
        let calendarNS = NSCalendar.current
        
        if(view.daysOfWeek[day-1] == 0)
        {
            var i = day - 1
            var daysChecked = false
            while(i < 7)
            {
                if(view.daysOfWeek[i] == 0)
                {
                    viewDate?.addTimeInterval(TimeInterval(86400))
                }
                else
                {
                    daysChecked = true
                    i = 7
                }
                i = i + 1
            }
            var j = day - 1
            if(j > 0 && !daysChecked)
            {
                while(j > 0)
                {
                    if(view.daysOfWeek[j] == 0)
                    {
                        viewDate?.addTimeInterval(TimeInterval(86400))
                    }
                    else
                    {
                        daysChecked = true
                        j = 0
                    }
                    j = j - 1
                }
            }
            if(!daysChecked)
            {
                return 0
            }
        }
        
        if(date! >= viewDate!)
        {
            
            

                if(view.repeatVal == 0)
                {

                    var daysFired = 0
                    while(date! > viewDate!)
                    {
                        //let day = calendar.component(.weekday, from: viewDate as! Date)
                        if(view.daysOfWeek[day - 1] == 1)
                        {
                            daysFired = daysFired + 1
                        }
                        viewDate?.addTimeInterval(TimeInterval(86400))
                    }
                    return daysFired
                }
                else if(view.repeatVal == 1 )
                {
                    /*if(view.daysOfWeek[day-1] == 1)
                    {
                        let components = calendarNS.dateComponents([.hour], from: viewDate!, to: date!)
                        return components.hour!
                    }
                    var i = day - 1
                    var daysChecked = false
                    while(i < 7)
                    {
                        if(view.daysOfWeek[i] == 0)
                        {
                            viewDate?.addTimeInterval(TimeInterval(86400))
                        }
                        else
                        {
                            daysChecked = true
                            viewDate?.addTimeInterval(TimeInterval(86400))
                            i = 7
                        }
                        i = i + 1
                    }
                    var j = day - 1
                    if(j > 0 && !daysChecked)
                    {
                        while(j > 0)
                        {
                            if(view.daysOfWeek[j] == 0)
                            {
                                viewDate?.addTimeInterval(TimeInterval(86400))
                            }
                            else
                            {
                                daysChecked = true
                                viewDate?.addTimeInterval(TimeInterval(86400))
                                j = 0
                            }
                            j = j - 1
                        }
                    }
                    if(!daysChecked)
                    {
                        return 0
                    }*/
                    let components = calendarNS.dateComponents([.hour], from: viewDate!, to: date!)
                    return components.hour!
                }
                else
                {
                    
                    let components = calendarNS.dateComponents([.minute], from: viewDate!, to: date!)
                    return components.minute!
                }
        
            
        }
        return 0
        
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
    func changeTimeZone(zone: String) -> TimeInterval
    {
        //Hawaii, Alaska, Pacific, Mountain, Central, Eastern
        switch(zone) {
        case "Mountain" :
            return 0
        case "Hawaii"  :
            return 86400 * -3
        case "Alaska" :
            return 86400 *  -2
        case "Pacific" :
            return -86400
        case "Central":
            return 86400
        case "Eastern"  :
            return 86400 * 2
        default:
            return 0
        }
    }
    
    //convert week array to string representation
    func convertToStringDigits(days: [Int]) -> String
    {
        var result = ""
        var i = 0
        for day in days
        {
            if(i < days.count)
            {
                
                if(day == 0)
                {
                    result = result + "0,"
                }
                else{
                    result = result + "1,"
                }
            }
            else{
                if(day == 0)
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
}


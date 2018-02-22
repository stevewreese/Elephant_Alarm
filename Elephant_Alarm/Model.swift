//
//  Model.swift
//  Elephant_Alarm
// handle the logis for the app
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import Foundation

//struct to save and pass the time to the views
struct time {
    var hour: String = ""
    var min: String = ""
    var sec: String = ""
    var timeDay: String = ""
    
}

//struct of the information needed to load up the saved alarms
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
    //the file to be saved
    let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    var filePath: String = ""
    
    init()
    {
        filePath = documentsPath + "/file.txt"
    }
    
    //calulates the time withe given seconds
    func calcTime(seconds : Int) -> time
    {
        var theTime = time()
        var alarmHour = seconds/3600
        let alarmMinute = seconds % 3600/60
        let alarmSec = seconds%60
        var addZeroMin: String = ""
        var addZeroHour: String = ""
        var addZeroSec: String = ""
        var timeOfDay: String = ""
        //if past noon set to PM esle set to Am and convertr from military time
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
        //if single digit add leading zero to hour minutes and seconds
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
        //add to the struct
        theTime.hour = "\(addZeroHour)\(alarmHour)"
        theTime.min = "\(addZeroMin)\(alarmMinute)"
        theTime.sec = "\(addZeroSec)\(alarmSec)"
        theTime.timeDay = timeOfDay
        return theTime
    }
    
    //this save the needed information to a text file
    func export(views: Array<AlarmView>)
    {
        var toExport: String = ""
        //add the name, seconds, date, time zone, time repeated and days of the week every view has
        for view in views {
            toExport = "\(toExport)\(view.EventName)_\(view.seconds)_\(view.Week_Day)_\(view.date)_\(view.TimeZone)_\(view.repeatVal)_\(convertToStringDigits(days: view.daysOfWeek))#"
        }
        //convert to NSString
        let theNSExport: NSString = toExport as NSString
        //save to file
        try! theNSExport.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)

    }

    //converts the string day to a Int sunday = 1 monday = 2 tuesday = 3 wednesday = 4 thurs = 5 fri = 6 sat = 7
    //this is need for some calculations
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
    
    //takes the information form the text file and add it to a struct to be used by the view holder
    func startUp() ->Array<imported>
    {
        //a list of sturcts to pass to view holder
        var importList : Array<imported> = Array()
        //if file doesn't exist do nothing and return a empty array
        do{
            let listener: NSString = try NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            //seperate text by views
            let items = listener.components(separatedBy: "#")
            
            for item in items{
                //sperate the information of the views
                let comp = item.components(separatedBy: "_")
                if(comp.count > 6)
                {
                    let importStuff = imported(label: comp[0], time: comp[1], day: comp[2], zone: comp[4], repeating: Int (comp[5])!, date: comp[3], week: comp[6])
                    importList.append(importStuff)
                }
                
            }
        }
        catch
        {
            
        }
        //return the information to the view holder
        return importList
        
    }
    
    func checkAlarms(views: Array<AlarmView>) -> Array<String>
    {
        //an array of string to be displayed in the event table
        var eventlist: Array<String> = Array()
        var result : String = ""
        for view in views
        {
            var timesFired = 0
            //if view is not empty calculate the time the event was fired
            if(!view.empty)
            {
                timesFired = timesAlerted(view: view)
            }
            //if event was fired at least once show it in the event table
            if(timesFired != 0)
            {
                result = "\(view.EventName) \(view.date) times fired: \(timesFired)"
                eventlist.append(result)
            }
            
        }
        return eventlist
    }
    
    //counts the number of times the alarm went off
    func timesAlerted(view: AlarmView)-> Int
    {
        //get current date
        var date : Date? = nil
        date = Date()
        
        //formating of the date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        
        //get the event date
        var viewDate = formatter.date(from: view.date)
        //add the time
        viewDate?.addTimeInterval(TimeInterval(view.seconds))
        //this is need to get the component of each date
        let calendar = Calendar.current
        //changes the time zone of the
        let changeZone = changeTimeZone(zone: "\(view.TimeZone)")
        date?.addTimeInterval(changeZone)
        let day = calendar.component(.weekday, from: viewDate as! Date)
        let calendarNS = NSCalendar.current
        
        //if the day of the week of the view date isn't selected then find the next day of the week selected
        if(view.daysOfWeek[day-1] == 0)
        {
            //get index of the array
            var i = day - 1
            var daysChecked = false
            //check the days following
            while(i < 7)
            {
                //if next day isn't selected add 24 hours to the the view date
                if(view.daysOfWeek[i] == 0)
                {
                    viewDate?.addTimeInterval(TimeInterval(86400))
                }
                    //if it is quit
                else
                {
                    daysChecked = true
                    i = 7
                }
                i = i + 1
            }
            //this check the rest of the week example if the alarm date is a tues but sunday was selected wednesday-saturday is check then sunday and monday is checked adding 24 hours each time
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
            //if now day where check then reurnt zero
            if(!daysChecked)
            {
                return 0
            }
        }
        
        if(date! >= viewDate!)
        {
                //if alarm is only suppose to fire once a day
                if(view.repeatVal == 0)
                {
                    var daysFired = 0
                    //check every day that was selected fromt he alarm date to the current day
                    while(date! > viewDate!)
                    {
                        //if the day of the week was selected then add an event
                        if(view.daysOfWeek[day - 1] == 1)
                        {
                            daysFired = daysFired + 1
                        }
                        //go up by 24 hours
                        viewDate?.addTimeInterval(TimeInterval(86400))
                    }
                    return daysFired
                }
                //if hourly is selected then count the hours from the alarm date and time to current date adn time
                else if(view.repeatVal == 1 )
                {
                    
                    let components = calendarNS.dateComponents([.hour], from: viewDate!, to: date!)
                    return components.hour!
                }
                //if each minute is selected then count the minutes from the alarm date and time to current date and time
                else
                {
                    
                    let components = calendarNS.dateComponents([.minute], from: viewDate!, to: date!)
                    return components.minute!
                }
        
            
        }
        //the date and time is after the current date and time do not fire
        return 0
        
    }
    
    
    //converts the string day to a Int sunday = 1 monday = 2 tuesday = 3 wednesday = 4 thurs = 5 fri = 6 sat = 7 for indexing
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
            return 3600 * -3
        case "Alaska" :
            return 3600 *  -2
        case "Pacific" :
            return -3600
        case "Central":
            return 3600
        case "Eastern"  :
            return 3600 * 2
        default:
            return 0
        }
    }
    
    //convert week int array to string representation index 0 = sunday 1 = monday .... 6 = saturday
    //1 means true and 0 means false
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


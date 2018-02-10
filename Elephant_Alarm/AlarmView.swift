//
//  AlarmView.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class AlarmView : UIView
{
    var seconds: Int = 0
    var Week_Day = ""
    var alarmHour : Int = 0
    var alarmMinute : Int = 0
    var alarmSec : Int = 0
    var duration : Int = 0
    var TimeZone = ""
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addClock()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addClock()
    {
        
        alarmHour = seconds/3600
        alarmMinute = seconds % 3600/60
        alarmSec = seconds%60
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
        let red: CGFloat = 195/255
        let green: CGFloat = 93/255
        let blue: CGFloat = 4/255
        var myField: UITextField = UITextField (frame: CGRect(x: 100, y: 253, width: UIScreen.main.bounds.width, height: 50));
        myField.adjustsFontSizeToFitWidth = true
        myField.editingRect(forBounds: CGRect(x: 100, y: 253, width: UIScreen.main.bounds.width, height: 50))
        
        let myText = "\(addZeroHour)\(alarmHour):\(addZeroMin)\(alarmMinute):\(addZeroSec)\(alarmSec) \(timeOfDay)"
        
        myField.text = myText
        
        self.addSubview(myField)
  
    }
}

//
//  AlarmView.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class AlarmView : UIView, UITextFieldDelegate
{
    /*A set of enum values which represents the days of the week on which the alarm will occur.*/
    enum Alarm_Days {
        case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    }
    /*An enum value indicating which time zone the alarm occurs in.*/
    enum Alarm_Time_Zone
    {
        case Hawaii, Alaska, Pacific, Mountain, Central, Eastern
    }
    var seconds: Int = 0
    var Week_Day = Alarm_Days.Monday
    var alarmHour : Int = 0
    var alarmMinute : Int = 0
    var alarmSec : Int = 0
    var duration : Int = 0
    var TimeZone = Alarm_Time_Zone.Mountain
    var secondsAdded: Int = 0
    var minutesAdded : Int = 0
    
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .blue
        setupButtons()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect){
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(bounds)
        context.setFillColor((backgroundColor ?? UIColor.white).cgColor)
        context.fill(bounds)
        
        addClock()
        
        
        
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
        let placeText = "Add event name here"
        let placeholder = NSAttributedString(string: "\(placeText)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        var HourField: UITextField = UITextField (frame: CGRect(x: 0, y: 550, width: UIScreen.main.bounds.width, height: 50));
        HourField.attributedPlaceholder = placeholder
        HourField.textColor = UIColor.black
        HourField.delegate = self
        HourField.borderStyle = UITextBorderStyle.roundedRect
        HourField.allowsEditingTextAttributes = true
        self.addSubview(HourField)
        
        let red: CGFloat = 195/255
        let green: CGFloat = 93/255
        let blue: CGFloat = 4/255
        let rtDay = CGRect(x: 110, y: 167, width: 200, height: 40)
        
        let paragraphStyleDay = NSMutableParagraphStyle()
        paragraphStyleDay.alignment = .center
        let attributesDay = [NSAttributedStringKey.paragraphStyle  :  paragraphStyleDay,
                             NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                             NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                             ]
        
        let myTextDay = "\(Week_Day)"
        let attrStringDay = NSAttributedString(string: myTextDay,
                                               attributes: attributesDay)
        
        
        attrStringDay.draw(in: rtDay)
        setNeedsDisplay(rtDay)
        
        let rt = CGRect(x: 100, y: 253, width: 225, height: 40)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        //UIColor.black.set()
        //UIBezierPath(rect: rt).fill()
        let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                          NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                          NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                          ]
        
        let myText = "\(addZeroHour)\(alarmHour):\(addZeroMin)\(alarmMinute):\(addZeroSec)\(alarmSec) \(timeOfDay)"
        let attrString = NSAttributedString(string: myText,
                                            attributes: attributes)
        
        
        attrString.draw(in: rt)
        setNeedsDisplay(rt)
        
        let rtDuration = CGRect(x: 105, y: 360, width: 225, height: 40)
        let paragraphStyleDuration = NSMutableParagraphStyle()
        paragraphStyleDuration.alignment = .center
        
        let attributesDuration = [NSAttributedStringKey.paragraphStyle  :  paragraphStyleDuration,
                                  NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                                  NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                                  ]
        let durInt = (Int) (duration)
        let myTextDuration = "Duration \(durInt)"
        let attrStringDuration = NSAttributedString(string: myTextDuration,
                                                    attributes: attributesDuration)
        
        
        attrStringDuration.draw(in: rtDuration)
        setNeedsDisplay(rtDuration)
        
        let rtZone = CGRect(x: 95, y: 450, width: 225, height: 40)
        let paragraphStyleZone = NSMutableParagraphStyle()
        paragraphStyleZone.alignment = .center
        
        let attributesZone = [NSAttributedStringKey.paragraphStyle  :  paragraphStyleZone,
                              NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                              NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                              ]
        
        let myTextZone = "\(TimeZone) Time"
        let attrStringZone = NSAttributedString(string: myTextZone,
                                                attributes: attributesZone)
        
        
        attrStringZone.draw(in: rtZone)
        setNeedsDisplay(rtZone)
        
    }
    
    private func setupButtons() {
        
        let xBase = 100
        let yBase = 225
        
        //day Buttons
        let buttonChangeNextDay = UIButton(frame: CGRect(x: xBase + 220, y: yBase - 50, width: 25, height: 25))
        buttonChangeNextDay.backgroundColor = .cyan
        buttonChangeNextDay.layer.cornerRadius = 5
        buttonChangeNextDay.setTitleColor(.black, for: .normal)
        buttonChangeNextDay.setTitle("+", for: .normal)
        buttonChangeNextDay.addTarget(self, action: #selector(AlarmView.changeNextDay(sender:)), for: .touchUpInside)
        self.addSubview(buttonChangeNextDay)
        
        let buttonChangePrevDay = UIButton(frame: CGRect(x: xBase - 20, y: yBase - 50, width: 25, height: 25))
        buttonChangePrevDay.layer.cornerRadius = 5
        buttonChangePrevDay.backgroundColor = .cyan
        buttonChangePrevDay.setTitleColor(.black, for: .normal)
        buttonChangePrevDay.setTitle("-", for: .normal)
        buttonChangePrevDay.addTarget(self, action: #selector(AlarmView.changePrevDay(sender:)), for: .touchUpInside)
        self.addSubview(buttonChangePrevDay)
        
        //Time zone Buttons
        let buttonChangeNextZone = UIButton(frame: CGRect(x: xBase - 40, y: yBase + 233, width: 25, height: 25))
        buttonChangeNextZone.layer.cornerRadius = 5
        buttonChangeNextZone.backgroundColor = .cyan
        buttonChangeNextZone.setTitleColor(.black, for: .normal)
        buttonChangeNextZone.setTitle("+", for: .normal)
        buttonChangeNextZone.addTarget(self, action: #selector(AlarmView.changeNextZone(sender:)), for: .touchUpInside)
        self.addSubview(buttonChangeNextZone)
        
        let buttonChangePrevZone = UIButton(frame: CGRect(x: xBase + 230, y: yBase + 233, width: 25, height: 25))
        buttonChangePrevZone.layer.cornerRadius = 5
        buttonChangePrevZone.backgroundColor = .cyan
        buttonChangePrevZone.setTitleColor(.black, for: .normal)
        buttonChangePrevZone.setTitle("-", for: .normal)
        buttonChangePrevZone.addTarget(self, action: #selector(AlarmView.changePrevZone(sender:)), for: .touchUpInside)
        self.addSubview(buttonChangePrevZone)
        
        //Time buttons
        let buttonAddSec = UIButton(frame: CGRect(x: xBase + 115, y: yBase, width: 25, height: 25))
        buttonAddSec.layer.cornerRadius = 5
        buttonAddSec.backgroundColor = .cyan
        buttonAddSec.setTitleColor(.black, for: .normal)
        buttonAddSec.setTitle("+", for: .normal)
        buttonAddSec.addTarget(self, action: #selector(AlarmView.addSecond(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonAddSec)
        
        let buttonMinusSec = UIButton(frame: CGRect(x: xBase + 115, y: yBase + 75, width: 25, height: 25))
        buttonMinusSec.layer.cornerRadius = 5
        buttonMinusSec.backgroundColor = .cyan
        buttonMinusSec.setTitleColor(.black, for: .normal)
        buttonMinusSec.setTitle("-", for: .normal)
        buttonMinusSec.addTarget(self, action: #selector(AlarmView.subSecond(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonMinusSec)
        
        let buttonAddMin = UIButton(frame: CGRect(x: xBase + 65, y: yBase, width: 25, height: 25))
        buttonAddMin.layer.cornerRadius = 5
        buttonAddMin.backgroundColor = .cyan
        buttonAddMin.setTitleColor(.black, for: .normal)
        buttonAddMin.setTitle("+", for: .normal)
        buttonAddMin.addTarget(self, action: #selector(AlarmView.addMinute(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonAddMin)
        
        let buttonMinusMin = UIButton(frame: CGRect(x: xBase + 65, y: yBase + 75, width: 25, height: 25))
        buttonMinusMin.layer.cornerRadius = 5
        buttonMinusMin.backgroundColor = .cyan
        buttonMinusMin.setTitleColor(.black, for: .normal)
        buttonMinusMin.setTitle("-", for: .normal)
        buttonMinusMin.addTarget(self, action: #selector(AlarmView.subMinute(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonMinusMin)
        
        let buttonAddHour = UIButton(frame: CGRect(x: xBase + 15, y: yBase, width: 25, height: 25))
        buttonAddHour.layer.cornerRadius = 5
        buttonAddHour.backgroundColor = .cyan
        buttonAddHour.setTitleColor(.black, for: .normal)
        buttonAddHour.setTitle("+", for: .normal)
        buttonAddHour.addTarget(self, action: #selector(AlarmView.addHour(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonAddHour)
        
        let buttonMinusHour = UIButton(frame: CGRect(x: xBase + 15, y: yBase + 75, width: 25, height: 25))
        buttonMinusHour.layer.cornerRadius = 5
        buttonMinusHour.backgroundColor = .cyan
        buttonMinusHour.setTitleColor(.black, for: .normal)
        buttonMinusHour.setTitle("-", for: .normal)
        buttonMinusHour.addTarget(self, action: #selector(AlarmView.subHour(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonMinusHour)
        
        let buttonAMPM = UIButton(frame: CGRect(x: xBase + 175, y: yBase, width: 25, height: 25))
        buttonAMPM.layer.cornerRadius = 5
        buttonAMPM.backgroundColor = .cyan
        buttonAMPM.setTitleColor(.black, for: .normal)
        buttonAMPM.setTitle("+", for: .normal)
        buttonAMPM.addTarget(self, action: #selector(AlarmView.add12Hours(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonAMPM)
        
        let buttonPMAM = UIButton(frame: CGRect(x: xBase + 175, y: yBase + 75, width: 25, height: 25))
        buttonPMAM.layer.cornerRadius = 5
        buttonPMAM.backgroundColor = .cyan
        buttonPMAM.setTitleColor(.black, for: .normal)
        buttonPMAM.setTitle("-", for: .normal)
        buttonPMAM.addTarget(self, action: #selector(AlarmView.sub12Hours(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonPMAM)
        
        //Duration Buttons
        let buttonAddDur = UIButton(frame: CGRect(x: xBase + 175, y: yBase + 110, width: 25, height: 25))
        buttonAddDur.layer.cornerRadius = 5
        buttonAddDur.backgroundColor = .cyan
        buttonAddDur.setTitleColor(.black, for: .normal)
        buttonAddDur.setTitle("+", for: .normal)
        buttonAddDur.addTarget(self, action: #selector(AlarmView.addSecondDur(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonAddDur)
        
        let buttonMinusDur = UIButton(frame: CGRect(x: xBase + 175, y: yBase + 185, width: 25, height: 25))
        buttonMinusDur.layer.cornerRadius = 5
        buttonMinusDur.backgroundColor = .cyan
        buttonMinusDur.setTitleColor(.black, for: .normal)
        buttonMinusDur.setTitle("-", for: .normal)
        buttonMinusDur.addTarget(self, action: #selector(AlarmView.subSecondDur(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonMinusDur)
        
        
    }
    
    //add the seconds to the durations
    @objc func addSecondDur(sender: UIButton!)
    {
        duration = duration + 1
        overTimeDur()
        addClock()
    }
    
    @objc func subSecondDur(sender: UIButton!)
    {
        duration = duration - 1
        overTimeDur()
        addClock()
    }
    
    //make sure duration doesn't go over 120 seconds
    func overTimeDur()
    {
        if(duration <= 0)
        {
            duration = 120 + duration
            
        }
        else if(duration >= 121)
        {
            duration = duration - 121
            if(duration == 0)
            {
                duration = 1
            }
        }
        
        
    }
    
    //add or subtract hour minutes and seconds to time
    @objc func addSecond(sender: UIButton!)
    {
        
        if(secondsAdded != 59)
        {
            seconds = seconds + 1
            secondsAdded = secondsAdded + 1
        }
        else
        {
            seconds = seconds - 59
            secondsAdded = 0
        }
        addClock()
    }
    
    @objc func addMinute(sender: UIButton!)
    {
        if(minutesAdded != 59)
        {
            seconds = seconds + 60
            minutesAdded = minutesAdded + 1
        }
        else
        {
            seconds = seconds - (59*60)
            minutesAdded = 0
        }
        addClock()
    }
    
    @objc func addHour(sender: UIButton!)
    {
        seconds = seconds + 3600
        overTime()
        addClock()
    }
    
    @objc func add12Hours(sender: UIButton!)
    {
        seconds = seconds + 3600 * 12
        overTime()
        addClock()
    }
    
    @objc func subSecond(sender: UIButton!)
    {
        if(secondsAdded == 0)
        {
            seconds = seconds + 59
            secondsAdded = 59
        }
        else
        {
            seconds = seconds - 1
            secondsAdded = secondsAdded - 1
            
        }
        addClock()
    }
    
    @objc func subMinute(sender: UIButton!)
    {
        if(minutesAdded == 0)
        {
            seconds = seconds + 59*60
            minutesAdded = 59
        }
        else
        {
            seconds = seconds - 60
            minutesAdded = minutesAdded - 1
            
        }
        addClock()
    }
    
    @objc func subHour(sender: UIButton!)
    {
        seconds = seconds - 3600
        overTime()
        addClock()
    }
    
    @objc func sub12Hours(sender: UIButton!)
    {
        seconds = seconds - 3600 * 12
        overTime()
        addClock()
    }
    
    //makes sure the time isn't over 86400 second
    func overTime()
    {
        if(seconds < 0)
        {
            seconds = 86400 + seconds
        }
        if(seconds >= 86400)
        {
            seconds = seconds - 86400
        }
        
    }
    
    @objc func changeNextZone(sender: UIButton!)
    {
        //Hawaii, Alaska, Pacific, Mountain, Central, Eastern
        switch(TimeZone) {
        case Alarm_Time_Zone.Hawaii :
            TimeZone = Alarm_Time_Zone.Alaska
            break
        case Alarm_Time_Zone.Alaska  :
            TimeZone = Alarm_Time_Zone.Pacific
            break
        case Alarm_Time_Zone.Pacific :
            TimeZone = Alarm_Time_Zone.Mountain
            break
        case Alarm_Time_Zone.Mountain  :
            TimeZone = Alarm_Time_Zone.Central
            break
        case Alarm_Time_Zone.Central :
            TimeZone = Alarm_Time_Zone.Eastern
            break
        case Alarm_Time_Zone.Eastern  :
            TimeZone = Alarm_Time_Zone.Hawaii
            break
        default: break
        }
        addClock()
    }
  
    @objc func changePrevZone(sender: UIButton!)
    {
        //Hawaii, Alaska, Pacific, Mountain, Central, Eastern
        switch(TimeZone) {
        case Alarm_Time_Zone.Hawaii :
            TimeZone = Alarm_Time_Zone.Eastern
            break
        case Alarm_Time_Zone.Alaska  :
            TimeZone = Alarm_Time_Zone.Hawaii
            break
        case Alarm_Time_Zone.Pacific :
            TimeZone = Alarm_Time_Zone.Alaska
            break
        case Alarm_Time_Zone.Mountain  :
            TimeZone = Alarm_Time_Zone.Pacific
            break
        case Alarm_Time_Zone.Central :
            TimeZone = Alarm_Time_Zone.Mountain
            break
        case Alarm_Time_Zone.Eastern  :
            TimeZone = Alarm_Time_Zone.Central
            break
        default: break
        }
        addClock()
    }
    
    @objc func changeNextDay(sender: UIButton!)
    {
        switch(Week_Day) {
        case Alarm_Days.Saturday :
            Week_Day = Alarm_Days.Sunday
            break
        case Alarm_Days.Sunday  :
            Week_Day = Alarm_Days.Monday
            break
        case Alarm_Days.Monday :
            Week_Day = Alarm_Days.Tuesday
            break
        case Alarm_Days.Tuesday  :
            Week_Day = Alarm_Days.Wednesday
            break
        case Alarm_Days.Wednesday :
            Week_Day = Alarm_Days.Thursday
            break
        case Alarm_Days.Thursday  :
            Week_Day = Alarm_Days.Friday
            break
        case Alarm_Days.Friday :
            Week_Day = Alarm_Days.Saturday
            break
        default: break
        }
        addClock()
    }
    
    @objc func changePrevDay(sender: UIButton!)
    {
        switch(Week_Day) {
        case Alarm_Days.Saturday :
            Week_Day = Alarm_Days.Friday
            break
        case Alarm_Days.Sunday  :
            Week_Day = Alarm_Days.Monday
            break
        case Alarm_Days.Monday :
            Week_Day = Alarm_Days.Sunday
            break
        case Alarm_Days.Tuesday  :
            Week_Day = Alarm_Days.Monday
            break
        case Alarm_Days.Wednesday :
            Week_Day = Alarm_Days.Tuesday
            break
        case Alarm_Days.Thursday  :
            Week_Day = Alarm_Days.Wednesday
            break
        case Alarm_Days.Friday :
            Week_Day = Alarm_Days.Thursday
            break
        default: break
        }
        addClock()
    }


    

}

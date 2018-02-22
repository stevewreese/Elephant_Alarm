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
    var date = ""
    var completed = false
    var timesTriggered = 0
    var seconds: Int = 0
    var Week_Day = Alarm_Days.Sunday
    var duration : Int = 0
    var TimeZone = Alarm_Time_Zone.Mountain
    var secondsAdded: Int = 0
    var minutesAdded : Int = 0
    var EventName = ""
    var repeatVal = 0
    var index: Int = 0;
    var empty = true
    var daysOfWeek : [Int] = [1, 0, 0, 0, 0, 0, 0]
    var EventField: UITextField = UITextField (frame: CGRect(x: 0, y: 105, width: UIScreen.main.bounds.width, height: 50));
    let buttonRepeatDay = UIButton(frame: CGRect(x: 50, y: 360, width: 100, height: 25))
    let buttonRepeatHour = UIButton(frame: CGRect(x: 150, y: 360, width: 100, height: 25))
    let buttonRepeatMin = UIButton(frame: CGRect(x: 250, y: 360, width: 100, height: 25))
    let buttonSun = UIButton(frame: CGRect(x: 25, y: 167, width: 50, height: 25))
    let buttonMon = UIButton(frame: CGRect(x: 75, y: 167, width: 50, height: 25))
    let buttonTues = UIButton(frame: CGRect(x: 125, y: 167, width: 50, height: 25))
    let buttonWed = UIButton(frame: CGRect(x: 175, y: 167, width: 50, height: 25))
    let buttonThurs = UIButton(frame: CGRect(x: 225, y: 167, width: 50, height: 25))
    let buttonFri = UIButton(frame: CGRect(x: 275, y: 167, width: 50, height: 25))
    let buttonSat = UIButton(frame: CGRect(x: 325, y: 167, width: 50, height: 25))
    var theControl: Control? = nil

    
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        setupButtons()
        
        let placeText = "Add event name here"
        let placeholder = NSAttributedString(string: "\(placeText)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        EventField.attributedPlaceholder = placeholder
        EventField.textColor = UIColor.black
        EventField.delegate = self
        EventField.borderStyle = UITextBorderStyle.roundedRect
        EventField.allowsEditingTextAttributes = true
        if(EventName != "")
        {
            EventField.text = EventName
        }
        self.addSubview(EventField)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIndex(index: Int)
    {
        self.index = index
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
        

        
        var theTime : time = (theControl?.getTime(secs: seconds))!

        
        let red: CGFloat = 195/255
        let green: CGFloat = 93/255
        let blue: CGFloat = 4/255
        let rtDay = CGRect(x: 110, y: 167, width: 200, height: 40)
        
        /*let paragraphStyleDay = NSMutableParagraphStyle()
        paragraphStyleDay.alignment = .center
        let attributesDay = [NSAttributedStringKey.paragraphStyle  :  paragraphStyleDay,
                             NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                             NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                             ]
        
        let myTextDay = "\(Week_Day)"
        let attrStringDay = NSAttributedString(string: myTextDay,
                                               attributes: attributesDay)
        
        
        attrStringDay.draw(in: rtDay)
        setNeedsDisplay(rtDay)*/
        
        let rt = CGRect(x: 100, y: 253, width: 225, height: 40)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        //UIColor.black.set()
        //UIBezierPath(rect: rt).fill()
        let attributes = [NSAttributedStringKey.paragraphStyle  :  paragraphStyle,
                          NSAttributedStringKey.font            :   UIFont.systemFont(ofSize: 35.0),
                          NSAttributedStringKey.foregroundColor : UIColor.init(red: red, green: green, blue: blue, alpha: 1),
                          ]
        
        let myText = "\(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"
        let attrString = NSAttributedString(string: myText,
                                            attributes: attributes)
        
        
        attrString.draw(in: rt)
        setNeedsDisplay(rt)
        
        /*let rtDuration = CGRect(x: 105, y: 360, width: 225, height: 40)
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
        setNeedsDisplay(rtDuration)*/
        
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
        
        let saveButton = UIButton(frame: CGRect(x: xBase, y: 50, width: 100, height: 25))
        saveButton.backgroundColor = .cyan
        saveButton.layer.cornerRadius = 5
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.setTitle("Save/Back", for: .normal)
        saveButton.addTarget(self, action: #selector(AlarmView.save(sender:)), for: .touchUpInside)
        self.addSubview(saveButton)
        
        //day Buttons
       /* let buttonChangeNextDay = UIButton(frame: CGRect(x: xBase + 220, y: yBase - 50, width: 25, height: 25))
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
        self.addSubview(buttonChangePrevDay)*/
        
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
        /*let buttonAddDur = UIButton(frame: CGRect(x: xBase + 175, y: yBase + 110, width: 25, height: 25))
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
        
        self.addSubview(buttonMinusDur)*/
        
        
        buttonRepeatDay.layer.cornerRadius = 5
        buttonRepeatDay.backgroundColor = .cyan
        buttonRepeatDay.setTitleColor(.black, for: .normal)
        buttonRepeatDay.setTitle("Once", for: .normal)
        buttonRepeatDay.addTarget(self, action: #selector(AlarmView.repeatSet(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonRepeatDay)
        
        buttonRepeatHour.layer.cornerRadius = 5
        buttonRepeatHour.backgroundColor = .white
        buttonRepeatHour.setTitleColor(.black, for: .normal)
        buttonRepeatHour.setTitle("Hourly", for: .normal)
        buttonRepeatHour.addTarget(self, action: #selector(AlarmView.repeatSet(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonRepeatHour)
        
        
        buttonRepeatMin.layer.cornerRadius = 5
        buttonRepeatMin.backgroundColor = .white
        buttonRepeatMin.setTitleColor(.black, for: .normal)
        buttonRepeatMin.setTitle("Minute", for: .normal)
        buttonRepeatMin.addTarget(self, action: #selector(AlarmView.repeatSet(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonRepeatMin)
        
        
        
        buttonSun.layer.cornerRadius = 5
        buttonSun.backgroundColor = .cyan
        buttonSun.setTitleColor(.black, for: .normal)
        buttonSun.setTitle("SU", for: .normal)
        buttonSun.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonSun)
        
        buttonMon.layer.cornerRadius = 5
        buttonMon.backgroundColor = .white
        buttonMon.setTitleColor(.black, for: .normal)
        buttonMon.setTitle("M", for: .normal)
        buttonMon.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonMon)
        
        buttonTues.layer.cornerRadius = 5
        buttonTues.backgroundColor = .white
        buttonTues.setTitleColor(.black, for: .normal)
        buttonTues.setTitle("TU", for: .normal)
        buttonTues.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonTues)
        
        buttonWed.layer.cornerRadius = 5
        buttonWed.backgroundColor = .white
        buttonWed.setTitleColor(.black, for: .normal)
        buttonWed.setTitle("W", for: .normal)
        buttonWed.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonWed)
        
        buttonThurs.layer.cornerRadius = 5
        buttonThurs.backgroundColor = .white
        buttonThurs.setTitleColor(.black, for: .normal)
        buttonThurs.setTitle("TH", for: .normal)
        buttonThurs.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonThurs)
        
        buttonFri.layer.cornerRadius = 5
        buttonFri.backgroundColor = .white
        buttonFri.setTitleColor(.black, for: .normal)
        buttonFri.setTitle("F", for: .normal)
        buttonFri.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonFri)
        
        buttonSat.layer.cornerRadius = 5
        buttonSat.backgroundColor = .white
        buttonSat.setTitleColor(.black, for: .normal)
        buttonSat.setTitle("SA", for: .normal)
        buttonSat.addTarget(self, action: #selector(AlarmView.setDay(sender:)), for: .touchUpInside)
        
        self.addSubview(buttonSat)
        
        
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
        }
        addClock()
    }
    
    /*@objc func changeNextDay(sender: UIButton!)
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
        }
        addClock()
    }*/
    
    @objc func repeatSet(sender: UIButton!)
    {
        if(sender.titleLabel?.text == "Once")
        {
            repeatVal = 0
            buttonRepeatDay.backgroundColor = .cyan
            buttonRepeatHour.backgroundColor = .white
            buttonRepeatMin.backgroundColor = .white
        }
        else if(sender.titleLabel?.text == "Hourly")
        {
            repeatVal = 1
            buttonRepeatDay.backgroundColor = .white
            buttonRepeatHour.backgroundColor = .cyan
            buttonRepeatMin.backgroundColor = .white
        }
        else
        {
            repeatVal = 2
            buttonRepeatDay.backgroundColor = .white
            buttonRepeatHour.backgroundColor = .white
            buttonRepeatMin.backgroundColor = .cyan
        }
    }
    
    func setRepeat(repeatValue: Int)
    {
        if(repeatValue == 0)
        {
            repeatVal = 0
            buttonRepeatDay.backgroundColor = .cyan
            buttonRepeatHour.backgroundColor = .white
            buttonRepeatMin.backgroundColor = .white
        }
        else if(repeatValue == 1)
        {
            repeatVal = 1
            buttonRepeatDay.backgroundColor = .white
            buttonRepeatHour.backgroundColor = .cyan
            buttonRepeatMin.backgroundColor = .white
        }
        else
        {
            repeatVal = 2
            buttonRepeatDay.backgroundColor = .white
            buttonRepeatHour.backgroundColor = .white
            buttonRepeatMin.backgroundColor = .cyan
        }
    }
    
   /* @objc func changePrevDay(sender: UIButton!)
    {
        switch(Week_Day) {
        case Alarm_Days.Saturday :
            Week_Day = Alarm_Days.Friday
            break
        case Alarm_Days.Sunday  :
            Week_Day = Alarm_Days.Saturday
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
        }
        addClock()
    }*/
    @objc func save(sender: UIButton!)
    {
        EventName = "\(EventField.text!)"

        let currentDate = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        /*let dayOfWeek = calendar.component(.weekday, from: currentDate as Date)
        var getDateNumber = 0
        getDateNumber   = (theControl?.convertDays(days: "\(Week_Day)"))!
        var addToDay = 0
        if(dayOfWeek < getDateNumber)
        {
            addToDay = getDateNumber - dayOfWeek
        }
        if(dayOfWeek > getDateNumber)
        {
            addToDay = (7 - getDateNumber) + dayOfWeek
        }
        var dateComponent = DateComponents()
        
        dateComponent.day = addToDay
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)*/
        let result = formatter.string(from: currentDate)
        date = result
        empty = false
        theControl?.alarmSaved(AlarmIndex: index, secs: seconds, days: "\(result)")
        
    }
    
    func setControl(theControl: Control)
    {
        self.theControl = theControl
    }
    
    func changeDay(day: String)
    {
        var theDays : String = day
        var listOfDays : [String] = theDays.components(separatedBy: ",")
        setDayButtons(dayList: listOfDays)
        /*buttonSun.backgroundColor = .white
        switch(day) {
        case "Friday" :
            Week_Day = Alarm_Days.Friday
            buttonFri.backgroundColor = .cyan
            break
        case "Saturday"  :
            Week_Day = Alarm_Days.Saturday
            buttonSat.backgroundColor = .cyan
            break
        case "Sunday" :
            Week_Day = Alarm_Days.Sunday
            buttonSun.backgroundColor = .cyan
            break
        case "Monday"  :
            Week_Day = Alarm_Days.Monday
            buttonMon.backgroundColor = .cyan
            break
        case "Tuesday" :
            Week_Day = Alarm_Days.Tuesday
            buttonTues.backgroundColor = .cyan
            break
        case "Wednesday" :
            Week_Day = Alarm_Days.Wednesday
            buttonWed.backgroundColor = .cyan
            break
        case "Thursday" :
            Week_Day = Alarm_Days.Thursday
            buttonThurs.backgroundColor = .cyan
            break
        default:
            Week_Day = Alarm_Days.Monday
            buttonMon.backgroundColor = .cyan
            break
        }*/
    }
    
    func setDayButtons(dayList: [String])
    {
        if(dayList[0] == "0")
        {
            buttonSun.backgroundColor = .white
            daysOfWeek[0] = 0
        }
        else
        {
            buttonSun.backgroundColor = .cyan
            daysOfWeek[0] = 1
        }
        if(dayList[1] == "0")
        {
            buttonMon.backgroundColor = .white
            daysOfWeek[1] = 0
        }
        else
        {
            buttonMon.backgroundColor = .cyan
            daysOfWeek[1] = 1
        }
        
        if(dayList[2] == "0")
        {
            buttonTues.backgroundColor = .white
            daysOfWeek[2] = 0
        }
        else
        {
            buttonTues.backgroundColor = .cyan
            daysOfWeek[2] = 1
        }
        if(dayList[3] == "0")
        {
            buttonWed.backgroundColor = .white
            daysOfWeek[3] = 0
        }
        else
        {
            buttonWed.backgroundColor = .cyan
            daysOfWeek[3] = 1
        }
        if(dayList[4] == "0")
        {
            buttonThurs.backgroundColor = .white
            daysOfWeek[4] = 0
        }
        else
        {
            buttonThurs.backgroundColor = .cyan
            daysOfWeek[4] = 1
        }
        if(dayList[5] == "0")
        {
            buttonFri.backgroundColor = .white
            daysOfWeek[5] = 0
        }
        else
        {
            buttonFri.backgroundColor = .cyan
            daysOfWeek[5] = 1
        }
        if(dayList[6] == "0")
        {
            buttonSat.backgroundColor = .white
            daysOfWeek[6] = 0
        }
        else
        {
            buttonSat.backgroundColor = .cyan
            daysOfWeek[6] = 1
        }
    }
    
    

    func setZone(zone: String)
    {
        //Hawaii, Alaska, Pacific, Mountain, Central, Eastern
        switch(zone) {
        case "Hawaii" :
            TimeZone = Alarm_Time_Zone.Hawaii
            break
        case "Alaska"  :
            TimeZone = Alarm_Time_Zone.Alaska
            break
        case "Pacific" :
            TimeZone = Alarm_Time_Zone.Pacific
            break
        case "Mountain"  :
            TimeZone = Alarm_Time_Zone.Mountain
            break
        case "Central" :
            TimeZone = Alarm_Time_Zone.Central
            break
        case "Eastern"  :
            TimeZone = Alarm_Time_Zone.Eastern
            break
        default:
            TimeZone = Alarm_Time_Zone.Mountain
        }
    }
    
    @objc func setDay(sender: UIButton!)
    {
        if(sender == buttonSun)
        {

                if(buttonSun.backgroundColor == .white)
                {
                    buttonSun.backgroundColor = .cyan
                    //Week_Day = Alarm_Days.Monday
                    daysOfWeek[0] = 1
                }
                else
                {
                    buttonSun.backgroundColor = .white
                    //Week_Day = Alarm_Days.Monday
                    daysOfWeek[0] = 0
                }
        }
        else if(sender == buttonMon)
        {
            if(buttonMon.backgroundColor == .white)
            {
                buttonMon.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[1] = 1
            }
            else
            {
                buttonMon.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[1] = 0
            }
        }
        else if(sender == buttonTues)
        {
            if(buttonTues.backgroundColor == .white)
            {
                buttonTues.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[2] = 1
            }
            else
            {
                buttonTues.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[2] = 0
            }
        }
        else if(sender == buttonWed)
        {
            if(buttonWed.backgroundColor == .white)
            {
                buttonWed.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[3] = 1
            }
            else
            {
                buttonWed.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[3] = 0
            }
        }
        else if(sender == buttonThurs)
        {
            if(buttonThurs.backgroundColor == .white)
            {
                buttonThurs.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[4] = 1
            }
            else
            {
                buttonThurs.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[4] = 0
            }
        }
        else if(sender == buttonFri)
        {
            if(buttonFri.backgroundColor == .white)
            {
                buttonFri.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[5] = 1
            }
            else
            {
                buttonFri.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[5] = 0
            }
        }
        else
        {
            if(buttonSat.backgroundColor == .white)
            {
                buttonSat.backgroundColor = .cyan
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[6] = 1
            }
            else
            {
                buttonSat.backgroundColor = .white
                //Week_Day = Alarm_Days.Monday
                daysOfWeek[6] = 0
            }
        }
        /*let buttonSun = UIButton(frame: CGRect(x: 25, y: 167, width: 50, height: 25))
        let buttonMon = UIButton(frame: CGRect(x: 75, y: 167, width: 50, height: 25))
        let buttonTues = UIButton(frame: CGRect(x: 125, y: 167, width: 50, height: 25))
        let buttonWed = UIButton(frame: CGRect(x: 175, y: 167, width: 50, height: 25))
        let buttonThurs = UIButton(frame: CGRect(x: 225, y: 167, width: 50, height: 25))
        let buttonFri = UIButton(frame: CGRect(x: 275, y: 167, width: 50, height: 25))
        let buttonSa*/
    }

    



    

}

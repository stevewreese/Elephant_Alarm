//
//  ViewHolder.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class ViewHolder: UIView, UITableViewDelegate, UITableViewDataSource, ControlDelegate
{

    
    var alarm : AlarmView = AlarmView()
    var alarmTable : UITableView!
    var eventTable : UITableView!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let buttonEvent = UIButton(frame: CGRect(x: 75, y: 50, width: 100, height: 50))
    let buttonAlarm = UIButton(frame: CGRect(x: 275, y: 50, width: 100, height: 50))
    let buttonClose = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 20))
    var alarmList : Array<AlarmView> = Array()
    var theControl = Control();
    var indexArray : Int = 0
    var inputOfViews: Array<imported>? = nil
    var eventlist: Array<String>? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        startUp()
        loadData()
        alarmsTriggered()
        
        alarmTable = UITableView(frame: CGRect(x: 0, y: 100, width: width, height: height - 100))
        alarmTable.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        alarmTable.dataSource = self
        alarmTable.delegate = self
        
        
        
        eventTable = UITableView(frame: CGRect(x: 0, y: 100, width: width, height: height - 100))
        eventTable.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        eventTable.dataSource = self
        eventTable.delegate = self
        
        self.addSubview(alarmTable)
        
        
        setupButtons()
        theControl.delegate = self
        
        let clock = AlarmView(frame: UIScreen.main.bounds)
        clock.setIndex(index: indexArray)
        clock.setControl(theControl: theControl)
        alarmList.append(clock)
        indexArray = indexArray + 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.alarmTable {
            return alarmList.count
        }
        else{
            return eventlist!.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == self.alarmTable {
            self.addSubview(alarmList[indexPath.row])
            if(indexPath.row == alarmList.count - 1)
            {
                let clock = AlarmView(frame: UIScreen.main.bounds)
                clock.setIndex(index: indexArray)
                clock.setControl(theControl: theControl)
                alarmList.append(clock)
                indexArray = indexArray + 1
                alarmTable.beginUpdates()
                alarmTable.insertRows(at: [IndexPath(row: alarmList.count - 1, section: 0)], with: .automatic)
                alarmTable.endUpdates()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if tableView == self.alarmTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath as IndexPath)
            if(alarmList[indexPath.row].EventName != "")
            {
                var theTime : time = theControl.getTime(secs: alarmList[indexPath.row].seconds)
                cell.textLabel!.text = alarmList[indexPath.row].EventName + " \(alarmList[indexPath.row].date) \(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"
            }
            else
            {
                cell.textLabel!.text = "Enter New Alarm here"
            }
            
        }
        
        if tableView == self.eventTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath)
            cell!.textLabel!.text = eventlist?[indexPath.row]
            let compButton = UIButton(frame: CGRect(x: 300, y: 10, width: 100, height: 25))
            compButton.backgroundColor = .lightGray
            compButton.layer.cornerRadius = 5
            compButton.setTitleColor(.black, for: .normal)
            compButton.setTitle("completed", for: .normal)
            compButton.addTarget(self, action: #selector(complete(sender:)), for: .touchUpInside)
            cell.addSubview(compButton)
            
        }
        
        
        
        return cell!
    }
    
    private func setupButtons() {

        buttonEvent.backgroundColor = .gray
        //buttonEvent.layer.cornerRadius = 5
        buttonEvent.setTitleColor(.black, for: .normal)
        buttonEvent.setTitle("Events", for: .normal)
        buttonEvent.addTarget(self, action: #selector(ViewHolder.changeToEvent(sender:)), for: .touchUpInside)
        self.addSubview(buttonEvent)
        
        //buttonAlarm.layer.cornerRadius = 5
        buttonAlarm.backgroundColor = .white
        buttonAlarm.setTitleColor(.black, for: .normal)
        buttonAlarm.setTitle("Alarms", for: .normal)
        buttonAlarm.addTarget(self, action: #selector(ViewHolder.changeToAlarm(sender:)), for: .touchUpInside)
        self.addSubview(buttonAlarm)
        
        buttonClose.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonClose.setTitleColor(.black, for: .normal)
        buttonClose.setTitle("Close", for: .normal)
        buttonClose.addTarget(self, action: #selector(ViewHolder.Close(sender:)), for: .touchUpInside)
        self.addSubview(buttonClose)
    }
    
    @objc func changeToEvent(sender: UIButton!)
    {
        if(sender.backgroundColor == .gray)
        {
            sender.backgroundColor = .white
            buttonAlarm.backgroundColor = .gray
            alarmTable.removeFromSuperview()
            self.addSubview(eventTable)
        }

    }
    
    @objc func changeToAlarm(sender: UIButton!)
    {
        if(sender.backgroundColor == .gray)
        {
            sender.backgroundColor = .white
            buttonEvent.backgroundColor = .gray
            eventTable.removeFromSuperview()
            self.addSubview(alarmTable)
        }

    }
    
    @objc func Close(sender: UIButton!)
    {
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                              to: UIApplication.shared, for: nil)
    }
    
    @objc func complete(sender: UIButton!)
    {
        if(sender.backgroundColor == .lightGray)
        {
            sender.backgroundColor = .cyan
        }
        else
        {
            sender.backgroundColor = .lightGray
        }
    }
    
    func saved(theIndex index: Int, clock theTime: time, day: String) {
        alarmList[index].removeFromSuperview()
        alarmTable.cellForRow(at: IndexPath(row: index, section: 0))?.textLabel?.text = alarmList[index].EventName + " \(day) \(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"
        export()

        
    }
    
    func export()
    {
        theControl.export(theViews: alarmList)
    }
    
    func startUp()
    {
        inputOfViews = theControl.startUp()
    }
    
    func loadData()
    {
        for view in inputOfViews!
        {
            if(view.label == "")
            {

            }
            else
            {
                let clock = AlarmView(frame: UIScreen.main.bounds)
                clock.setIndex(index: indexArray)
                clock.setControl(theControl: theControl)
                clock.seconds = Int(view.time)!
                clock.EventField.text = view.label
                clock.EventName = view.label
                clock.date = view.date
                clock.changeDay(day: view.week)
                clock.setZone(zone: view.zone)
                clock.setRepeat(repeatValue: view.repeating)
                clock.empty = false
                alarmList.append(clock)
                indexArray = indexArray + 1
            }
        }
        
 
        
        
    }
    
    
    func alarmsTriggered()
    {
        eventlist = theControl.alarmsTriggered(theViews: alarmList)
    }
    
    
    
}



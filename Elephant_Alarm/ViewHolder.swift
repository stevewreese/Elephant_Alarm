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
    var alarmList : Array<AlarmView> = Array()
    var theControl = Control();
    var indexArray : Int = 0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
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
            return 1
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
            cell.textLabel!.text = "Enter new event alarm "
            
        }
        
        if tableView == self.eventTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath)
            cell!.textLabel!.text = "Event View"
            
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
    
    func saved(theIndex index: Int, clock theTime: time) {
        alarmList[index].removeFromSuperview()
        alarmTable.cellForRow(at: IndexPath(row: index, section: 0))?.textLabel?.text = alarmList[index].EventName + " \(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"

        
    }
    
    
    
}



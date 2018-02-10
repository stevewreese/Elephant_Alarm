//
//  ViewHolder.swift
//  Elephant_Alarm
//
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class ViewHolder: UIView, UITableViewDelegate, UITableViewDataSource
{
    var alarm : AlarmView = AlarmView()
    var alarmTable : UITableView!
    var eventTable : UITableView!
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let buttonEvent = UIButton(frame: CGRect(x: 75, y: 50, width: 100, height: 50))
    let buttonAlarm = UIButton(frame: CGRect(x: 275, y: 50, width: 100, height: 50))
    
    let clock: AlarmView = {
        let clock = AlarmView()
        clock.backgroundColor = UIColor.init(red: 46/255, green: 15/255, blue: 77/255, alpha: 1)
        return clock
        
    }()
    
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
        
        //self.addSubview(alarmTable)
        self.addSubview(clock)
        
        //setupButtons()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        if tableView == self.alarmTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath as IndexPath)
            cell.textLabel!.text = "Alarm View"
            
        }
        
        if tableView == self.eventTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath)
            cell!.textLabel!.text = "Event View"
            
        }
        
        
        
        return cell!
    }
    
    private func setupButtons() {

        buttonEvent.backgroundColor = .blue
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
        if(sender.backgroundColor == .blue)
        {
            sender.backgroundColor = .white
            buttonAlarm.backgroundColor = .blue
            alarmTable.removeFromSuperview()
            self.addSubview(eventTable)
        }

    }
    
    @objc func changeToAlarm(sender: UIButton!)
    {
        if(sender.backgroundColor == .blue)
        {
            sender.backgroundColor = .white
            buttonEvent.backgroundColor = .blue
            eventTable.removeFromSuperview()
            self.addSubview(alarmTable)
        }

    }
    
}



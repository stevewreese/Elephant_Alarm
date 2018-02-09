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
        //self.addSubview(eventTable)
        
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
}



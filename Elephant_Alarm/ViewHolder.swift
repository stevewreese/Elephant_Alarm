//
//  ViewHolder.swift
//  Elephant_Alarm
//  holds the three views the alarm table, event table and the alarm view
//  Created by Stephen Reese on 2/8/18.
//  Copyright © 2018 Stephen Reese. All rights reserved.
//

import UIKit

class ViewHolder: UIView, UITableViewDelegate, UITableViewDataSource, ControlDelegate
{

    
    //var alarm : AlarmView = AlarmView()
    //table to hold all the alarms
    var alarmTable : UITableView!
    //table to hold all the fired events
    var eventTable : UITableView!
    //bounds of the screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    //list of created Alarms
    var alarmList : Array<AlarmView> = Array()
    //controller of all the events
    var theControl = Control();
    //the index of the last Alram in alarmList
    var indexArray : Int = 0
    //structs of imported information from the saved file
    var inputOfViews: Array<imported>? = nil
    //an array of stirng that will be printed to the event table
    var eventlist: Array<String>? = nil
    //buttons to switch between tables
    let buttonEvent = UIButton(frame: CGRect(x: 75, y: 50, width: 100, height: 50))
    let buttonAlarm = UIButton(frame: CGRect(x: 275, y: 50, width: 100, height: 50))
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //gather and load the Data
        startUp()
        loadData()
        //load up the tiggerd alarms
        alarmsTriggered()
        
        //set up the Alarm tabel
        alarmTable = UITableView(frame: CGRect(x: 0, y: 100, width: width, height: height - 100))
        alarmTable.register(UITableViewCell.self, forCellReuseIdentifier: "AlarmCell")
        alarmTable.dataSource = self
        alarmTable.delegate = self
        
        //set up the Event Tables
        eventTable = UITableView(frame: CGRect(x: 0, y: 100, width: width, height: height - 100))
        eventTable.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        eventTable.dataSource = self
        eventTable.delegate = self
        
        //start up the with the event table in view
        self.addSubview(eventTable)
        
        //as expected set up the buttons
        setupButtons()
        //set up the delegate from the control
        theControl.delegate = self
        
        //add an empty Alarm in the list
        let clock = AlarmView(frame: UIScreen.main.bounds)
        //set the index to the Alarm
        clock.setIndex(index: indexArray)
        //set the control
        clock.setControl(theControl: theControl)
        alarmList.append(clock)
        //add one the the Alarm list index
        indexArray = indexArray + 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set up the sizes of the tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.alarmTable {
            return alarmList.count
        }
        else{
            return eventlist!.count
        }
    }
    
    //when the Alarm table cell is touched modify the Alarm if already made or make a new one if an empty cell is touched
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if tableView == self.alarmTable {
            //add the alarm to the sub view
            self.addSubview(alarmList[indexPath.row])
            //if the row is the last row it will make a new row and add an empty Alarm into the cell
            if(indexPath.row == alarmList.count - 1)
            {
                let clock = AlarmView(frame: UIScreen.main.bounds)
                clock.setIndex(index: indexArray)
                clock.setControl(theControl: theControl)
                alarmList.append(clock)
                indexArray = indexArray + 1
                //This adds a new row
                alarmTable.beginUpdates()
                alarmTable.insertRows(at: [IndexPath(row: alarmList.count - 1, section: 0)], with: .automatic)
                alarmTable.endUpdates()
            }
            
        }
    }
    //populate the cells of the Alarm table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //make the cell
        var cell:UITableViewCell!
        //make sure you have the right table
        if tableView == self.alarmTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath as IndexPath)
            //if alarm isn't empty populate with name date and time
            if(!alarmList[indexPath.row].empty)
            {
                //ask the control to get the time
                let theTime : time = theControl.getTime(secs: alarmList[indexPath.row].seconds)
                //get the relevant info
                cell.textLabel!.text = alarmList[indexPath.row].EventName + " \(alarmList[indexPath.row].date) \(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"
            }
            //if alarm is empty ask the user to make a new alarm
            else
            {
                cell.textLabel!.text = "Make New Alarm Here"
            }
            
        }
        //populate the cells of the Event table
        if tableView == self.eventTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath)
            //add the text from the array received fromt the model
            cell!.textLabel!.text = eventlist?[indexPath.row]
            //make the completed button
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
    
    //set up the close button, and the table tabs
    private func setupButtons() {
        
        let buttonClose = UIButton(frame: CGRect(x: 25, y: 25, width: 50, height: 20))

        buttonEvent.backgroundColor = .white
        //buttonEvent.layer.cornerRadius = 5
        buttonEvent.setTitleColor(.black, for: .normal)
        buttonEvent.setTitle("Events", for: .normal)
        buttonEvent.addTarget(self, action: #selector(ViewHolder.changeToEvent(sender:)), for: .touchUpInside)
        self.addSubview(buttonEvent)
        
        //buttonAlarm.layer.cornerRadius = 5
        buttonAlarm.backgroundColor = .gray
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
    
    //the event when the Event tab is click if not on event tab then switch to events
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
    //the event when the Alarms tab is click if not on Alarms tab then switch to Alarms
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
    
    //send to back ground when close button is pressed
    @objc func Close(sender: UIButton!)
    {
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                              to: UIApplication.shared, for: nil)
    }
    
    //highlight/dehighlight button if button clicked no pother behavior specified in the assigment
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
    
    //when save/back button is press in the Alarm view this even fires up. This updates the row of the corresponding row
    func saved(theIndex index: Int, clock theTime: time, day: String) {
        //go back to the table views
        alarmList[index].removeFromSuperview()
        //update the table
        alarmTable.cellForRow(at: IndexPath(row: index, section: 0))?.textLabel?.text = alarmList[index].EventName + " \(day) \(theTime.hour):\(theTime.min):\(theTime.sec) \(theTime.timeDay)"
        //save the data each time an alarm is saved
        export()
        
    }
    
    //ask the control to ask the model to save the information
    func export()
    {
        theControl.export(theViews: alarmList)
    }
    // get a struct with the relevant info from the save file
    func startUp()
    {
        inputOfViews = theControl.startUp()
    }
    
    //load up the data into the alarmList
    func loadData()
    {
        for view in inputOfViews!
        {
            if(view.label == "")
            {

            }
            else
            {
                //make a new clock and load up the information.
                let clock = AlarmView(frame: UIScreen.main.bounds)
                //set index
                clock.setIndex(index: indexArray)
                // set the control
                clock.setControl(theControl: theControl)
                //set the seconds
                clock.seconds = Int(view.time)!
                //set the name
                clock.EventField.text = view.label
                clock.EventName = view.label
                //set the date
                clock.date = view.date
                //change how many days are set
                clock.changeDay(day: view.week)
                //set the Zone
                clock.setZone(zone: view.zone)
                //set when it repeats
                clock.setRepeat(repeatValue: view.repeating)
                //make sure its not empty
                clock.empty = false
                //add it to the array
                alarmList.append(clock)
                indexArray = indexArray + 1
            }
        }
    }
    
    //load up the data from the model to count the events triggered.
    func alarmsTriggered()
    {
        eventlist = theControl.alarmsTriggered(theViews: alarmList)
        
    }
    //when enter foreground reload the table
    func reload()
    {
        eventTable.reloadData()
    }
    
    
    
}



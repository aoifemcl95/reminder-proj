//
//  CalenderSelectionViewController.swift
//  tableViewProject
//
//  Created by Aoife McLaughlin on 30/05/2018.
//  Copyright © 2018 Aoife McLaughlin. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class CalenderSelectionViewController: UIViewController {
    
    var myTableViewCell = MyTableViewCell()

    var item: Item?

    init(item:Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createEvent(todoItem: Item) {
        let eventStore: EKEventStore = EKEventStore()
        let date = self.datePicker.date
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if (granted) && (error == nil ) {
                print ("permission is granted")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = todoItem.name
                event.startDate = date
                event.endDate = date
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                event.addAlarm(EKAlarm.init(relativeOffset: 60.0))
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let specError as NSError {
                    print("A specific error occurred: \(specError)")
                } catch {
                    print("An error occurred")
                }
                print("Event saved")
                
            } else {
                print("need permission to create a event")
            }
            
        }
    }

    @IBAction func cancelButtonSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonSelected(_ sender: Any) {
        self.createEvent(todoItem: item!)
        self.dismiss(animated: true, completion: nil)
    
    }
    

}

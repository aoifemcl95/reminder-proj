//
//  ViewController.swift
//  tableViewProject
//
//  Created by Aoife McLaughlin on 30/04/2018.
//  Copyright © 2018 Aoife McLaughlin. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate{

    var items: [Item] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var expandedRows = Set<Int>()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      let nibName = UINib.init(nibName: "MyTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "MyTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewController.didTapEditItemButton(_:)))
        self.tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as! MyTableViewCell
//        let item = items[0]
        cell.updateCellForItem(item: items[indexPath.row])
        cell.delegate = self
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        cell.backgroundColor = UIColor.init(red: 255, green: 211, blue: 0, alpha: 0.7)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(items)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.beginUpdates()
        guard let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell
            else { return }
        
        switch cell.isExpanded
        {
        case true:
            self.expandedRows.remove(indexPath.row)
            
        case false:
            self.expandedRows.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell
        if ((cell) != nil)
        {
            if (cell!.isExpanded) {
                return 100
            }
            else {
                return 50
            }
        }
        else {
            return 50
    }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let item = self.items[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let complete = UITableViewRowAction(style: .default, title: "Complete") { (action, indexPath) in
            tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
            print("Share")
        }
        
        return [delete, complete]
    }
    
    private func addNewItemToDoItem(title:String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newEntry = Item(context: context)
        newEntry.name = title
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        fetchData()
    }
    
    @objc func didTapAddItemButton(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "New to-do item", message: "Insert the title of the new to-do item:", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                self.addNewItemToDoItem(title: title)
                
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func fetchData() {
        do {
            items = try context.fetch(Item.fetchRequest())
            print(items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't fetch data")
        }
    }
    
    @objc func didTapEditItemButton(_ sender: UIBarButtonItem)
    {
        self.tableView.isEditing = true
        
    }
    
    func toDoItemsDeleted(todoItem: Item) {
        let index = (items as NSArray).index(of: todoItem) as! IndexPath
//        if index == NSNotFound { return }
        let item = items[index.row]
        self.context.delete(item)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.items.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .fade)
        fetchData()
//        items.remove(at: index)
//        
        tableView.beginUpdates()
//        let indexPathForRow = NSIndexPath(row: index, section: 0)
//        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        tableView.endUpdates()
//
        tableView.reloadData()
        
        
    }
    
    func toDoItemsCompleted(todoItem: Item) {
        let index = (items as NSArray).index(of: todoItem)
        if index == NSNotFound { return }
        let indexPathForRow = NSIndexPath(row: index, section: 0)
        if todoItem.completed {
            tableView.cellForRow(at: indexPathForRow as IndexPath)?.backgroundColor = UIColor.green
        }
    }
    
    func createEvent(todoItem: Item) {
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if (granted) && (error == nil ) {
                print ("permission is granted")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = todoItem.name
                event.startDate = NSDate() as Date?
                event.endDate = NSDate() as Date?
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
    
    func presentDatePicker(todoItem:Item) {
        //initialise calenderViewController with item to pass through
        let calenderViewController = CalenderSelectionViewController(item: todoItem)
        self.present(calenderViewController, animated: true, completion: nil)
    }
}




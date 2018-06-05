//
//  ToDoItem.swift
//  tableViewProject
//
//  Created by Aoife McLaughlin on 11/05/2018.
//  Copyright © 2018 Aoife McLaughlin. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
        var text: String
        var completed: Bool
        
        init(text: String) {
            self.text = text
            self.completed = false
        }
}

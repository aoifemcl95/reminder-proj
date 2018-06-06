//
//  MyTableViewCell.swift
//  tableViewProject
//
//  Created by Aoife McLaughlin on 30/04/2018.
//  Copyright © 2018 Aoife McLaughlin. All rights reserved.
//

import UIKit
import EventKit

protocol TableViewCellDelegate {
    func toDoItemsDeleted(todoItem: Item)
    func toDoItemsCompleted(todoItem: Item)
    func createEvent(todoItem: Item)
    func presentDatePicker(todoItem: Item)
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var completeImage: UIImageView!
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    var delegate: TableViewCellDelegate?

    var toDoItem: Item?{
        didSet{
            myLabel.text = toDoItem!.name
            toDoItem!.completed = false
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 5.0
    }
    
    var isExpanded: Bool = false
    {
        didSet
        {
            if !isExpanded {
//                self.buttonHeight.constant = 0.0
                self.myButton.isHidden = true
            }
            else {
//                self.buttonHeight.constant = 50.0
                self.myButton.isHidden = false
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        cellView.layer.borderWidth = 1.0
        cellView.layer.borderColor = UIColor.white.cgColor
        cellView.layer.shadowColor = UIColor.lightGray.cgColor
        cellView.layer.shadowRadius = 2.0
        cellView.layer.shadowOpacity = 1.0
        cellView.layer.shadowOffset = CGSize(width:0, height: 2)
        cellView.layer.shadowPath = UIBezierPath(rect: cellView.bounds).cgPath
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func updateCellForItem(item: Item) {
        myLabel.text = item.name
        self.toDoItem = item
    }

    
    //allows you to cancel the recognition of a gesture before it has begun
    //if it is a vertical pan you cancel the gesture recognizer
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer{
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
            
        }
        return false
    }
    
    @IBAction func actionCreateEvent(_ sender: Any) {
        self.delegate?.presentDatePicker(todoItem: toDoItem!)
}

}

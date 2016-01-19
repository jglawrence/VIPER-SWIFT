//
//  AddViewController.swift
//  VIPER TODO
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, AddViewInterface {
    @IBOutlet var nameTextField : UITextField?
    @IBOutlet var datePicker : UIDatePicker?

    var eventHandler : AddModuleInterface?
    var minimumDate = NSDate()
    var transitioningBackgroundView = UIView()
    
    @IBAction func save(sender: AnyObject) {
        if let text = nameTextField?.text, date = datePicker?.date {
            eventHandler?.saveAddActionWithName(text, dueDate: date)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        nameTextField?.resignFirstResponder()
        eventHandler?.cancelAddAction()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: Selector("dismiss"))
        
        transitioningBackgroundView.userInteractionEnabled = true
        
        nameTextField?.becomeFirstResponder()
        
        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = minimumDate
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        nameTextField?.resignFirstResponder()
    }
    
    func dismiss() {
        eventHandler?.cancelAddAction()
    }
    
    func setEntryName(name: String) {
        nameTextField?.text = name
    }
    
    func setEntryDueDate(date: NSDate) {
        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = date
        }
    }
    
    func setMinimumDueDate(date: NSDate) {
        minimumDate = date
        
        if let realDatePicker = datePicker {
            realDatePicker.minimumDate = date
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
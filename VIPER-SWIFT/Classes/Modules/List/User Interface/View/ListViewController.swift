//
//  ListViewController.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

var ListEntryCellIdentifier = "ListEntryCell"

class ListViewController : UITableViewController, ListViewInterface {
    var eventHandler : ListModuleInterface?
    var dataProperty : UpcomingDisplayData?
    
    @IBOutlet var noContentView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.updateView()
    }
    
    func configureView() {
        navigationItem.title = "VIPER TODO"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("didTapAddButton"))
        
        navigationItem.rightBarButtonItem = addItem
    }
    
    func didTapAddButton () {
        eventHandler?.addNewEntry()
    }
    
    func showNoContentMessage() {
        view = noContentView
    }
    
    func showUpcomingDisplayData(data: UpcomingDisplayData) {
        view = tableView
        
        dataProperty = data
        reloadEntries()
    }
    
    func reloadEntries() {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let numberOfSections = dataProperty?.sections.count else { return 0 }
        
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let upcomingSectionItems = dataProperty?.sections[section].items else { return 0 }

        return upcomingSectionItems.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        guard let upcomingSection = dataProperty?.sections[section] else { return "" }

        return upcomingSection.name
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListEntryCellIdentifier, forIndexPath: indexPath) as UITableViewCell

        guard let upcomingSection = dataProperty?.sections[indexPath.section],
            let upcomingItem = upcomingSection.items?[indexPath.row] else { return cell }

        cell.textLabel?.text = upcomingItem.title;
        cell.detailTextLabel?.text = upcomingItem.dueDate;
        cell.imageView?.image = UIImage(named: upcomingSection.imageName)
        cell.selectionStyle = .None;

        return cell
    }
}
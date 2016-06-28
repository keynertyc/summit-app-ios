//
//  SearchViewController.swift
//  OpenStackSummit
//
//  Created by Claudio on 10/22/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit

@objc final class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RevealViewController, MessageEnabledViewController {
    
    // MARK: - IB Outlets

    @IBOutlet weak var speakersTableView: PeopleListView!
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var searchTermTextView: UITextField!
    @IBOutlet weak var eventsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tracksTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var speakersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Accessors

    var searchTerm: String = "" {
        
        didSet {
            
            self.loadView()
            searchTermTextView.text = searchTerm
        }
    }
    
    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMenuButton()
        
        // setup table view
        eventsTableView.registerNib(R.nib.scheduleTableViewCell)
        eventsTableView.estimatedRowHeight = 100
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        
        speakersTableView.tableView.registerNib(R.nib.peopleTableViewCell)
        searchTermTextView.delegate = self
        
        //hack: if I don't add this constraint, width for table goes out of margins and height doesn't work well
        let tableWidthConstraint = NSLayoutConstraint(item: speakersTableView.tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: speakersTableView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        speakersTableView.addConstraint(tableWidthConstraint)
        let tableHeightConstraint = NSLayoutConstraint(item: speakersTableView.tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: speakersTableView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        speakersTableView.addConstraint(tableHeightConstraint)
        
        navigationItem.title = "SEARCH"
    }
    
    // MARK: - Private Methods
    
    // MARK: Configure Table View Cells
    
    
    
    // MARK: Reload Table Views
    
    func reloadEvents() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.reloadData()
        eventsTableView.layoutIfNeeded()
        setupTable(eventsTableView, withRowCount: eventsTableView.numberOfRowsInSection(0), withMinSize: 130, withConstraint: eventsTableViewHeightConstraint)
        eventsTableView.updateConstraintsIfNeeded()
    }

    func reloadTracks() {
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        tracksTableView.reloadData()
        tracksTableView.layoutIfNeeded()
        setupTable(tracksTableView, withRowCount: tracksTableView.numberOfRowsInSection(0), withMinSize: 50, withConstraint: tracksTableViewHeightConstraint)
        tracksTableView.updateConstraintsIfNeeded()
    }

    func reloadSpeakers() {
        speakersTableView.tableView.delegate = self
        speakersTableView.tableView.dataSource = self
        speakersTableView.tableView.reloadData()
        speakersTableView.layoutIfNeeded()
        setupTable(speakersTableView.tableView, withRowCount: speakersTableView.tableView.numberOfRowsInSection(0), withMinSize: 60, withConstraint: speakersTableViewHeightConstraint)
        speakersTableView.updateConstraintsIfNeeded()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        searchTermTextView.resignFirstResponder()
        
        if searchTermTextView.text!.isEmpty == false {
            
            self.search(searchTermTextView.text)
        }
        
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if (tableView == eventsTableView) {
            count = presenter.getEventsCount()
        }
        else if (tableView == tracksTableView) {
            count = presenter.getTracksCount()
        }
        else if (tableView == speakersTableView.tableView) {
            count = presenter.getSpeakersCount()
        }
        else if (tableView == attendeesTableView.tableView) {
            count = presenter.getAttendeesCount()
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case eventsTableView:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.scheduleTableViewCell, forIndexPath: indexPath)!
            cell.scheduleButton.addTarget(self, action: #selector(SearchViewController.toggleScheduledStatus(_:)), forControlEvents: .TouchUpInside)
            
            presenter.buildEventCell(cell, index: indexPath.row)
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.layoutSubviews()
            return cell
            
        case tracksTableView:
            
            
        }
        
        if (tableView == eventsTableView) {
        }
        else if (tableView == tracksTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier(tracksTableViewCellIdentifier, forIndexPath: indexPath) as! TrackTableViewCell
            presenter.buildTrackCell(cell, index: indexPath.row)
            return cell
        }
        else if (tableView == speakersTableView.tableView)  {
            let cell = tableView.dequeueReusableCellWithIdentifier(speakersTableViewCellIdentifier, forIndexPath: indexPath) as! PeopleTableViewCell
            presenter.buildSpeakerCell(cell, index: indexPath.row)
            return cell
        }
        else if (tableView == attendeesTableView.tableView)  {
            let cell = tableView.dequeueReusableCellWithIdentifier(attendeesTableViewCellIdentifier, forIndexPath: indexPath) as! PeopleTableViewCell
            presenter.buildAttendeeCell(cell, index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        if (tableView == eventsTableView) {
            presenter.showEventDetail(indexPath.row)
        }
        else if (tableView == tracksTableView) {
            presenter.showTrackEvents(indexPath.row)
        }
        else if (tableView == speakersTableView.tableView) {
            presenter.showSpeakerProfile(indexPath.row)
        }
        else if (tableView == attendeesTableView.tableView) {
            presenter.showAttendeeProfile(indexPath.row)
        }
    }
    
    func setupTable(tableView: UITableView, withRowCount count: Int, withMinSize minSize:Int, withConstraint constraint: NSLayoutConstraint) {
        if count > 0 {
            constraint.constant = count <= 4 ? max(CGFloat(minSize), tableView.contentSize.height) : 290
            tableView.backgroundView = nil
        }
        else {
            constraint.constant = 40
            let label = UILabel()
            label.text = " No results"
            label.sizeToFit()
            tableView.backgroundView = label
        }
        tableView.frame.size.height = constraint.constant
    }
    
    func toggleScheduledStatus(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! UITableViewCell
        let indexPath = eventsTableView.indexPathForCell(cell)
        
        presenter.toggleScheduledStatus(indexPath!.row, cell: view.superview as! IScheduleTableViewCell)
    }
}

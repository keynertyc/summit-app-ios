//
//  GeneralSchedulePresenter.swift
//  OpenStackSummit
//
//  Created by Claudio on 8/7/15.
//  Copyright © 2015 OpenStack. All rights reserved.
//

import UIKit
import MTDates

extension Array where Element: SummitEvent {
    func filter(byDate date: NSDate) -> [SummitEvent] {
        return self.filter { (event) -> Bool in
            event.start.mt_isWithinSameDay(date)
        }
    }
}

@objc
public protocol IGeneralSchedulePresenter {
    func reloadSchedule()
    func showEventDetail(eventId: Int)
    func viewLoad()
    func buildCell(cell: IGeneralScheduleTableViewCell, index: Int)
    func getDayEventsCount() -> Int
}

public class GeneralSchedulePresenter: NSObject {
    
    weak var viewController : IGeneralScheduleViewController!
    var interactor : IGeneralScheduleInteractor!
    var generalScheduleWireframe : IGeneralScheduleWireframe!
    var session: ISession!
    var summitTimeZoneOffsetToLocalTimeZone: Int!
    var dayEvents: [ScheduleItemDTO]!
    
    public func viewLoad() {
        viewController.showActivityIndicator()
        interactor.getActiveSummit() { summit, error in
            defer { self.viewController.hideActivityIndicator() }
            
            if (error != nil) {
                self.viewController.showErrorMessage(error!)
                return
            }
            
            let offsetLocalTimeZone = -NSTimeZone.localTimeZone().secondsFromGMT
            self.summitTimeZoneOffsetToLocalTimeZone = NSTimeZone(name: summit!.timeZone)!.secondsFromGMT + offsetLocalTimeZone
            self.viewController.startDate = summit!.startDate.mt_dateSecondsAfter(offsetLocalTimeZone)
            self.viewController.endDate = summit!.endDate.mt_dateSecondsAfter(offsetLocalTimeZone).mt_dateDaysAfter(1)
            self.viewController.selectedDate = self.viewController.startDate
        }
    }
    
    public func reloadSchedule() {
        let filterSelections = session.get(Constants.SessionKeys.GeneralScheduleFilterSelections) as? Dictionary<FilterSectionTypes, [Int]>
        let startDate = viewController.selectedDate.mt_dateSecondsAfter(-summitTimeZoneOffsetToLocalTimeZone)
        let endDate = viewController.selectedDate.mt_dateDaysAfter(1).mt_dateSecondsAfter(-summitTimeZoneOffsetToLocalTimeZone)
        
        dayEvents = self.interactor.getScheduleEvents(
            startDate,
            endDate: endDate,
            eventTypes: filterSelections?[FilterSectionTypes.EventType],
            summitTypes: filterSelections?[FilterSectionTypes.SummitType]
        )
        self.viewController.reloadSchedule()
    }
    
    public func buildCell(cell: IGeneralScheduleTableViewCell, index: Int){
        let event = dayEvents[index]
        cell.eventTitle = event.title
        cell.timeAndPlace = event.date
    }
    
    func getDayEventsCount() -> Int {
        return dayEvents.count
    }
    
    func showEventDetail(index: Int) {
        let event = dayEvents[index]
        self.generalScheduleWireframe.showEventDetail(event.id)
    }
}

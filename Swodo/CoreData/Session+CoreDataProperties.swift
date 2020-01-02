//
//  Session+CoreDataProperties.swift
//  Swodo
//
//  Created by Oskar on 30/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var canceled: Bool
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var numberOfWorkIntervals: Int16
    @NSManaged public var singleBreakDuration: Int16
    @NSManaged public var singleWorkDuration: Int16
    @NSManaged public var startDate: Date?
    @NSManaged public var totalWorkDuration: Int16

}

//extension Session: Identifiable {}

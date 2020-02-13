//
//  MainViewModelMock.swift
//  SwodoTests
//
//  Created by Oskar on 13/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import XCTest
import CoreData
@testable import Swodo

class StorageManagerDelegateMock: StorageManagerDelegate {
  var context: NSManagedObjectContext? = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
  
  var numberOfWorkIntervals: Int16? = 5
  
  var animationDuration: CGFloat = 600
  
  var progressValue: CGFloat = 1.0
  
  var numberOfSessions: Int = 5
  
  var state: TimerState = .notStarted
  
  var workTime: CGFloat = 600.0
  
  var singleWorkDuration: Int16? = 600
  
  var startSessionDate: Date! = Date()
  
  
}

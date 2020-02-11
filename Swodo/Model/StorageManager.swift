//
//  StorageManager.swift
//  Swodo
//
//  Created by Oskar on 18/01/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreData

protocol StorageManagerDelegate: ProgressDataDelegate {
  var context: NSManagedObjectContext? { get set }
}

protocol ProgressDataDelegate {
  var numberOfWorkIntervals: Int16? { get set }
  var animationDuration: CGFloat { get set }
  var progressValue: CGFloat { get set }
  var numberOfSessions: Int { get set }
  var state: TimerState { get set }
  var workTime: CGFloat { get set }
  var singleWorkDuration: Int16? { get set }
  var startSessionDate: Date! { get set }
}

final class StorageManager {
  private let userDefaultsQueue = DispatchQueue(label: "com.oschly.swodo.userDefaultsTask", qos: .userInteractive)
  private let userDefaults = UserDefaults.standard
  
  var delegate: StorageManagerDelegate?
  private var isReadingExecuting = false
}

// MARK: - UserDefaults methods
extension StorageManager {
  func saveSession() {
    isReadingExecuting = false
    
    userDefaultsQueue.async { [weak self] in
      guard let self = self else { return }
      self.userDefaults.set(self.delegate?.state.rawValue, forKey: .stateKey)
      self.userDefaults.set(self.delegate?.progressValue, forKey: .progressValueKey)
      self.userDefaults.set(self.delegate?.numberOfSessions, forKey: .numberOfSessionsKey)
      self.userDefaults.set(self.delegate?.workTime, forKey: .workTimeKey)
      self.userDefaults.set(self.delegate?.animationDuration, forKey: .animationDurationKey)
      self.userDefaults.set(Date(), forKey: .dateKey)
    }
  }
  
  func readUnfinishedSession() {
    guard var delegate = delegate else { return }
    
    // Check if isn't already there another process of saving data
    guard !isReadingExecuting else { return }
    isReadingExecuting = true
    
    // Safety-check if user entered the app that has ended session
    if delegate.state == .notStarted {
      delegate.progressValue = 1.0
      return
    }
    
    // Set default value key for 5 minutes (lowest available)
    userDefaults.register(defaults: [.workTimeKey : 5])
    
    // Calculate time between app's last exit and present re-launch
    // (app doesn't have to be killed to execute that method).
    //
    // differenceBetweenDates uses negated value of exitDate, because
    // any timeIntervalSinceNow used on past date will return negative value.
    let exitDate = userDefaults.value(forKey: .dateKey) as! Date
    var differenceBetweenDates = CGFloat(-exitDate.timeIntervalSinceNow)
    
    // Read informations about last session from UserDefaults
    delegate.workTime = CGFloat(userDefaults.integer(forKey: .workTimeKey))
    delegate.numberOfSessions = userDefaults.integer(forKey: .numberOfSessionsKey)
    
    // Calculate present session's state based on data of last exit and present launch
    while differenceBetweenDates > delegate.workTime {
      
      // If differeneceBetweenDates is bigger than workTime and numberOfSessions equals 1,
      // there is no need to continue the loop, just set session as ended.
      if delegate.numberOfSessions == 1 {
        delegate.state = .notStarted
      }
      guard delegate.state != .notStarted else { return }
      
      delegate.numberOfSessions -= 1
      differenceBetweenDates -= delegate.workTime
    }
    
    // Read the data from last session, to calculate present state of progress Ring.
    let leftAnimationTime = CGFloat(userDefaults.float(forKey: .animationDurationKey))
    
    // animationDuration increases its value when is counting breaks' time and
    // decreasing when counting works' time.
    if delegate.state == .workTime {
      delegate.animationDuration = leftAnimationTime - differenceBetweenDates
    } else {
      delegate.animationDuration = leftAnimationTime + differenceBetweenDates
    }
    
    // Bring progress circle to present state
    delegate.progressValue = delegate.animationDuration / delegate.workTime
    isReadingExecuting = false
  }
}


// MARK: - Core Data methods
extension StorageManager {
  func saveToCoreData() {
    guard let workIntervals = delegate?.numberOfWorkIntervals,
      let singleWorkDuration = delegate?.singleWorkDuration else {
        return
    }
    
    guard let context = delegate?.context else { return }
    let totalWork = workIntervals * singleWorkDuration + (workIntervals - 1)
    let session = Session(context: context)
    session.canceled = false
    session.endDate = Date()
    session.id = UUID()
    session.numberOfWorkIntervals = workIntervals
    session.singleBreakDuration = 5
    session.startDate = delegate?.startSessionDate
    session.totalWorkDuration = totalWork
    session.singleWorkDuration = singleWorkDuration
    
    try? delegate?.context!.save()
  }
}

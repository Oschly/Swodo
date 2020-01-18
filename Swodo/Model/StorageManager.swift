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
  var isReadingExecuted: Bool { get set }
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
  private let userDefaultsQueue = DispatchQueue(label: "com.oschly.swodo.userDefaultsTask", qos: .background)
  private let userDefaults = UserDefaults.standard
  
  var delegate: StorageManagerDelegate?
}

// MARK: - UserDefaults methods
extension StorageManager {
  func saveSession() {
    delegate?.isReadingExecuted = false
    
    userDefaultsQueue.async { [unowned self] in
      self.userDefaults.set(self.delegate?.state.rawValue, forKey: .stateKey)
      self.userDefaults.set(self.delegate?.progressValue, forKey: .progressValueKey)
      self.userDefaults.set(self.delegate?.numberOfSessions, forKey: .numberOfSessionsKey)
      self.userDefaults.set(self.delegate?.workTime, forKey: .workTimeKey)
      self.userDefaults.set(self.delegate?.animationDuration, forKey: .animationDurationKey)
      self.userDefaults.set(Date(), forKey: .dateKey)
    }
  }
  
  func readUnfinishedSession() {
    guard !(delegate?.isReadingExecuted ?? true) else { return }
    delegate?.isReadingExecuted = true
    
    if delegate?.state == .notStarted {
      delegate?.progressValue = 1.0
      return
    }
    
    userDefaults.register(defaults: [.workTimeKey : 5])
    
    let exitDate = userDefaults.value(forKey: .dateKey) as! Date
    var differenceBetweenDates = CGFloat(-exitDate.timeIntervalSinceNow)
    
    delegate?.workTime = CGFloat(userDefaults.integer(forKey: .workTimeKey))
    delegate?.numberOfSessions = userDefaults.integer(forKey: .numberOfSessionsKey)
    
    while differenceBetweenDates > delegate?.workTime ?? 0 {
      if delegate?.numberOfSessions == 1 {
        delegate?.state = .notStarted
      }
      
      delegate?.numberOfSessions -= 1
      differenceBetweenDates -= delegate?.workTime ?? 0
    }
    
    let leftAnimationTime = CGFloat(userDefaults.float(forKey: .animationDurationKey))
    delegate?.progressValue = CGFloat(userDefaults.float(forKey: .progressValueKey))
    
    if delegate?.state == .workTime {
      delegate?.animationDuration = leftAnimationTime - differenceBetweenDates
    } else {
      delegate?.animationDuration = leftAnimationTime + differenceBetweenDates
    }
  }
}


// MARK: - Core Data methods
extension StorageManager {
  func saveToCoreData() {
    guard let workIntervals = delegate?.numberOfWorkIntervals,
      let singleWorkDuration = delegate?.singleWorkDuration else {
        return
    }
    
    let totalWork = workIntervals * singleWorkDuration + (workIntervals - 1)
    
    guard let context = delegate?.context else { return }
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

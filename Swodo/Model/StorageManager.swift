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

// I didn't find any other way to request given for SwiftUI
// views Core Data's context. It allows to operate on same context
// through whole app.
protocol StorageManagerDelegate: ProgressDataDelegate {
  var context: NSManagedObjectContext? { get set }
}

final class StorageManager {
  
  // Queues for saving and removing data.
  private let userDefaultsQueue = DispatchQueue(label: "com.oschly.swodo.userDefaultsTask", qos: .userInteractive)
  private let userDefaultsBackgroundQueue = DispatchQueue(label: "com.oschly.swodo.userDefaultsBackgroundTask", qos: .background)
  private let userDefaults = UserDefaults.standard
  
  // delegate allows code to do it own job here (saving, reading, etc.) and
  // give required data to classes and structs which need that data to work.
  var delegate: StorageManagerDelegate?
  
  // A value which indicates if is any saving/reading method already running.
  // It helps to prevent running multiple tries to save data what can
  // be problematic in complex situations.
  private var isUsingDisk = false
}

// MARK: - UserDefaults methods
extension StorageManager {
  func saveSession() {
    isUsingDisk = true
    
    // Execute that not on main thread to prevent system's hangs on app's exit
    userDefaultsQueue.async { [weak self] in
      guard let self = self,
        let delegate = self.delegate
        else { return }
      
      self.userDefaults.set(delegate.state.rawValue, forKey: .stateKey)
      self.userDefaults.set(delegate.progressValue, forKey: .progressValueKey)
      self.userDefaults.set(delegate.numberOfSessions, forKey: .numberOfSessionsKey)
      self.userDefaults.set(delegate.workTime, forKey: .workTimeKey)
      self.userDefaults.set(delegate.animationDuration, forKey: .animationDurationKey)
      self.userDefaults.set(Date(), forKey: .dateKey)
      self.userDefaults.set(delegate.sessionTitle, forKey: .sessionTitleKey)
      
      #if DEBUG
      let notification = Notification(name: .debugDefaultsValue, object: nil)
      NotificationCenter.default.post(notification)
      #endif
    }
    
    isUsingDisk = false
  }
  
  func readUnfinishedSession() {
    userDefaultsQueue.async { [weak self] in
      guard let self = self else { return }
      
      // Check if isn't already there another process of saving data
      // or any other case that this method shouldn't be executed now
      guard !self.isUsingDisk,
        var delegate = self.delegate,
        delegate.state != .notStarted
        else { return }
      self.isUsingDisk = true
      
      // Set default value key for 5 minutes (lowest available)
      // in case of absence of value for .workTimeKey
      self.userDefaults.register(defaults: [.workTimeKey: 5])
      
      // Calculate time between app's last exit and present re-launch
      // (app doesn't have to be killed to execute that method).
      //
      // differenceBetweenDates uses negated value of exitDate, because
      // any timeIntervalSinceNow used on past date returns negative value.
      guard let exitDate = self.userDefaults.value(forKey: .dateKey) as? Date else { return }
      var differenceBetweenDates = CGFloat(-exitDate.timeIntervalSinceNow)
      
      // Read informations about last session from UserDefaults
      delegate.workTime = CGFloat(self.userDefaults.integer(forKey: .workTimeKey))
      delegate.numberOfSessions = self.userDefaults.integer(forKey: .numberOfSessionsKey)
      
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
      let leftAnimationTime = CGFloat(self.userDefaults.float(forKey: .animationDurationKey))
      
      // animationDuration increases its value when is counting breaks' time and
      // decreasing when counting works' time.
      if delegate.state == .workTime {
        delegate.animationDuration = leftAnimationTime - differenceBetweenDates
      } else {
        delegate.animationDuration = leftAnimationTime + differenceBetweenDates
      }
      
      // Bring progress circle to present state
      delegate.progressValue = delegate.animationDuration / delegate.workTime
      delegate.sessionTitle = self.userDefaults.string(forKey: .sessionTitleKey) ?? ""
      self.clearSessionUserDefaults()
      self.isUsingDisk = false
    }
  }
  
  internal func clearSessionUserDefaults() {
    userDefaultsBackgroundQueue.async { [weak self] in
      guard let self = self else { return }
      let keys: [String] = [.stateKey, .progressValueKey, .numberOfSessionsKey,
                            .workTimeKey, .animationDurationKey, .dateKey]
      
      for key in keys {
        self.userDefaults.removeObject(forKey: key)
      }
    }
  }
}


// MARK: - Core Data methods
extension StorageManager {
  func saveToCoreData(isSessionCanceled canceled: Bool) {
    guard let workIntervals = delegate?.numberOfWorkIntervals,
      let singleWorkDuration = delegate?.singleWorkDuration,
      let breakDuration = delegate?.breakDuration else {
        return
    }
    
    // 1. Check if context is present (it always should be, but
    // anything can happen.
    //
    // 2. Fill all missing data, because in any other places it
    // isn't necessary
    guard let context = delegate?.context,
      let delegate = delegate
      else { return }
    #warning("canceled and singleBreakDuration are set to constant value!")
    let totalWork = workIntervals * singleWorkDuration + (workIntervals - 1)
    let session = Session(context: context)
    session.canceled = canceled
    session.endDate = Date()
    session.id = UUID()
    session.numberOfWorkIntervals = workIntervals
    session.singleBreakDuration = breakDuration
    session.startDate = delegate.startSessionDate
    session.totalWorkDuration = totalWork
    session.singleWorkDuration = singleWorkDuration
    session.title = delegate.sessionTitle
    
    do {
      guard let context = delegate.context else { throw ErrorType.UnwrappingContextError }
      try context.save()
    } catch {
      // TODO: - Some nice Error handling here
      print(error)
    }
  }
}



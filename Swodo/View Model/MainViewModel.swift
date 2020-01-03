//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreData

#warning("Breaks aren't implemented properly!")
final class MainViewModel: ObservableObject {
  private var context: NSManagedObjectContext?
  
  private let notificationCenter = NotificationCenter.default
  private let userDefaults = UserDefaults.standard
  private var formatter: DateComponentsFormatter {
    let tempFormatter = DateComponentsFormatter()
    tempFormatter.allowedUnits = [.minute, .second]
    tempFormatter.unitsStyle = .positional
    
    return tempFormatter
  }
  
  @Published var progressValue: CGFloat = 0
  @Published var time: String = ""
  @Published var numberOfSessions = 1
  @Published var state: TimerState
  @Published var workTime: CGFloat = 1 {
    didSet {
      self.animationDuration = workTime
    }
  }
  
  @Published var animationDuration: CGFloat = 5.0 {
    willSet {
      let roundedValue = Double(newValue.rounded(.towardZero))
      guard let time = formatter.string(from: roundedValue) else { return }
      self.time = time
    }
  }
  
  var countdownTimer: Timer?
  var isReadingExecuted = false
  
  var startSessionDate: Date!
  var numberOfWorkIntervals: Int16!
  var singleWorkDuration: Int16!
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    state = .workTime
    
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer) in
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        self.animationDuration = 1.0
        self.numberOfSessions -= 1
        
        if self.numberOfSessions > 0 {
          self.animationDuration = 0
          self.startBreakCycle()
        } else {
          
          let totalWork = self.numberOfWorkIntervals * self.singleWorkDuration + (self.numberOfWorkIntervals - 1)
          
          let session = Session(context: self.context!)
          session.canceled = false
          session.endDate = Date()
          session.id = UUID()
          session.numberOfWorkIntervals = self.numberOfWorkIntervals
          session.singleBreakDuration = 5
          session.startDate = self.startSessionDate
          session.totalWorkDuration = totalWork
          session.singleWorkDuration = self.singleWorkDuration
          
          try? self.context!.save()
          
          self.state = .notStarted
          self.animationDuration = self.workTime
          self.progressValue = 1.0
          self.numberOfSessions = 1
        }
        return
        
      }
      
      self.progressValue = self.animationDuration/self.workTime
      self.animationDuration -= 0.1
    })
    self.countdownTimer?.fire()
  }
  
  internal func startBreakCycle() {
    state = .breakTime
    DispatchQueue.main.async {
      self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer) in
        guard self.animationDuration < self.workTime else {
          self.countdownTimer?.invalidate()
          self.countdownTimer = nil
          self.startWorkCycle()
          
          return
        }
        self.progressValue = self.animationDuration/self.workTime
        self.animationDuration += 0.1
        #warning("Bigger amount of time makes animation bugged with that if-condition")
        if self.progressValue > 0.99 {
          self.progressValue = 1.0
        }
      })
    }
    countdownTimer?.fire()
    
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    countdownTimer = nil
    state = .stopped
    progressValue = 1.0
    
    // It somehow fixes the bug with invalid ring's value resetting.
    animationDuration = workTime
  }
  
  func pauseAnimation() {
    countdownTimer?.invalidate()
    countdownTimer = nil
  }
  
  func saveSession() {
    isReadingExecuted = false
    
    countdownTimer?.invalidate()
    countdownTimer = nil
    
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(state.rawValue, forKey: .stateKey)
    userDefaults.set(progressValue, forKey: .progressValueKey)
    userDefaults.set(numberOfSessions, forKey: .numberOfSessionsKey)
    userDefaults.set(workTime, forKey: .workTimeKey)
    userDefaults.set(animationDuration, forKey: .animationDurationKey)
    userDefaults.set(Date(), forKey: .dateKey)
    
  }
  
  func readUnfinishedSession() {
    guard !isReadingExecuted else { return }
    isReadingExecuted = true
    
    if state == .notStarted {
      progressValue = 1.0
      return
    }
    
    userDefaults.register(defaults: [.workTimeKey : 5])
    
    let exitDate = userDefaults.value(forKey: .dateKey) as! Date
    var differenceBetweenDates = CGFloat(-exitDate.timeIntervalSinceNow)
    
    workTime = CGFloat(userDefaults.integer(forKey: .workTimeKey))
    numberOfSessions = userDefaults.integer(forKey: .numberOfSessionsKey)
    
    while differenceBetweenDates > workTime {
      if numberOfSessions == 1 {
        state = .notStarted
      }
      
      numberOfSessions -= 1
      differenceBetweenDates -= workTime
    }
    
    let leftAnimationTime = CGFloat(userDefaults.float(forKey: .animationDurationKey))
    progressValue = CGFloat(userDefaults.float(forKey: .progressValueKey))
    
    if state == .workTime {
      animationDuration = leftAnimationTime - differenceBetweenDates
    } else {
      animationDuration = leftAnimationTime + differenceBetweenDates
    }
    
    resumeTimer(nil)
  }
  
  internal func resumeTimer(_ aNotification: Notification?) {
    countdownTimer?.invalidate()
    countdownTimer = nil
    
    switch state {
    case .workTime:
      startWorkCycle()
    case .breakTime:
      startBreakCycle()
    default:
      break
    }
  }
  
  func setupContext(_ context: NSManagedObjectContext) {
    if context.parent == nil {
      self.context = context
    }
  }
  
  init() {
    progressValue = CGFloat(userDefaults.float(forKey: .progressValueKey))
    state = TimerState(rawValue: userDefaults.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
  }
}


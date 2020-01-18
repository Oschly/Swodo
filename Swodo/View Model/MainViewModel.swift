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
  
  private let userDefaults = UserDefaults.standard
  private var formatter: DateComponentsFormatter {
    let tempFormatter = DateComponentsFormatter()
    tempFormatter.allowedUnits = [.minute, .second]
    tempFormatter.unitsStyle = .positional
    
    return tempFormatter
  }
  
  private let userDefaultsQueue = DispatchQueue(label: "com.oschly.swodo.userDefaultsTask", qos: .background)
  
  @Published var progressValue: CGFloat = 0
  @Published var time: String = ""
  @Published var numberOfSessions = 1
  @Published var state: TimerState
  @Published var workTime: CGFloat = 5 {
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
  var numberOfWorkIntervals: Int16?
  var singleWorkDuration: Int16?
  
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
          self.saveToCoreData()
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
    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer) in
      DispatchQueue.global(qos: .userInitiated).async {
      guard self.animationDuration < self.workTime else {
        self.countdownTimer?.invalidate()
        self.startWorkCycle()
        
        return
      }
      
      self.progressValue = self.animationDuration/self.workTime
      self.animationDuration += 0.1
      #warning("Bigger amount of time makes animation bugged with that if-condition")
      if self.progressValue > 0.999 {
        self.progressValue = 1.0
      }
      }
    })
    
    DispatchQueue.main.async {
      self.countdownTimer?.fire()
    }
    
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    state = .stopped
    progressValue = 1.0
    
    // It somehow fixes the bug with invalid ring's value resetting.
    animationDuration = workTime
  }
  
  func saveSession() {
    isReadingExecuted = false
    
    countdownTimer?.invalidate()
    
    let userDefaults = UserDefaults.standard
    
    userDefaultsQueue.async { [weak self] in
      userDefaults.set(self?.state.rawValue, forKey: .stateKey)
      userDefaults.set(self?.progressValue, forKey: .progressValueKey)
      userDefaults.set(self?.numberOfSessions, forKey: .numberOfSessionsKey)
      userDefaults.set(self?.workTime, forKey: .workTimeKey)
      userDefaults.set(self?.animationDuration, forKey: .animationDurationKey)
      userDefaults.set(Date(), forKey: .dateKey)
    }
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
  
  internal func saveToCoreData() {
    guard let workIntervals = numberOfWorkIntervals,
      let singleWorkDuration = singleWorkDuration else {
        return
    }
    
    let totalWork = workIntervals * singleWorkDuration + (workIntervals - 1)
    
    let session = Session(context: self.context!)
    session.canceled = false
    session.endDate = Date()
    session.id = UUID()
    session.numberOfWorkIntervals = workIntervals
    session.singleBreakDuration = 5
    session.startDate = self.startSessionDate
    session.totalWorkDuration = totalWork
    session.singleWorkDuration = singleWorkDuration
    
    try? self.context!.save()
  }
  
  init() {
    progressValue = CGFloat(userDefaults.float(forKey: .progressValueKey))
    state = TimerState(rawValue: userDefaults.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
  }
}

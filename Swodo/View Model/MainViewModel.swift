//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import Foundation

final class MainViewModel: ObservableObject {
  private let notificationCenter = NotificationCenter.default
  private let userDefaults = UserDefaults.standard
  private var formatter: DateComponentsFormatter {
    let tempFormatter = DateComponentsFormatter()
    tempFormatter.allowedUnits = [.minute, .second]
    tempFormatter.unitsStyle = .positional
    
    return tempFormatter
  }
  
  @Published var progressValue: Double
  @Published var time: String = ""
  @Published var isAnimationStopped = true
  @Published var numberOfSessions = 1
  @Published var state: TimerState
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
    }
  }
  
  @Published var animationDuration = 5.0 {
    willSet {
      let roundedValue = newValue.rounded(.towardZero)
      guard let time = formatter.string(from: roundedValue) else { return }
      self.time = time
    }
  }
  
  var previousTimerState: TimerState
  var countdownTimer: Timer?
  var isReadingExecuted = false
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    guard isAnimationStopped else { return }
    previousTimerState = state
    state = .workTime
    isAnimationStopped = false
    
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
      guard let self = self else { return }
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
        self.isAnimationStopped = true
        self.animationDuration = 1.0
        self.numberOfSessions -= 1
        
        if self.numberOfSessions > 0 {
          self.animationDuration = 0
          self.startBreakCycle()
        } else {
          self.previousTimerState = self.state
          self.state = .notStarted
          self.animationDuration = Double(self.workTime * 5)
          self.progressValue = 1.0
          self.numberOfSessions = 1
        }
        return
        
      }
      
      self.progressValue = self.animationDuration/Double(self.workTime * 5)
      self.animationDuration -= 0.1
    })
    self.countdownTimer?.fire()
  }
  
  internal func startBreakCycle() {
    guard isAnimationStopped else { return }
    previousTimerState = state
    state = .breakTime
    isAnimationStopped = false
    DispatchQueue.main.async {
      self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
        guard let self = self else { return }
        guard self.animationDuration < Double(self.workTime * 5) else {
          self.countdownTimer?.invalidate()
          self.countdownTimer = nil
          self.isAnimationStopped = true
          self.startWorkCycle()
          
          return
        }
        self.progressValue = self.animationDuration/Double(self.workTime * 5)
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
    previousTimerState = state
    state = .stopped
    isAnimationStopped = true
    progressValue = 1.0
    
    // It somehow fixes the bug with invalid ring's value resetting.
    animationDuration = Double(workTime * 5)
  }
  
  func pauseAnimation() {
    countdownTimer?.invalidate()
    countdownTimer = nil
    self.isAnimationStopped = true
  }
  
  func saveSession() {
    isReadingExecuted = false
    
    countdownTimer?.invalidate()
    countdownTimer = nil
    isAnimationStopped = true
    
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(state.rawValue, forKey: .stateKey)
    
    previousTimerState = state
    userDefaults.set(previousTimerState.rawValue, forKey: .previousTimerState)
    
    userDefaults.set(progressValue, forKey: .progressValueKey)
    
    userDefaults.set(numberOfSessions, forKey: .numberOfSessionsKey)
    userDefaults.set(workTime, forKey: .workTimeKey)
    userDefaults.set(animationDuration, forKey: "leftAnimationDuration")
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
    var differenceBetweenDates = -exitDate.timeIntervalSinceNow

    workTime = userDefaults.integer(forKey: .workTimeKey)
    numberOfSessions = userDefaults.integer(forKey: .numberOfSessionsKey)
    
    while differenceBetweenDates > Double(workTime * 5) {
      if numberOfSessions == 1 {
        state = .notStarted
      }
      
      numberOfSessions -= 1
      differenceBetweenDates -= Double(workTime * 5)
    }
    
    let leftAnimationTime = userDefaults.double(forKey: "leftAnimationDuration")
    progressValue = userDefaults.double(forKey: .progressValueKey)
    
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
    isAnimationStopped = true
    
    switch state {
    case .workTime:
      startWorkCycle()
      
    case .breakTime:
      startBreakCycle()
      
    default:
      break
    }
  }
  
  init() {
    progressValue = userDefaults.double(forKey: .progressValueKey)
    previousTimerState = TimerState(rawValue: userDefaults.string(forKey: .previousTimerState) ?? TimerState.notStarted.rawValue)!
    state = TimerState(rawValue: userDefaults.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
  }
}


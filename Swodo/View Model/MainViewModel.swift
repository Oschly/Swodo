//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import Foundation

enum TimerState: String {
  case notStarted
  case stopped
  case paused
  case workTime
  case endOfWork
  case breakTime
  case endOfBreak
}

final class MainViewModel: ObservableObject {
  
  // Ring's animation data
  @Published var progressValue = 1.0
  @Published var animationDuration = 5.0
  @Published var isAnimationStopped = true
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
    }
  }
  
  var countdownTimer: Timer?
  
  // Manage sessions (work-break time)
  @Published var numberOfSessions = 1
  @Published var state: TimerState = .notStarted
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    guard isAnimationStopped else { return }
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
        
        if self.numberOfSessions != 0 {
          self.animationDuration = 0
          self.startBreakCycle()
        } else {
          self.state = .stopped
          self.animationDuration = Double(self.workTime * 5)
          self.progressValue = 1.0
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
    state = .breakTime
    isAnimationStopped = false
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
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
    countdownTimer?.fire()
    
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    countdownTimer = nil
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
  
  func saveSession(aNotification: Notification) {
    let userDefaults = UserDefaults.standard
    
    // Consider reducing saving data to make it less laggy on exit.
    userDefaults.set(isAnimationStopped, forKey: "isAnimationStopped")
    userDefaults.set(animationDuration, forKey: "animationDuration")
    userDefaults.set(numberOfSessions, forKey: "numberOfSessions")
    userDefaults.set(progressValue, forKey: "progressValue")
    userDefaults.set(workTime, forKey: "workTime")
    userDefaults.set(state.rawValue, forKey: "TimerState")
    
    print("saved!")
  }
}

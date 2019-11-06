//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

enum TimerState {
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
  @Published var countdownTimer: Timer?
  @Published var animationDuration = 5.0
  @Published var isAnimationStopped = true
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
    }
  }
  
  
  // Manage sessions (work-break time)
  @Published var numberOfSessions = 1
  @Published var state: TimerState = .notStarted
  
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    guard isAnimationStopped else { return }
    state = .workTime
    isAnimationStopped = false
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self]  _ in
      guard let self = self else { return }
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
        self.isAnimationStopped = true
        self.animationDuration = 1.0
        self.numberOfSessions -= 1
        
        if self.numberOfSessions != 0 {
          self.animationDuration = 5
          self.state = .stopped
          self.startBreakCycle()
        }
        
        return
      }
      self.progressValue = self.animationDuration/Double(self.workTime * 5)
      self.animationDuration -= 0.1
    })
  }
  
  internal func startBreakCycle() {
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {  _ in
      guard self.animationDuration < 1 else {
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil


        return
      }
      self.progressValue = self.animationDuration/Double(self.workTime * 5)
      self.animationDuration += 0.1
    })
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    countdownTimer = nil
    state = .stopped
    isAnimationStopped = true
    progressValue = 1.0
    
    // It somehow fixes the bug with invalid ring's value resetting.
    animationDuration = 5.0
  }
  
  func pauseAnimation() {
    countdownTimer?.invalidate()
    countdownTimer = nil
    isAnimationStopped = true
  }
  
  
}

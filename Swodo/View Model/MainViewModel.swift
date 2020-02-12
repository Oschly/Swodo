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

final class MainViewModel: ObservableObject {
  internal var context: NSManagedObjectContext?
  private let storageManager = StorageManager()
  
  @Published var progressValue: CGFloat = 0
  @Published var time = String()
  @Published var numberOfSessions = 1
  @Published var state: TimerState
  @Published var workTime: CGFloat = 5
  @Published var animationDuration: CGFloat = 5.0 {
    willSet {
      if state == .workTime {
        time = newValue.timeFormattedToString()
      } else if state == .breakTime {
        time = (self.workTime - self.animationDuration).timeFormattedToString()
      }
    }
  }
  
  var countdownTimer: Timer!
  var startSessionDate: Date!
  var numberOfWorkIntervals: Int16?
  var singleWorkDuration: Int16?
  
  init() {
    state = TimerState(rawValue: UserDefaults.standard.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
    storageManager.delegate = self
  }
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    state = .workTime
    
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
      guard let self = self else { return }
      
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        self.animationDuration = 1.0
        self.numberOfSessions -= 1
        
        if self.numberOfSessions > 0 {
          // Start break cycle
          self.animationDuration = 0
          self.startBreakCycle()
        } else {
          // End whole session
          self.saveToCoreData()
          self.animationDuration = 0
          
          self.state = .notStarted
          self.animationDuration = self.workTime
          self.numberOfSessions = Int(self.numberOfWorkIntervals ?? 1)
          self.numberOfWorkIntervals = nil
        }
        return
        
      }
      
      self.modifyProgressValue(mathOperation: .subtraction)
    })
    RunLoop.current.add(countdownTimer!, forMode: .common)
  }
  
  internal func startBreakCycle() {
    state = .breakTime
    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
      guard let self = self else { return }
      
      guard self.animationDuration < self.workTime else {
        self.countdownTimer?.invalidate()
        self.startWorkCycle()
        return
      }
      
      self.modifyProgressValue(mathOperation: .addition)
      if self.progressValue > 0.999 {
        self.progressValue = 1.0
      }
    })
    
    RunLoop.current.add(countdownTimer!, forMode: .common)
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    state = .stopped
    progressValue = 1.0
    animationDuration = workTime
  }
  
  func saveSession() {
    countdownTimer?.invalidate()
    storageManager.saveSession()
  }
  
  func readUnfinishedSession() {
    storageManager.readUnfinishedSession()
    resumeTimer()
  }
  
  internal func resumeTimer() {
    countdownTimer?.invalidate()
    
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
    storageManager.saveToCoreData()
  }
  
  internal func setWorkTime() {
    animationDuration = workTime
  }
  
  internal func modifyProgressValue(mathOperation: MathOperationType) {
    let formula = 1 / (self.workTime / 0.1)
    mathOperation.execute(lhs: &progressValue, rhs: formula)
    mathOperation.execute(lhs: &animationDuration, rhs: 0.1)
  }
}

extension MainViewModel: StorageManagerDelegate {}

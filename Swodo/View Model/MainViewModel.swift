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
import UIKit

#warning("Add somewhere notification that when device orientation changes, selection view refreshes")
final class MainViewModel: ObservableObject {
  internal var context: NSManagedObjectContext?
  
  private let storageManager = StorageManager()
  
  @Published var progressValue: CGFloat = 1.0
  
  @Published var time = String()
  
  @Published var sessionTitle = String()
  
  @Published var numberOfSessions: Int
  
  @Published var state: TimerState
  
  @Published var workTime: CGFloat = 300
  
  @Published var animationDuration: CGFloat = 5.0
  
  var countdownTimer: Timer!
  
  var startSessionDate: Date!
  
  var numberOfWorkIntervals: Int16?
  
  var singleWorkDuration: Int16?
  
  var breakDuration: Int16?
    
  init() {
    state = TimerState(rawValue: UserDefaults.standard.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
    numberOfSessions = 1
    storageManager.delegate = self
  }
  
  
  // https://stackoverflow.com/a/58048635/8140676
  func startWorkCycle() {
    
    state = .workTime
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
      guard let self = self else { return }
      
      guard self.animationDuration > 0 else {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred(intensity: 100)
        
        self.countdownTimer?.invalidate()
        self.animationDuration = 1.0
        self.numberOfSessions -= 1
        
        if self.numberOfSessions > 0 {
          // Start break cycle
          
          self.animationDuration = 0
          self.startBreakCycle()
        } else {
          // End whole session
          let impact = UIImpactFeedbackGenerator(style: .heavy)
          impact.impactOccurred(intensity: 100)
          
          self.state = .notStarted
          if Settings.shared.historyEnabled {
            self.saveToCoreData(isSessionCancelled: false)
          }
          self.animationDuration = 0
          
          self.animationDuration = self.workTime
          self.numberOfSessions = Int(self.numberOfWorkIntervals ?? 1)
          
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
        
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred(intensity: 100)
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
  
  internal func saveToCoreData(isSessionCancelled canceled: Bool) {
    if canceled {
      numberOfWorkIntervals = numberOfWorkIntervals! - Int16(numberOfSessions)
    }
    storageManager.saveToCoreData(isSessionCanceled: canceled)
    self.numberOfWorkIntervals = 1
  }
  
  internal func setWorkTime() {
    animationDuration = workTime
  }
  
  internal func modifyProgressValue(mathOperation: MathOperationType) {
    let formula = 1 / (self.workTime / 0.1)
    mathOperation.execute(lhs: &progressValue, rhs: formula)
    mathOperation.execute(lhs: &animationDuration, rhs: 0.1)
    
    if state == .workTime {
      time = animationDuration.timeFormattedToString()
    } else if state == .breakTime {
      time = (self.workTime - self.animationDuration).timeFormattedToString()
    }
  }
}

// MARK: - Debug inits
extension MainViewModel {
  #if DEBUG
  convenience init(time: String = "0:01",
                   sessionTitle: String = "Doing stuff",
                   numberOfSessions: Int = 1,
                   state: TimerState = .notStarted,
                   animationDuration: CGFloat = 5,
                   workTime: CGFloat = 5,
                   progressValue: CGFloat = 1) {
    self.init()
    
    self.time = time
    self.sessionTitle = sessionTitle
    self.numberOfSessions = numberOfSessions
    self.state = state
    self.animationDuration = animationDuration
    self.workTime = workTime
    self.progressValue = progressValue
  }
  #endif
}

extension MainViewModel: StorageManagerDelegate {}

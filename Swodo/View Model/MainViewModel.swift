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
final class MainViewModel: ObservableObject, StorageManagerDelegate {
  internal var context: NSManagedObjectContext?
  private let storageManager = StorageManager()
  
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
  
  var countdownTimer: Timer!
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
          self.animationDuration = 0
          self.saveToCoreData()
          
          self.state = .notStarted
          self.animationDuration = self.workTime
          self.progressValue = 1.0
          self.numberOfSessions = Int(self.numberOfWorkIntervals ?? 1)
        }
        return
        
      }
      
      self.progressValue = self.animationDuration/self.workTime
      self.animationDuration -= 0.1
    })
    RunLoop.current.add(countdownTimer!, forMode: .common)
  }
  
  internal func startBreakCycle() {
    state = .breakTime
    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] timer in
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
    })
    RunLoop.current.add(countdownTimer!, forMode: .common)
  }
  
  func stopWorkSession() {
    countdownTimer?.invalidate()
    state = .stopped
    progressValue = 1.0
    
    // It somehow fixes the bug with invalid ring's value resetting.
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
  
  init() {
    progressValue = CGFloat(UserDefaults.standard.float(forKey: .progressValueKey))
    state = TimerState(rawValue: UserDefaults.standard.string(forKey: .stateKey) ?? TimerState.notStarted.rawValue)!
    storageManager.delegate = self
  }
}


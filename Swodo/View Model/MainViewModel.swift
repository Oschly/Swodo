//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI
import Combine

enum TimerState {
  case notStarted
  case paused
  case workTime
  case endOfWork
  case breakTime
  case endOfBreak
}

final class MainViewModel: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  // Ring's animation data
  @Published var countdownTimer: Timer? { didSet { didChange.send() } }
  @Published var progressValue = 1.0 { didSet { didChange.send() } }
  @Published var animationDuration = 5.0 { didSet { didChange.send() } }
  @Published var isAnimationStopped = true { didSet { didChange.send() } }
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
      didChange.send()
    }
  }
  
  // Manage sessions (work-break time)
  @Published var numberOfSessions = 1 { didSet { didChange.send() } }
  @Published var state: TimerState = .notStarted { didSet { didChange.send() } }
  
  // https://stackoverflow.com/a/58048635/8140676
  func startAnimation() {
    guard isAnimationStopped else { return }
    isAnimationStopped = false
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {  _ in
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        self.state = .endOfWork
        return
      }
      self.progressValue = self.animationDuration/Double(self.workTime * 5)
      self.animationDuration -= 0.1
    })
  }
  
    func stopAnimation() {
      countdownTimer?.invalidate()
      isAnimationStopped = true
  }
  

}

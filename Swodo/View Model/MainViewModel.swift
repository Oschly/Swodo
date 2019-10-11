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

class MainViewModel: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  // This object allows us to control anim
  @Published var countdownTimer: Timer? { didSet { didChange.send() } }
  
  // Overall ring's fill progress
  @Published var progressValue = 1.0 { didSet { didChange.send() } }
  @Published var animationDuration = 5.0 { didSet { didChange.send() } }
  @Published var stopAnimation = true { didSet { didChange.send() } }
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
      didChange.send()
    }
  }
  
  // Manage sessions (work-break time)
  @Published var numberOfSessions = 1 { didSet { didChange.send() } }
  @Published var state: TimerState = .notStarted { didSet { didChange.send() } }
}

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
  
  // This object allows us to control anim
  @Published var countdownTimer: Timer? { didSet { didChange.send() } }
  
  // Overall ring's fill progress
  @Published var progressValue = 1.0 { didSet { didChange.send() } }
  @Published var animationDuration = 5.0 { didSet { didChange.send() } }
  @Published var shouldAnimate = true { didSet { didChange.send() } }
  @Published var workTime = 1 {
    didSet {
      self.animationDuration = Double(workTime * 5)
      didChange.send()
    }
  }
  
  // Manage sessions (work-break time)
  @Published var numberOfSessions = 1 { didSet { didChange.send() } }
  @Published var state: TimerState = .notStarted { didSet { didChange.send() } }
  
  private var newRing = AnimatedRing()
  
  // MARK: - Views
  var ring: some View {
    AnimatedRing(progressValue: progressValue, shouldAnimate: shouldAnimate)
  }
  
  var pickers: some View {
    Pickers(duration: progressValue, sessions: numberOfSessions)
  }
  
  func startAnimation() {
    guard shouldAnimate else { return }
    shouldAnimate = false
    countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
      guard self.animationDuration > 0 else {
        self.countdownTimer?.invalidate()
        return
      }
      self.progressValue = self.animationDuration/Double(self.workTime * 5)
      self.animationDuration -= 0.1
    })
  }
  
  func stopAnimation() {
    self.countdownTimer?.invalidate()
    self.shouldAnimate = true
  }
  
  func returnProperView() -> AnyView {
    switch state {
    case .notStarted:
      return AnyView(Pickers(duration: self.animationDuration, sessions: self.numberOfSessions))
    case .paused:
      return AnyView(pickers)
    case .workTime:
      defer {
        startAnimation()
      }
      
      return AnyView(ring)
    case .endOfWork:
      return AnyView(pickers)
    case .breakTime:
      return AnyView(ring)
    case .endOfBreak:
      return AnyView(ring)
    }
  }
}

struct AnimatedRing: View {
  
  @State var progressValue: Double = 1.0
  @State var shouldAnimate: Bool = true
  
  #warning("Add Feature to change color of Ring")
  var body: some View {
    Ring(fillPoint: 0.0)
      .stroke(Color.red, lineWidth: 15.0)
      .frame(width: 200, height: 200)
      .padding(40)
      .animation(shouldAnimate ? nil : .easeIn(duration: 0.1))
  }
}

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
  
  // MARK: - Views
  var ring: some View {
    return Ring(fillPoint: self.progressValue)
      .stroke(Color.red, lineWidth: 15.0)
      .frame(width: 200, height: 200)
      .padding(40)
      .animation(self.shouldAnimate ? nil : .easeIn(duration: 0.1))
  }
  
    var pickers: some View {
      GeometryReader { geometry in
        HStack {
          VStack {
            Picker(selection: self.$progressValue, label: Text("")) {
              ForEach(Range(1...24), id: \.self) { index in
                Text("\(index * 5) Minutes").id(index)
              }
            }.frame(maxWidth: geometry.size.width / 2,
                    maxHeight: 74)
              .clipped()
              .labelsHidden()
            Text("Session's duration")
          }
          VStack {
            Picker(selection: self.$numberOfSessions,
                   label: Text("Number of sessions")) {
                    ForEach(Range(1...10), id: \.self) { index in
                      Text("\(index)").id(index)
                    }
            }.frame(maxWidth: geometry.size.width / 2,
                    maxHeight: 74)
              .clipped()
              .labelsHidden()
            Text("Number of sessions")
          }
        }
      }
  }
  
  func startAnimation() {
    guard shouldAnimate == true else { return }
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
        return AnyView(Circle())
      case .paused:
        return AnyView(pickers)
      case .workTime:
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

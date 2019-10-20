//
//  AnimatedRing.swift
//  Swodo
//
//  Created by Oschły on 20/10/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI
import Combine

struct AnimatedRing: View {
  
  @ObservedObject private var viewModel = MainViewModel()
  
  #warning("Add Feature to change color of Ring")
  var body: some View {
    Ring(fillPoint: viewModel.progressValue)
      .stroke(Color.red, lineWidth: 15.0)
      .frame(width: 200, height: 200)
      .padding(40)
      .animation(viewModel.isAnimationStopped ? nil : .easeIn(duration: 0.1))
  }
  

  
  func stopAnimation() {
    viewModel.countdownTimer?.invalidate()
    //    self.shouldAnimate = true
  }
}


final class AnimatedRingViewModel: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  @Published var progressValue = 1.0 { didSet { didChange.send() } }
  @Published var isAnimationStopped = true { didSet { didChange.send() } }
  // This object allows us to control anim
  @Published var countdownTimer: Timer? { didSet { didChange.send() } }

  

}

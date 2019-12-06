//
//  RingView.swift
//  Swodo
//
//  Created by Oskar on 06/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct RingView: View {
  @ObservedObject var viewModel: MainViewModel
  
  private let notificationCenter = NotificationCenter.default
  
  var body: some View {
    VStack {
      Ring(fillPoint: viewModel.progressValue)
        .stroke(Color.red, lineWidth: 15.0)
        .frame(width: 200, height: 200)
        .padding(40)
        .animation(viewModel.isAnimationStopped ? nil : .easeIn(duration: 0.1))
      
      HStack {
        Button("Resume") {
          self.viewModel.startWorkCycle()
        }
        Button("Stop") {
          self.viewModel.stopWorkSession()
        }
        Button("Pause") {
          self.viewModel.pauseAnimation()
        }
      }
    }
    .onAppear {
      self.notificationCenter.addObserver(forName: .appIsGoingToBackground, object: nil, queue: nil, using: self.viewModel.saveSession)
    }
  }
  
  // Move to ViewModel!

}


extension NSNotification.Name {
  static let appIsGoingToBackground = Notification.Name("AppIsGoingToBackground")
}

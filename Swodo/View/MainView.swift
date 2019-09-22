//
//  ContentView.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @State private var fillPoint = 1.0
  @State private var animationDuration = 60.0
  @State private var  stopAnimation = true
  @State private var countdownTimer: Timer?
  
  private var fillPointMax: Double = 60
  
  private var ring: Ring {
    let ring = Ring(fillPoint: self.fillPoint)
    return ring
  }
  
  // https://stackoverflow.com/a/58048635/8140676
  var body: some View {
    VStack {
      ring.stroke(Color.red, lineWidth: 15.0)
        .frame(width: 200, height: 200)
        .padding(40)
        .animation(self.stopAnimation ? nil : .easeIn(duration: 0.1))
      HStack {
        Button(action: {
          guard self.stopAnimation == true else { return }
          self.stopAnimation = false
          self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            guard self.animationDuration > 0 else {
              self.countdownTimer?.invalidate()
              return
            }
            self.fillPoint = self.animationDuration/self.fillPointMax
            self.animationDuration -= 0.1
            print(self.fillPoint)
          })
        }) {
          Text("Start")
        }
        Button(action: {
          self.countdownTimer?.invalidate()
          self.stopAnimation = true
        }) {
          Text("Stop")
        }
      }
    }
  }
}
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}


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
    
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack {
          Ring(fillPoint: self.viewModel.progressValue)
            .stroke(Color.red, lineWidth: 15.0)
            .frame(width: geometry.size.width * 0.8,
                   height: geometry.size.height / 3)
            .padding(40)
            .animation(self.viewModel.isAnimationStopped ? nil : .easeIn(duration: 0.1))
            .padding(geometry.size.height * 0.05)
          
          Text(self.viewModel.time)
            .font(.largeTitle)
          .bold()
            .fontWeight(.heavy)
        }
        
        Spacer()
        HStack() {
          Button("Resume") {
            print(self.viewModel.progressValue)
            switch self.viewModel.previousTimerState {
            case .breakTime:
              self.viewModel.startBreakCycle()
            default:
              self.viewModel.startWorkCycle()
              print("\(self.viewModel.previousTimerState)")
            }
          }
          Button("Stop") {
            self.viewModel.stopWorkSession()
          }
          Button("Pause") {
            self.viewModel.pauseAnimation()
          }
        }
        Spacer(minLength: geometry.size.height / 3 + 5)
      }
    }
  }
}



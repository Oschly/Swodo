//
//  ContentView.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @ObservedObject private var viewModel = MainViewModel()
  
  private var ring: Ring {
    let ring = Ring(fillPoint: self.viewModel.fillPoint)
    return ring
  }
  
  // https://stackoverflow.com/a/58048635/8140676
  var body: some View {
    VStack {
      ring.stroke(Color.red, lineWidth: 15.0)
        .frame(width: 200, height: 200)
        .padding(40)
        .animation(self.viewModel.stopAnimation ? nil : .easeIn(duration: 0.1))
      GeometryReader { geometry in
        HStack {
          VStack {
            Picker(selection: self.$viewModel.fillPointMax, label: Text("")) {
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
            Picker(selection: self.$viewModel.numberOfSessions,
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
      HStack {
        Button(action: {
          guard self.viewModel.stopAnimation == true else { return }
          self.viewModel.stopAnimation = false
          self.viewModel.countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            guard self.viewModel.animationDuration > 0 else {
              self.viewModel.countdownTimer?.invalidate()
              return
            }
            self.viewModel.fillPoint = self.viewModel.animationDuration/Double(self.viewModel.fillPointMax * 5)
            self.viewModel.animationDuration -= 0.1
            print(self.viewModel.fillPoint)
          })
        }) {
          Text("Start")
        }
        Button(action: {
          self.viewModel.countdownTimer?.invalidate()
          self.viewModel.stopAnimation = true
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


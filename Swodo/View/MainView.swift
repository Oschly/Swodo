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
  
  private var pickers: some View {
    GeometryReader { geometry in
      HStack {
        VStack {
          Picker(selection: self.$viewModel.workTime, label: Text("")) {
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
  }
  
  private var ring: some View {
    return Ring(fillPoint: viewModel.progressValue)
      .stroke(Color.red, lineWidth: 15.0)
      .frame(width: 200, height: 200)
      .padding(40)
      .animation(viewModel.isAnimationStopped ? nil : .easeIn(duration: 0.1))
  }
  
  var body: some View {
    VStack {
      returnProperView()
      HStack {
        Button(action: {
          self.viewModel.state = .workTime
        }) {
          Text("Start")
        }
        Button(action: {
          self.viewModel.state = .paused
        }) {
          Text("Stop")
        }
      }
    }
  }
  
  internal func returnProperView() -> AnyView {
    switch viewModel.state {
    case .notStarted:
      return AnyView(pickers)
    case .paused:
      defer {
        viewModel.stopAnimation()
      }
      return AnyView(pickers)
    case .workTime:
      defer {
        viewModel.startAnimation()
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
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}


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
            ForEach(1...24, id: \.self) { index in
              Text("\(index * 5) Minutes")
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
                  ForEach(1...10, id: \.self) { index in
                    Text("\(index)")
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
  
  
  // MARK: - Body
  var body: some View {
    VStack {
      returnProperView()
      HStack {
        Button("Start") {
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
  }
  
  internal func returnProperView() -> AnyView {
    switch viewModel.state {
    case .notStarted:
      return AnyView(pickers)
    case .stopped:
      return AnyView(pickers)
    case .paused:
      return AnyView(ring)
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

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}


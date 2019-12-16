//
//  TabBarView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  @ObservedObject var mainViewModel: MainViewModel
  @State private var opacity = 0.0
  
  var body: some View {
    if mainViewModel.state == .workTime {
      return AnyView(MainView(viewModel: mainViewModel)
        .opacity(opacity)
        .onAppear {
          withAnimation(.easeIn) {
            self.opacity = 1.0
          }
      }
      .onDisappear {
        self.opacity = 0.0
      })
    }
    
    return AnyView(TabView {
      MainView(viewModel: mainViewModel).tabItem {
        VStack {
          Text("Timer")
          Image(systemName: "clock")
            .font(.system(size: 23))
        }
      }
      
      Text("Stats").tabItem {
        VStack {
          Text("Statistics")
          Image(systemName: "chart.bar")
            .font(.system(size: 23))
        }
      }
      
      Text("Settings").tabItem {
        VStack {
          Text("Settings")
          Image(systemName: "gear")
            .font(.system(size: 23))
          
        }
      }
    }
    .opacity(opacity)
    .onAppear {
      withAnimation(.easeIn) {
        self.opacity = 1.0
      }
    }
    .onDisappear {
      self.opacity = 0.0
    })
  }
}

//
//  TabBarView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  @EnvironmentObject var mainViewModel: MainViewModel
  @State private var opacity = 0.0
  
  var body: some View {
    // If user launched session, there shouldn't be on the screen anything
    // what's not related with timer itself and OS's elements
    if mainViewModel.state == .workTime || mainViewModel.state == .breakTime {
      return AnyView(
        RingView()
          
          // Code below gives smooth transistions between
          // timer's states
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
    
    // If not in working state, return default app's view
    return AnyView(TabView {
      SelectionView()
        .tabItem {
          VStack {
            Text("Timer")
            Image(systemName: "clock")
              .font(.system(size: 23))
          }
      }
      
      HistoryView()
        .tabItem {
          VStack {
            Text("Statistics")
            Image(systemName: "chart.bar")
              .font(.system(size: 23))
          }
      }
      
      Text("Settings")
        .tabItem {
          VStack {
            Text("Settings")
            Image(systemName: "gear")
              .font(.system(size: 23))
            
          }
      }
    }
      
      // Code below gives smooth transistions between
      // timer's states
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



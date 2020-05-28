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
  @EnvironmentObject var settings: Settings
  @State private var opacity = 0.0
  
  var body: some View {
    // If user launched session, there shouldn't be on the screen anything
    // what's not related with timer itself and OS's elements
    if mainViewModel.state == .workTime ||
      mainViewModel.state == .breakTime ||
      mainViewModel.state == .stopped {
      return AnyView(
        FocusView()
          
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
      
      if settings.historyEnabled {
        HistoryView()
          .tabItem {
            VStack {
              Text("History")
              Image(systemName: "chart.bar")
                .font(.system(size: 23))
            }
        }
      }
      
      SettingsView()
        .tabItem {
          VStack {
            Text("Settings")
            Image(systemName: "gear")
              .font(.system(size: 23))
            
          }
      }
    }
    .accentColor(settings.theme.value())
      
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
  
  init() {
  }
}



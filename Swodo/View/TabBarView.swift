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
  
  var body: some View {
    ZStack {
      TabView {
        MainView(viewModel: mainViewModel).tabItem {
          Text("Timer")
          Image(systemName: "clock")
        }
      }
    }
  }
}

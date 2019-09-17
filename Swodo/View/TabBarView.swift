//
//  TabBarView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  let viewModel = MainViewModel()
  
  var body: some View {
    TabView {
      MainView().tabItem {
        Text("Timer")
        Image(systemName: "clock")
      }
    }
  }
}
//            withAnimation(.easeIn(duration: self.animationDuration)) {
//              self.fillPoint = 0.0

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView()
  }
}

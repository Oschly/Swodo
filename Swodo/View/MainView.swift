//
//  MainView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  let viewModel = MainViewModel()
  
  @State private var fillPoint = 1.0
  @State private var animationDuration = 5.0
  
  var body: some View {
    TabView {
      Group {
        Ring(fillPoint: fillPoint).stroke(Color.red, lineWidth: 15)
          .frame(width: 200, height: 200)
          .onAppear() {
            withAnimation(.easeIn(duration: self.animationDuration)) {
              self.fillPoint = 0.0
            }
        }
      }.tabItem {
        Text("Timer")
        Image(systemName: "clock")
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

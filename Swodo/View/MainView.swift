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
  
  // https://stackoverflow.com/a/58048635/8140676
  var body: some View {
    VStack {
      self.viewModel.returnProperView()
      HStack {
        Button(action: {
          self.viewModel.startAnimation()
        }) {
          Text("Start")
        }
        Button(action: {
          self.viewModel.stopAnimation()
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


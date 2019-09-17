//
//  ContentView.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @State private var fillPoint = 1.0
  @State private var animationDuration = 5.0
  
  var body: some View {
    VStack {
      Ring(fillPoint: fillPoint).stroke(Color.red, lineWidth: 15.0)
        .frame(width: 200, height: 200)
        .padding(40)
      HStack {
        Button(action: {
          withAnimation {
              self.fillPoint = 0
          }
        }) {
          Text("Start")
        }
        Button(action: {
          withAnimation { 
            self.fillPoint = 1
          }
        }) {
          Text("Reset")
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

//
//  MainView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @State private var fillPoint = 1.0
  
  var body: some View {
    Group {
      Ring(fillPoint: fillPoint).stroke(Color.red, lineWidth: 15)
        .frame(width: 200, height: 200)
        .onAppear() {
          withAnimation() {
            self.fillPoint = 0.0
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

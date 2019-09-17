//
//  ContentView.swift
//  Swodo
//
//  Created by Oschły on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var fillPoint = 0.0
  
  var body: some View {
    Ring(fillPoint: fillPoint).stroke(Color.red, lineWidth: 15)
      .frame(width: 200, height: 200)
      .onAppear() {
        withAnimation() {
          self.fillPoint = 1.0
        }
    }
  }
}

struct Ring: Shape {
  var fillPoint: Double
  var delayPoint = 0.5
  
  var animatableData: Double {
    get { return fillPoint }
    set { fillPoint = newValue }
  }
  
  func path(in rect: CGRect) -> Path {
    var start = 0.0
    let end = 360 * fillPoint
    
    var path = Path()
    
    path.addArc(center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2, startAngle: .degrees(start - 90), endAngle: .degrees(end - 90),
                clockwise: false)
    return path
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

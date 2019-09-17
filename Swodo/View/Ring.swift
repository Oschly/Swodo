//
//  Ring.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct Ring: Shape {
  var delayPoint = 0.5
  private var startArcAngle: Double
  
  var fillPoint: Double {
    willSet {
      startArcAngle = 360 * newValue
    }
  }
  
  internal var animatableData: Double {
    get { return fillPoint }
    set { fillPoint = newValue }
  }
  
  internal func path(in rect: CGRect) -> Path {
    let endArcAngle = 0.0
    
    var path = Path()
    
    path.addArc(center: CGPoint(x: rect.size.width / 2,
                                y: rect.size.height / 2),
                radius: rect.size.width / 2,
                startAngle: .degrees(startArcAngle - 90),
                endAngle: .degrees(endArcAngle - 90),
                clockwise: true)
    
    return path
  }
}

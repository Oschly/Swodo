//
//  MathOperationType.swift
//  Swodo
//
//  Created by Oskar on 09/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import CoreGraphics

enum MathOperationType {
  case addition
  case subtraction
  
  func execute(lhs: inout CGFloat, rhs: CGFloat) {
    switch self {
      case .addition:
        lhs += rhs
      case .subtraction:
        lhs -= rhs
    }
  }
}

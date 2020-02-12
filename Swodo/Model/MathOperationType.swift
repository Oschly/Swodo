//
//  MathOperationType.swift
//  Swodo
//
//  Created by Oskar on 09/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import CoreGraphics

// Gives more readability in calculating Progress Circle's fill,
// even though it's more lines.
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

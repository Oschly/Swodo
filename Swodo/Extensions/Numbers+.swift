//
//  Numbers+.swift
//  Swodo
//
//  Created by Oskar on 08/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - CGFloat extensions
extension CGFloat {
  func double() -> Double {
    Double(self)
  }
  
  func humanReadable() -> String {
    String(format: "%.f", self)
  }
  
  func timeFormattedToString() -> String {
    let formatter = DateComponentsFormatter.viewTimeFormatter
    let rounded = self.rounded(.up).double()
    
    // TODO: - Some spicy handling here
    guard let string = formatter.string(from: rounded) else { return "" }
    return string
  }
}

// MARK: - Int Extensions
extension BinaryInteger {
  func cgfloat() -> CGFloat {
    CGFloat(self)
  }
}

//
//  DateComponentsFormatter.swift
//  Swodo
//
//  Created by Oskar on 08/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import Foundation

// Helps in method inside Numbers+.swift with
// converting CGFloats to time values.
extension DateComponentsFormatter {
  static var viewTimeFormatter: DateComponentsFormatter {
    let tempFormatter = DateComponentsFormatter()
    tempFormatter.allowedUnits = [.minute, .second]
    tempFormatter.unitsStyle = .positional
    
    return tempFormatter
  }
}

public extension Optional where Wrapped == Date {
  var hour: String {
    let formatter = DateComponentsFormatter()
    guard let date = self,
      let components = formatter.calendar?.dateComponents([.hour, .minute], from: date),
      let string = formatter.string(from: components)
      else {
        return ""
    }
    
    return string
  }
}

public extension Bool {
  var humanFriendly: String { self ? "Yes" : "No" }
}

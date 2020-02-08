//
//  DateComponentsFormatter.swift
//  Swodo
//
//  Created by Oskar on 08/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
  static var viewTimeFormatter: DateComponentsFormatter {
    let tempFormatter = DateComponentsFormatter()
    tempFormatter.allowedUnits = [.minute, .second]
    tempFormatter.unitsStyle = .positional
    
    return tempFormatter
  }
}

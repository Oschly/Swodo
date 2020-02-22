//
//  ProgressDataDelegate.swift
//  Swodo
//
//  Created by Oskar on 12/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import Foundation
import CoreGraphics

// Values needed in multiple places, but not for everyone
//  with all values provided with class that holds these objects.

protocol ProgressDataDelegate {
  var numberOfWorkIntervals: Int16? { get set }
  var animationDuration: CGFloat { get set }
  var progressValue: CGFloat { get set }
  var numberOfSessions: Int { get set }
  var state: TimerState { get set }
  var workTime: CGFloat { get set }
  var singleWorkDuration: Int16? { get set }
  var startSessionDate: Date! { get set }
  var sessionTitle: String { get set }
}

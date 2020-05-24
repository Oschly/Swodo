//
//  TimerState.swift
//  Swodo
//
//  Created by Oskar on 07/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

// notStarted - it's almost all time when Progress Circle isn't visible.
// workTime - interval when Progress Circle's fill value is decreasing
// breakTime - interval when Progress Circle's fill value is increasing.
// stopped - temporary state, which will help in resolving if given session is canceled,
//            right after that state it should be changed to notStarted.
enum TimerState: String {
  case notStarted
  case workTime
  case breakTime
  case stopped
  
  func buttonTitle() -> String {
    switch self {
    case .notStarted:
      return "Start"
    default:
      return "Stop"
    }
  }
}

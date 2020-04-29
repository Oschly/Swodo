//
//  Settings.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI
import UIKit

final class Settings: ObservableObject {
  @Published var theme: ColorLiteral {
    didSet {
      UserDefaults.standard.set(theme.rawValue, forKey: "theme")
    }
  }
  
  @Published var ringTheme: ColorLiteral {
    didSet {
      UserDefaults.standard.set(ringTheme.rawValue, forKey: "ringTheme")
    }
  }
  
  init() {
    theme = ColorLiteral(rawValue: UserDefaults.standard.string(forKey: "theme") ??
      ColorLiteral.blue.rawValue)!
    
    ringTheme = ColorLiteral(rawValue: UserDefaults.standard.string(forKey: "ringTheme") ??
    ColorLiteral.red.rawValue)!
  }
}

extension Settings {
  func changeTheme(to color: ColorLiteral) {
    theme = color
  }
  
  func changeRingTheme(to color: ColorLiteral) {
    ringTheme = color
  }
}


enum ColorLiteral: String {
  case blue = "Blue"
  case gray = "Gray"
  case green = "Green"
  case orange = "Orange"
  case pink = "Pink"
  case red = "Red"
  case yellow = "Yellow"
}

extension ColorLiteral {
  func value() -> Color {
    switch self {
    case .blue: return .blue
    case .gray: return .gray
    case .green: return .green
    case .orange: return .orange
    case .pink: return .pink
    case .red: return .red
    case .yellow: return .yellow
    }
  }
}

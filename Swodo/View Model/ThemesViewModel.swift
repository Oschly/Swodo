//
//  ThemesViewModel.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

class ThemesViewModel: ObservableObject {
  @Published private(set) var colors: [String] =
    [
      "Blue",
      "Gray",
      "Green",
      "Orange",
      "Pink",
      "Red",
      "Yellow"
  ]
}

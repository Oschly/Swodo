//
//  MainViewModel.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
  var didChange = PassthroughSubject<Void, Never>()
  
  @Published var fillPoint = 1.0 { didSet { didChange.send() } }
  @Published var animationDuration = 5.0 { didSet { didChange.send() } }
  @Published var  stopAnimation = true { didSet { didChange.send() } }
  @Published var countdownTimer: Timer? { didSet { didChange.send() } }
  @Published var fillPointMax = 5 {
    didSet {
      self.animationDuration = Double(fillPointMax * 5)
      didChange.send()
    }
  }
}

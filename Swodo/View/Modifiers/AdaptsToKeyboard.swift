//
//  AdaptsToKeyboard.swift
//  Swodo
//
//  Created by Oskar on 23/03/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI
import Combine


struct AdaptsToSoftwareKeyboard: ViewModifier {
  @State private var orientation = UIDevice.current.orientation
  @State var currentHeight: CGFloat = 0
  
  init() {
    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                           object: nil,
                                           queue: nil,
                                           using: updateOrientation(_:))
  }
  
  func body(content: Content) -> some View {
    if orientation.isLandscape {
      return AnyView(content
        .padding(.bottom, currentHeight)
        .edgesIgnoringSafeArea(currentHeight == 0 ? Edge.Set() : .bottom)
        .onAppear(perform: subscribeToKeyboardEvents))
    } else {
      return AnyView(content)
    }
  }
  
  private let keyboardWillOpen = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
    .map { $0.height }
  
  private let keyboardWillHide =  NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillHideNotification)
    .map { _ in CGFloat.zero }
  
  private func subscribeToKeyboardEvents() {
    _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
      .subscribe(on: RunLoop.main)
      .assign(to: \.currentHeight, on: self)
  }
  
  private func updateOrientation(_ notification: Notification) {
    guard let orientation = notification.object as? UIDevice else {
      return
    }
    self.orientation = orientation.orientation
  }
}

extension View {
  func adaptsToSoftwareKeyboard() -> some View {
    modifier(AdaptsToSoftwareKeyboard())
  }
}

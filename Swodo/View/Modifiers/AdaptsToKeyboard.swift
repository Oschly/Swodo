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
  @State private var deviceName = UIDevice.current.name
  @State var currentHeight: CGFloat = 0
  
  func body(content: Content) -> some View {
    if deviceName == "iPhone SE (1st generation)" {
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
}

extension View {
  func adaptsToSoftwareKeyboard() -> some View {
    modifier(AdaptsToSoftwareKeyboard())
  }
}

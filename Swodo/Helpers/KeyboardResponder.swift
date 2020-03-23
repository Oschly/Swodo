//
//  KeyboardResponder.swift
//  Swodo
//
//  Created by Oskar on 23/03/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {

    let willChange = PassthroughSubject<CGFloat, Never>()

    private(set) var currentHeight: CGFloat = 0 {
        willSet {
            willChange.send(currentHeight)
        }
    }

    let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .first() // keyboardWillShow notification may be posted repeatedly
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height }

    let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat(0) }

    func listen() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
    }

    init() {
        listen()
    }
}

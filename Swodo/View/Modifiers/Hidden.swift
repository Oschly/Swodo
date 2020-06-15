//
//  Hidden.swift
//  Swodo
//
//  Created by Oskar on 28/05/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct Hidden: ViewModifier {
  let bool: Bool
  
  func body(content: Content) -> some View {
    if bool {
      return AnyView(content.hidden())
    } else {
      return AnyView(content)
    }
  }
}

extension View {
  func hidden(_ hidden: Bool) -> some View {
    return self
      .modifier(Hidden(bool: hidden))
  }
}

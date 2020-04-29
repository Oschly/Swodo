//
//  ActionButton.swift
//  Swodo
//
//  Created by Oskar on 21/03/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

#warning("Implement disabled view")
struct ActionButton: View {
  @EnvironmentObject var settings: Settings
  var enabled: Bool
  
  let title: String
  let action: (() -> Void)
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .background(GeometryReader { geo in
          Capsule()
            .frame(width: geo.size.width * 2.5, height: geo.size.height * 2)
            .foregroundColor(self.enabled ? self.settings.theme.value() : .gray)
            .shadow(radius: 10)
        })
    }
  }
  
  init(enabled: Bool, title: String, action: @escaping () -> ()) {
    self.enabled = enabled
    self.title = title
    self.action = action
  }
  
  init() {
    self = ActionButton(enabled: true,
                        title: "Test Button",
                        action: {})
  }
}

struct ActionButton_Previews: PreviewProvider {
  static var previews: some View {
    ActionButton(enabled: false, title: "Start", action: { })
  }
}

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
  var enabled: Bool
  
  let title: String
  let action: (() -> Void)
  
  let primaryColor: Color = .white
  let secondaryColor: Color = .blue
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .fontWeight(.bold)
        .foregroundColor(primaryColor)
        .background(GeometryReader { geo in
          Capsule()
            .frame(width: geo.size.width * 2.5, height: geo.size.height * 2)
            .foregroundColor(self.enabled ? self.secondaryColor : .gray)
            .shadow(radius: 10)
        })
    }
  }
}

struct ActionButton_Previews: PreviewProvider {
  static var previews: some View {
    ActionButton(enabled: false, title: "Start", action: { })
  }
}

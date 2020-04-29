//
//  ThemesView.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
  @EnvironmentObject private var settings: Settings
  @ObservedObject private var viewModel = ThemesViewModel()
  var body: some View {
    VStack {
      ActionButton(enabled: true,
                   title: "Test button",
                   action: {})
        .padding(.bottom, 10)
      
      List(viewModel.colors, id: \.self) { color in
        HStack {
          RoundedRectangle(cornerRadius: 20)
            .frame(width: 20, height: 20, alignment: .leading)
            .foregroundColor(ColorLiteral(rawValue: color)!.value())
          
          Text(color)
        }
        .onTapGesture {
          withAnimation {
            self.settings.changeTheme(to: ColorLiteral(rawValue: color)!)
          }
        }
      }
    }
  }
}

struct ThemeView_Previews: PreviewProvider {
  static var previews: some View {
    ThemeView()
  }
}

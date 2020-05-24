//
//  ThemesView.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct ThemeView<T: View>: View {
  @EnvironmentObject private var settings: Settings
  @ObservedObject private var viewModel = ThemesViewModel()
  
  var changeColorHandler: ((ColorLiteral) -> ())
  var sampleView: T
  var offset: CGFloat
  
  var body: some View {
    ZStack {
      VStack {
        sampleView
          .padding(.top, offset)
          .background(Color(.systemGray6))
        
        List(viewModel.colors, id: \.self) { color in
          HStack {
            RoundedRectangle(cornerRadius: 20)
              .frame(width: 20, height: 20, alignment: .leading)
              .foregroundColor(ColorLiteral(rawValue: color)!.value())
            
            Text(color)
          }
          .onTapGesture {
            withAnimation {
              self.changeColorHandler(ColorLiteral(rawValue: color)!)
            }
          }
        }
      }
      .zIndex(2)
      
      Rectangle()
        .foregroundColor(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .zIndex(1)
    }
  }
}

struct ThemeView_Previews: PreviewProvider {
  static var previews: some View {
    ThemeView(changeColorHandler: { _ in }, sampleView: ActionButton(), offset: 300)
  }
}

//
//  RingView.swift
//  Swodo
//
//  Created by Oskar on 06/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct RingView: View {
  @EnvironmentObject var viewModel: MainViewModel
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack {
          Circle()
            .stroke(lineWidth: 10.0)
            .opacity(0.05)
            .frame(width: geometry.size.width * 0.8,
                   height: geometry.size.height / 3)
          
          Circle()
            .trim(from: 0, to: self.viewModel.progressValue)
            .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round))
            .animation(.default)
            .foregroundColor(.red)
            .frame(width: geometry.size.width * 0.8,
                   height: geometry.size.height / 3)
            .padding(geometry.size.height * 0.05)
          .rotationEffect(.degrees(-90))

          
          Text(self.viewModel.time)
            .font(.largeTitle)
            .bold()
            .fontWeight(.heavy)
        }
        
        Spacer()
        HStack() {
          Button("Stop") {
            self.viewModel.stopWorkSession()
          }
        }
        Spacer(minLength: geometry.size.height / 3 + 5)
      }
    }
  }
}



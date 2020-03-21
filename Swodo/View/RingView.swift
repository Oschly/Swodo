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
  
  
  // TODO: - move that view to center of the screen.
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack {
          // Background circle which marks
          // circle's below that path that it went.
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
        
        Text(self.viewModel.sessionTitle)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
        
        Spacer()
        HStack() {
          ActionButton(title: self.viewModel.state.buttonTitle()) {
            self.viewModel.stopWorkSession()
          }
        }
        Spacer(minLength: geometry.size.height / 3 + 5)
      }
    }
  }
}

#if DEBUG

struct RingView_Previews: PreviewProvider {  
  static var previews: some View {
    RingView()
      .environmentObject(MainViewModel(time: "1:00",
                                       sessionTitle: "Doing some ultra very advanced stuff that nobody can't do except me."))
  }
}

#endif

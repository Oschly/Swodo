//
//  RingView.swift
//  Swodo
//
//  Created by Oskar on 06/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct FocusView: View {
  @EnvironmentObject var viewModel: MainViewModel
  
  var body: some View {
    GeometryReader { geometry in
      if UIDevice.current.orientation == .portrait ||
      UIDevice.current.orientation == .faceUp ||
      UIDevice.current.orientation == .faceDown {
        VStack {
          ZStack {
            // Background circle which marks
            // circle's below that path that it went.
            RingView(progressValue: self.$viewModel.progressValue,
                     time: self.$viewModel.time,
                     title: self.$viewModel.sessionTitle,
                     height: geometry.size.height)
          }
          
          Text(self.viewModel.sessionTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(width: geometry.size.width * 0.9)
          
          Spacer()
          HStack() {
            ActionButton(enabled: true, title: self.viewModel.state.buttonTitle()) {
              self.viewModel.stopWorkSession()
            }
          }
          Spacer(minLength: geometry.size.height / 3 + 5)
        }
      } else {
        HStack {
          ActionButton(enabled: true, title: self.viewModel.state.buttonTitle()) {
            self.viewModel.stopWorkSession()
          }
          .offset(x: geometry.size.width * 0.14 / 2)
          
          RingView(progressValue: self.$viewModel.progressValue,
                   time: self.$viewModel.time,
                   title: self.$viewModel.sessionTitle,
                   height: geometry.size.height)
          }
        }
      }
    }
  }


#if DEBUG

struct FocusView_Previews: PreviewProvider {  
  static var previews: some View {
    FocusView()
      .environmentObject(MainViewModel(time: "1:00",
                                       sessionTitle: "Doing some ultra very advanced stuff that nobody can't do except me."))
  }
}

#endif

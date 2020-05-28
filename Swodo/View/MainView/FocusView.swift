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
  
  @State private var showCancelAlert = false
  
  var body: some View {
    GeometryReader { geometry in
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
          .padding(.top, 40)
        
        Spacer(minLength: 50)
        HStack() {
          ActionButton(enabled: true, title: self.viewModel.state.buttonTitle()) {
            self.viewModel.stopWorkSession()
            self.showCancelAlert = true
          }
        }
        Spacer(minLength: geometry.size.height / 3)
      }
    }
    .alert(isPresented: $showCancelAlert) { () -> Alert in
      Alert(title: Text("Are You sure?"),
            primaryButton: .destructive(Text("Cancel")) {
                  self.viewModel.saveToCoreData(isSessionCancelled: true)
                  self.viewModel.state = .notStarted
            },
            secondaryButton: .cancel(Text("Keep running")) {
                  self.viewModel.startWorkCycle()
            })
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

//
//  RingView.swift
//  Swodo
//
//  Created by Oskar on 09/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct RingView: View {
  @EnvironmentObject var settings: Settings
  
  @Binding var progressValue: CGFloat
  @Binding var time: String
  @Binding var title: String
  
  var height: CGFloat
  
  var body: some View {
    VStack {
      Spacer()
      ZStack {
        Circle()
          .stroke(lineWidth: 10.0)
          .opacity(0.05)
          .frame(height: height * 0.45)
        
        Circle()
          .trim(from: 0, to: progressValue)
          .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round))
          .animation(.easeIn)
          .foregroundColor(settings.ringTheme.value())
          .frame(height: height * 0.45)
          .rotationEffect(.degrees(-90))
        
        Text(time)
          .font(.largeTitle)
          .bold()
          .fontWeight(.heavy)
      }
    }
  }
  
  init(progressValue: Binding<CGFloat>,
       time: Binding<String>,
       title: Binding<String>,
    height: CGFloat) {
    self._progressValue = progressValue
    self._time = time
    self._title = title
    self.height = height
  }
  
  init(height: CGFloat) {
    self._progressValue = .constant(1)
    self._time = .constant("60:00")
    self._title = .constant("Choosing awesome theme.")
    self.height = height
  }
}

#if DEBUG
struct RingView_Previews: PreviewProvider {
  static var previews: some View {
    RingView(progressValue: .constant(20),
             time: .constant("20"),
             title: .constant("Ultra wide title that if I am good programmer it will fit properly on every screen that is available on the market."),
             height: 704)
      //.previewLayout(.fixed(width: 1218, height: 563))
      .previewDevice("iPhone Xr")
  }
}
#endif

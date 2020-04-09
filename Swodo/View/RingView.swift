//
//  RingView.swift
//  Swodo
//
//  Created by Oskar on 09/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct RingView: View {
  @Binding var progressValue: CGFloat
  @Binding var time: String
  @Binding var title: String
  
  var height: CGFloat
  var heightMultiplier: CGFloat { !isLandscape ? 0.8 : 1/3 }
  
  var isLandscape: Bool { UIDevice.current.orientation == .faceDown || UIDevice.current.orientation == .faceUp || UIDevice.current.orientation == .portrait }
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 10.0)
        .opacity(0.05)
        .frame(height: height * heightMultiplier)
      
      Circle()
        .trim(from: 0, to: progressValue)
        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round))
        .animation(.default)
        .foregroundColor(.red)
        .frame(height: height * heightMultiplier)
        .padding(height * 0.05)
        .rotationEffect(.degrees(-90))
        .onAppear { print(self.isLandscape) }
      
      Text(time)
        .font(.largeTitle)
        .bold()
        .fontWeight(.heavy)
      
      GeometryReader { localGeo in
        Text(self.title)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .frame(width: localGeo.size.width * 0.2)
          .offset(x: localGeo.size.width * 0.37)
      }
    }
  }
  #warning("This view is bugged if first time is loaded portrait view")
}

struct RingView_Previews: PreviewProvider {
  static var previews: some View {
    RingView(progressValue: .constant(20),
             time: .constant("20"),
             title: .constant("Ultra wide title that if I am good programmer it will fit properly on every screen that is available on the market."),
             height: 704)
      .previewLayout(.fixed(width: 1218, height: 563))
  }
}

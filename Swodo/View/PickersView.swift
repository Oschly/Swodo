//
//  PickersView.swift
//  Swodo
//
//  Created by Oschły on 20/10/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct Pickers: View {
  @State var duration: Double
  @State var sessions: Int
  
  var body: some View {
    GeometryReader { geometry in
      HStack {
        VStack {
          Picker(selection: self.$duration, label: Text("")) {
            ForEach(Range(1...24), id: \.self) { index in
              Text("\(index * 5) Minutes").id(index)
            }
          }.frame(maxWidth: geometry.size.width / 2,
                  maxHeight: 74)
            .clipped()
            .labelsHidden()
          Text("Session's duration")
        }
        VStack {
          Picker(selection: self.$sessions,
                 label: Text("Number of sessions")) {
                  ForEach(Range(1...10), id: \.self) { index in
                    Text("\(index)").id(index)
                  }
          }.frame(maxWidth: geometry.size.width / 2,
                  maxHeight: 74)
            .clipped()
            .labelsHidden()
          Text("Number of sessions")
        }
      }
    }
  }
  
}

//
//  SelectionView.swift
//  Swodo
//
//  Created by Oskar on 06/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct SelectionView: View {
  @EnvironmentObject var viewModel: MainViewModel
  @Environment(\.managedObjectContext) var moc

  // Values for Picker view, easier for later calculations
  // than multiplying values from 1 to 20 by 5
  let workTimeValues = stride(from: 5.cgfloat(),
                              to: 121.cgfloat(),
                              by: 5.cgfloat())
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        // View's bounds are merged together so it
        // looks like these two pickers are single view
        //
        // TODO: - Make these views as custom structs with separated
        // code from that struct
        HStack(spacing: 0) {
          VStack {
            Picker(selection: self.$viewModel.workTime, label: Text("")) {
              ForEach(Array(self.workTimeValues), id: \.self) { index in
                Text(index.humanReadable() + " Minutes")
              }
            }.frame(maxWidth: geometry.size.width / 2,
                    maxHeight: 74)
              .clipped()
              .labelsHidden()
            Text("Session's duration")
          }
          
          VStack {
            Picker(selection: self.$viewModel.numberOfSessions,
                   label: Text("Number of sessions")) {
                    ForEach(1...10, id: \.self) { index in
                      Text("\(index)")
                    }
            }
            .frame(maxWidth: geometry.size.width / 2,
                    maxHeight: 74)
              .clipped()
              .labelsHidden()
            Text("Number of sessions")
          }
        }
        .padding(geometry.size.height * 0.1)
        
        HStack(spacing: 80) {
          Button("Start") {
            // TODO: - Move it to viewModel as new method.
            self.viewModel.progressValue = 1.0
            self.viewModel.setupContext(self.moc)
            self.viewModel.startSessionDate = Date()
            self.viewModel.numberOfWorkIntervals = Int16(self.viewModel.numberOfSessions)
            self.viewModel.singleWorkDuration = Int16(self.viewModel.workTime)
            
            self.viewModel.setWorkTime()
            self.viewModel.startWorkCycle()
          }
        }
        Spacer()
      }
    }
  }
}


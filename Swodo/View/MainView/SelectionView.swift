//
//  SelectionView.swift
//  Swodo
//
//  Created by Oskar on 06/12/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI
import UserNotifications

struct SelectionView: View {
  @EnvironmentObject var viewModel: MainViewModel
  @EnvironmentObject var settings: Settings
  @Environment(\.managedObjectContext) var moc
  @ObservedObject var keyboard = KeyboardResponder()
  
  // Values for Picker view, easier for later calculations
  // than multiplying values from 1 to 20 by 5
  let workTimeValues = stride(from: 300.cgfloat(),
                              to: 7260.cgfloat(),
                              by: 300.cgfloat())
  
  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        VStack {
          HStack(spacing: 0) {
            VStack {
              Picker(selection: self.$viewModel.workTime, label: Text("")) {
                ForEach(Array(self.workTimeValues), id: \.self) { index in
                  Text(index.humanReadable() + " Minutes")
                }
              }
              .frame(maxWidth: geometry.size.width / 2,
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
          .padding(.top, geometry.size.height * 0.18)
          .padding(.bottom, geometry.size.height * 0.05)
          
          TextField("What do you plan to work on?", text: self.$viewModel.sessionTitle)
            .multilineTextAlignment(.center)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: geometry.size.width * 0.8, alignment: .center)
          
          
          HStack(spacing: 80) {
            ActionButton(enabled: !self.viewModel.sessionTitle.isEmpty, title: self.viewModel.state.buttonTitle()) {
              // TODO: - Move it to viewModel as new method.
              self.viewModel.progressValue = 1.0
              self.viewModel.setupContext(self.moc)
              self.viewModel.startSessionDate = Date()
              self.viewModel.numberOfWorkIntervals = Int16(self.viewModel.numberOfSessions)
              self.viewModel.singleWorkDuration = Int16(self.viewModel.workTime / 60)
              self.viewModel.progressValue = 1.0
              self.viewModel.breakDuration = self.settings.breakDuration
              self.viewModel.animationDuration = self.viewModel.workTime
              self.viewModel.startWorkCycle()
              
              let numOfSessions = self.viewModel.numberOfSessions
              
              if numOfSessions > 1 {
                let breakContent = UNMutableNotificationContent()
                breakContent.title = "Break time!"
                breakContent.sound = .default
                
                let workContent = UNMutableNotificationContent()
                workContent.title = "It's time to work!"
                workContent.sound = .default
                
                // Add notification after every work and break interval.
                for i in 1..<numOfSessions {
                  let breakIntervalIteration = i - 1
                  let workTimeInterval = Double(i * Int(self.viewModel.workTime))
                  let breakTimeInterval = Double(breakIntervalIteration * Int(self.viewModel.breakDuration!))
                  
                  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: workTimeInterval + breakTimeInterval, repeats: false)
                  let request = UNNotificationRequest(identifier: UUID().uuidString, content: breakContent, trigger: trigger)
                  
                  UNUserNotificationCenter.current().add(request)
                  
                  if i != self.viewModel.numberOfSessions {
                    let nextBreakInterval = Double(i * Int(self.viewModel.breakDuration!)) * 60
                    
                    let breakTrigger = UNTimeIntervalNotificationTrigger(timeInterval: workTimeInterval + nextBreakInterval, repeats: false)
                    let breakRequest = UNNotificationRequest(identifier: UUID().uuidString, content: workContent, trigger: breakTrigger)
                    
                    UNUserNotificationCenter.current().add(breakRequest)
                  }
                }
              }
              
              // Add notification on the end of the session
              let endSessionContent = UNMutableNotificationContent()
              endSessionContent.title = "You have just finished your session!"
              endSessionContent.sound = .default
              
              let allWorkIntervalsDuration = numOfSessions * Int(self.viewModel.workTime)
              let allBreakIntervalsDuration = (numOfSessions - 1) * Int(self.settings.breakDuration) * 60
              let wholeSessionDuration = Double(allWorkIntervalsDuration + allBreakIntervalsDuration)
              
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: wholeSessionDuration, repeats: false)
              let request = UNNotificationRequest(identifier: UUID().uuidString, content: endSessionContent, trigger: trigger)
              UNUserNotificationCenter.current().add(request)
              
            }
            .disabled(self.viewModel.sessionTitle.isEmpty)
            
          }
          .padding(30)
          Spacer()
        }
      }
      .animation(.easeOut(duration: 0.3))
      .navigationBarTitle("Timer")
    }
    .animation(.easeOut)
    .adaptsToSoftwareKeyboard()
    .navigationViewStyle(StackNavigationViewStyle())
    .onTapGesture {
      UIApplication.shared.endEditing()
    }
    .onAppear {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
          if success {
              print("All set!")
          } else if let error = error {
              print(error.localizedDescription)
          }
      }
    }
  }
}

#if DEBUG

struct SelectionView_Previews: PreviewProvider {
  static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  static var previews: some View {
    Group {
      //    SelectionView()
      //      .environmentObject(MainViewModel())
      //      .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
      
      //      SelectionView()
      //        .environmentObject(MainViewModel())
      //        .previewDevice("iPad8,1")
      
      SelectionView()
        .environmentObject(MainViewModel())
        .previewDevice("iPhone 11 Pro Max")
    }
  }
}

#endif

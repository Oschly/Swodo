//
//  SettingsView.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var settings: Settings
  
  var body: some View {
    GeometryReader { geo in
      NavigationView {
        Form {
          Section(header: Text("General")) {
            NavigationLink(destination: ThemeView(changeColorHandler: self.settings.changeTheme(to:),
                                                  sampleView: ActionButton(enabled: true,
                                                                           title: "Test button",
                                                                           action: {}),
                                                  offset: -(geo.size.height / 18))) {
                                                    Text("App theme")
            }
            
            NavigationLink(destination: ThemeView(changeColorHandler: self.settings.changeRingTheme(to:),
                                                  sampleView: RingView(progressValue: .constant(1.0),
                                                                       time: .constant("60:00"),
                                                                       title: .constant("Test"),
                                                                       height: geo.size.height),
                                                  offset: -(geo.size.height / 1))) {
                                                    Text("Progress ring theme")
            }
            
          }
        }
        .navigationBarTitle("Settings")
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

//
//  SettingsView.swift
//  Swodo
//
//  Created by Oskar on 29/04/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("General")) {
          NavigationLink(destination: ThemeView()) {
            Text("Theme")
          }
        }
      }
      .navigationBarTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

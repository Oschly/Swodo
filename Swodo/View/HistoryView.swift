//
//  HistoryView.swift
//  Swodo
//
//  Created by Oskar on 02/01/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
  @FetchRequest(entity: Session.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Session.endDate, ascending: false)]) var sessions: FetchedResults<Session>
  
  var body: some View {
    NavigationView {
      List(sessions, id: \.self) { session in
        Text(String(session.singleWorkDuration))
      }
      .navigationBarTitle("Statistics")
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}

//
//  HistoryView.swift
//  Swodo
//
//  Created by Oskar on 02/01/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
  @FetchRequest(entity: Session.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Session.endDate, ascending: false)])
  private var sessions: FetchedResults<Session>
  
  // TODO: - Make own view for cells.
  var body: some View {
    NavigationView {
      List(sessions, id: \.self) { session in
        CellView(session: session)
          .frame(height: 100)
      }
      .navigationBarTitle("Statistics")
    }
  }
  
  init() {
    // Hide separator between cells
    UITableView.appearance().separatorColor = .clear
  }
}

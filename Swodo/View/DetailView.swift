//
//  DetailView.swift
//  Swodo
//
//  Created by Oskar on 20/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct DetailView: View {
  let session: Session
  
  private var formattedDateString: String {
    guard let date = session.startDate else { return "" }
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    
    return formatter.string(from: date)
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("General")) {
          SimpleCell(title: "Title", value: session.title)
          SimpleCell(title: "Canceled", value: session.canceled.humanFriendly)
        }
        
        Section(header: Text("Time")) {
          SimpleCell(title: "Date", value: formattedDateString)
          SimpleCell(title: "Hour started", value: session.startDate.hour)
          SimpleCell(title: "Hour ended", value: session.endDate.hour)
        }
        
        Section(header: Text("Details")) {
          SimpleCell(title: "Intervals", value: String(session.numberOfWorkIntervals))
          SimpleCell(title: "Interval duration", value: String(session.singleWorkDuration) + " minutes")
          SimpleCell(title: "Break duration", value: String(session.singleBreakDuration) + " minutes")
        }
      }
      .navigationBarTitle("Session")
    }
    .navigationViewStyle(DefaultNavigationViewStyle())
  }
}

#if DEBUG
struct DetailView_Previews: PreviewProvider {
  static var session: Session {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let session = Session(context: context)
    session.title = "Test session"
    session.canceled = false
    session.id = UUID()
    session.startDate = Date()
    session.endDate = Date().addingTimeInterval(5 * 30 + 4 * 10)
    session.numberOfWorkIntervals = 5
    session.singleBreakDuration = 10
    session.singleWorkDuration = 30
    
    return session
  }
  
  static var previews: some View {
    DetailView(session: session)
  }
}

#endif

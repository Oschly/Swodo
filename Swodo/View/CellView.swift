//
//  CellView.swift
//  Swodo
//
//  Created by Oskar on 16/02/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct CellView: View {
  let session: Session
  
  private var formattedStartDateString: String {
    guard let date = session.startDate else { return "" }
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated // To be considered
    
    let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
    
    return relativeDate
  }
  
  var body: some View {
    VStack {
      Spacer()
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .foregroundColor(.white)
          .shadow(radius: 10)
        HStack {
          VStack {
            Text(formattedStartDateString)
              .font(.title)
              .offset(x: 15, y: 5)
            Spacer()
            Text("Subtext")
              .font(.subheadline)
            .offset(x: 10, y: -10)
          }
          Spacer()
          VStack {
            Text("Coś")
            .offset(x: -20, y: 0)
          }
        }
      }
      Spacer()
    }
  }
}

#if DEBUG
struct CellView_Previews: PreviewProvider {
  static private var session: Session {
    let session = Session()
    session.canceled = false
    session.endDate = Date()
    session.startDate = Date().addingTimeInterval(-2000)
    session.id = UUID()
    session.numberOfWorkIntervals = 20
    session.singleBreakDuration = 10
    session.singleWorkDuration = 20
    session.totalWorkDuration = 590
    
    return session
  }
  
  static var previews: some View {
    CellView(session: self.session)
  }
}
#endif

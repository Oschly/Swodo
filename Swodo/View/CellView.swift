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
  
  @State private var presentingDetails = false
  
  private var formattedStartDateString: String {
    guard let date = session.endDate else { return "" }
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
            Text(self.session.title)
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
      .sheet(isPresented: $presentingDetails, content: {
        DetailView(session: self.session)
      })
      .onTapGesture {
        self.presentingDetails = true
      }
      Spacer()
    }
  }
}

#if DEBUG
struct CellView_Previews: PreviewProvider {
  static private var session: Session {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let session = Session(context: context)
    return session
  }
  
  static var previews: some View {
    CellView(session: self.session)
  }
}
#endif

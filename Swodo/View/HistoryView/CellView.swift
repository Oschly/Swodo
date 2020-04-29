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
    guard let date = session.startDate else { return "" }
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated // To be considered
    
    let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
    
    return relativeDate
  }
  
  private var formattedNumberOfIntervals: String {
    var text = String()
    let intervals = session.numberOfWorkIntervals
    
    if intervals > 1 {
      text = "\(intervals) intervals"
    } else {
      text = "\(intervals) interval"
    }
    
    return text
  }
  
  var body: some View {
      VStack {
        HStack {
          Text(self.session.title)
            .bold()
            .font(.system(size: 18))
            .offset(x: 0, y: 3)
          
          Spacer()
        }
        Spacer()
        HStack {
          Text(self.formattedStartDateString)
            .offset(x: 0, y: -10)
          
          Spacer()
          Text(self.formattedNumberOfIntervals)
            .offset(x: 0, y: -10)
        }
        
      }
      .sheet(isPresented: self.$presentingDetails, content: {
        DetailView(session: self.session)
      })
      .onTapGesture {
        self.presentingDetails = true
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

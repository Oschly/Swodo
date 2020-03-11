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
        Section {
          SimpleCell(title: "Title", value: session.title)
          SimpleCell(title: "Date", value: formattedDateString)
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
    return session
  }
  
  static var previews: some View {
    DetailView(session: session)
  }
}

#endif

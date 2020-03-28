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
  
  var body: some View {
    NavigationView {
      List(sessions) { session in
        CellView(session: session)
          .frame(height: 100)
      }
      .buttonStyle(PlainButtonStyle())
      .navigationBarTitle("Statistics")
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

#if DEBUG
import CoreData

struct HistoryView_Preview: PreviewProvider {
  static var context: NSManagedObjectContext {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let entry = Session(context: context)
    
    return context
  }
  
  static var previews: some View {
    HistoryView()
      .environment(\.managedObjectContext, context)
  }
}

#endif

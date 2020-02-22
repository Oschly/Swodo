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
  var body: some View {
    NavigationView {
      Form {
        Section {
          Text("Hello")
        }
      }
      .navigationBarTitle(session.title)
    }
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

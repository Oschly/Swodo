//
//  SimpleCell.swift
//  Swodo
//
//  Created by Oskar on 11/03/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import SwiftUI

struct SimpleCell: View {
  var title: String
  var value: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(value)
    }
  }
}

#if DEBUG
struct SimpleCell_Previews: PreviewProvider {
    static var previews: some View {
      SimpleCell(title: "Test", value: "Test Value")
    }
}
#endif

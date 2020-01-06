//
//  ContentView.swift
//  Swodo
//
//  Created by Oskar on 17/09/2019.
//  Copyright © 2019 Oschły. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
    switch viewModel.state {
    case .notStarted:
      return AnyView(SelectionView(viewModel: viewModel))
    case .stopped:
      return AnyView(SelectionView(viewModel: viewModel))
    case .workTime:
      return AnyView(RingView(viewModel: viewModel))
    case .breakTime:
      return AnyView(RingView(viewModel: viewModel))
    }
  }
}

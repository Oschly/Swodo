//
//  StorageManagerTests.swift
//  SwodoTests
//
//  Created by Oskar on 25/01/2020.
//  Copyright © 2020 Oschły. All rights reserved.
//

import XCTest
@testable import Swodo

class StorageManagerTests: XCTestCase {
  
  var sut: StorageManager!
  
  override func setUp() {
    super.setUp()
    sut = StorageManager()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Given
  func setupDelegate() {
    sut.delegate = MainViewModel()
  }
  
  // MARK: - Initialization
  
  func testStorageManager_afterInitialize_isDelegateNil() {
    let delegate = sut.delegate
    XCTAssertNil(delegate, "Delegate on initialize isn't nil!")
  }
}

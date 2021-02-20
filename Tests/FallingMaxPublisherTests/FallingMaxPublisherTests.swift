//
//  FallingMaxPublisherTests.swift
//  FallingMaxPublisher
//
//  Copyright © 2021 Chris Davis, https://www.chrisdavis.com
//


import XCTest
import Combine
@testable import FallingMaxPublisher

final class FallingMaxPublisherTests: XCTestCase {
  
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    cancellables = []
  }
  
  func testClimbingList() {
    // Arrange
    let list = [1, 2, 3, 4, 5, 2, 2, 4, 7, 9]
    let pub = list
      .publisher
    
    // Act
    var output: [Int] = []
    pub
      .fallingMax()
      .sink { (complete) in
        
      } receiveValue: { (value) in
        output.append(value)
      }
      .store(in: &cancellables)
    
    // Assert
    XCTAssertEqual([1,2,3,4,5,4,3,4,7,9], output.prefix(list.count), "Output values incorrect")
  }
  
  func testClimbingAndStop() {
    // Arrange
    let list = [1, 2, 3, 4, 5, 1, 1, 1, 1, 1]
    let pub = list
      .publisher
    
    // Act
    var output: [Int] = []
    pub
      .fallingMax()
      .sink { (complete) in
        
      } receiveValue: { (value) in
        output.append(value)
      }
      .store(in: &cancellables)
    
    // Assert
    XCTAssertEqual([1,2,3,4,5,4,3,2,1,0], output.prefix(list.count), "Output values incorrect")
  }
  
  func testWontGoNegative() {
    // Arrange
    let list = [1, 2, 3, -1, -1, -1, -1, -1]
    let pub = list
      .publisher
    
    // Act
    var output: [Int] = []
    pub
      .fallingMax()
      .sink { (complete) in
        
      } receiveValue: { (value) in
        output.append(value)
      }
      .store(in: &cancellables)
    
    // Assert
    XCTAssertEqual([1,2,3,2,1, 0, 0, 0], output.prefix(list.count), "Output values incorrect")
  }
  
  static var allTests = [
    ("testClimbingList", testClimbingList),
  ]
}

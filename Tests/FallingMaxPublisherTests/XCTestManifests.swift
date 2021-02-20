//
//  XCTestManifests.swift
//  FallingMaxPublisher
//
//  Copyright © 2021 Chris Davis, https://www.chrisdavis.com
//


import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(FallingMaxPublisherTests.allTests),
  ]
}
#endif

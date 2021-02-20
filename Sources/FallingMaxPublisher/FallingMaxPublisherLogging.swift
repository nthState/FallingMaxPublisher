//
//  FallingMaxLogging.swift
//  AudioLevelPublisherSubscriber
//
//  Copyright © 2021 Chris Davis, https://www.chrisdavis.com
//

import Foundation
import os.log

public extension OSLog {
  
  static var fallingMaxSystem = "com.fallingMax.publisher"
  
  /// FallingMax Publisher
  static let fallingMax = OSLog(subsystem: OSLog.fallingMaxSystem, category: "FallingMax")
}

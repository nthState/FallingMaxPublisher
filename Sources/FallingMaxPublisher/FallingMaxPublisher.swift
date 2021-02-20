//
//  FadingMaxPublisher.swift
//  FallingMaxPublisher
//
//  Copyright © 2021 Chris Davis, https://www.chrisdavis.com
//

/**
 FadingMax Publisher
 
 Returns the maximum value, but then max is reduced by one if the latest value isn't larger.
 
 Example Input:
 1,2,3,4,5,6,3,4,4,5,5
 Output:
 1,2,3,4,5,6,5,4,4,5,5
 
 built with help from: https://jullianmercier.com/2020-04-03/combine-single-valued-publisher
 */

import Foundation
import Combine
import os.log

public typealias Number = BinaryInteger

public extension Publisher
where
  Output: Any,
  Failure == Never {
  
  /**
   Returns the maximum value, but then max is reduced by one if the latest value isn't larger.
   
   ```
   if input > maxValue {
   maxValue = input
   } else {
   maxValue = max(0, maxValue - fadeDownAmount)
   }
   
   return maxValue
   ```
   */
  func fallingMax<T: Number>() -> Publishers.FallingMax<Self, T> {
    Publishers.FallingMax(upstream: self)
  }
}

public extension Publishers {
  
  struct FallingMax<Upstream: Publisher, T: Number>: Publisher
  where
    Upstream.Output == T
  {
    
    public typealias Output = Upstream.Output
    public typealias Failure = Upstream.Failure
    
    private let upstream: Upstream
    
    public init(upstream: Upstream) {
      self.upstream = upstream
    }
    
    public func receive<S>(subscriber: S)
    where
      S : Subscriber,
      Self.Failure == S.Failure,
      Self.Output == S.Input,
      Self.Output == T
    {
      subscriber.receive(subscription: Subscription(upstream: upstream, downstream: subscriber))
    }
    
  }
}

private extension Publishers.FallingMax {
  
  class Subscription<Downstream: Subscriber, T: Number>: Combine.Subscription
  where
    Downstream.Input == Upstream.Output,
    Downstream.Failure == Upstream.Failure,
    Upstream.Output == T
  {
    
    private var subscriber: FadingMaxSubscriber<Upstream, Downstream, T>?
    
    init(upstream: Upstream, downstream: Downstream) {
      subscriber = .init(upstream: upstream, downstream: downstream)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
      subscriber = nil
    }
    
  }
}

class FadingMaxSubscriber<Upstream: Publisher, Downstream: Subscriber, T: Number>: Subscriber
where
  Upstream.Output == Downstream.Input,
  Downstream.Failure == Upstream.Failure,
  Upstream.Output == T
{
  
  private var downstream: Downstream
  private var _element: Upstream.Output?
  
  init(upstream: Upstream, downstream: Downstream) {
    self.downstream = downstream
    upstream.subscribe(self)
  }
  
  /**
   Stores the current highest value, if a lower value comes in,
   then we simply take one from this number, until
   it becomes zero
   */
  private var maxValue = 0
  
  /**
   The amount to fade down by
   */
  private var fadeDownAmount = 1
  
  func receive(subscription: Subscription) {
    subscription.request(.max(1))
  }
  
  func receive(_ input: Upstream.Output) -> Subscribers.Demand {
    
    if input > maxValue {
      maxValue = Int(input)
    } else {
      maxValue = max(0, maxValue - fadeDownAmount)
    }
    
    _ = downstream.receive(maxValue as! T)
    
    return .max(1)
  }
  
  func receive(completion: Subscribers.Completion<Upstream.Failure>) {
    
    os_log("%{PRIVATE}@", log: OSLog.fallingMax, type: .debug, "FadingMaxSubscriber Completion: \(completion), last max: \(maxValue)")
    
    // Fall all the way to zero after completion
    while maxValue > 0 {
      maxValue -= 1
      _ = downstream.receive(maxValue as! T)
    }
  }
  
}

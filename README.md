# Falling Max Combine Publisher

## Introduction

Given a stream of inputs, record the max value.
If the next number is lower, take one from the last recorded max value and emit that.

#### Example

```
Input:  [1,2,3,4,5,2,3,3,1]
Output: [1,2,3,4,5,4,3,3,2]
```

## Pseudocode

Calculating the new value that should be emitted by the publisher, by comparing it to the last known largest number

```
if newValue > maxValue {
    maxValue = newValue
} else {
    maxValue = max(0, maxValue - 1)
}
```


## Rationale

I wrote this publisher as I wanted to create an old-school style equalizer as seen below.

![Old School Equalizer](https://github.com/nthState/FallingMaxPublisher/blob/main/oldSchoolEqualizer.png?raw=true)

### Requirements

- [ ] Replicate an old-school equalizer in SwiftUI using Combine
- [ ] Should be stand alone, as in, I'm trying to get away from writing something like this with an instance value, however if there is a way of doing this without
an instance variable to store the current max, I'm all ears

```
var lastMaxInstanceValue: Float = 0

publisher
    .map { newValue
      if newValue > lastMaxInstanceValue {
        lastMaxInstanceValue = newValue
      } else {
        lastMaxInstanceValue = max(0, lastMaxInstanceValue - 1)
      }
    }
    .assign(to: \.percentage, on: self)
    .store(in: &cancellables)
```

## Use

The publisher filter can be be setup like so:

```
publisher
    .fallingMax()
    .assign(to: \.percentage, on: self)
    .store(in: &cancellables)
```

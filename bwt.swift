#!/usr/bin/env xcrun swift

import Foundation

class BWT {
  let terminator = "$"

  func encode(encodedString: String) -> String {
    var stringWithTerminator = encodedString + self.terminator
    let n = countElements(stringWithTerminator)
    var rotatedStrings: [String] = []
    for i in 0..<n {
      rotatedStrings.append(rotate(stringWithTerminator, count: i))
    }
    sort(&rotatedStrings)
    let lastChars = rotatedStrings.map {
      $0[$0.endIndex.predecessor()]
    }
    return lastChars.reduce("", combine: +)
  }

  func decode(encodedString: String) -> String {
    let encodedArray = Array(encodedString)
    let n = encodedArray.count

    var builtStrings = Array(count: n, repeatedValue: "")

    for i in 0..<n {
      for j in 0..<n {
        builtStrings[j] = encodedArray[j] + builtStrings[j]
      }
      sort(&builtStrings)
    }
    let decodedString = builtStrings.filter({ $0.hasSuffix(self.terminator) }).first!
    return decodedString.substringToIndex(decodedString.endIndex.predecessor())
  }

  func rotate(inputString: String, count: Int) -> String {
    var string = inputString
    for i in 0..<count {
      let head = string[string.startIndex]
      let tail = string.substringFromIndex(advance(string.startIndex, 1))
      string = tail + head
    }
    return string
  }
}

let bwt = BWT()

println(bwt.encode("hi"), "i$h")
println(bwt.encode("banana"), "annb$aa")

println(bwt.decode("i$h"), "hi")
println(bwt.decode("annb$aa"), "banana")

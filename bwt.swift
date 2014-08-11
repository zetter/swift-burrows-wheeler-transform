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
    var lastChars = rotatedStrings.map {
      String($0[$0.endIndex.predecessor()])
    }
    return arrayToString(lastChars)
  }

  func decode(encodedString: String) -> String {
    let encodedArray = stringToArray(encodedString)
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

  func stringToArray(string: String) -> [String] {
    var array: [String] = []
    for char in string {
      array.append(String(char))
    }
    return array
  }

  func arrayToString(array: [String]) -> String {
    return array.reduce("", combine: +)
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

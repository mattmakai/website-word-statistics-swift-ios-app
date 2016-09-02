//
//  TextStats.swift
//  Just the Data
//
//  Created by Matthew Makai on 9/1/16.
//  Copyright © 2016 Matt Makai. All rights reserved.
//

import Foundation

struct TextStatistics {
  var charCount = Int(0)
  var wordCount = Int(0)
  var syllableCount = Int(0)
  var pElementCount = Int(0)
  var h1ElementCount = Int(0)
  var h2ElementCount = Int(0)
  
  func statisticsMessage() -> String {
    if (charCount == 0 && wordCount == 0 && syllableCount == 0 && pElementCount == 0 && h1ElementCount == 0 && h2ElementCount == 0) {
      return "Unable to gather word statistics for this URL, please try another one!"
    }
    return "\nStatistics for this webpage - only counts within <p>, <h1> and <h2> elements.\n\nCharacters: \(charCount)\nWords: \(wordCount)\nSyllables: \(wordCount)\n\n<p> elements: \(pElementCount)\n<h1> elements: \(h1ElementCount)\n<h2> elements: \(h2ElementCount)\n"
  }
  
  mutating func resetStatistics() {
    self.charCount = Int(0)
    self.wordCount = Int(0)
    self.syllableCount = Int(0)
    self.pElementCount = Int(0)
    self.h1ElementCount = Int(0)
    self.h2ElementCount = Int(0)
  }
}
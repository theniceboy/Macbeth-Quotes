//
//  Quotes.swift
//  Macbeth Quotes
//
//  Created by David Chen on 3/19/19.
//  Copyright © 2019 David Chen. All rights reserved.
//

import Foundation

class Speaker {
    var id: Int = 0
    var name: String = ""
    var quotes: [Int] = []
}
var aiSpeakerID = 1
var speakers: [Speaker] = []

class Quote {
    var id: Int = 0
    var speaker: Int = 0
    var lines: [Int] = []
}
var aiQuoteID = 1
var quotes: [Quote] = []

class Line {
    var id: Int = 0
    var quote: Int = 0
    var name: String = ""
    var content: String = ""
}
var aiLineID = 1
var lines: [Line] = []

func addSpeaker (name: String) -> Int {
    for speaker in speakers {
        if speaker.name == name {
            return speaker.id
        }
    }
    let newSpeaker: Speaker = Speaker()
    newSpeaker.id = aiSpeakerID
    aiSpeakerID += 1
    newSpeaker.name = name
    speakers.append(newSpeaker)
    return newSpeaker.id
}

func addQuote (speakerID: Int) -> Int {
    let newQuote = Quote()
    newQuote.id = aiQuoteID
    aiQuoteID += 1
    newQuote.speaker = speakerID
    quotes.append(newQuote)
    return newQuote.id
}

func addLine (quoteID: Int, name: String) -> Int {
    let newLine = Line()
    newLine.id = aiLineID
    aiLineID += 1
    newLine.quote = quoteID
    newLine.name = name
    lines.append(newLine)
    return newLine.id
}

func analyse (txt: String) {
 
    speakers = []
    speakers.append(Speaker())
    quotes = []
    quotes.append(Quote())
    lines = []
    lines.append(Line())
    
    var tagContent: String = ""
    var curSpeaker: String = "", curSpeakerID: Int = 0
    var curQuoteID: Int = 0
    var curLineID: Int = 0
    var lookingForTag: Bool = false
    var lookingForSpeaker: Bool = false, speakerSpeaking: Bool = false
    var lookingForQuote: Bool = false
    var lookingForLine: Bool = false
    for c in txt {
        if c == "<" {
            lookingForTag = true
            tagContent = ""
            continue
        } else if c == ">" {
            lookingForTag = false
            if tagContent.contains("A NAME=speech") {
                lookingForSpeaker = true
                curSpeaker = ""
            } else if tagContent == "/a" || tagContent == "/A" {
                if lookingForSpeaker {
                    lookingForSpeaker = false
                    curSpeakerID = addSpeaker(name: curSpeaker)
                    speakerSpeaking = true
                } else if lookingForLine {
                    lookingForLine = false
                }
            } else if tagContent == "blockquote" {
                lookingForQuote = true
                curQuoteID = addQuote(speakerID: curSpeakerID)
            } else if tagContent == "/blockquote" {
                if speakerSpeaking {
                    lookingForQuote = false
                    speakers[curSpeakerID].quotes.append(curQuoteID)
                    speakerSpeaking = false
                    //print(speakers[curSpeakerID].name, lines[quotes[curQuoteID].lines.first ?? -1].content)
                }
            } else if lookingForQuote && tagContent.contains("A NAME=") && speakerSpeaking {
                lookingForLine = true
                tagContent.removeFirst(7)
                curLineID = addLine(quoteID: curQuoteID, name: tagContent)
                quotes[curQuoteID].lines.append(curLineID)
            }
        } else {
            if lookingForTag {
                tagContent.append(c)
            } else if lookingForSpeaker {
                curSpeaker.append(c)
            } else if lookingForLine {
                lines[curLineID].content.append(c)
            }
        }
        
    }
}

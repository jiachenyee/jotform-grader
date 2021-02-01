//
//  Answers.swift
//  grader
//
//  Created by JiaChen(: on 1/2/21.
//

import Foundation

struct Marking: Codable {
    var outputPath: String
    var outputName: String
    var questions: [Question]
}

struct Question: Codable {
    var questionIndex: String
    var answers: [Answer]
}
struct Answer: Codable {
    var answerPrefix: String // A, B, C...
    var score: Double
}


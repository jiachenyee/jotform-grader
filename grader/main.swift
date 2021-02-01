//
//  main.swift
//  grader
//
//  Created by JiaChen(: on 1/2/21.
//

import Foundation

// /Users/jiachen/Desktop/Marking.json
// /Users/jiachen/Downloads/DRAFT_Swift_Accelerator_Ap2021-02-01_05_23_23.csv
func main() {
    print("""
    +------------------+
    |  JotForm Grader  |
    +------------------+
    """)
    
    guard let responses = getResponses(),
          let marking = getAnswers() else { return }
    
    print("\nComparing Marking and Responses...")
    
    var indexForQuestion: [String : Int] = [:]
    
    for (index, value) in responses.header.enumerated() {
        guard let prefix = value.first else { continue }
        if prefix.isNumber {
            let questionIndex = String(value.split(separator: ".").first ?? "x")
            
            if marking.questions.contains(where: { (question) -> Bool in
                question.questionIndex == questionIndex
            }) {
                print("Question \(questionIndex) : ✅")
                
                indexForQuestion[questionIndex] = index
            } else {
                print("Question \(questionIndex) : ⚠️")
            }
        }
    }
    
    let rows = responses.enumeratedRows
    
    print("\nCheck that all questions have been validated. If there is ⚠️ it means that it failed to detect the question.")
    
    print("Continue? (y/n) : ", terminator: "")
    if readLine()?.lowercased() == "n" {
        return
    }
    
    print("\nGrading... 👨‍🏫\n")
    
    var outputCSV = "\"Name\",Score"
    
    for row in rows {
        var indexForScore: [String : Double] = [:]
        
        for question in marking.questions {
            
            guard let questionRowIndex = indexForQuestion[question.questionIndex] else {
                print("could not get answer")
                continue
            }
            
            let answer = row[questionRowIndex]
            let extraxtedResponses = answer.split(separator: ";")
            
            for response in extraxtedResponses {
                for answerKey in question.answers {
                    
                    if response.filter({ $0.isLetter }).hasPrefix(answerKey.answerPrefix) {
                        indexForScore[question.questionIndex] = (indexForScore[question.questionIndex] ?? 0) + answerKey.score
                        break
                    }
                }
            }
        }
        
        var finalScore = indexForScore.values.reduce(0) {
            $0 + $1
        }
        
        finalScore *= 1000
        finalScore.round()
        finalScore /= 1000
        
        print("Score For", row[1], "=", finalScore)
        
        outputCSV += "\n\"\(row[1])\",\(finalScore)"
    }
    
    print()
    print("\nVerify the results above and save!")
    
    print("Save? (y/n) : ", terminator: "")
    if readLine()?.lowercased() == "n" {
        return
    }
    
    //First make sure you know your file path, you can get it from user input or whatever
    //Keep the path clean of the name for now
    var filePath = marking.outputPath
    
    //then you need to pick your file name
    let fileName = marking.outputName
    
    // Create a FileManager instance this will help you make a new folder if you don't have it already
    let fileManager = FileManager.default
    
    //Create your target directory
    do {
        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        //Now it's finally time to complete the path
        filePath += fileName
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
    
    //Then simply write to the file
    do {
        // Write contents to file
        try outputCSV.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        print("Writing CSV to: \(filePath)")
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
}

func getResponses() -> CSV? {
    print("JotForm Responses CSV : ", terminator: "")
    
    guard let responsePath = readLine(strippingNewline: true) else {
        print("Error: Response CSV cannot be nil")
        return nil
    }
    
    do {
        guard let url = URL(string: "file://" + responsePath) else { return nil }
        let csv = try CSV(url: url)
        
        return csv
    } catch {
        print(error.localizedDescription)
    }
    
    return nil
}

func getAnswers() -> Marking? {
    print("JotForm Answers JSON : ", terminator: "")
    
    guard let answersPath = readLine(strippingNewline: true) else {
        print("Error: Answers JSON cannot be nil")
        return nil
    }
    
    guard let url = URL(string: "file://" + answersPath) else { return nil }
    
    let decoder = JSONDecoder()
    
    do {
        return try decoder.decode(Marking.self, from: Data(contentsOf: url))
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

main()

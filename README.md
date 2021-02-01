# JotForm Grader
## A macOS command line grading tool for JotForm

## Set Up
### Setting up your form
1. Create a field for the user's name, preferably as the first field
2. Prefix every question with `questionIndex. `
> E.g. `1. Why doesn't JotForm have an auto-grader`?
3. Prefix each answer with a letter, (A, B, C, D...)
> E.g. 
> ```
> A. I don't know
> B. Option name
> C. I have no idea
> ```
4. This tool has only been tested with multiple-choice and single-choice questions. 

### Preparing your Answers JSON
#### Answer/Marking Swift Struct
Your Answers JSON will be converted to a `Marking`.
```swift
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
```

#### Example JSON
Prepare your Answers JSON like this to ensure that it works properly.
```json
{
    "outputPath": "/Where/Do/You/What/To/Put/Your/File/",
    "outputName" : "Output.csv",
    "questions" : [
        {
            "questionIndex" : "1",
            "answers" : [
                {
                    "answerPrefix" : "A",
                    "score" : 100
                },
                {
                    "answerPrefix" : "B",
                    "score" : 200
                },
                {
                    "answerPrefix" : "C",
                    "score" : 300
                },
                {
                    "answerPrefix" : "D",
                    "score" : 400
                }
            ]
        },
        {
            "questionIndex" : "2",
            "answers" : [
                {
                    "answerPrefix" : "A",
                    "score" : -100.86
                },
                {
                    "answerPrefix" : "B",
                    "score" : -200.56
                },
                {
                    "answerPrefix" : "C",
                    "score" : -300.24
                },
                {
                    "answerPrefix" : "D",
                    "score" : -400.05
                }
            ]
        }
    ]
}
```

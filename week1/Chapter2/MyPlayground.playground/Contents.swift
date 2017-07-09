//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
str = "Hello, Swift"

let constStr = str

// let으로 선언된 상수는 변경 불가
// constStr = "CHANGE"

/// 타입 지정, 추론 - 프로퍼티, 이니셜라이저, 인스턴스 메서드, 스태틱 메서드

var year: Int
var temp: Float
var hasPet: Bool

var arrayOfInts:[Int]   //Array<Int>
var dictionaryOfCapitalsByCountry: [String:String] ////Dictionary<String, String>

var winningLotteryNumbers: Set<Int>

/// 리터럴, 서브스크립팅

let number = 42
let fmStation = 91.1

let countingUp = ["one", "two"]
let nameByParkingSpace = [13: "Alice", 27: "Bob"]

let secondElement = countingUp[1]

/// 이니셜라이저

let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()

let defaultNumber = Int()
let defaultBool = Bool()

let availableRooms = Set([205, 411, 412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.141592)

let easyPi = 3.14
let floatFromDouble = Float(easyPi)
let floatingPi: Float = 3.14        // 3.14 대신 easyPi 대입은 불가능


/// 프로퍼티

countingUp.count
countingUp.capacity
countingUp.underestimatedCount

countingUp.customMirror
countingUp.description
countingUp.debugDescription

countingUp.startIndex
countingUp.endIndex

countingUp.first
countingUp.last

emptyString.isEmpty
emptyString.capitalized
emptyString.characters
emptyString.customMirror

emptyString.fastestEncoding
emptyString.smallestEncoding

emptyString.utf16
emptyString.utf8
emptyString.utf8CString
emptyString.unicodeScalars

emptyString.startIndex
emptyString.endIndex

/// 인스턴스 메서드

var newStr = countingUp
newStr.count

newStr.append("three")
newStr.count

/// 옵셔널

var anOptionalFloat: Float?
var anOptionalArrayOfStrings: [String]?
var anOptionalArrayOfOptionalStrings: [String?]?

var num1: Float? = 10.0
var num2: Float? = 9
var num3: Float? = Float(8)

if let r1 = num1, let r2 = num2, let r3 = num3 {
    let avg = (r1 + r2 + r3) / 3
}

/// 딕셔너리

let space13Assignee = nameByParkingSpace[13]
let space42Assignee = nameByParkingSpace[42]

if let assignee = nameByParkingSpace[42] {
    print("Key 42 is assigned in the dictionary")
} else {
    print("Key 42 is not assigned in the dictionary")
}

/// 반복문

for i in 0..<countingUp.count {
    let count = countingUp[i]
    print(count)
}

for (key, value) in countingUp.enumerated() {
    print("\(key) - \(value)")
}

for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
    print(permit)
}

enum PieType {
    case apple
    case cherry
    case pecan
}

let favoritePie = PieType.pecan

var name: String
switch favoritePie {
case .apple:
    name = "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
    fallthrough
default:
    print("Pecan Or ETC")
}

print(name)

let osxversion: Int = 10

switch osxversion {
case 0...8:
    print("A big cat")
case 9:
    print("Mavericks")
case 10:
    print("Yosemite")
default:
    print("Greetings, people of the future! What's new in 10.\(osxversion)?")
}

enum MyType: Int{
    case A = 0
    case B  // A(0) + 1 = 1로 자동할당
    case C  // B(1) + 1 = 2로 자동할당
}

let rawValue = MyType.B.rawValue
if let myType = MyType(rawValue: rawValue) {
    print("정상 rawValue \(myType)")
}


var string: String? = "a"
if let text = string, !text.isEmpty {
    print(text)
}

var doubleStr: String? = "0.1"
if let text = doubleStr, let value = Double(text) {
    print(value)
} else {
    print("???")
}

/// @IBOutlet var celsiusLabel: UILabel!

var fahrenheitValue: Double?

var celsiusValue: Double? {
    if let value = fahrenheitValue {
        return (value - 32) * (5 / 9)
    } else {
        return nil
    }
}

func updateCelsiusLabel() -> Double? {
    if let value = fahrenheitValue {
        return (value - 32) * (5 / 9)
    } else {
        return nil
    }
}

var nf = NumberFormatter()
nf.numberStyle = .decimal
nf.minimumFractionDigits = 0
nf.maximumFractionDigits = 1
nf.string(from: 1.23)

nf.string(from: 1)
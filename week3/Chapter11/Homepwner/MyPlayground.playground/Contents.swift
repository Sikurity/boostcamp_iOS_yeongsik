import Foundation

class CreditCard {
    let serialNumber: String
    
    unowned var owner: Person
    
    init(owner: Person){
        self.serialNumber = "\(arc4random_uniform(UInt32(UInt32.max)))"
        self.owner = owner
    }
    
    deinit {
        print("\(self.serialNumber) credit card is deinitialized")
    }
}

class House {
    weak var resident: Person?
    
    deinit {
        print("house is deinitialized")
    }
}

class Person {
    var name: String
    
    var fingerPrint: FingerPrint!
    weak var house: House?
    var creditCard: CreditCard?
    
    init(name: String){
        self.name = name
    }
    
    deinit {
        print("\(self.name) is deinitialized")
    }
}

class FingerPrint {
    unowned var owner: Person
    
    init(owner: Person) {
        self.owner = owner
    }
    
    deinit {
        print("fingerprint is deinitialized")
    }
}

FileManager

var myHome: House? = House()

var me: Person? = Person(name: "LYS")

me?.fingerPrint = FingerPrint(owner: me!)
me?.creditCard = CreditCard(owner: me!)
me?.house = myHome
me = nil

myHome = nil
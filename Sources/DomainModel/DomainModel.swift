struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}



public struct Money {
    
    var amount: Int
    var currency: String
      
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
      
    func convert(_ targetCurrency: String) -> Money {
        let currencyUppercase = targetCurrency.uppercased()
        guard ["USD", "GBP", "EUR", "CAN"].contains(currencyUppercase)
        else {
            print("ERROR: UNKNOWN")
            return Money(amount: 0, currency: currencyUppercase)
        }
        let conversionRates: [String: Double] = ["USD": 1.0, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
        
        let amountUSD = Double(amount) / conversionRates[currency]!
        
        let convertedAmount = Int(amountUSD * conversionRates[currencyUppercase]!)
        
        return Money(amount: convertedAmount, currency: currencyUppercase)
    }

    func add(_ amountAdd: Money) -> Money {
        if self.currency == amountAdd.currency {
            return Money(amount: self.amount + amountAdd.amount, currency: self.currency)
        } 
        else {
            let convertedSelf = self.convert(amountAdd.currency)
            
            return Money(amount: convertedSelf.amount + amountAdd.amount, currency: amountAdd.currency)
        }
    }
       
    func subtract(_ amountSubtract: Money) -> Money {
        
        if self.currency == amountSubtract.currency {
            
            return Money(amount: self.amount - amountSubtract.amount, currency: self.currency)
        } 
        else {
            
            let convertedOther = amountSubtract.convert(self.currency)
            
            return Money(amount: self.amount - convertedOther.amount, currency: self.currency)
        }
    }
}


////////////////////////////////////
// Job
//
public class Job {
    
    let title: String
    
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    
    func calculateIncome(_ hours: Int) -> Int {
        switch type {
            
        case .Hourly(let wage):
            
            return Int(wage * Double(hours))
        case .Salary(let salary):
            return Int(salary)
        }
    }
    
    func raise(byAmount amount: Double) {
            switch type {
            case .Hourly(let wage):
                type = .Hourly(wage + Double(amount))
            case .Salary(let salary):
                type = .Salary(salary + UInt(Int(amount)))
            }
        }
        
    func raise(byPercent: Double) {
        
        switch type {
        case .Hourly(let wage):
            
            let raiseFactor = 1.0 + byPercent
            
            let newWage = wage * raiseFactor
            
            type = .Hourly(newWage)
            
        case .Salary(let salary):
            
            let raiseBy = 1.0 + byPercent
            
            let newSalary = Double(salary) * raiseBy
            
            type = .Salary(UInt(newSalary))
        }
    }

}




////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    
    var spouse: Person? {
        didSet {
            if age < 16 {
                spouse = nil
            }
        }
    }
    
    
    func toString() -> String {
        var result = "[Person: firstName:" + firstName + " lastName:" + lastName + " age:" + String(age) + " job:"
        if job != nil {
            result += job!.title
        } else {
            result += "nil"
        }
        result += " spouse:"
        if spouse != nil {
            result += spouse!.firstName
        } else {
            result += "nil"
        }
        result += "]"
        return result
    }
}


////////////////////////////////////
// Family

public class Family {
    
    var members: [Person] = []

    init(spouse1: Person, spouse2: Person) {
        guard spouse1.spouse == nil && spouse2.spouse == nil 
        else {
            fatalError("Error")
        }

        spouse1.spouse = spouse2
        
        spouse2.spouse = spouse1

        self.members = [spouse1, spouse2]
        
    }

    func haveChild(_ infant: Person) -> Bool {
        guard members.contains(where: { $0.age >= 21 }) 
        else {
            return false
        }

        members.append(infant)
        return true
    }

    func householdIncome(_ hours: Int? = nil) -> Int {
        if let hours = hours {
            return members.compactMap { $0.job?.calculateIncome(hours) }.reduce(0, +)
        } 
        else {
            return members.compactMap { $0.job?.calculateIncome(2000) }.reduce(0, +)
        }
    }

}















import Foundation

let predicate1 = NSPredicate(format: "%@ == %@", "Hallo", "yes")
print(predicate1.predicateFormat)

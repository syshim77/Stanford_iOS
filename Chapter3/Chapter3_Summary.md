## Chapter3 - Calculator

1. Optional
  - enum with 2 cases(None, Some)
  - Optional Chaining
    * display?.text?.value : display, text, value 각각에 대하여 값이 있는지 확인하고 하나라도 없는 것이 발견되면 nil을 반환함
    * value ?? 0 : value 값이 nil일 경우 default 값을 0으로 설정
2. tuple
  - 개수는 상관이 없음
  - let value(Int, Double, String) = x
    * let (index, answer, word) = x 로 get value(새로운 변수 설정하여 값을 받아오는 방법)
  - let x: (i: Int, a: Double, w: String)
    * x.i, x.a, x.w로 get value*(tuple을 선언할 때 변수를 같이 정하는 방법)
    * 위의 방식으로 tuple 선언 후 let (index, answer, word) = x로 새로운 변수를 다시 설정해주면 새로 설정된 변수로 사용
  - can return multiple values
  - if using _ , can ignore that value
3. range
  - important in Swift
  - 연속적으로 표현되는 양 끝 점(startIndex, endIndex)
  - can use ?, !, ... , ..< , for-in
4. data structures(classes, structures, enumerations)
  - similarity
    * declare in the same way(keyword + name + { code })
    * can have properties & functions
    * have initializers(except enum)
  - difference
    * inheritance(class only)
    * value type(struct, enum) vs reference type(class)
      + value type : copied when passed as an argument to function or assigned to different variable, use let then it's immutable, use mutating then it can be changed(copy when willing to start mutation)
      + reference type : stored in heap(count becomes 0 then removed), use let means pointer doesn't change
    * using fundamental types -> struct, otherwise -> class
5. methods
  - have external name, internal name(external name comes first)
    * caller use external name, internal name is used in function
    * usually don't use first parameter's external name
  - override methods/properties
    * if use final then cannot override that method/property
  - types & instances can have methods/properties
6. properties
  - can observe changes using willSet, didSet
    * stored, inherited, computed or added/changed
  - lazy initialization : not initialized until access to it
7. array
  - declare: let arr: [String]()
    * () means default initialize
  - use let -> cannot modify
  - methods use closure(filter, map, reduce)
    * reduce : trailing closure syntax
8. dictionary
  - declare: let dic: [key:value]
  - tuple with for-in to enumerate
9. string
  - full unicode -> complicated
  - String.characterView or String.Index -> deal with characters in a string
10. NSObject, NSNumber, NSDate, NSData
  - NSObject : base class for all object-C classes
  - NSNumber : generic number holding class
  - NSDate : can use with NSCalendar, NSDateFormatter, NSDateComponents
  - NSData : bag o' bits
11. initialization
  - if declare own init -> don't use free init
  - inside -> set property's value or constant property
  - convenience init, designated init, inheriting init, required init, failable init
    * required init : must be implemented
    * failable init : use ? and return Optional
12. AnyObject
  - special type(actually protocol)
  - argument to function
    * ex) sender, cookie
  - conversion -> use as?
  - property list
    * use bridging to get struct to object
    * NSUserDefaults : database of Plist
  - CalculatorBrain(in Calculator project)
    * "3 x 4 x a = " 과 같은 연산을 수행하여 변수 a를 구할 때
    * flexible
  - casting -> use as
    * as! can be crashed so use if let as?

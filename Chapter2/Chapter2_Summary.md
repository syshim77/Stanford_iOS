## Chapter2 - Calculator

1. MVC
  - 3 camps : Model, View, Controller
  - Model : what the application is(not display)
  - View : controller's minions
  - Controller : how model is present to UI logic
2. communication between camps
  - Controller -> Model : always talk directly
  - Controller -> View : always talk directly
    * ex) outlet
  - Model -> View : never speak to each other
  - View -> Model : never speak to each other
  - View -> Controller : limited communication(talk when blind, structured)
    * ex) target - action
  - Model -> Controller : cannot talk about UI, just notification & KVO
  - **views do not own the data they display**
  - combine MVC : one MVC is part of view of another MVC
3. Xcode file
  - Cocoa Touch class : make view controller
  - swift file : make model
    * never import UIKit
    * model do not concern about UI
4. internal vs public
  - internal : 해당 module 내에서만 공용으로 사용 가능
  - public : 해당 module 외의 모든 module에서 공용으로 사용 가능
5. data structure
  - class
    * passed by reference
    * have free initializer
  - enum
    * discrete set of values
    * allow to have methods
    * cannot declare stored var, can declare computed var
    * cannot inherit
    * passed by value
    * have associated value
  - struct
    * similar with class
    * can have both stored, computed var
    * cannot inherit
    * passed by value
6. passed by reference vs passed by value
  - **passed by reference**
    * live in heap
    * pass pointer
  - **passed by value**
    * pass copied data
    * if data changed or added, do not impact to caller
    * mutate : copy part of data, not mutate : share data
7. capitalize
  - type : first letter capitalized
  - local variable, var : first letter lower, continued word first letter capitalized
8. closure
  - inlined function
  - 추론 가능한 내용들을 생략할 수 있음
  - parameter를 $0, $1, ... 으로 쓰고 생략할 수 있음(이 경우 return 생략 가능)
  - in 으로 코드와 선언부 구분(선언부 생략 가능하면 in도 생략 가능)

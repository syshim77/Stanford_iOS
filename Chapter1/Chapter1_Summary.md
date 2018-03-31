## Chapter1 - Calculator

1. iOS의 구성
  - Cocoa Touch (Web View, Camera, controls, ...)
  - Media (audio, PDF, JPEG/PNG, video, ...)
  - Core Services (Networking, Threading, ...)
  - Core OS (kernel, ...)
2. Design Model
  - MVC : Model - View - Controller
    * Model : program 그 자체(UI independent)
    * View : UI(button, display, ...)
    * Controller : model과 view를 연결해줌
3. UIKit vs Foundation
  - UIKit : 모든 UI를 담고 있는 하나의 모듈(class를 묶어서 만든 그룹이 모듈), View
  - Foundation : Core Services(Networking, Databasing 등), Model
4. let vs var
  - let : initialize 된 상태에서 값이 변하지 않을 때 사용, 읽기 전용 코드임을 알 수 있고 array나 dictionary에서 읽기만 하고 값이 변하지 않음을 알 수 있음
  - var : 가변적인 property 일 때 사용
5. Optional
  - iOS에서 memory address가 hidden 되어있어서 사용, 0이나 "" 대신 nil 값을 이용하여 광범위한 값을 사용
    * nil = not set 상태
    * associated value = set 상태
  - ? 으로 표현
  - ! 으로 implicitly unwrapping 가능하나 이는 crash 될 위험이 있음
6. action vs outlet
  - action : 특정 UI가 실행되면 행해지는 함수로 UI로부터 값을 받아와서 실행
  - outlet : property로 선언되며 UI로부터 값을 받아와서 실행되는 것이 아니라 controller로부터 받아와서 실행
7. initialize
  - 모든 property는 initial value를 가져야함
  - initializer를 이용하거나 선언할 때 property_name = initial value 형식으로 initialize 가능
  - optional은 선언하면 늘 nil로 initialize 되므로 따로 초기화할 필요없음

//
//  services.swift
//  multi_thread_alarm
//
//  Created by 장승균 on 2022/11/04.
//

import Foundation

class Serivces {
    ///
    func timeThread(completion: @escaping () -> Void, min: Int) {
        
        // 여기서의 Thread는 main Thread와 별개로 새로운 작업자(Thread)에게 작업을 맡긴 것
        DispatchQueue.global().async {
            for index in 0..<min {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
            
            // uilable finishLable은 반드시 mainThread에서 변경되어야 하기 때문에
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    func intervalThread(completion: @escaping () -> Void, interval: Double) {
        
        // 여기서의 Thread는 main Thread와 별개로 새로운 작업자(Thread)에게 작업을 맡긴 것
        DispatchQueue.global().async {
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
            
            // uilable finishLable은 반드시 mainThread에서 변경되어야 하기 때문에
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    ///
    
    // closure가 들어간 func을 만들려면 안에 closure를 넣어야 함(closure기본형: () -> Void)
    func simpleClosureInMain(completion: () -> Void) {
        
        for index in 0..<10 {
            // 긴 작업이라고 가정하기 위해서 쓰레드를 잠깐씩 멈춤(Thread.sleep사용)
            // 여기서의 Thread는 main Thread
            // 앱에서의 모든 life cycle을 총괄하는게 main Thread 따라서 maindp .sleep을 걸면 다른 변화요소들이 멈추기 때문에 문제인것(스크롤도 안됨)
            // 따라서, 화면에 락이 걸리지 않게 하기 위해 긴 작업을 따로 다른 Thread에 빼둬야 한다
            Thread.sleep(forTimeInterval: 0.2)
            print(index)
        }
        
        // 선언해둔 () -> Void 실행
        completion()
    }

    func simpleClosureInDivideThread(completion: @escaping () -> Void,) {
        
        // 여기서의 Thread는 main Thread와 별개로 새로운 작업자(Thread)에게 작업을 맡긴 것
        DispatchQueue.global().async {
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
            
            // uilable finishLable은 반드시 mainThread에서 변경되어야 하기 때문에
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }

    func groupDispathQueue() {
        let dispatchGroup = DispatchGroup()
        let que1 = DispatchQueue(label: "q1")
        let que2 = DispatchQueue(label: "q2")
        let que3 = DispatchQueue(label: "q3")
        
        que1.async(group: dispatchGroup) {
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
        }
        que2.async(group: dispatchGroup) {
            for index in 10..<20 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
        }
        que3.async(group: dispatchGroup) {
            for index in 20..<30 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
        }
        
        // queue: main Thread에서 작동되도록 해뒀음
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("끝")
        }
    }

    func groupMultiDispathQueue() {
        let dispatchGroup = DispatchGroup()
        let que1 = DispatchQueue(label: "q1")
        let que2 = DispatchQueue(label: "q2")
        let que3 = DispatchQueue(label: "q3")
        
        // dispatchGroup.enter() : 작업중인게 있다라고 알림
        // dispatchGroup.leave() : 작업이 끝났다고 알림
        // enter()호출횟수와 leave()호출횟수가 맞지 않으면 영원히 끝나지 않으니 오류 주의
        
        que1.async(group: dispatchGroup) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                for index in 0..<10 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
        }
        que2.async(group: dispatchGroup) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                for index in 10..<20 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
        }
        que3.async(group: dispatchGroup) {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                for index in 20..<30 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                dispatchGroup.leave()
            }
        }
        
        // queue: main Thread에서 작동되도록 해뒀음
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("끝")
        }
    }

    func syncExam1() {
        let que1 = DispatchQueue(label: "q1")
        let que2 = DispatchQueue(label: "q2")
        
        // 밑의 코드의 경우 빌드하면 main Thread도 멈춤
        que1.sync {
            for index in 0..<10 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
        }
        que2.sync {
            for index in 10..<20 {
                Thread.sleep(forTimeInterval: 0.2)
                print(index)
            }
        }
    }
}


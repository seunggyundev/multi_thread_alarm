//
//  services.swift
//  multi_thread_alarm
//
//  Created by 장승균 on 2022/11/04.
//

import Foundation

class Serivces {
    ///
    let firstBoxQue = DispatchQueue(label: "firstBoxQue")
    let secondBoxQue = DispatchQueue(label: "secondBoxQue")
    let dispatchGroup = DispatchGroup()
    
    func groupDispathQueue(completion: @escaping () -> Void) {
        // queue: main Thread에서 작동되도록 해뒀음
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    func firstBoxThread(completion: @escaping () -> Void, sec: Int, interval: Double) {
        
        // 여기서의 Thread는 main Thread와 별개로 새로운 작업자(Thread)에게 작업을 맡긴 것
        firstBoxQue.async(group: dispatchGroup) {
            for index in 0..<sec {
                Thread.sleep(forTimeInterval: interval)
                DispatchQueue.main.async {
                    completion()
                }
                print(index)
            }
        }
    }
    
    func secondBoxThread(completion: @escaping () -> Void, sec: Int, interval: Double) {
        
        // 여기서의 Thread는 main Thread와 별개로 새로운 작업자(Thread)에게 작업을 맡긴 것
        secondBoxQue.async(group: dispatchGroup) {
            for index in 0..<sec {
                Thread.sleep(forTimeInterval: interval)
                DispatchQueue.main.async {
                    completion()
                }
                print(index)
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

    func simpleClosureInDivideThread(completion: @escaping () -> Void) {
        
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
    
        // deadLock : 상대 작업이 끝날 때까지 서로 계속 기다리는 상태
        // sync를 쓸 일이 있다면 deadLock을 꼭 기억하고 판단해라
        func deadLockExam() {
            let que1 = DispatchQueue(label: "q1")
            
            que1.sync {
                // [1]
                for index in 0..<10 {
                    Thread.sleep(forTimeInterval: 0.2)
                    print(index)
                }
                
                // deadlock
                // 위의 que1은 [1]~[2]까지 진행되어야 끝나는데 밑의 que1은 위의 que1이 끝날 때 까지 계속 기다리니
                // 영원히 끝나지 않고 서로 기다리게 되는 오류가 생기는 것
                // sync,async 상관없이 오류가 생김
                que1.sync {
                    for index in 10..<20 {
                        Thread.sleep(forTimeInterval: 0.2)
                        print(index)
                    }
                }
            // [2]
            }
            
            // 위와 같은 상황으로 main Thread에 sync를 걸면 안된다
            // 계속 실행중인 메인에 sync를 건다? -> XX
            DispatchQueue.main.sync {
                
            }
        }
        
        // 그렇다면 sync는 언제 쓰냐? -> 작업이 정말 중요해서 다른 작업들은 끝날 때까지 절대로 시작하면 안될 경우에 사용, 다른 Thread를 막아서까지 꼭 사용해야하는 경우인지 꼭 고민하고 검토해야한다
}


//
//  userDefault.swift
//  multi_thread_alarm
//
//  Created by 장승균 on 2022/11/12.
//

import Foundation

let completedKey = "completedKey"

func saveCompleted(completed: Int) {
    
    //저장
    UserDefaults.standard.set(completed, forKey: completedKey)
}

func getCompleted() -> Int {
    
    //꺼내오기
    var userDefault = UserDefaults.standard.integer(forKey: completedKey)
    
    return userDefault
}

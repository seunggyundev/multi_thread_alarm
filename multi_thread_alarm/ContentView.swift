//
//  ContentView.swift
//  multi_thread_alarm
//
//  Created by 장승균 on 2022/11/04.
//

import SwiftUI

struct ContentView: View {
    let total = 6
    @State var completed = getCompleted()
    
    let lineWidth: CGFloat = 8
    let service = Serivces()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var firstBoxColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    @State private var secondBoxColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    let data = Array(1...2).map { "\($0)"}
    
    var body: some View {
        VStack {
            CircularProgressBarView(total: total, completed: completed, lineWidth: lineWidth, color: .green)
            LazyVGrid(columns: columns) {
              ForEach(data, id: \.self) { index in
                  if index == "1" {
                      firstBoxColor.cornerRadius(15).frame(width: 150, height: 150).padding()
                  } else {
                      secondBoxColor.cornerRadius(15).frame(width: 150, height: 150).padding()
                  }
              }
            }
            Button {
                withAnimation {
                    guard completed < total else {
                        completed = 0
                        saveCompleted(completed: completed)
                        return
                    }
                    service.firstBoxThread(completion: {
                        self.firstBoxColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                        
                    }, sec: 15, interval: 0.2)
                    
                    service.secondBoxThread(completion: {
                        secondBoxColor = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
                        
                    }, sec: 15, interval: 0.5)
                    
                    service.groupDispathQueue(completion: {
                        completed += 1
                        saveCompleted(completed: completed)
                    })
        
                }
            } label: {
                Text("시작")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            .padding(.vertical)
        }
        .padding()
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}

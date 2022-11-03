//
//  ContentView.swift
//  multi_thread_alarm
//
//  Created by 장승균 on 2022/11/04.
//

import SwiftUI

struct ContentView: View {
    let total = 6
    @State var completed = 0
    let lineWidth: CGFloat = 8
    let service = Serivces()
    
    var body: some View {
        VStack {
            CircularProgressBarView(total: total, completed: completed, lineWidth: lineWidth, color: .green)
            Button {
                withAnimation {
                    guard completed < total else {
                        completed = 0
                        return
                    }
                    service.simpleClosureInMain {
                        completed += 1
                    }
                }
            } label: {
                Text("Finish next step")
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

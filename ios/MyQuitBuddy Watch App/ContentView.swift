//
//  ContentView.swift
//  MyQuitBuddy Watch App
//
//  Created by Edoardo Pavan on 13/07/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    
    var body: some View {
        VStack {
            Text("Cigarettes smoked today: \(viewModel.cigarettes)")
                .padding()
            Button(action: {
                viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.cigarettes + 1])
            }) {
                Text("+ by 1")
            }
        }
    }
}

#Preview {
    ContentView()
}

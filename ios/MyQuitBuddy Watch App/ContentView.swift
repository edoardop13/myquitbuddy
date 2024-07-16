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
        VStack(spacing: 10) {
            Button(action: {
                print("click")
                viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.cigarettes + 1])
            }) {
                Image(.smokingRoomsIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
            }
            .background(getBackgroundColor())
            .clipShape(Circle())
            
            Text("Cigarettes smoked today: ")
            + Text("\(viewModel.cigarettes)")
                .foregroundStyle(getBackgroundColor() == .clear ? .white : getBackgroundColor())
        }
    }
    
    func getBackgroundColor() -> Color {
        if viewModel.cigarettes < 1 {
            return .green
        }
        else if viewModel.cigarettes < 3 {
            return .yellow
        }
        else if viewModel.cigarettes < 6 {
            return .orange
        }
        else if viewModel.cigarettes < 9 {
            return .red
        }
        return .clear
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  CardanoNodeBuddy
//
//  Created by Jon Bauer on 12/3/22.
//

import SwiftUI

struct ContentView: View {
    @State var message = "Hello, World!"
    @State var isRunning = false
    
    var body: some View {
        VStack {
            Text("SayThis")
                .font(.largeTitle)
                .padding()
            HStack {
                TextField("Message", text: $message)
                    .padding(.leading)
                Button(action: {
                    let executableURL = URL(fileURLWithPath: "/usr/bin/say")
                    self.isRunning = true
                    try! Process.run(executableURL,
                                     arguments: [self.message],
                                     terminationHandler: { _ in self.isRunning = false })
                }) {
                    Text("Say")
                }.disabled(isRunning)
                    .padding(.trailing)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

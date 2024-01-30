//
//  ContentView.swift
//  debounce
//
//  Created by Donny Le on 1/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model;
    @State private var delay: Double = 0.1
    @State private var formatter: NumberFormatter = NumberFormatter()
    
    
    
    var body: some View {
        
        VStack {
            

            var started: Bool = false;
            Keyboard().onTapGesture {
                if(model.checkAccess() && !started) {
                    model.start();
                    started = true;
                }
                else {
                    print("need access")
                }
            }
            HStack {
            
                var strDelay: String = String((floor(delay * 100) / 100));
                Text("Debounce Delay: " + strDelay)
                
                Slider (
                    value: $delay,
                    in: 0...1,
                    onEditingChanged: {editing in
                        model.changeDelay(delay: delay)
                        
                    }
                )
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}



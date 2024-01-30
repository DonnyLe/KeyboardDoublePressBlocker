//
//  Test.swift
//  debounce
//
//  Created by Donny Le on 1/27/24.
//

import SwiftUI

struct Keyboard: View {
    @EnvironmentObject var model: Model;
    @State var color: Color =  Color(red: 0, green: 0, blue: 0)
    var body: some View {
        VStack{
            ForEach (0..<model.allKeys.endIndex, id:\.self) { index in
                HStack {
                    ForEach(Array(model.allKeys[index].orderedValues)) { key in
                        Text(key.keyName)
                            .padding(20)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).fill(color.changeKeyColor(percentage:                         key.getPercentageOfDoublePress())))
                            .padding(3)
                    }
                }
                
            }
        }
    }
}
    


#Preview {
    Keyboard()
}

extension Color {
    func changeKeyColor(percentage: Double) -> Color {
        if(percentage == 0) {
            return Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.5)
            
        }
        else {
            print(percentage)
            return Color(red: 1, green: 1 - min(1, log10(percentage + 0.056) + 1.25), blue: 0, opacity: 0.5)
            
        }
    }
    
}

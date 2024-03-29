//
//  Keys.swift
//  debounce
//
//  Created by Donny Le on 1/27/24.
//

import Foundation
import SwiftUI;

@Observable class Keys: Identifiable{
    var pressedTimeStamp: Double;
    var releasedTimeStamp: Double;
    var keyName: String;
    var doublePresses: Double;
    var doubleReleases: Double;

    var presses: Double;
    var releases: Double;
    var id = UUID()
    var delay: Double = 0.1;

    
    
    init(_ keyName: String) {
        self.keyName = keyName;
        self.pressedTimeStamp = 0;
        self.releasedTimeStamp = 0;
        self.presses = 0;
        self.doublePresses = 0;
        self.releases = 0;
        self.doubleReleases = 0;
    }
    
    func setReleasedTimeStamp(time: Double) {
        self.releasedTimeStamp = time;
    }
    
    func setPressedTimeStamp(time: Double) {
        self.pressedTimeStamp = time;
    }
    
    func isDoublePress(time: Double) -> Bool {
//        print("Prev Time: \(self.pressedTimeStamp)");
//              print("Curr Time: \(time)");
        self.presses += 1;
        if((time - self.pressedTimeStamp) < self.delay) {
            self.doublePresses += 1;
            return true;
        } else {
            return false;
        }
    }
    func isDoubleRelease(time: Double) -> Bool {
        self.releases += 1;
        if((time - self.releasedTimeStamp) < 0.1) {
            self.doubleReleases += 1;
            return true;
        } else {
            return false;
        }
    }
    
    func getPercentageOfDoublePress() -> Double {
        if(self.presses > 0) {
            return self.doublePresses / self.presses;
        }
        return 0;
    }
    
    
    
}

//
//  Package_Management_SystemApp.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/5/23.
//

import SwiftUI

// Write a program to simulate package distribution at a facility with X employees and Y packages.
// Each package must be handled by multiple employees.
// The probability for loss is directly proportionate to the number of people handling a package.
// Your goal is design the system to maximize employee utilization while miniziming the probability for package loss.


@main
struct Package_Management_SystemApp: App {
    var body: some Scene {
        WindowGroup {
            PMSStartView()
        }
    }
}

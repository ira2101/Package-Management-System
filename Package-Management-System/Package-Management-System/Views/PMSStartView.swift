//
//  ContentView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/5/23.
//

import SwiftUI

struct PMSStartView: View {
    
    @State var employeeCount: String = ""
    
    @State var packageCount: String = ""
    
    @State var shouldStartSimulation: Bool = false
        
    var body: some View {
        NavigationView {
            VStack {
                Text("Package Management System")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                                
                HStack(alignment: .center) {
                    VStack {
                        Text("Employees")
                        .font(.body)
                        .fontWeight(.bold)
                        
                        TextField("#", text: $employeeCount)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    }
                                
                    VStack {
                        Text("Packages")
                        .font(.body)
                        .fontWeight(.bold)
                        
                        TextField("#", text: $packageCount)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                    }
                }
                .padding(.top, 32)
                .lineSpacing(8)
                
                Spacer()
                
                if let employeeCount = Int(employeeCount),
                    let packageCount = Int(packageCount) {
                    NavigationLink(
                        "",
                        destination:
                            PMSSimulationView(
                                facility: PMSFacility(
                                    employeeCount: employeeCount,
                                    packageCount: packageCount
                                )
                            ),
                        isActive: $shouldStartSimulation
                    )
                }
                
                
                
                VStack {
                    Text("Start Simulation")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(.blue)
                .cornerRadius(.greatestFiniteMagnitude)
                .onTapGesture {
                    if Int(employeeCount) != nil && Int(packageCount) != nil {
                        shouldStartSimulation = true
                    }
                }
                .disabled(
                    employeeCount.isEmpty || packageCount.isEmpty
                )
                .background(
                    
//                    NavigationLink(
//                        "Start Simulation",
//                        destination: SimulationView(),
//                        isActive: $shouldStartSimulation
//                    )
                    
                )
            }
            .padding(.vertical, 16)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PMSStartView()
    }
}

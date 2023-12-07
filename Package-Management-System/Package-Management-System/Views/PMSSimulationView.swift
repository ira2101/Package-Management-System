//
//  SimulationView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSSimulationView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 32) {
                PMSFacilityHealthView(facility: facility)
                
                PMSEnterFacilityStageView(facility: facility)
                
                PMSPresortStageView(facility: facility)
                
                PMSHoldingStageView(facility: facility)
                
                PMSShippingStageView(facility: facility)
                
                PMSShippedStageView(facility: facility)
            }
            .padding()
        }
    }
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        PMSSimulationView(
            facility: PMSFacility(
                employeeCount: 0,
                packageCount: 0
            )
        )
    }
}

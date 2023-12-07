//
//  PMSHoldingStageView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSHoldingStageView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("In Holding Zone")
            .font(.body)
            .fontWeight(.bold)
                                  
            HStack(alignment: .center, spacing: 32) {
                if let zoneA = facility.holdingZones[.a] {
                    PMSZoneStatView(
                        text: "A",
                        count: zoneA.packageCount
                    )
                }

                if let zoneB = facility.holdingZones[.b] {
                    PMSZoneStatView(
                        text: "B",
                        count: zoneB.packageCount
                    )
                }

                if let zoneC = facility.holdingZones[.c] {
                    PMSZoneStatView(
                        text: "C",
                        count: zoneC.packageCount
                    )
                }

                if let zoneD = facility.holdingZones[.d] {
                    PMSZoneStatView(
                        text: "D",
                        count: zoneD.packageCount
                    )
                }

                if let zoneE = facility.holdingZones[.e] {
                    PMSZoneStatView(
                        text: "E",
                        count: zoneE.packageCount
                    )
                }
            }
        }
    }
}

struct PMSHoldingStageView_Previews: PreviewProvider {
    static var previews: some View {
        PMSHoldingStageView(facility: PMSFacility(employeeCount: 0, packageCount: 0))
    }
}

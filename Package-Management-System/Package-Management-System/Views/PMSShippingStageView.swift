//
//  PMSShippingStageView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSShippingStageView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("In Shipping Zone")
            .font(.body)
            .fontWeight(.bold)
                                  
            HStack(alignment: .center, spacing: 32) {
                if let zoneA = facility.shippingZones[.a] {
                    PMSZoneStatView(
                        text: "A",
                        count: zoneA.packagesInZoneCount
                    )
                }

                if let zoneB = facility.shippingZones[.b] {
                    PMSZoneStatView(
                        text: "B",
                        count: zoneB.packagesInZoneCount
                    )
                }

                if let zoneC = facility.shippingZones[.c] {
                    PMSZoneStatView(
                        text: "C",
                        count: zoneC.packagesInZoneCount
                    )
                }

                if let zoneD = facility.shippingZones[.d] {
                    PMSZoneStatView(
                        text: "D",
                        count: zoneD.packagesInZoneCount
                    )
                }

                if let zoneE = facility.shippingZones[.e] {
                    PMSZoneStatView(
                        text: "E",
                        count: zoneE.packagesInZoneCount
                    )
                }
            }
        }
    }
}

struct PMSShippingStageView_Previews: PreviewProvider {
    static var previews: some View {
        PMSShippingStageView(facility: PMSFacility(employeeCount: 0, packageCount: 0))
    }
}

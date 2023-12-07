//
//  PMSPresortStageView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSPresortStageView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        VStack {
            Text("Pre-Sorted")
            .font(.body)
            .fontWeight(.bold)
            
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 32) {
                    if let perishableZone = facility.presortZones[.perishables] {
                        PMSZoneStatView(
                            text: "Perishables",
                            count: perishableZone.packageCount
                        )
                    }
                    
                    if let fragilesZone = facility.presortZones[.fragileItems] {
                        PMSZoneStatView(
                            text: "Fragiles",
                            count: fragilesZone.packageCount
                        )
                    }
                    
                    if let largeItemZone = facility.presortZones[.largeItems] {
                        PMSZoneStatView(
                            text: "Large Items",
                            count: largeItemZone.packageCount
                        )
                    }
                    
                    if let generalZone = facility.presortZones[.general] {
                        PMSZoneStatView(
                            text: "General",
                            count: generalZone.packageCount
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct PMSPresortStageView_Previews: PreviewProvider {
    static var previews: some View {
        PMSPresortStageView(facility: PMSFacility(employeeCount: 0, packageCount: 0))
    }
}

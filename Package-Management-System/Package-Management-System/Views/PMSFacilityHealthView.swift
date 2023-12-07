//
//  PMSFacilityHealthView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSFacilityHealthView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Facility Health")
            .font(.title2)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            
            HStack(alignment: .center, spacing: 32) {
                PMSZoneStatView(
                    text: "Shipped",
                    count: facility.numberOfPackagesShipped
                )
                PMSZoneStatView(
                    text: "Lost",
                    count: facility.numberOfPackagesLost
                )
            }
                            
            ProgressView(value: facility.health)
            .tint(.green)
            .background(.red)
            .progressViewStyle(.linear)
        }
    }
}

struct PMSFacilityHealthView_Previews: PreviewProvider {
    static var previews: some View {
        PMSFacilityHealthView(facility: PMSFacility(employeeCount: 0, packageCount: 0))
    }
}

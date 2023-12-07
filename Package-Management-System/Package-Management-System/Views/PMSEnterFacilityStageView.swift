//
//  PMSEnterFacilityStageView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSEnterFacilityStageView: View {
    
    @ObservedObject var facility: PMSFacility
    
    init(facility: PMSFacility) {
        self.facility = facility
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Entered Facility")
            .font(.body)
            .fontWeight(.bold)
            
            Text(facility.entryZone.packagesInZoneCount.formatted())
            .font(.largeTitle)
            .multilineTextAlignment(.center)
        }
    }
}


struct PMSEnterFacilityStageView_Previews: PreviewProvider {
    static var previews: some View {
        PMSEnterFacilityStageView(
            facility: PMSFacility(
            employeeCount: 0,
            packageCount: 0
        ))
    }
}

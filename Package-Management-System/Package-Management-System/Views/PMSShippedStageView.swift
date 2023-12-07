//
//  PMSShippedStageView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSShippedStageView: View {
    
    @ObservedObject var facility: PMSFacility
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Shipped")
            .font(.body)
            .fontWeight(.bold)
            
            Text(facility.numberOfPackagesShipped.formatted())
            .font(.largeTitle)
            .multilineTextAlignment(.center)
        }
    }
}

struct PMSShippedStageView_Previews: PreviewProvider {
    static var previews: some View {
        PMSShippedStageView(facility: PMSFacility(employeeCount: 0, packageCount: 0))
    }
}

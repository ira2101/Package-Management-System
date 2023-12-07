//
//  PMSZoneStatView.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/7/23.
//

import SwiftUI

struct PMSZoneStatView: View {
    
    var text: String
    var count: Int
    
    init(text: String, count: Int) {
        self.text = text
        self.count = count
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            
            Text(count.formatted())
            .font(.largeTitle)
            .multilineTextAlignment(.center)
        }
    }
}

struct PMSZoneStatView_Previews: PreviewProvider {
    static var previews: some View {
        PMSZoneStatView(text: "Test", count: 0)
    }
}

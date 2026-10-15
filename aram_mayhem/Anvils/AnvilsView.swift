//
//  AnvilsView.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 3/10/26.
//

import SwiftUI

struct AnvilsView: View {
    
    var body: some View {
        
        List {
            AnvilsHeaderSection()
            
            HStack {
                Text("Forge Tier Catalog")
                Spacer()
                Text("Tap for Details")
            }
            .listRowBackground(Color.clear)
            
            ForEach(0..<3) { _ in
                AnvilsTierCatalogSection()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.lightTextPrimary)
        .listStyle(.insetGrouped)
    }
}

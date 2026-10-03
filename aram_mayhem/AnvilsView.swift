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
            
            Section {
                VStack  {
                    Text("Test")
                }
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        
                }
            } header: {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Stats Anvil", systemImage: "flame.fill")
                            .labelStyle(.trailingIcon)
                        Text("Permanent Stat Refinement System")
                    }

                    Spacer()

                    Text("\(Text("·").font(.title).bold()) 3 Tiers").frame(alignment: .center)
                }
            }
        }
    }
}

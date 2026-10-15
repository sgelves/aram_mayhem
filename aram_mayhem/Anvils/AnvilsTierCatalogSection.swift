//
//  AnvilsTierCatalogSection.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 5/10/26.
//

import SwiftUI

struct AnvilsTierCatalogSection: View {
    
    @State var anvilsList: [String] = ["0", "1", "2"]
    
    var body: some View {
        Section {
            
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: "wrench.adjustable")
                    .frame(width: 32, height: 32)
                    .padding(8)
                    .buttonBorderShape(.roundedRectangle)
                
                VStack {
                    Text("Silver Anvil")
                        .font(.headline)
                    Text("Unlock level 9")
                        .font(.headline)
                }
                
                Spacer()
                
                (Text("\(Image(systemName: "dollarsign.circle")) ").foregroundColor(Color.orange) + Text("Cost 750 Gold").foregroundColor(Color.snowlight))
                    .padding([.horizontal], 15)
                    .padding([.vertical], 5)
                    .background(
                        RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.glacierSlate)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(Color.frozenSteel, lineWidth: 2)
                    }
            }
            
            
            Divider().frame(height: 2).overlay(Color.glacierSlate.opacity(0.4))
            
            ForEach($anvilsList, id: \.self) { _ in
                HStack {
                    Text("Stat")
                    
                    Spacer()
                    
                    Text("Value TDB")
                }
                .padding(15)
                .background(Color.fog, in: .rect(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.glacierSlate.opacity(0.4), lineWidth: 2))
            }

        }
        .listRowSpacing(0)
        .listRowBackground(Color.deepIce)
        .listRowSeparator(.hidden)
    }
}

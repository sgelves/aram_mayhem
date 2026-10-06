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

struct AnvilsTierCatalogSection: View {
    
    @State var anvilsList: [String] = ["", "", ""]
    
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

struct AnvilsHeaderSection: View {
    
    @State var isExpanded = false
    
    var body: some View {

        let header = HStack {
            Text("\(Image(systemName: "info.circle")) ").foregroundColor(Color.orange) + Text("What are Stat Anvils?").foregroundColor(Color.white)
            Spacer()
            if isExpanded {
                Image(systemName: "arrow.up")
            } else {
                Image(systemName: "arrow.down")
            }
        }.onTapGesture {
            isExpanded.toggle()
        }

        Section {
            VStack  {
                header
                if isExpanded {
                    Text("Stat Anvils are consumable forge shards in ARAM Mayhem, allowing champions to permanently augment their core attributes without taking inventory slots. Choose from random stat options to scale directly against enemy threats. ")
                        .foregroundColor(Color.mist)
                    HStack(alignment: .center, spacing: 10) {
                        
                        Label("Unlock Level 9", systemImage: "lock.open").foregroundColor(Color.snowlight)
                            .padding([.horizontal], 15)
                            .padding([.vertical], 5)
                            .background(
                                RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.glacierSlate)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(Color.frozenSteel, lineWidth: 2)
                            }
                        (Text("\(Image(systemName: "dollarsign.circle")) ").foregroundColor(Color.orange) + Text("Cost 750 Gold").foregroundColor(Color.snowlight))
                            .padding([.horizontal], 15)
                            .padding([.vertical], 5)
                            .background(
                                RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.glacierSlate)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(Color.frozenSteel, lineWidth: 2)
                            }
                        
                        Spacer()
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .background(Color.deepIce, in: RoundedRectangle(cornerRadius: 15))

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
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

//
//  AugnmentsView.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 10/10/26.
//

import Foundation
import SwiftUI

class Augment: Codable, Hashable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Augment, rhs: Augment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

private struct CellIndex  {
    let row: Int
    let column: Int
}

extension CellIndex {
    
}

struct AugnmentsView: View {

    let minWidth: CGFloat
    let spacing: CGFloat
    @State var augmentsList: [Augment] = (0..<30).map{ Augment(id: "\($0)", name: "\($0)") }

    init() {
        spacing = 10
        minWidth = 150
    }

    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width
            let columnAmount = max(1, Int(screenWidth/(minWidth + spacing*2)))
            
            ScrollView {
                AugmentsGrid(columnAmount: columnAmount, columnWidth: minWidth, spacing: spacing, augmentsList: $augmentsList)
            }
        }
        .padding(10)
        .background(Color.lightTextPrimary)
    }
}

struct AugmentsGrid: View {

    let columnAmount: Int
    let columnWidth: CGFloat
    let spacing: CGFloat
    var rowAmount: Int {
        augmentsList.count/columnAmount
    }
    @Binding var augmentsList: [Augment]
    
    var body: some View {
        Grid {
            ForEach(0..<rowAmount, id: \.self) { index in
                GridRow(alignment: .top) {
                    let currentRow = columnAmount*index
                    ForEach(currentRow..<currentRow+columnAmount, id: \.self) { index in
                        AugmentsGridCell(minHeight: 180)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct AugmentsGridCell: View {
    
    let minHeight: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "hammer")
                Text("Prismatic")
            }
            Text("Lorem ipson description")
                .foregroundStyle(.white)
            Divider()
            HStack {
                Text("AP").background(Color.glacierSlate, in: .rect(cornerRadius: 15))
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding(10)
        .frame(minHeight: minHeight)
        .background(Color.black , in: .rect(cornerRadius: 15))
        .background(
            RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.glacierSlate)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 15).stroke(Color.frozenSteel, lineWidth: 2)
        }
    }
}

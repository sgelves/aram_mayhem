//
//  LabelStyle+TrailingIcon.swift
//  aram_mayhem
//
//  Created by Sergio Gelves on 3/10/26.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {

    /// A label style that displays the icon at the trailing of the label.
    @MainActor @preconcurrency internal static var trailingIcon: TrailingIconLabelStyle { return TrailingIconLabelStyle() }
}

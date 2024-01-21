//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import SwiftUI

public struct BorderButtonStyle: ButtonStyle {
    var isEnabled: Bool
    
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? .primary : .secondary)
            .frame(width: 52, height: 52)
            .background(
                Circle()
                    .strokeBorder(isEnabled ? .black : .secondary, lineWidth: 2)
            )
            .contentShape(Circle())
            .disabled(!isEnabled)
    }
}

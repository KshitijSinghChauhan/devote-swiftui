//
//  HeightKeyboardExtension.swift
//  Devote
//
//  Created by Kshitij Singh Chauhan on 14/12/23.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

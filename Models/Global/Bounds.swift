//
//  Orientation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    enum Orientation {
        case landscape
        case portrait
    }
    var orientation: Orientation {
        size.height > size.width ? .portrait : .landscape
    }
}

enum Device {
    case iPhone
    case iPad
}

final class Bounds: ObservableObject {
    @Published var mode =  GeometryProxy.Orientation.portrait
    @Published var insets = EdgeInsets()
    /// notched devices (including the new iPad Pros) have bottom insets
    var notch: Bool {
        insets.bottom != 0
    }
    @Published var device = Device.iPhone
}

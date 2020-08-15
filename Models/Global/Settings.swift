//  Settings.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import Combine

final class Settings: ObservableObject {
    @Published var user: User? = nil
    var cancellable: AnyCancellable? = nil
}

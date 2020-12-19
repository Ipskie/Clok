//
//  SaveChangesButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SaveChangesButton: View {
    let save: () -> Void
    let canUndo: Bool
    
    var body: some View {
        Button(action: save) {
            Image(systemName: "checkmark")
                .font(Font.body.weight(.semibold))
        }
            /// only allow saving if there are changes (i.e. something to undo)
            .disabled(!canUndo)
    }
}

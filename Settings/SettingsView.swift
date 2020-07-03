//
//  SettingsView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    HStack {
                        Text("Logged in as")
                        Spacer()
                        Text(settings.user?.fullName ?? "No One")
                    }
                    HStack {
                        Text("Workspace")
                        Spacer()
                        Text(settings.space?.name ?? "No Space")
                    }
                }
                Section(header: EmptyView()) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .onTapGesture {
                            // destroy local data
                            self.data.report = Report()
                            
                            // destroy credentials
                            try! dropKey()
                            
                            // destroy workspace records
                            WorkspaceManager.saveSpaces([])
                            WorkspaceManager.saveChosen(Workspace(wid: 0, name: ""))
                            
                            self.settings.user = nil
                            print("logged out!")
                        }
                }
            }
            .modifier(roundedList())
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

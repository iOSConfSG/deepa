//
//  ContentView.swift
//  deepa
//
//  Created by Vina Melody on 15/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            WorkshopView()
                .tabItem {
                    Label("Workshop", systemImage: "laptopcomputer")
                }
            NewsView()
                .tabItem {
                    Label("News", systemImage: "bubble.right.fill")
                }
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.square.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

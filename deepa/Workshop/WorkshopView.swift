//
//  WorkshopView.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import SwiftUI

struct WorkshopView: View {
    @StateObject var viewModel: ScheduleViewModel
    
    init() {
        let viewModel = ScheduleViewModel {
            print("fail init")
        }
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }

    static let extractDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    @State private var schedulePicker = 0
    
    var body: some View {
        NavigationView {
            VStack {
                
                if schedulePicker == 0 {
                    List {
                        ForEach(viewModel.schedule) { talk in
                            if Self.extractDate.string(from: talk.startAt ?? Date.now) == "17/01/2022" {
                                VStack {
                                    NavigationLink(destination: DetailView(talk: talk)) {
                                        TalkContent(talk: talk)
                                    }
                                }
                            }
                        }
                    }.listStyle(.plain)
                } else {
                    List {
                        ForEach(viewModel.schedule) { talk in
                            if Self.extractDate.string(from: talk.startAt ?? Date.now) == "18/01/2022" {
                                VStack {
                                    NavigationLink(destination: DetailView(talk: talk)) {
                                        TalkContent(talk: talk)
                                    }
                                }
                            }
                        }
                    }.listStyle(.plain)
                }
                
                Spacer()
                
            }.navigationTitle("Schedule")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Picker("Schedule", selection: $schedulePicker) {
                            Text("Day 1").tag(0)
                            Text("Day 2").tag(1)
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
        .onAppear {
            viewModel.fetchSchedule()
        }
    }
    
    func handleGraphqlError() {
        
    }
}

struct WorkshopView_Previews: PreviewProvider {
    static var previews: some View {
        WorkshopView()
    }
}

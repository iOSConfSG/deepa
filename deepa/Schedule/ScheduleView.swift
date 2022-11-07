//
//  ScheduleView.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import SwiftUI
import Foundation

struct ScheduleView: View {
    
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
                            if Self.extractDate.string(from: talk.startAt ?? Date.now) == "20/01/2022" {
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
                            if Self.extractDate.string(from: talk.startAt ?? Date.now) == "21/01/2022" {
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

struct TalkContent: View {
    @State var talk: Talk
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        HStack {
            SpeakersImage(speakers: talk.speakers)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(talk.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                if talk.speakers.count == 1 {
                    Text(talk.speakers[0].name)
                        .font(.subheadline)
                } else {
                    Text(concatSpeakerName(speakers: talk.speakers, requireCompany: false))
                        .font(.subheadline)
                }
                
                HStack(spacing: 0) {
                    Text(talk.startAt ?? Date.now, formatter: Self.dateFormat)
                    Text(" - ")
                    Text(talk.endAt ?? Date.now, formatter: Self.dateFormat)
                }.font(.caption)
                    .fontWeight(.light)
            }
        }
    }
}

extension View {
    func concatSpeakerName(speakers: Array<Speaker>, requireCompany: Bool) -> String {
        var speakersList: Array<String> = []
        if requireCompany {
            for speaker in speakers {
                speakersList.append("\(speaker.name) (\(speaker.company ?? ""))")
            }
        } else {
            for speaker in speakers {
                speakersList.append(speaker.name)
            }
        }
        let speakers = speakersList.joined(separator: " & ")
        return speakers
    }
}

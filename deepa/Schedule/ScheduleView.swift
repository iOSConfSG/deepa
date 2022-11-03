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
                Picker("Schedule", selection: $schedulePicker) {
                    Text("Day 1").tag(0)
                    Text("Day 2").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if schedulePicker == 0 {
                    List {
                        ForEach(viewModel.schedule) { information in
                            if Self.extractDate.string(from: information.startAt ?? Date.now) == "20/01/2022" {
                                VStack {
                                    NavigationLink(destination: WorkshopDetailsView(title: information.title, startAt: information.startAt ?? Date.now, endAt: information.endAt ?? Date.now, talkDescription: information.talkDescription ?? "", activityName: information.activityName ?? "", speakers: information.speakers)) {
                                        ListContent(title: information.title, speakers: information.speakers, startAt: information.startAt ?? Date.now, endAt: information.endAt ?? Date.now)
                                    }
                                }
                            }
                        }
                    }.listStyle(.plain)
                } else {
                    List {
                        ForEach(viewModel.schedule) { information in
                            if Self.extractDate.string(from: information.startAt ?? Date.now) == "21/01/2022" {
                                VStack {
                                    NavigationLink(destination: WorkshopDetailsView(title: information.title, startAt: information.startAt ?? Date.now, endAt: information.endAt ?? Date.now, talkDescription: information.talkDescription ?? "", activityName: information.activityName ?? "", speakers: information.speakers)) {
                                        ListContent(title: information.title, speakers: information.speakers, startAt: information.startAt ?? Date.now, endAt: information.endAt ?? Date.now)
                                    }
                                }
                            }
                        }
                    }.listStyle(.plain)
                }
                
                Spacer()
                
            }.navigationTitle("Schedule")
        }
        .onAppear {
            viewModel.fetchSchedule()
        }
    }
    
    func handleGraphqlError() {
        
    }
}

extension View {
    func concatSpeakerName(speakers: Array<Speaker>, requireCompany: Bool) -> String {
        if requireCompany {
            var speakersList: Array<String> = []
            for speaker in speakers {
                speakersList.append("\(speaker.name) (\(speaker.company ?? ""))")
            }
            let speakers = speakersList.joined(separator: " & ")
            return speakers
        } else {
            var speakersList: Array<String> = []
            for speaker in speakers {
                speakersList.append(speaker.name)
            }
            let speakers = speakersList.joined(separator: " & ")
            return speakers
        }
    }
}

struct ListContent: View {
    @State var title: String
    @State var speakers: Array<Speaker>
    @State var startAt: Date
    @State var endAt: Date
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        HStack {
            if speakers.count > 1 {
                Circle()
                    .frame(width: 80)
            } else {
                AsyncImage(url: URL(string: speakers[0].imageUrl ?? ""))
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                if speakers.count == 1 {
                    Text(speakers[0].name)
                        .font(.subheadline)
                } else {
                    Text(concatSpeakerName(speakers: speakers, requireCompany: false))
                        .font(.subheadline)
                }
                
                HStack(spacing: 0) {
                    Text(startAt, formatter: Self.dateFormat)
                    Text(" - ")
                    Text(endAt, formatter: Self.dateFormat)
                }.font(.caption)
                    .fontWeight(.light)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

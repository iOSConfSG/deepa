//
//  WorkshopDetailsView.swift
//  deepa
//
//  Created by Don Chia on 3/11/22.
//

import SwiftUI

struct WorkshopDetailsView: View {
    @State var title: String
    @State var startAt: Date
    @State var endAt: Date
    @State var talkDescription: String
    @State var activityName: String
    @State var speakers: Array<Speaker>
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d HH:mm"
        return formatter
    }()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.systemGroupedBackground).ignoresSafeArea(.all)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(Self.dateFormat.string(from: startAt) + " - " + Self.dateFormat.string(from: endAt))
                        .font(.subheadline)
                    
                    HStack {
                        SpeakersImage(speakers: speakers)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            if speakers.count == 1 {
                                Text("\(speakers[0].name) (\(speakers[0].company ?? ""))")
                                    .font(.subheadline)
                            } else {
                                Text(concatSpeakerName(speakers: speakers, requireCompany: true))
                                    .font(.subheadline)
                            }
                            
                            if speakers.count == 1 {
                                Link("@\(speakers[0].twitter ?? "")", destination: URL(string: "https://twitter.com/\(speakers[0].twitter ?? "")")!)
                            } else {
                                VStack(alignment: .leading) {
                                    ForEach(speakers) { speaker in
                                        Link("@\(speaker.twitter ?? "")", destination: URL(string: "https://twitter.com/\(speaker.twitter ?? "")")!)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Text(talkDescription)
                        .font(Font.body.leading(.loose))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemBackground))
                Spacer()
            }
        }.navigationBarTitle(title)
    }
}

struct SpeakersImage: View {
    @State var speakers: Array<Speaker>
    
    var body: some View {
        if speakers.count > 1 {
            Rectangle()
               .frame(width: 80, height: 80)
               .background(.gray)
               .cornerRadius(6)
        } else {
            AsyncImage(url: URL(string: getURL2022(speakerImageURL: speakers[0].imageUrl ?? ""))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                 Rectangle()
                    .frame(width: 80, height: 80)
                    .background(.gray)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(6)
        }
    }
}

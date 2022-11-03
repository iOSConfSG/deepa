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
                        if speakers.count > 1 {
                            Circle()
                                .frame(width: 80)
                        } else {
                            AsyncImage(url: URL(string: speakers[0].imageUrl ?? ""))
                                .frame(width: 80, height: 80)
                        }
                        
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
                    .background(.white)
                Spacer()
            }
        }.navigationBarTitle(title)
    }
}

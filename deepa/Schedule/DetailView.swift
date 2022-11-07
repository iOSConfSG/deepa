//
//  DetailView.swift
//  deepa
//
//  Created by Don Chia on 3/11/22.
//

import SwiftUI

struct DetailView: View {
    @State var talk: Talk
    
    @State var presentFeedbackSheet: Bool = false
    
    @State var comment: String = ""
    @State var ratings: Int = 0
    
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
                    Text(Self.dateFormat.string(from: talk.startAt ?? Date.now) + " - " + Self.dateFormat.string(from: talk.endAt ?? Date.now))
                        .font(.subheadline)
                    
                    HStack {
                        SpeakersImage(speakers: talk.speakers)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            if talk.speakers.count == 1 {
                                Text("\(talk.speakers[0].name) (\(talk.speakers[0].company ?? ""))")
                                    .font(.subheadline)
                            } else {
                                Text(concatSpeakerName(speakers: talk.speakers, requireCompany: true))
                                    .font(.subheadline)
                            }
                            
                            if talk.speakers.count == 1 {
                                Link("@\(talk.speakers[0].twitter ?? "")", destination: URL(string: "https://twitter.com/\(talk.speakers[0].twitter ?? "")")!)
                            } else {
                                VStack(alignment: .leading) {
                                    ForEach(talk.speakers) { speaker in
                                        Link("@\(speaker.twitter ?? "")", destination: URL(string: "https://twitter.com/\(speaker.twitter ?? "")")!)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    Text(talk.talkDescription ?? "")
                        .font(Font.body.leading(.loose))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemBackground))
                Spacer()
            }
        }.navigationBarTitle(talk.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentFeedbackSheet.toggle()
                    }) {
                        Text("Feedback")
                    }
                }
            }
            .sheet(isPresented: $presentFeedbackSheet) {
                FeedbackForm(comment: comment, ratings: ratings)
            }
    }
}

struct FeedbackForm: View {
    
    @State var comment: String
    @State var ratings: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What do you think of this talk?")
                .fontWeight(.bold)
            HStack {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(i <= self.ratings ? .orange : Color.primary)
                        .onTapGesture(perform: {
                            self.ratings = i
                        })
                }
            }
            TextEditor(text: $comment)
                .border(.gray)
            Button {
                
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
            }
            .tint(.orange)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .cornerRadius(6)
        }
        .presentationDetents([.medium])
        .padding()
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
            AsyncImage(url: URL(string: speakers[0].imageUrl ?? "")) { image in
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
            DetailView(talk: Talk(id: 0, title: "Awesome Talk Title", talkType: TalkType.normalTalk, speakers: [Speaker(id: 0, name: "Tim Apple")]))
    }
}

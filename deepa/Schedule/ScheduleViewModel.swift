//
//  ScheduleViewMode.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import Foundation
import Apollo

class ScheduleViewModel: ObservableObject {
    private var apollo: ApolloClient!
    private var subscription: Cancellable?
    private var graphql: [GetScheduleSubscription.Data.Schedule] = []
    @Published var schedule: [Talk] = []
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return df
    }()
    
    init(failInitClosure: @escaping (()-> Void)) {
//        guard let connection = NetworkManager.shared.client else {
//            failInitClosure()
//            return
//        }
        self.apollo = NetworkManager.shared.client
    }
    
    func fetchSchedule() {
        subscription = apollo.subscribe(subscription: GetScheduleSubscription(), resultHandler: { [weak self] result in
            switch result {
            case .success(let graphqlResult):
                self?.createSchedule(from: graphqlResult)
            case .failure(let error):
                self?.handleError(error)
            }
        })
    }
    
    func createSchedule(from result: GraphQLResult<GetScheduleSubscription.Data>) {
        
        guard let data = result.data else { return }
        let rawSchedule = data.schedule
        
        if !self.schedule.isEmpty {
            self.schedule.removeAll()
        }
        
        for item in rawSchedule {
            guard let id = item.id,
                  let title = item.title,
                  let type = item.talkType,
                  let talkType = TalkType(rawValue: type) else {
                return
            }
            
            var speakers: [Speaker] = []
            
            if !item.speakers.isEmpty {
                speakers = createSpeakers(from: item)
            }
            
            let talk = Talk(id: id,
                            title: title,
                            talkType: talkType,
                            startAt: dateFormatter.date(from: item.startAt ?? ""),
                            endAt: dateFormatter.date(from: item.endAt ?? ""),
                            talkDescription: item.talkDescription,
                            activityName: item.activity ?? "",
                            speakers: speakers)
            self.schedule.append(talk)
            
             print(self.schedule)
        }
    }
    
    func handleError(_ error: Error) {
        print("Error \(error)")
    }
    
    func createSpeakers(from graphqlTalk: GetScheduleSubscription.Data.Schedule) -> [Speaker] {
        let speakers = graphqlTalk.speakers.map { speaker -> Speaker in
            return Speaker(
                id: speaker.id ?? 1,
                name: speaker.name ?? "",
                shortBio: speaker.shortBio,
                twitter: speaker.twitter,
                linkedIn: speaker.linkedinUrl,
                company: speaker.company,
                companyUrl: speaker.companyUrl,
                imageUrl: speaker.imageUrl,
                imageFilename: speaker.imageFilename)
        }
        return speakers
    }
}

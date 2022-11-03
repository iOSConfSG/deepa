//
//  Talk.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import Foundation

public enum TalkType: String {
    case registration
    case openingAddress
    case closingAddress
    case shortbreak
    case lunch
    case normalTalk
    case lightningTalk
    case afterparty
    case workshop
    case groupPhoto
    case quiz
    case energyboost
    case combinedTalk
}

struct Talk: Identifiable {
    var id: Int
    var title: String
    var talkType: TalkType
    var startAt: Date?
    var endAt: Date?
    var talkDescription: String?
    var activityName: String?
    var speakers: [Speaker]
}

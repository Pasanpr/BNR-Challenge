//
//  PostMetadata.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

struct PostMetadata : Codable {
    let title : String
    let publishDate : Date
    let postId : String
    let summary: String
    let author: Author
}

extension PostMetadata {
    enum Month: Int {
        case jan = 1
        case feb
        case mar
        case april
        case may
        case june
        case july
        case aug
        case sep
        case oct
        case nov
        case dec
    }
    var month: Month {
        let monthValue = Calendar.autoupdatingCurrent.component(.month, from: publishDate)
        guard let month = Month(rawValue: monthValue) else {
            fatalError()
        }
        
        return month
    }
}

extension PostMetadata.Month: CustomStringConvertible {
    var description: String {
        switch self {
        case .jan: return "January"
        case .feb: return "February"
        case .mar: return "March"
        case .april: return "April"
        case .may: return "May"
        case .june: return "June"
        case .july: return "July"
        case .aug: return "August"
        case .sep: return "September"
        case .oct: return "October"
        case .nov: return "November"
        case .dec: return "December"
        }
    }
}


extension PostMetadata: Equatable {
    static func ==(lhs: PostMetadata, rhs: PostMetadata) -> Bool {
        return lhs.title == rhs.title && lhs.publishDate == rhs.publishDate && lhs.postId == rhs.postId && lhs.summary == rhs.summary && lhs.author == rhs.author
    }
}

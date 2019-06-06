//
//  Author.swift
//  Blog Nerd Ranch
//
//  Created by Pasan Premaratne on 6/6/19.
//  Copyright © 2019 Chris Downie. All rights reserved.
//

import Foundation

struct Author: Codable {
    let name: String
    let image: String
    let title: String
}


extension Author: Equatable {
    static func ==(lhs: Author, rhs: Author) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image && lhs.title == rhs.title
    }
}

extension Author: Comparable {
    static func <(lhs: Author, rhs: Author) -> Bool {
        return lhs.name < rhs.name
    }
}

//
//  PostMetadataDataSource.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 9/3/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

/// Group & sort posts based on the given ordering.
struct PostMetadataDataSource {
    /// Represents a named group of posts. The nature of the group depends on the ordering it was created with
    private struct Group {
        let name : String?
        var postMetadata: [PostMetadata]
    }
    
    var ordering : DisplayOrdering {
        didSet {
            createGroups()
        }
    }
    var postMetadataList : [PostMetadata] {
        didSet {
            createGroups()
        }
    }
    
    private var groups: [Group] = []
    
    init(ordering: DisplayOrdering, postMetadata: [PostMetadata] = []) {
        self.ordering = ordering
        self.postMetadataList = postMetadata
        createGroups()
    }
    
    private mutating func createGroups() {
        switch ordering.grouping {
        case .author:
            createGroupsByAuthor()
        case .month:
            createGroupsByMonth()
        case .none:
            groups = [Group(name: nil, postMetadata: postMetadataList)]
        }
        
        let isGrouped = ordering.grouping != .none
        
        switch ordering.sorting {
        case let .alphabeticalByAuthor(ascending):
            let sortCriteria: (String, String) -> Bool = ascending == true ? (<) : (>)
            sortAlphabeticallyByAuthor(isGrouped: isGrouped, criteria: sortCriteria)
        case let .alphabeticalByTitle(ascending):
            let sortCriteria: (String, String) -> Bool = ascending == true ? (<) : (>)
            sortAlphabeticallyByTitle(isGrouped: isGrouped, criteria: sortCriteria)
        case let .byPublishDate(recentFirst):
            let sortCriteria: (Date, Date) -> Bool = recentFirst == true ? (>) : (<)
            sortByPublishDate(isGrouped: isGrouped, criteria: sortCriteria)
        }
    }
    
    // MARK: UICollectionViewDataSource convenience
    
    func numberOfSections() -> Int {
        return groups.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return groups[section].name
    }
    
    func numberOfPostsInSection(_ section: Int) -> Int {
        return groups[section].postMetadata.count
    }
    
    func postMetadata(at indexPath: IndexPath) -> PostMetadata {
        return groups[indexPath.section].postMetadata[indexPath.row]
    }
 
    // MARK: Grouping
    
    private mutating func createGroupsByAuthor() {
        let authors = Array(Set(postMetadataList.map({ $0.author.name })))
        groups = authors.map { author in
            let posts = postMetadataList.filter({ $0.author.name == author })
            return Group(name: author, postMetadata: posts)
        }
    }
    
    private mutating func createGroupsByMonth() {
        let months = Array(Set(postMetadataList.map({ $0.month }))).sorted(by: { $0.rawValue < $1.rawValue })
        groups = months.map { month in
            let posts = postMetadataList.filter({ $0.month == month })
            return Group(name: month.description, postMetadata: posts)
        }
    }
        
    // MARK: Sorting
    
    private mutating func sortAlphabeticallyByAuthor(isGrouped: Bool, criteria: (String, String) -> Bool) {
        switch isGrouped {
        case true:
            sortGroupsAlphabeticallyByAuthor(criteria: criteria)
        case false:
            sortGroupAlphabeticallyByAuthor(criteria: criteria)
        }
    }
    
    private mutating func sortGroupAlphabeticallyByAuthor(criteria: (String, String) -> Bool) {
        groups = [Group(name: nil, postMetadata: postMetadataList.sorted(by: {
            criteria($0.author.name, $1.author.name)
        }))]
    }
    
    private mutating func sortGroupsAlphabeticallyByAuthor(criteria: (String, String) -> Bool) {
        groups = groups.sorted(by: { criteria($0.postMetadata.first!.author.name, $1.postMetadata.first!.author.name) })
    }
    
    private mutating func sortAlphabeticallyByTitle(isGrouped: Bool, criteria: (String, String) -> Bool) {
        switch isGrouped {
        case true:
            sortGroupsAlphabeticallyByTitle(criteria: criteria)
        case false:
            sortGroupAlphabeticallyByTitle(criteria: criteria)
        }
    }
    
    private mutating func sortGroupAlphabeticallyByTitle(criteria: (String, String) -> Bool) {
        groups = [Group(name: nil, postMetadata: postMetadataList.sorted(by: {
            criteria($0.title, $1.title)
        }))]
    }
    
    private mutating func sortGroupsAlphabeticallyByTitle(criteria: (String, String) -> Bool) {
        // FIXME: Force unwrapping!
        groups = groups.sorted(by: { criteria($0.postMetadata.first!.title, $1.postMetadata.first!.title) })
    }
    
    private mutating func sortByPublishDate(isGrouped: Bool, criteria: (Date, Date) -> Bool) {
        switch isGrouped {
        case true:
            sortGroupsByPublishDate(criteria: criteria)
        case false:
            sortGroupByPublishDate(criteria: criteria)
        }
    }
    
    private mutating func sortGroupByPublishDate(criteria: (Date, Date) -> Bool) {
        groups = [Group(name: nil, postMetadata: postMetadataList.sorted(by: {
            criteria($0.publishDate, $1.publishDate)
        }))]
    }
    
    private mutating func sortGroupsByPublishDate(criteria: (Date, Date) -> Bool) {
        // FIXME: Force unwrapping!
        groups = groups.sorted(by: { criteria($0.postMetadata.first!.publishDate, $1.postMetadata.first!.publishDate) })
    }
}

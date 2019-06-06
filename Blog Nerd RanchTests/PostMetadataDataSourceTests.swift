//
//  PostMetadataDataSourceTests.swift
//  Blog Nerd RanchTests
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import XCTest
@testable import Blog_Nerd_Ranch

class PostMetadataDataSourceTests: XCTestCase {
    var postMetadataList: [PostMetadata] = []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        
        let tim = Author(name: "Tim Cook", image: "/avatar/tim.png", title: "CEO")
        let jony = Author(name: "Jony Ive", image: "/avatar/jony.png", title: "CDO")
        
        // 01/01/2019 @ 12:00am (UTC)
        let january = Date(timeIntervalSince1970: 1546300800)
        // 02/01/2019 @ 12:00am (UTC)
        let february = Date(timeIntervalSince1970: 1548979200)
        // 03/15/2019 @ 12:00am (UTC)
        let march = Date(timeIntervalSince1970: 1552608000)
        
        postMetadataList = [
            PostMetadata(title: "Foo", publishDate: january, postId: "1", summary: "Bar", author: tim),
            PostMetadata(title: "Bar", publishDate: february, postId: "2", summary: "Baz", author: tim),
            PostMetadata(title: "Baz", publishDate: march, postId: "3", summary: "Quz", author: jony)
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrderWithNoPosts() {
        let ordering = DisplayOrdering(grouping: .none, sorting: .byPublishDate(recentFirst: false))
        
        let dataSource = PostMetadataDataSource(ordering: ordering)
        
        XCTAssertEqual(dataSource.numberOfSections(), 1)
        XCTAssertNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 0)
    }
    
    func testOrderWithAuthorGroups() {
        let ordering = DisplayOrdering(grouping: .author, sorting: .byPublishDate(recentFirst: false))
        
        var dataSource = PostMetadataDataSource(ordering: ordering)
        dataSource.postMetadataList = postMetadataList
        
        XCTAssertEqual(dataSource.numberOfSections(), 2)
        XCTAssertNotNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 2)
    }
    
    func testOrderWithMonthGroups() {
        let ordering = DisplayOrdering(grouping: .month, sorting: .byPublishDate(recentFirst: false))
        
        var dataSource = PostMetadataDataSource(ordering: ordering)
        dataSource.postMetadataList = postMetadataList
        
        XCTAssertEqual(dataSource.numberOfSections(), 3)
        XCTAssertNotNil(dataSource.titleForSection(0))
        XCTAssertEqual(dataSource.numberOfPostsInSection(0), 1)
    }
}

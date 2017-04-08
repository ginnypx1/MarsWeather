//
//  MarsWeatherTests.swift
//  MarsWeatherTests
//
//  Created by Ginny Pennekamp on 3/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import XCTest
@testable import MarsWeather

class MarsWeatherTests: XCTestCase {
    
    var requestUnderTest: MarsRequest!
    var secondRequestUnderTest: DarkSkyRequest!
    
    override func setUp() {
        super.setUp()
        requestUnderTest = MarsRequest()
        secondRequestUnderTest = DarkSkyRequest()
    }
    
    override func tearDown() {
        //requestUnderTest = nil
        secondRequestUnderTest = nil
        super.tearDown()
    }
    
    func testMarsURLIsCorrect() {
        let url = requestUnderTest.buildURL()
        let assertEqualToURL = "http://marsweather.ingenology.com/v1/latest/?api_key=\(MARS_API_KEY)&format=json"
        XCTAssertEqual(url, URL(string: assertEqualToURL), "The URL is NOT correct")
    }
    
    func testDarkSkyURLIsCorrect() {
        let url = secondRequestUnderTest.buildURL()
        let assertEqualToURL = "https://api.darksky.net/forecast/\(DARK_SKY_API_KEY)/34.102142,-118.272374?exclude=[%22minutely%22,%22hourly%22,%22alerts%22,%22flags%22]"
        XCTAssertEqual(url, URL(string: assertEqualToURL), "The URL is NOT correct")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


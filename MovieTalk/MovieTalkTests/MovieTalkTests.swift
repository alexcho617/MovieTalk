//
//  MovieTalkTests.swift
//  MovieTalkTests
//
//  Created by Alex Cho on 2023/11/13.
//

import XCTest
import Moya
import RxSwift

@testable import MovieTalk

final class MovieTalkTests: XCTestCase {
    
    var viewModel: AddPostViewModel!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        viewModel = AddPostViewModel()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
    }
    
    func testPostSuccess() {
        let expectation = self.expectation(description: "Post should succeed")
        let manager = ContentsManager.shared
        let model = ContentsCreateRequestDTO.sampleData
        
        // Mock MoyaProvider for success response
        let mockProvider = MoyaProvider<ContentsServerAPI>()
        manager.post(model)
            .subscribe(onNext: { success in
                XCTAssertTrue(success, "Post should succeed")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Unexpected error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExample() throws {
        
    }
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
}

extension ContentsCreateRequestDTO {
    static var sampleData: ContentsCreateRequestDTO {
        return ContentsCreateRequestDTO(
            title: "Sample Title",
            content: "This is a sample content for testing purposes.",
            file: Data(), // Mock image data
            product_id: "mtSNS",
            content1: "sampleMovieID",
            content2: "Sample Movie Title",
            content3: nil,
            content4: nil,
            content5: nil
        )
    }
}

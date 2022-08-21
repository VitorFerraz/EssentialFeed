//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 14/08/22.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValuesRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, !data.isEmpty, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError
        
        let receivedError = resultError(for: nil, response: nil, error: requestError) as NSError?
        
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultError(for: nil, response: nil, error: nil))
        XCTAssertNotNil(resultError(for: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultError(for: nil, response: anyHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultError(for: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultError(for: anyData, response: nil, error: anyNSError))
        XCTAssertNotNil(resultError(for: nil, response: nonHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(for: nil, response: anyHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(for: anyData, response: nonHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(for: anyData, response: anyHTTPURLResponse, error: anyNSError))
        XCTAssertNotNil(resultError(for: anyData, response: nonHTTPURLResponse, error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData
        let response = anyHTTPURLResponse
        URLProtocolStub.stub(data: data, response: response, error: nil)
        
        let exp = expectation(description: "wait for completion")
        makeSUT().get(from: anyURL) { result in
            switch result {
            case .success((let receivedData, let receivedResponse)):
                XCTAssertEqual(receivedData, data)
                XCTAssertEqual(receivedResponse.url, response?.url)
                XCTAssertEqual(receivedResponse.statusCode, response?.statusCode)
            case .failure:
                XCTFail("expected success but got \(result)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func resultError(
        for data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)

        let exp = expectation(description: "wait for completion")
        let sut = makeSUT(file: file, line: line)
        
        var receivedError: Error?
        sut.get(from: anyURL) { result in
            switch result {
            case .failure(let error as NSError):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return receivedError
    }
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }
    
    private var anyData: Data {
        Data("any data".utf8)
    }
    
    private var nonHTTPURLResponse: URLResponse {
        URLResponse(url: anyURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    }
    
    private var anyHTTPURLResponse: HTTPURLResponse? {
        HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    }
    
    private var anyNSError: NSError {
        NSError(domain: "", code: 1)
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            requestObserver = nil
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}

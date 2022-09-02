//
//  Bundle+loadJSONTests.swift
//  PokedexTests
//
//  Created by Tino on 31/8/2022.
//

import XCTest
@testable import Pokedex

final class Bundle_loadJSONTests: XCTestCase {
    func testSuccessfulDecoding() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        do {
            let pokemon = try Bundle.main.loadJSON(ofType: Pokemon.self, filename: "pokemon", extension: "json")
            XCTAssertTrue(Pokemon.self == type(of: pokemon.self))
        } catch {
            
        }
    }

    func testFailedDecoding() throws {
        do {
            let pokemon = try Bundle.main.loadJSON(ofType: Move.self, filename: "pokemon", extension: "json")
        } catch let error as Bundle.LoadJSONError {
            XCTAssertTrue(error == Bundle.LoadJSONError.dataDecodingError)
        }
    }
    
    func testWithInvalidFilename() throws {
        do {
            _ = try Bundle.main.loadJSON(ofType: Pokemon.self, filename: "noSuchFile")
        } catch let error as Bundle.LoadJSONError {
            XCTAssertTrue(error == Bundle.LoadJSONError.noFileFound)
        } catch {
            XCTAssertTrue(true, "Expected noFileFound error")
        }
    }
    
    func testWithInvalidFilenameWithEmptyExtension() throws {
        do {
            _ = try Bundle.main.loadJSON(ofType: Pokemon.self, filename: "pokemon")
        } catch let error as Bundle.LoadJSONError {
            XCTAssertTrue(error == Bundle.LoadJSONError.noFileFound)
        } catch {
            XCTAssertTrue(true, "Expected noFileFound error")
        }
    }
    
    func testWithNoFilename() throws {
        do {
            _ = try Bundle.main.loadJSON(ofType: Pokemon.self, filename: "")
        } catch let error as Bundle.LoadJSONError {
            XCTAssertTrue(error == Bundle.LoadJSONError.noFileFound)
        } catch {
            XCTAssertTrue(true, "Expected noFileFound error")
        }
    }
}

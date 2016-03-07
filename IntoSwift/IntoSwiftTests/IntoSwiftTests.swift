

import XCTest
@testable import IntoSwift

class IntoSwiftTests: XCTestCase {
    
    var injector: Injector!
    override func setUp() {
        super.setUp()
        
        injector = Injector()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPrintingGraph() {
        let graph = injector.bind(TestProtocol.self).to(TestStruct.init).printGraph()
        print("graph:\n\(graph)")
    }
    
    func testPrintingGraphWithDependencies() {
        let graph = injector
            .bind(TestStructWithDependency).to(TestStructWithDependency.init)
            .bind(TestProtocol.self).to(TestStruct.init)
            .bind(TestProtocol2.self).to(TestStruct2.init)
            .printGraph()
        print("graph:\n\(graph)")
    }
    
    func testPrintingGraphWithCircularDependencies()  {
        let graph = injector
            .bind(TestACircle.self).to(TestACircle.init)
            .bind(TestBCircle.self).to(TestBCircle.init)
            .bind(TestCCircle.self).to(TestCCircle.init)
            .printGraph()
        print("graph:\n\(graph)")
    }
    
    func testBuildingCircularDependency() {
        do {
        try injector
            .bind(TestACircle.self).to(TestACircle.init)
            .bind(TestBCircle.self).to(TestBCircle.init)
            .bind(TestCCircle.self).to(TestCCircle.init)
            .build()
        } catch InjectionError.FailedToResolve(let cause, let graph) {
            print(graph)
        } catch {
            // Try to recover or something
        }
    }
    
}


protocol TestProtocol {}
protocol TestProtocol2 {}
protocol TestProtocol3 {}

struct TestStruct: TestProtocol{}
struct TestStruct2: TestProtocol2{}
struct TestStruct3: TestProtocol3{}

struct TestStructWithDependency{
    let a: TestProtocol
    let b: TestProtocol2
}

class TestACircle {
    init(b:TestBCircle){}
}

class TestBCircle {
    init(c:TestCCircle){}
}

class TestCCircle {
    init(a:TestACircle){}
}
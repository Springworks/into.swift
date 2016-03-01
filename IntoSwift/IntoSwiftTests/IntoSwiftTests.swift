

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
        let resolver = injector.bind(TestProtocol.self).to(TestStruct.init).resolve()
        let graph = resolver.check()
        print("graph:\n\(graph)")
    }
    
    func testPrintingGraphWithDependencies() {
        let resolver = injector
            .bind(TestStructWithDependency).to(TestStructWithDependency.init)
            .bind(TestProtocol.self).to(TestStruct.init)
            .bind(TestProtocol2.self).to(TestStruct2.init)
            .resolve()
        let graph = resolver.check()
        print("graph:\n\(graph)")
    }
    
    func testPrintingGraphWithCircularDependencies() {
        let resolver = injector
            .bind(TestACircle.self).to(TestACircle.init)
            .bind(TestBCircle.self).to(TestBCircle.init)
            .bind(TestCCircle.self).to(TestCCircle.init)
            .resolve()
        let graph = resolver.check()
        print("graph:\n\(graph)")
    }
    
    
    func testStringifyingTypeNameExample() {
        
        let dict:[String:Any.Type] = ["TestStruct":TestStruct.self,
            "TestStruct2":TestStruct2.self,
            "TestStruct3":TestStruct3.self,
            "TestProtocol":TestProtocol.self,
            "TestProtocol2":TestProtocol2.self,
            "TestProtocol3":TestProtocol3.self]
        
        self.measureBlock {
            let name = String(TestStruct.self)
            let type = dict[name]
        }
        
        
    }
    
    func testLookingUpFromList() {
        var list:[Any.Type] = [TestStruct.self,
            TestStruct2.self, TestStruct3.self,
            TestProtocol.self, TestProtocol2.self,
            TestProtocol3.self]
        
        self.measureBlock {
            for type in list {
                // do nothing
            }
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
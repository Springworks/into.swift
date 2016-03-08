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
        } catch InjectionError.FailedToResolve( _, let graph) {
            print(graph)
        } catch {
            // Try to recover or something
        }
    }
    
    func testResolvePrototypeScopeBindingReturnsNewInstances() {
        
        guard let resolver = try? injector.inScope(.Prototype).bind(TestClass.self).to(TestClass.init).build() else {
            XCTFail("Could not setup injector")
            return
        }
        
        guard let instance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create instance")
            return
        }
        
        instance.value = "first"
        
        guard let otherInstance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create other instance")
            return
        }
        
        otherInstance.value = "seconds"
        
        XCTAssertNotEqual(instance.value, otherInstance.value)
    }
    
    func testResolveWeakSingletonBindingReturnsSameInstanceWhenReferenceExists() {
        guard let resolver = try? injector.inScope(.Weak).bind(TestClass.self).to(TestClass.init).build() else {
            XCTFail("Could not setup injector")
            return
        }
        
        guard let instance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create instance")
            return
        }
        
        instance.value = "first"
        
        guard let otherInstance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create other instance")
            return
        }
        
        otherInstance.value = "seconds"
        
        XCTAssertEqual(instance.value, otherInstance.value)
    }
    
    func testResolveWeakSingletonBindingReturnsANewInstanceWhenAllReferencesHaveBeenLost() {
        guard let resolver = try? injector.inScope(.Weak).bind(TestClass.self).to(TestClass.init).build() else {
            XCTFail("Could not setup injector")
            return
        }
        
        guard var instance:TestClass? = try? resolver.resolve(TestClass.self) else {
            XCTFail("Could not create instance")
            return
        }
        
        instance?.value = "first"
        
        XCTAssertEqual(instance?.value, "first")
        
        // nil the reference
        instance = nil
        
        guard let otherInstance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create other instance")
            return
        }
        
        XCTAssertEqual(otherInstance.value, "nothing")
    }
    
    func testResolveSingletonBindingReturnsTheSameInstanceEvenWhenAllReferencesHaveBeenLost() {
        guard let resolver = try? injector.inScope(.Singleton).bind(TestClass.self).to(TestClass.init).build() else {
            XCTFail("Could not setup injector")
            return
        }
        
        guard var instance:TestClass? = try? resolver.resolve(TestClass.self) else {
            XCTFail("Could not create instance")
            return
        }
        
        instance?.value = "first"
        
        XCTAssertEqual(instance?.value, "first")
        
        // nil the reference
        instance = nil
        
        guard let otherInstance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not create other instance")
            return
        }
        
        XCTAssertEqual(otherInstance.value, "first")
    }
    
    
    func testBindingDirectlyToClassConstructorToItsOwnType() {
        guard let resolver = try? injector.bind(TestClass.init).build() else {
            XCTFail("Could not setup injector")
            return
        }
        
        guard let instance:TestClass = try? resolver.resolve() else {
            XCTFail("Could not resolve instance")
            return
        }
    }
    
    
    
}


protocol TestProtocol {}
protocol TestProtocol2 {}
protocol TestProtocol3 {}

struct TestStruct: TestProtocol{}
struct TestStruct2: TestProtocol2{}
struct TestStruct3: TestProtocol3{}

class TestClass {
    var value: String = "nothing"
}

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
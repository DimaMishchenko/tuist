import TuistAsyncQueue
import TuistCore
import Foundation

public enum MockAsyncQueueDispatcherError: Error {
    case dispatchError
}

public class MockAsyncQueueDispatcher: AsyncQueueDispatching {

    public init() {}
    
    public var invokedIdentifierGetter = false
    public var invokedIdentifierGetterCount = 0
    public var stubbedIdentifier: String! = ""

    public var identifier: String {
        invokedIdentifierGetter = true
        invokedIdentifierGetterCount += 1
        return stubbedIdentifier
    }

    public var invokedDispatch = false
    public var invokedDispatchCallBack: () -> Void = {}
    public var invokedDispatchCount = 0
    public var invokedDispatchParameterEvent: AsyncQueueEvent? = nil
    public var invokedDispatchParametersEventsList = [AsyncQueueEvent]()
    public var stubbedDispatchError: Error?

    public func dispatch(event: AsyncQueueEvent) throws {
        invokedDispatch = true
        invokedDispatchCount += 1
        invokedDispatchParameterEvent = event
        invokedDispatchParametersEventsList.append(event)
        if let error = stubbedDispatchError {
            invokedDispatchCallBack()
            throw error
        }
        invokedDispatchCallBack()
    }

    public var invokedDispatchPersisted = false
    public var invokedDispatchPersistedCount = 0
    public var invokedDispatchPersistedParameters: (data: Data, Void)?
    public var invokedDispatchPersistedParametersList = [(data: Data, Void)]()
    public var stubbedDispatchPersistedError: Error?

    public func dispatchPersisted(data: Data) throws {
        invokedDispatchPersisted = true
        invokedDispatchPersistedCount += 1
        invokedDispatchPersistedParameters = (data, ())
        invokedDispatchPersistedParametersList.append((data, ()))
        if let error = stubbedDispatchPersistedError {
            throw error
        }
    }
}
//
//  Store.swift
//

import Combine
import Foundation
import SwiftUI

typealias AppStore = Store<AppState, AppAction>
typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>?


final class Store<State, Action>: ObservableObject {

    // Read only access to app state
    @Published private(set) var state: State

    var tasks = [AnyCancellable?]()

    let serialQueue = DispatchQueue(label: "com.jlo.store.serial.queue")

    private let reducer: Reducer<State, Action>
    let middlewares: [Middleware<State, Action>]
    private var middlewareCancellables: Set<AnyCancellable> = []

    init(initialState: State,
         reducer: @escaping Reducer<State, Action>,
         middlewares: [Middleware<State, Action>] = []) {
        self.state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
    }

    // The dispatch function.
    func dispatch(_ action: Action) {
        reducer(&state, action)

        // Dispatch all middleware functions
        for mw in middlewares {
            guard let middleware = mw(state, action) else {
                break
            }
            
            middleware
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] in
                    guard let self = self
                    else { return }
                    self.dispatch($0)
                })
                .store(in: &middlewareCancellables)

        }
    }
}

//
//  Publisher+Extensions.swift
//  SpriteAnimationPreview
//
//  Created by Jonathan Long on 8/22/22.
//

import Combine
import Foundation

public extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

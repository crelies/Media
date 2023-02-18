import SwiftUI

extension Binding {
    static func writeOnly<T>(
        _ set: @escaping (T?) -> Void
    ) -> Binding<Optional<T>> {
        Binding<Optional<T>>(
            get: { nil },
            set: set
        )
    }
}

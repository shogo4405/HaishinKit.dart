import Foundation

enum AnyUtil {
    static func removeEmpty(_ value: Any?) -> Any? {
        if var value = value as? [String: Any?] {
            if value.isEmpty {
                return nil
            }
            for var element in value {
                value[element.key] = removeEmpty(element.value)
            }
            return value
        }
        if var value = value as? [Any?] {
            if value.isEmpty {
                return nil
            }
            for i in 0..<value.count {
                value[i] = removeEmpty(value[i])
            }
            return value
        }
        return value
    }
}

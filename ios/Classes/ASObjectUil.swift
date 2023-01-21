import Foundation
import HaishinKit

enum ASObjectUtil {
    static func removeEmpty(_ value: Any?) -> Any? {
        if var value = value as? ASObject {
            for var element in value {
                value[element.key] = removeEmpty(element.value)
            }
            return value.isEmpty ? nil : value
        }
        if let value = value as? ASArray {
            var result: [Any?] = []
            for i in 0..<value.length {
                result.append(removeEmpty(value[i]))
            }
            return result.isEmpty ? nil : result
        }
        if let value = value {
            if (value is ASUndefined) {
                return nil
            }
            return value
        }
        return nil
    }
}


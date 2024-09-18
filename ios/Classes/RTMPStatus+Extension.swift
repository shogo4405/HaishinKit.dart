import Foundation
import HaishinKit

extension RTMPStatus {
    func makeEvent() -> [String: Any?] {
        return [
            "type": "rtmpStatus",
            "data": [
                "code": code,
                "level": level,
                "description": description
            ]
        ]
    }
}

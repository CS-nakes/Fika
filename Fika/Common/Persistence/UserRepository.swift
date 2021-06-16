import Foundation

/// Adapted from https://www.iosapptemplates.com/blog/ios-development/data-persistence-ios-swift
class UserRepository {

    static let userDefaults: UserDefaults = .standard

    static func saveValue(forKey key: String, value: Any) {
        userDefaults.set(value, forKey: key)
    }

    static func readValue<T>(forKey key: String) -> T? {
        userDefaults.value(forKey: key) as? T
    }

    static func deleteValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

}

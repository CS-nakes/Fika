enum Timeslot: String, Codable {
    case breakfast
    case lunch
    case tea

    var endHour: Int {
        switch self {
        case .breakfast:
            return 9
        case .lunch:
            return 13
        case .tea:
            return 15
        }
    }

    var endMinute: Int {
        switch self {
        case .breakfast:
            return 0
        case .lunch:
            return 30
        case .tea:
            return 0
        }
    }

}

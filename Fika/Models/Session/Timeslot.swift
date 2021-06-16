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

    var rangeString: String {
        switch self {
        case .breakfast:
            return "9:00AM - 9:30AM"
        case .lunch:
            return "12:30PM - 1:00PM"
        case .tea:
            return "3:00PM - 3:30PM"
        }
    }

}

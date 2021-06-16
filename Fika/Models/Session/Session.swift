import Foundation

struct Session {
    let id: String?
    let participants: [String] // array of user ids
    let date: Date
    let timeslot: Timeslot
}

extension Session {
    init(from record: SessionRecord) throws {
        self.init(
            id: record.id,
            participants: record.participants,
            date: record.date,
            timeslot: record.timeslot
        )
    }
}

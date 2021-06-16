import FirebaseFirestore
import FirebaseFirestoreSwift

struct SessionRecord {
    @DocumentID private(set) var id: String?
    private(set) var participants: [String]
    private(set) var date: Date
    private(set) var timeslot: Timeslot
    private(set) var isCompleted: Bool
}

extension SessionRecord: Codable {

}

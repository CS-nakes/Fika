import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserRecord {
    @DocumentID private(set) var id: String?
    private(set) var name: String
    private(set) var position: String
    // no companyId
    private(set) var profilePictureId: String?
    @ExplicitNull private(set) var introduction: String?
    private(set) var preferredTimeslots: [Timeslot]

}

extension UserRecord: Codable {

}

struct User {
    // email pw is in firebase
    let id: String?
    let name: String
    let position: String
    let companyId: String
    let introduction: String?
    let profilePicture: String // id to firebaseCloud storage
    let preferredTimeslots: [Timeslot]
}

extension User {
    init(from record: UserRecord) throws {
        self.init(
            id: record.id,
            name: record.name,
            position: record.position,
            companyId: "IGNORE",
            introduction: record.introduction,
            profilePicture: record.profilePicture,
            preferredTimeslots: record.preferredTimeslots
        )
    }
}

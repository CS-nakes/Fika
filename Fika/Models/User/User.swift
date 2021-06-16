struct User {
    // email pw is in firebase
    var id: String?
    var name: String?
    var position: String?
    var companyId: String?
    var introduction: String?
    var profilePictureId: String?// id to firebaseCloud storage
    var preferredTimeslots: [Timeslot]

    init(id: String? = nil, name: String? = nil, position: String? = nil, companyId: String? = nil,
         introduction: String? = nil, profilePictureId: String? = nil, preferredTimeslots: [Timeslot] = []) {
        self.id = nil
        self.name = name
        self.position = position
        self.companyId = companyId
        self.introduction = introduction
        self.profilePictureId = profilePictureId
        self.preferredTimeslots = preferredTimeslots
    }
}

extension User {
    init(from record: UserRecord) throws {
        self.init(
            id: record.id,
            name: record.name,
            position: record.position,
            companyId: "IGNORE",
            introduction: record.introduction,
            profilePictureId: record.profilePictureId,
            preferredTimeslots: record.preferredTimeslots
        )
    }
}

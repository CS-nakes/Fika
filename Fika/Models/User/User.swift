struct User {
    // email pw is in firebase
    var id: String?
    var name: String?
    var position: String?
    var companyId: String?
    var introduction: String?
    var profilePicture: String?// id to firebaseCloud storage
    var preferredTimeslots: [Timeslot]

    init(id: String? = nil, name: String? = nil, position: String? = nil, companyId: String? = nil,
         introduction: String? = nil, profilePicture: String? = nil, preferredTimeslots: [Timeslot] = []) {
        self.id = nil
        self.name = name
        self.position = position
        self.companyId = companyId
        self.introduction = introduction
        self.profilePicture = profilePicture
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
            profilePicture: record.profilePicture,
            preferredTimeslots: record.preferredTimeslots
        )
    }
}

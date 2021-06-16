struct User {
    // email pw is in firebase
    let name: String?
    let position: String?
    let companyId: String?
    let introduction: String?
    let profilePicture: String?// id to firebaseCloud storage
    let preferredTimeslots: [Timeslot]

    init(name: String? = nil, position: String? = nil, companyId: String? = nil, introduction: String? = nil,
         profilePicture: String? = nil, preferredTimeslots: [Timeslot] = []) {

        self.name = name
        self.position = position
        self.companyId = companyId
        self.introduction = introduction
        self.profilePicture = profilePicture
        self.preferredTimeslots = preferredTimeslots
    }
}

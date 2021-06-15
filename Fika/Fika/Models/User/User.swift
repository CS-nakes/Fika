struct User {
    // email pw is in firebase
    let name: String
    let position: String
    let companyId: String
    let introduction: String
    let profilePicture: String // id to firebaseCloud storage
    let preferredTimeslots: [Timeslot]
}

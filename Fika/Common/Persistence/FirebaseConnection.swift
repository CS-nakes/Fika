import Firebase
import FirebaseStorage

struct FirebaseConnection {
    private let userPath: String = "users"
    private let sessionPath: String = "sessions"
    private let db = Firestore.firestore()

    // MARK: - FirebaseDatabase: Create/Update

    // use case: on creating profile
    func createUser(user: User, completion: @escaping (Error?) -> Void) throws {
        UserRepository.deleteValue(forKey: "profilePictureId")
        // only called after createAuth
        guard let userId: String = UserRepository.readValue(forKey: "userId") else {
            completion(DatabaseError.noUserId)
            return
        }

        guard let name = user.name, let position = user.position else {
            completion(DatabaseError.invalidUser)
            return
        }

        let userDoc = UserRecord(name: name, position: position,
                                 profilePictureId: user.profilePictureId,
                                 introduction: user.introduction,
                                 preferredTimeslots: user.preferredTimeslots,
                                 isAvailable: true)

        try db.collection(userPath).document(userId).setData(from: userDoc) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }

    }

    // MARK: - FirebaseDatabase: Get

    // could also remove userId and grab userid from UserDefaults
    private func fetchUpcomingSessions(completion: @escaping ([Session]?, Error?) -> Void) {

        // only get the last 1, because u might finish the call early.
        // if fetch all, may show the call that you just ended

        db.collection(sessionPath).getDocuments { snapshot, err in
            guard let sessionRecords = (snapshot?.documents
                                            .compactMap { try? $0.data(as: SessionRecord.self) }),
                  err == nil else {
                completion([], err)
                return
            }

            guard let userId: String = UserRepository.readValue(forKey: "userId") else {
                completion([], nil)
                return
            }

            let involvedSessionRecords = sessionRecords.filter { $0.participants.contains(userId) }

            let upcomingSessionRecords = involvedSessionRecords.filter { !$0.isCompleted &&
                Calendar.current.date(bySettingHour: $0.timeslot.endHour,
                                      minute: $0.timeslot.endMinute, second: 0, of: $0.date)! > Date()
            }

            guard let lastSessionRecord = upcomingSessionRecords.max(by: { $0.date > $1.date }),
                  let lastSession = try? Session(from: lastSessionRecord) else {
                completion([], nil)
                return
            }

            completion([lastSession], nil)
        }
    }

    // use case: display on session card
    func fetchUser(userId: String, completion: @escaping (User?, Error?) -> Void) {
        db.collection(userPath).document(userId).getDocument { document, err in
            guard let userRecord = try? document?.data(as: UserRecord.self), err == nil,
                  let user = try? User(from: userRecord) else {
                completion(nil, err)
                return
            }
            completion(user, nil)
        }

    }

    func upcomingSessionsListener(completion: @escaping ([Session]?, Error?) -> Void) {
        guard let userId: String = UserRepository.readValue(forKey: "userId") else {
            completion([], nil)
            return
        }

        db.collection(userPath).document(userId)
            .addSnapshotListener { _, _ in
                fetchUpcomingSessions(completion: completion)
            }
    }

    func completeSession(sessionId: String, completion: @escaping (Error?) -> Void) {
        guard let userId: String = UserRepository.readValue(forKey: "userId") else {
            completion(DatabaseError.noUserId)
            return
        }

        db.collection(sessionPath).document(sessionId).updateData(["isCompleted": true]) { err in
            guard err == nil else {
                completion(err)
                return
            }

            db.collection(userPath).document(userId).updateData(["isAvailable": true]) { err in
                guard err == nil else {
                    completion(err)
                    return
                }
                completion(nil)
            }

        }

    }

    // MARK: - FirebaseAuth

    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        UserRepository.deleteValue(forKey: "profilePictureId")
        UserRepository.deleteValue(forKey: "userId")
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            guard let userId = authDataResult?.user.uid, error == nil else {
                // should not reach
                completion(authDataResult, error)
                return
            }
            UserRepository.saveValue(forKey: "userId", value: userId)
            fetchUser(userId: userId) { user, error in
                guard let profilePictureId = user?.profilePictureId else {
                    completion(authDataResult, error)
                    return
                }
                UserRepository.saveValue(forKey: "profilePictureId", value: profilePictureId)
                completion(authDataResult, error)
            }

        }
    }

    func createAuth(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        UserRepository.deleteValue(forKey: "profilePictureId")
        UserRepository.deleteValue(forKey: "userId")
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            guard let userId = authDataResult?.user.uid else {
                completion(authDataResult, error)
                return
            }
            UserRepository.saveValue(forKey: "userId", value: userId)
            completion(authDataResult, error)
        }
    }

    // MARK: - FirebaseCloudStorage

    private let storageRef = Storage.storage().reference()
    private static let imageMaxSize: Int64 = 1_000 * 1_024 * 1_024
    private let compressionQuality: CGFloat = 0.3

    /// Uploads compressed jpg image to Storage
    func uploadImage(image: Data, completion: @escaping (String?, Error?) -> Void) {
        let id = UUID().uuidString
        let uploadRef = getStorageRef(id)
        // compresses image for faster upload
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        uploadRef.putData(image, metadata: metaData) { _, error in
            if error != nil {
                completion(nil, error)
            } else {
                UserRepository.saveValue(forKey: "profilePictureId", value: id)
                completion(id, nil)
            }
        }
    }

    /// Retrieves Image data from Storage of a maximum size
    func fetchImage(name: String, completion: @escaping (Data?, Error?) -> Void) {
        let downloadRef = getStorageRef(name)
        downloadRef.getData(maxSize: FirebaseConnection.imageMaxSize) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
    }

    private func getStorageRef(_ fileName: String) -> StorageReference {
        storageRef.child("userImages/\(fileName).jpg")
    }

}

enum DatabaseError: Error {
    case noUserId
    case invalidUser
    case firebaseError
}

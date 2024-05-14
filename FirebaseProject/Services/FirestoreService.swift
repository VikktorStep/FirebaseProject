
import FirebaseFirestore

final class FirestoreService {
    // MARK: - Properties
    static let shared: FirestoreService = FirestoreService(); private init() { }
    
    private let db = Firestore.firestore()
    private var profiles: CollectionReference { db.collection("profiles") }
    private var questions: CollectionReference { db.collection("questions") }
    
    // MARK: - Profiles
    func createNew(profile: Profile) async throws {
        let path = profiles.document(profile.id)
        try await path.setData(profile.representation)
    }
    
    func getProfile(byId id: String) async throws -> Profile {
        let path = profiles.document(id)
        let snapshot = try await path.getDocument()
        guard let profile = Profile(snapshot: snapshot) else { throw FirestoreErrorCode(.dataLoss) }
        return profile
    }
    
    func getAllProfiles() async throws -> [Profile] {
        let snapshot = try await profiles.getDocuments()
        let docs = snapshot.documents
        let profiles = docs.compactMap { Profile(snapshot: $0) }
        
        for profile in profiles {
            let games = try await self.getGamesBy(userId: profile.id)
            profile.games = games
        }
        
        return profiles.sorted { first, last in
            let firstMoney = first.allMoney
            let lastMoney = last.allMoney
            return firstMoney > lastMoney
        }
    }

    // MARK: - Questions
    func getQuestions() async throws -> [Question] {
        let easySnapshot = questions.whereField("difficulty", isEqualTo: "easy")
        let mediumSnapshot = questions.whereField("difficulty", isEqualTo: "medium")
        let hardSnapshot = questions.whereField("difficulty", isEqualTo: "hard")
        
        let docsSnapshot = try await easySnapshot.getDocuments()
        _ = docsSnapshot.documents
        
        let easyQuestions = [Question]()
        let mediumQuestions = [Question]()
        let hardQuestions = [Question]()
        
        var arrayQusetions = [easyQuestions, mediumQuestions, hardQuestions]
        let snapshots = [easySnapshot, mediumSnapshot, hardSnapshot]
        
        for (index, snap) in snapshots.enumerated() {
            let docsSnapshot = try await snap.getDocuments()
            let docs = docsSnapshot.documents
            for doc in docs {
                if let question = Question(qsnap: doc) { arrayQusetions[index].append(question) }
            }
        }
        
        var questions = [Question]()
        
        for quesArr in arrayQusetions {
            var quesArr = quesArr
            quesArr.shuffle()
            if quesArr.count > 4 {
                for _ in 0...4 {
                    questions.append(quesArr.removeFirst())
                }
            }
        }
        
        return questions
    }
    
    func sendQuestions() {
        let questions = Question.questions
        for question in questions {
            let representation = question.representation
            self.questions.document(question.id).setData(representation)
        }
    }
    
    // MARK: - Games
    func createGame(_ game: Game, forUser userId: String) async throws {
        let path = createGamesPath(userId: userId).document(game.id)
        try await path.setData(game.representation)
    }
    
    func getGamesBy(userId: String) async throws -> [Game] {
        let path = createGamesPath(userId: userId)
        let querySnapshot = try await path.getDocuments()
        let docs = querySnapshot.documents
        let games = docs
            .compactMap { doc in
                return Game(queryDocumentSnapshot: doc)
            }
        
        return games
    }
    
    private func createGamesPath(userId: String) -> CollectionReference {
        return profiles.document(userId).collection("games")
    }
}

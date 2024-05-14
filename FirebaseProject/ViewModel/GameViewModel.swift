
import Foundation

final class GameViewModel: ObservableObject {
    @Published var profile: Profile
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex = 0
    @Published var bank = 0
    @Published var gameInProcess = true
    @Published var showFinishAlert = false
    @Published var finishAlertMessage = ""
    
    var questionPrice: Int {
        switch currentQuestionIndex {
        case 0...4: return 10_000
        case 5...9: return 30_000
        default: return 160_000
        }
    }
    
    var currentQuestion: Question? {
        guard !questions.isEmpty else { return nil }
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    init(profile: Profile) {
        self.profile = profile
        getData()
    }
    
    func getData() {
        Task {
            let questions = try await FirestoreService.shared.getQuestions()
            DispatchQueue.main.async {
                self.questions = questions
            }
        }
    }
    
    func checkAnswer(_ answer: String) {
        guard let currentQuestion else { return  }
        let res = answer == currentQuestion.correctAnswer
        switch res {
        case true:
            bank += questionPrice
            if currentQuestionIndex < 14 {
                currentQuestionIndex += 1
            } else {
                self.win()
            }
        case false:
            lose()
        }
    }
    
    func win() {
        let game = Game(questionNumber: 15, result: .win, money: self.bank)
        
        Task {
            try await FirestoreService.shared.createGame(game, forUser: profile.id)
            DispatchQueue.main.async {
                self.finishAlertMessage = "Поздравляю, Вы победили!\nВаш выигрыш \(self.bank) рублей"
                self.showFinishAlert = true
            }
        }
    }
    
    func lose() {
        let game = Game(questionNumber: self.currentQuestionIndex + 1, result: .lose, money: 0)
        
        Task {
            try await FirestoreService.shared.createGame(game, forUser: profile.id)
            DispatchQueue.main.async {
                self.finishAlertMessage = "Упс...\nОтвет неверный( Вы проиграли"
                self.showFinishAlert = true
            }
        }
    }
    
    func breakWithMoney() {
        let game = Game(questionNumber: self.currentQuestionIndex + 1, result: .quit, money: self.bank)
        
        Task {
            try await FirestoreService.shared.createGame(game, forUser: profile.id)
            DispatchQueue.main.async {
                self.finishAlertMessage = "Игра окончена!\nВаш выигрыш \(self.bank) рублей"
                self.showFinishAlert = true
            }
        }
    }
    
}

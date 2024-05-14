
import Foundation
import FirebaseFirestore

final class Question: Identifiable {
    var id = UUID().uuidString
    let text: String
    let correctAnswer: String
    let destructors: [String]
    let difficulty: Difficulty
    
    var answers: [String] {
        var answer = destructors
        answer.append(correctAnswer)
        return answer.shuffled()
    }
    
    init(text: String, correctAnswer: String, destructors: [String], difficulty: Difficulty) {
        self.text = text
        self.correctAnswer = correctAnswer
        self.destructors = destructors
        self.difficulty = difficulty
    }
    
    enum Difficulty: String {
        case easy, medium, hard
        
        init?(rawValue: String) {
            switch rawValue {
            case "easy": self = .easy
            case "medium": self = .medium
            case "hard": self = .hard
            default: return nil
            }
        }
    }
    
    init?(qsnap: QueryDocumentSnapshot) {
        let data = qsnap.data()
        guard let id = data["id"] as? String,
              let text = data["text"] as? String,
              let correctAnswer = data["correctAnswer"] as? String,
              let difficultyValue  = data["difficulty"] as? String,
              let destructors = data["destructors"] as? [String]
        else { return nil }
        
        guard let difficulty = Difficulty(rawValue: difficultyValue)
        else { return nil }
        
        self.id = id
        self.text = text
        self.correctAnswer = correctAnswer
        self.difficulty = difficulty
        self.destructors = destructors
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["text"] = self.text
        repres["correctAnswer"] = correctAnswer
        repres["destructors"] = destructors
        repres["difficulty"] = difficulty.rawValue
        return repres
    }
    
    static let questions: [Question] = [
        .init(
            text: "Как называется тип, когда значение может отсутствовать?",
            correctAnswer: "Optional",
            destructors: [
                "NIL",
                "NULL",
                "Пустое значение"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Как называется механизм подсчёта ссылок в Swift?",
            correctAnswer: "ARC",
            destructors: [
                "BMW",
                "NKVD",
                "KGB"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какой паттерн является основой реактивного программирования?",
            correctAnswer: "Наблюдатель",
            destructors: [
                "Делегат",
                "Строитель",
                "Простая фабрика"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какая планета является ближайшей к Солнцу?",
            correctAnswer: "Меркурий",
            destructors: [
                "Венера",
                "Марс",
                "Земля"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какой год объявлен Международным годом математики?",
            correctAnswer: "2022",
            destructors: [
                "2020",
                "2021",
                "2023"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Какая страна является родиной кенгуру?",
            correctAnswer: "Австралия",
            destructors: [
                "Южная Африка",
                "Бразилия",
                "Индонезия"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Кто написал роман 'Преступление и наказание'?",
            correctAnswer: "Фёдор Достоевский",
            destructors: [
                "Лев Толстой",
                "Александр Пушкин",
                "Иван Тургенев"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Какое химическое вещество обозначается символом 'H2O'?",
            correctAnswer: "Вода",
            destructors: [
                "Соляная кислота",
                "Этилен",
                "Углекислый газ"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какой океан самый большой по площади?",
            correctAnswer: "Тихий",
            destructors: [
                "Атлантический",
                "Индийский",
                "Северный Ледовитый"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какой металл является самым легким?",
            correctAnswer: "Литий",
            destructors: [
                "Магний",
                "Алюминий",
                "Марганец"
            ],
            difficulty: .hard
        ),
        .init(
            text: "Какой год был назван Международным годом Лесов?",
            correctAnswer: "2011",
            destructors: [
                "2008",
                "2010",
                "2012"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Какой фрукт является самым популярным в мире?",
            correctAnswer: "Помидор",
            destructors: [
                "Яблоко",
                "Банан",
                "Апельсин"
            ],
            difficulty: .hard
        ),
        .init(
            text: "Сколько костей в человеческом теле?",
            correctAnswer: "206",
            destructors: [
                "208",
                "210",
                "212"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Кто написал роман 'Война и мир'?",
            correctAnswer: "Лев Толстой",
            destructors: [
                "Фёдор Достоевский",
                "Александр Пушкин",
                "Иван Тургенев"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Какая самая высокая гора в мире?",
            correctAnswer: "Эверест",
            destructors: [
                "К2",
                "Канченджунга",
                "Макалу"
            ],
            difficulty:.hard
        ),
        .init(
            text: "Как называется процесс, в результате которого растения преобразуют солнечный свет в энергию?",
            correctAnswer: "Фотосинтез",
            destructors: [
                "Дыхание",
                "Транспирация",
                "Трансформация"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Какой химический элемент образует основную составляющую алмазов?",
            correctAnswer: "Углерод",
            destructors: [
                "Алмаз",
                "Азот",
                "Кислород"
            ],
            difficulty: .hard
        ),
        .init(
            text: "Сколько континентов на Земле?",
            correctAnswer: "7",
            destructors: [
                "5",
                "6",
                "8"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Кто написал 'Ромео и Джульетта'?",
            correctAnswer: "Уильям Шекспир",
            destructors: [
                "Джейн Остин",
                "Фёдор Достоевский",
                "Чарльз Диккенс"
            ],
            difficulty: .medium
        ),
        .init(
            text: "Какой химический элемент обозначается символом 'Fe'?",
            correctAnswer: "Железо",
            destructors: [
                "Фтор",
                "Фосфор",
                "Франций"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Как называется самая большая планета в Солнечной системе?",
            correctAnswer: "Юпитер",
            destructors: [
                "Сатурн",
                "Уран",
                "Нептун"
            ],
            difficulty: .medium
        ),
        .init(
            text: "В каком году состоялся первый полет человека в космос?",
            correctAnswer: "1961",
            destructors: [
                "1957",
                "1960",
                "1962"
            ],
            difficulty: .easy
        ),
        .init(
            text: "Кто изобрел телефон?",
            correctAnswer: "Александр Грэхам Белл",
            destructors: [
                "Томас Эдисон",
                "Никола Тесла",
                "Галилео Галилей"
            ],
            difficulty: .hard
        )
        
    ]
}

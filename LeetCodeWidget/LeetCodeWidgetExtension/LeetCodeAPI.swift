import Foundation

struct LeetCodeStats: Codable {
    struct Submission: Codable {
        let difficulty: String
        let count: Int
    }
    struct SubmitStats: Codable {
        let acSubmissionNum: [Submission]
    }
    let submitStats: SubmitStats
}

class LeetCodeAPI {
    static func fetchStats(completion: @escaping (LeetCodeStats?) -> Void) {
        let username = "meathul"  // Change this to your LeetCode username
        let url = URL(string: "https://leetcode.com/graphql")!
        let query = """
        {
          matchedUser(username: "\(username)") {
            submitStats {
              acSubmissionNum {
                difficulty
                count
              }
            }
          }
        }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["query": query])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let stats = try? JSONDecoder().decode(LeetCodeStats.self, from: data)
                DispatchQueue.main.async {
                    completion(stats)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}


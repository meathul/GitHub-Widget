import WidgetKit
import SwiftUI

struct LeetCodeEntry: TimelineEntry {
    let date: Date
    let stats: LeetCodeStats?
}

struct LeetCodeProvider: TimelineProvider {
    func placeholder(in context: Context) -> LeetCodeEntry {
        LeetCodeEntry(date: Date(), stats: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (LeetCodeEntry) -> Void) {
        LeetCodeAPI.fetchStats { stats in
            let entry = LeetCodeEntry(date: Date(), stats: stats)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LeetCodeEntry>) -> Void) {
        LeetCodeAPI.fetchStats { stats in
            let entry = LeetCodeEntry(date: Date(), stats: stats)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LeetCodeWidgetEntryView: View {
    var entry: LeetCodeProvider.Entry

    var body: some View {
        VStack {
            Text("LeetCode Stats")
                .font(.headline)
            if let stats = entry.stats {
                Text("Easy: \(stats.submitStats.acSubmissionNum[0].count)")
                Text("Medium: \(stats.submitStats.acSubmissionNum[1].count)")
                Text("Hard: \(stats.submitStats.acSubmissionNum[2].count)")
            } else {
                Text("Loading...")
            }
        }
        .padding()
    }
}

struct LeetCodeWidget: Widget {
    let kind: String = "LeetCodeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LeetCodeProvider()) { entry in
            LeetCodeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("LeetCode Progress")
        .description("Track your LeetCode solved problems.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


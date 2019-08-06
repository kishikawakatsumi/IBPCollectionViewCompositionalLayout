/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Sample news feed controller object.
*/

import UIKit

class ConferenceNewsController: NSObject {

    struct NewsFeedItem: Hashable {
        let title: String
        let date: Date
        let body: String
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        init(title: String, date: DateComponents, body: String) {
            self.title = title
            self.date = DateComponents(calendar: Calendar.current,
                                       year: date.year,
                                       month: date.month,
                                       day: date.day).date!
            self.body = body
        }
    }

    lazy var items: [NewsFeedItem] = {
       return itemsInternal()
    }()
}

extension ConferenceNewsController {
    func itemsInternal() -> [NewsFeedItem] {
        return [ NewsFeedItem(title: "Conference 2019 Registration Now Open",
                              date: DateComponents(year: 2019, month: 3, day: 14), body: """
                    Register by Wednesday, March 20, 2019 at 5:00PM PSD for your chance to join us and thousands
                    of coders, creators, and crazy ones at this year's Conference 19 in San Jose, June 3-7.
                    """),
                 NewsFeedItem(title: "Apply for a Conference19 Scholarship",
                              date: DateComponents(year: 2019, month: 3, day: 14), body: """
                    Conference Scholarships reward talented studens and STEM orgination members with the opportunity
                    to attend this year's conference. Apply by Sunday, March 24, 2019 at 5:00PM PDT
                    """),
                 NewsFeedItem(title: "Conference18 Video Subtitles Now in More Languages",
                              date: DateComponents(year: 2019, month: 8, day: 8), body: """
                    All of this year's session videos are now available with Japanese and Simplified Chinese subtitles.
                    Watch in the Videos tab or on the Apple Developer website.
                    """),
                 NewsFeedItem(title: "Lunchtime Inspiration",
                              date: DateComponents(year: 2019, month: 6, day: 8), body: """
                    All of this year's session videos are now available with Japanese and Simplified Chinease subtitles.
                    Watch in the Videos tab or on the Apple Developer website.
                    """),
                 NewsFeedItem(title: "Close Your Rings Challenge",
                              date: DateComponents(year: 2019, month: 6, day: 8), body: """
                    Congratulations to all Close Your Rings Challenge participants for staying active
                    throughout the week! Everyone who participated in the challenge can pick up a
                    special reward pin outside on the Plaza until 5:00 p.m.
                    """)
        ]
    }
}

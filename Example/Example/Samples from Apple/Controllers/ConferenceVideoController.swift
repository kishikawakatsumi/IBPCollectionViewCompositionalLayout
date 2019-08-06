/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Controller object that manages the videos and video collection for the sample app
*/

import Foundation

class ConferenceVideoController {

    struct Video: Hashable {
        let title: String
        let category: String
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct VideoCollection: Hashable {
        let title: String
        let videos: [Video]

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    var collections: [VideoCollection] {
        return _collections
    }

    init() {
        generateCollections()
    }
    fileprivate var _collections = [VideoCollection]()
}

extension ConferenceVideoController {
    func generateCollections() {
        _collections = [
            VideoCollection(title: "The New iPad Pro",
                            videos: [Video(title: "Bringing Your Apps to the New iPad Pro", category: "Tech Talks"),
                                     Video(title: "Designing for iPad Pro and Apple Pencil", category: "Tech Talks")]),

            VideoCollection(title: "iPhone and Apple Watch",
                            videos: [Video(title: "Building Apps for iPhone XS, iPhone XS Max, and iPhone XR",
                                            category: "Tech Talks"),
                                      Video(title: "Designing for Apple Watch Series 4",
                                            category: "Tech Talks"),
                                      Video(title: "Developing Complications for Apple Watch Series 4",
                                            category: "Tech Talks"),
                                      Video(title: "What's New in Core NFC",
                                            category: "Tech Talks")]),

            VideoCollection(title: "App Store Connect",
                            videos: [Video(title: "App Store Connect Basics", category: "App Store Connect"),
                                      Video(title: "App Analytics Retention", category: "App Store Connect"),
                                      Video(title: "App Analytics Metrics", category: "App Store Connect"),
                                      Video(title: "App Analytics Overview", category: "App Store Connect"),
                                      Video(title: "TestFlight", category: "App Store Connect")]),

            VideoCollection(title: "Apps on Your Wrist",
                            videos: [Video(title: "What's new in watchOS", category: "Conference 2018"),
                                      Video(title: "Updating for Apple Watch Series 3", category: "Tech Talks"),
                                      Video(title: "Planning a Great Apple Watch Experience",
                                            category: "Conference 2017"),
                                      Video(title: "News Ways to Work with Workouts", category: "Conference 2018"),
                                      Video(title: "Siri Shortcuts on the Siri Watch Face",
                                            category: "Conference 2018"),
                                      Video(title: "Creating Audio Apps for watchOS", category: "Conference 2018"),
                                      Video(title: "Designing Notifications", category: "Conference 2018")]),

            VideoCollection(title: "Speaking with Siri",
                            videos: [Video(title: "Introduction to Siri Shortcuts", category: "Conference 2018"),
                                     Video(title: "Building for Voice with Siri Shortcuts",
                                           category: "Conference 2018"),
                                     Video(title: "What's New in SiriKit", category: "Conference 2017"),
                                     Video(title: "Making Great SiriKit Experiences", category: "Conference 2017"),
                                     Video(title: "Increase Usage of You App With Proactive Suggestions",
                                           category: "Conference 2018")])
        ]
    }
}

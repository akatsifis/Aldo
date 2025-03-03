//
//  CourseSearchview.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//
import SwiftUI

struct CourseSearchView: View {
    @Binding var selectedCourse: GolfCourse?

    let courses = [
        GolfCourse(id: 1, name: "Armitage Golf Club", par: 70),
        GolfCourse(id: 2, name: "Rich Valley Golf", par: 72), // Par value not specified in available sources
        GolfCourse(id: 3, name: "Dauphin Highlands Golf Course", par: 72),
        GolfCourse(id: 4, name: "Cumberland Golf Club", par: 72), // Par value not specified in available sources
        GolfCourse(id: 5, name: "Mayapple Golf Club", par: 72), // Par value not specified in available sources
        GolfCourse(id: 6, name: "Carlisle Country Club", par: 72), // Par value not specified in available sources
        GolfCourse(id: 7, name: "West Shore Country Club", par: 72), // Par value not specified in available sources
        GolfCourse(id: 8, name: "Walnut Lane Golf Club", par: 62), // Par value not specified in available sources
        GolfCourse(id: 9, name: "RiverWinds Golf & Tennis Club", par: 72), // Par value not specified in available sources
        GolfCourse(id: 10, name: "Reading Country Club", par: 71) // Par value not specified in available sources
    ]

    var body: some View {
        List(courses) { course in
            Button(action: {
                selectedCourse = course
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .font(.title2)
                            .bold()
                        Text("Par \(course.par)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Select a Course")
    }
}

struct CourseSearchView_Previews: PreviewProvider {
    @State static var previewSelectedCourse: GolfCourse? = nil
    static var previews: some View {
        CourseSearchView(selectedCourse: $previewSelectedCourse)
    }
}

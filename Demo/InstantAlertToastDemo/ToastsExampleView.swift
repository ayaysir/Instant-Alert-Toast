//
//  ToastsExampleView.swift
//  InstantAlertToastDemo
//
//  Created by 윤범태 on 3/4/26.
//

import SwiftUI
import InstantAlertToast

// MARK: - Main
struct ToastsExampleView: View {
  @State private var status = "[status]"
  
  var body: some View {
    VStack {
      Text(verbatim: status)
      Divider()
      
      Button("Toast 1: small") {
        Instant.showSmallToast("Loading", subtitle: "Fetching data...", icon: .spinnerSmall)
      }
      
      Button("Toast 2: small without icon") {
        Instant.showSmallToast("Deleted", subtitle: nil, icon: nil, dismissByTap: false, duration: 3)
        
      }
      
      Button("Toast 3: medium") {
        Instant.showMediumToast("Deleted", subtitle: "Medium size", icon: .heart, dismissByTap: true)
      }
      
      Button("Toast 4: medium without icon") {
        Instant.showMediumToast("Deleted", subtitle: "Medium size", icon: nil, dismissByTap: true)
      }
      
      Button("Toast 5: medium with options") {
        Instant.showMediumToast(
          "Loading",
          subtitle: "Fetching data...",
          icon: .custom(UIImage(systemName: "trash")!),
          dismissByTap: true,
          dismissInTime: true,
          duration: 2,
          haptic: .success) {
            print("[5] Present Handler")
          }
      }
      
      Button("Toast 6: special toast with custom icon") {
        Instant.showSmallToastWithButton(
          "Loading",
          subtitle: "Fetching data...",
          icon: .custom(UIImage(systemName: "trash")!),
          dismissByTap: true,
          dismissInTime: true,
          duration: 2,
          haptic: .success) {
            print("[6] Present Handler")
          } actionButtonHandler: { dismiss in
            status = "[toast 6] action button tapped"
            dismiss()
          }
      }
      
      Button("Toast 7: special toast without icon") {
        Instant.showSmallToastWithButton("Deleted.", actionButtonHandler:  { dismiss in
          status = "[toast 7] action button tapped (\(Int.random(in: 100...999)))"
          // without dismiss
        })
      }
      
      Button("Toast 8: special toast with changed button title, calling another toast") {
        Instant.showSmallToastWithButton(
          "Chat deleted",
          icon: .done,
          actionButtonTitle: "Mute",
          actionButtonHandler:  { dismiss in
          status = "[toast 8] action button tapped"
            dismiss()
            Instant.showSmallToast("Muted", duration: 0.8)
        })
      }
      
      Spacer()
    }
    .padding()
  }
}


// MARK: - #Preview
#Preview {
  ToastsExampleView()
}

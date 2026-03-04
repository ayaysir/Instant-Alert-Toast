//
//  ToastsExampleView.swift
//  InstantAlertToastDemo
//
//  Created by 윤범태 on 3/4/26.
//

import SwiftUI
import InstantAlertToast

// MARK: - Main
struct ToastExampleView: View {
  var body: some View {
    VStack {
      Button("toast 1") {
        Instant.showSmallToast("로딩 중", subtitle: "데이터를 가져오는 중...", icon: .spinnerSmall)
      }
      Button("toast 2") {
        Instant.showSmallToast("삭제되었습니다", subtitle: nil, icon: .heart, dismissByTap: false, duration: 3)
        
      }
      Button("toast 3") {
        Instant.showMediumToast("삭제되었습니다", subtitle: "중간 크기", icon: .heart, dismissByTap: true)
        
      }
      Button("toast 4") {
        Instant.showMediumToast(
          "로딩 중",
          subtitle: "데이터를 가져오는 중입니다...",
          icon: .custom(UIImage(systemName: "trash")!),
          dismissByTap: true,
          dismissInTime: true,
          duration: 2,
          haptic: .success) {
            print("dkd")
          }
      }
      
      Spacer()
    }
  }
}


// MARK: - #Preview
#Preview {
  ToastExampleView()
}

//
//  AlertsExampleView.swift
//  InstantAlertToastDemo
//
//  Created by 윤범태 on 3/3/26.
//

import SwiftUI
import InstantAlertToast

struct AlertsExampleView: View {
  @State private var status = "[status]"
  
  var body: some View {
    VStack {
      Text(verbatim: status)
      
      Divider()
      
      Button("[1] Simple Alert") {
        Instant.showSimpleAlert("Simple Alert Title", message: "Press OK")
      }
      
      Button("[2] Confirmation Alert") {
        Instant.showConfirmAlert("Confirmation Alert Title") { _ in
          status = "[2] Confirmed"
        }
      }
      
      Button("[3] Confirmation Alert With Cancel Handler") {
        Instant.showConfirmAlert("Confirmation Alert Title") {
          status = "[3] Alert Presented"
        } cancelHandler: { _ in
          status = "[3] Cancelled"
        } confirmHandler: { _ in
          status = "[3] Confirmed"
        }
      }
      
      Button("[4] Destructive Confirmation Alert") {
        Instant.showConfirmAlert("Confirmation Alert Title", isDestructiveConfirm: true) { _ in
          status = "[4] Confirmed"
        }
      }
      
      
      Button("[5] Alert with Multiple Actions") {
        Instant.showAlertWithMultipleActions(
          "Multiple Actions", message: "Select an option") {
          [
            .init(title: "Cancel", style: .cancel),
            .init(title: "Choice 1", style: .default, handler: { _ in
              status = "[5] Choice 1 Selected"
            }),
            .init(title: "Choice 2", style: .default, handler: { _ in
              status = "[5] Choice 2 Selected"
            }),
            .init(title: "Choice 3", style: .destructive, handler: { _ in
              status = "[5] Choice 3 Selected"
            })
          ]
        }
      }
      Spacer()
    }
    .padding()
    .onAppear {
      Instant.configuration.alertOkText = "알겠습니다(OK)"
      Instant.configuration.alertConfirmText = "확인(Confirm)"
      Instant.configuration.alertCancelText = "취소(Cancel)"
    }
  }
}

#Preview {
  AlertsExampleView()
}

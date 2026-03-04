//
//  InstantAlertToastDemoApp.swift
//  InstantAlertToastDemo
//
//  Created by 윤범태 on 3/3/26.
//

import SwiftUI

@main
struct InstantAlertToastDemoApp: App {
  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
  }
}

struct MainTabView: View {
  var body: some View {
    TabView {
      AlertsExampleView()
        .tabItem {
          Label("Alert", systemImage: "play")
        }
      ToastsExampleView()
        .tabItem {
          Label("Toast", systemImage: "play")
        }
    }
  }
}

#Preview {
  MainTabView()
}

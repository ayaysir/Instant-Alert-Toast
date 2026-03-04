# InstantAlertToast

InstantAlertToast is a lightweight Swift Package that allows you to easily present **Alerts and Toasts** from both **UIKit** and **SwiftUI**.

It is designed to minimize boilerplate and let you trigger common alert and toast patterns with a single line of code.

---

## Overview

With InstantAlertToast, you can:

- Present simple alerts and toasts with one line
- Use it seamlessly in both UIKit and SwiftUI projects

---

## Who Is This For?

This package is especially useful for:

- Small to medium-sized apps
- Rapid prototyping projects
- Apps where you want to handle alerts and toasts quickly without repetitive `UIAlertController` boilerplate

If you want fast, clean alert/toast handling without building your own manager layer, this package is for you.

---

## Installation (Swift Package Manager)

### 1. In Xcode

1. Open your project.
2. Go to **File → Add Packages…**
3. Enter `https://github.com/ayaysir/Instant-Alert-Toast.git`.
4. Choose the desired version.
5. Add the package to your target.

### 2. Package.swift (Manual)

```swift
dependencies: [
  .package(url: "https://github.com/ayaysir/Instant-Alert-Toast.git", from: "1.0.0")
]
```

Then add:

```swift
.target(
  name: "InstantAlertToast",
  dependencies: ["InstantAlertToast"]
)
```

---

## Alerts Usage (SwiftUI Example)

```swift
import SwiftUI
import InstantAlertToast
```

### 1. Simple Alert

```swift
Instant.showSimpleAlert("Simple Alert Title", message: "Press OK")
```

### 2. Confirmation Alert

```swift
Instant.showConfirmAlert("Confirmation Alert Title") { _ in
  print("Confirmed")
}
```

### 3. Destructive Confirmation

```swift
Instant.showConfirmAlert(
  "Delete Item?",
  isDestructiveConfirm: true
) { _ in
  print("Deleted")
}
```

### 4. Alert with Multiple Actions

```swift
Instant.showAlertWithMultipleActions(
  "Multiple Actions",
  message: "Select an option"
) {
  [
    .init(title: "Cancel", style: .cancel),
    .init(title: "Choice 1", style: .default),
    .init(title: "Choice 2", style: .default),
    .init(title: "Choice 3", style: .destructive)
  ]
}
```

### Global Text Configuration

You can globally customize default button titles:

```swift
Instant.configuration.alertOkText = "OK"
Instant.configuration.alertConfirmText = "Confirm"
Instant.configuration.alertCancelText = "Cancel"
```

---

## Toast Usage (SwiftUI Example)

### 1. Small Toast

```swift
Instant.showSmallToast(
  "Loading",
  subtitle: "Fetching data...",
  icon: .spinnerSmall
)
```

### 2. Medium Toast

```swift
Instant.showMediumToast(
  "Deleted",
  subtitle: "Medium size",
  icon: .heart
)
```

### 3. Small Toast with Action Button

```swift
Instant.showSmallToastWithButton(
  "Loading",
  subtitle: "Fetching data..."
) { dismiss in
  print("Button tapped")
  dismiss()
}
```

---

## Demo App

For full usage examples and advanced configuration,  
please refer to the included **Demo App** in the repository.

The demo project contains complete examples for:

- All alert variations
- Toast variations (small, medium, with button)
- Custom icons
- Haptic configurations
- Callback handling

---

## Used 3rd-party Libraries
- [AlertKit](https://github.com/sparrowcode/AlertKit) - Manually imported, no dependencies, MIT Licenses

---

## License

MIT License

---

If you find this package helpful, consider starring the repository ⭐

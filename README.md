# 🎞️ Animated Series Ryuu App

## 📌 Overview

Ryuu animated series app. It allows users to:

- Browse a list of episodes (some available, some "coming soon")
- Tap into an available episode to experience vertically scrolling video scenes
- Enjoy seamless video transitions and playback akin to TikTok or Instagram Reels

---

## 📱 Features

### ✅ Episode Selection Screen

- **Vertically scrollable list** of episodes
- Each row displays:
  - Episode thumbnail
  - Title
  - Status (`NEW` for available episodes, `SOON` for upcoming)
- Episodes are ordered with the **most recent available at the bottom**
- Tap on an available episode to enter the vertical scene experience

### ✅ Vertical Scroll Scene Experience (Core Focus)

- **Smooth, gesture-based vertical scrolling** through video scenes
- **Only the current scene/video plays**, others are paused
- **Video playback is paused during scrolling** and resumes only once the new scene is fully visible
- Responsive and fluid **gesture handling with momentum**
- Tap the screen to **toggle play/pause** for the current scene
- Designed for a **Reels-like tactile UX**

---

## ⚙️ Preloading & Prefetching

- Videos are preloaded using `AVPlayer` instances before they are shown
- **Next and previous videos** (within a buffer of 1–2 scenes) are **preloaded in advance**
- We preload using:
  ```swift
  func preloadVideo(url: String) {
      let player = getPlayer(for: url)
      player.currentItem?.preferredForwardBufferDuration = 5.0
      player.automaticallyWaitsToMinimizeStalling = false
  }

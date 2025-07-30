# Pacman-Assembly-Game

# 🟡 PAC-MAN Game in Assembly 

A classic 3-level Pac-Man game fully developed in **x86 Assembly language ** using **MASM615** and the **Irvine32 library**. This project demonstrates game logic, graphics via console manipulation, sound effects, and file handling — all done in low-level Assembly.

---

## 🕹️ Gameplay Overview

- 👻 Three levels of increasing difficulty with smarter ghost AI
- 🟨 Player (Pac-Man) collects dots and fruits while avoiding ghosts
- 🔄 Teleportation paths, power pellets, and bonus items on higher levels
- 🎵 Sound integration with `Game_startmusic.wav`
- 🧠 AI ghost behavior changes based on level (e.g. chase, ambush, boss ghost)

---
## ⚙️ How to Run the Game

1. 🔧 Install **MASM615** and ensure Irvine32 is properly set up  
2. Open `Pacman.asm` in Visual Studio (MASM template)  
3. Build and Run  
4. Make sure `Game_startmusic.wav` is in the same folder as the `.exe`  

✅ Screen Size: `640x480`  
✅ Compatible with: **Windows 32-bit environments**

---

## 🎮 Controls

| Key        | Action               |
|------------|----------------------|
| `Y`        | Move Up              |
| `H`        | Move Down            |
| `G`        | Move Left            |
| `J`        | Move Right           |
| `P`        | Pause Game           |
| `R`        | Resume Game          |
| `M`        | Return to Main Menu  |
| `I`        | Show Instructions    |
| `E`        | Exit Game            |

---

## 💡 Features

- ✅ Multiple levels with increasing difficulty and ghost speed
- ✅ File handling: save player name and score
- ✅ Sound playback using `PlaySound` (Winmm.lib)
- ✅ Colored text and console UI
- ✅ AI Ghost Movement (Level 2 & 3)
- ✅ Life system & scoring
- ✅ Maze design inspired by roll number pattern

---


<div align="center">

```
 ██████╗██╗     ██╗███████╗███╗   ██╗████████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║       ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║       ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
╚██████╗███████╗██║███████╗██║ ╚████║   ██║       ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
 ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
```

**free roblox scripts — use them, enjoy them, don't be weird about it**

![Scripts](https://img.shields.io/badge/scripts-1-blueviolet?style=flat-square)
![Language](https://img.shields.io/badge/language-Luau-blue?style=flat-square&logo=lua)
![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/license-free-9B59B6?style=flat-square)

</div>

---

## ✦ About

A collection of free Roblox scripts — hubs, utilities, and trolling tools — all built for executor injection. Everything here is free, no paywalls, no Discord nitro gating, no bs.

New scripts get added over time. Each one has its own section below with features, install instructions, and keybinds.

---

## ✦ Scripts

<details>
<summary><b>🟣 VESP Hub</b> — <i>Lavender & Black Troll/Utility Hub</i></summary>

<br/>

```
██╗   ██╗███████╗███████╗██████╗ 
██║   ██║██╔════╝██╔════╝██╔══██╗
██║   ██║█████╗  ███████╗██████╔╝
╚██╗ ██╔╝██╔══╝  ╚════██║██╔═══╝ 
 ╚████╔╝ ███████╗███████║██║     
  ╚═══╝  ╚══════╝╚══════╝╚═╝     
```

> A sleek lavender & black hub. Tracers, 3D boxes, aimbot, and more to come. Drag the window, bind your keys, go cook.

---

### ⚡ Install

```lua
-- paste into your executor and run
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/vesp-hub.lua"))()
```

Or load the file directly through your executor's file loader.

---

### 🎯 Features

#### Combat
| Feature | Description |
|---|---|
| **Aimbot** | Hold RMB to lock onto the nearest player's HumanoidRootPart |
| **Aim Smoothing** | Lerp-based — silky, not snappy |
| **FOV Circle** | Visual ring showing detection radius *(coming soon)* |

#### Visuals
| Feature | Description |
|---|---|
| **ESP** | See all players through walls |
| **Tracers** | Lines from screen bottom-center to each player |
| **3D Boxes** | Full 3D bounding box rendered around each player's hitbox |
| **Tracer Color** | Hue / Saturation / Brightness color picker |
| **Box Color** | Independent color picker for boxes |

---

### ⌨️ Keybinds

| Action | Bind |
|---|---|
| Show / Hide UI | `Right Alt` |
| Aimbot (hold) | `Right Mouse Button` |

---

### 🛠️ Compatibility

| Executor | Status |
|---|---|
| Xeno | ✅ |
| Wave | ✅ |
| Solara | ✅ |
| Any executor with `Drawing` API | ✅ |

---

### 📋 Notes

- UI is injected into `CoreGui` — persists through respawns
- `Drawing` API is required for ESP/tracers — all major executors support it
- Aimbot is client-side only; the camera lerps toward the target while RMB is held
- More features (Trigger Bot, Name Tags, Speed, Fly, etc.) coming in future updates

---

</details>

---

## ✦ General Notes

- All scripts are **client-side** — they do not bypass server-sided anti-cheats
- Features that modify movement, health, etc. are local unless the game is unfiltered
- Use at your own risk — I'm not responsible for bans
- Feel free to fork, modify, or use pieces in your own scripts

---

## ✦ Roadmap

- [x] VESP Hub v1 — ESP, Tracers, 3D Boxes, Aimbot, Trigger Bot, Name Tags, Speed, Fly, Noclip
- [ ] FUSION Hub v1 - Insane client side exploits, macros
- [ ] Second script (TBD)

---

<div align="center">

made for fun · kept free · built different

![Made with Lua](https://img.shields.io/badge/made%20with-Luau-blueviolet?style=flat-square&logo=lua)

</div>

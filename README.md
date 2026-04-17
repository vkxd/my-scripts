<detials>
<div align="center">

<br/>

```
██╗   ██╗███████╗███████╗██████╗     ██╗  ██╗██╗   ██╗██████╗ 
██║   ██║██╔════╝██╔════╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
██║   ██║█████╗  ███████╗██████╔╝    ███████║██║   ██║██████╔╝
╚██╗ ██╔╝██╔══╝  ╚════██║██╔═══╝     ██╔══██║██║   ██║██╔══██╗
 ╚████╔╝ ███████╗███████║██║         ██║  ██║╚██████╔╝██████╔╝
  ╚═══╝  ╚══════╝╚══════╝╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
```

**A feature-rich Roblox troll/utility script hub**

![Version](https://img.shields.io/badge/version-v3.0-blueviolet?style=flat-square&logo=roblox)
![Lua](https://img.shields.io/badge/language-Lua-blue?style=flat-square&logo=lua)
![Game](https://img.shields.io/badge/game-Arsenal%20%2F%20FPS-orange?style=flat-square)
![Status](https://img.shields.io/badge/status-active-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/license-private-red?style=flat-square)

</div>

---

## ✦ Overview

**VESP Hub** is a gamepass-gated troll/utility script for Arsenal-based Roblox shooters. It features a sleek, dark-themed UI with real-time notifications, animated tab switching, hover effects, and a comprehensive keybind system — all injected into `CoreGui` for persistence.

---

## ✦ Features

### 🎯 Combat
| Feature | Description |
|---|---|
| **Aimbot** | Locks onto the nearest enemy head within FOV range |
| **Aim Smoothing** | Adjustable 1–100% lerp speed — from instant snap to silky smooth |
| **FOV Circle** | Visual circle showing your current aimbot detection radius |
| **Trigger Bot** | Automatically clicks when your crosshair is over an enemy |
| **Big Head** | Expands enemy head hitboxes for easier kills |

### 👁️ Visuals
| Feature | Description |
|---|---|
| **ESP Chams** | Highlight all enemies through walls with theme color |
| **Tracers** | Draws lines from screen center to all visible enemies |
| **Name Tags** | Billboard name + color-coded HP bars above enemy heads |
| **Fullbright** | Removes fog and shadows, maximizes world brightness |

### 🏃 Movement
| Feature | Description |
|---|---|
| **Speed Boost** | Toggle boosted WalkSpeed — resets to game's original on disable |
| **Jump Boost** | Toggle boosted JumpPower — resets to game's original on disable |
| **Fly** | Full WASD + Space/Shift 6DoF flight |
| **Noclip** | Walk through any solid geometry |
| **No Fall Damage** | Disables ragdoll and fall death states |
| **Low Gravity** | Halves workspace gravity for floaty movement |

### 🧍 Player
| Feature | Description |
|---|---|
| **God Mode** | Attempts ForceField + MaxHealth loop + local script disabling |
| **Invisible** | Makes your entire character transparent to others |
| **Anti-AFK** | Sends periodic inputs to prevent auto-kick |
| **Chat Spam** | Sends a custom message repeatedly in all chat |
| **Respawn** | Instantly breaks your character joints to force respawn |
| **Server Hop** | Finds and teleports to a new public server |
| **Rejoin** | Quickly rejoins your current place |
| **Infinite Yield** | One-click loader for the Infinite Yield admin script |

---

## ✦ UI Highlights

- **Dark glassmorphic theme** with `#B482FF` accent color
- **5-tab layout** — Combat / Visuals / Move / Player / Config
- **Toast notifications** — pop up bottom-right when toggling features
- **Active feature counter** — live count in the header
- **Animated tab indicators** with smooth transitions
- **Hover glow effects** on every interactive element
- **Draggable window** — click and drag the header
- **Hide toggle** — `Left Alt` smoothly collapses the window

---

## ✦ Keybind System

Every feature has an assignable keybind in the **Config** tab.

1. Open the **Config** tab
2. Click the `—` button next to any feature
3. Press any key or mouse button to assign it
4. Press `Escape` or `Backspace` to clear the bind
5. Your assigned key will **toggle** that feature on/off in real-time

The **Aimbot hold key** is separate — it works as a hold-to-activate, not a toggle.

---

## ✦ Installation

### Method 1 — Direct Execute
Paste the script into your Roblox executor and run it:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/vkxd/my-scripts/refs/heads/main/vesp-hub.lua"))()
```

### Method 2 — Local File
Save `vesp-hub.lua` and execute it directly through your executor's file loader.

---

## ✦ Keybinds (Defaults)

| Action | Default Bind |
|---|---|
| Hide / Show UI | `Left Alt` |
| Aimbot Hold | `Right Mouse Button` |
| All others | Unbound (set in Config) |

---

## ✦ Notes on God Mode

> Arsenal and Arsenal-based games process **all damage server-side**. Health is changed by the server and replicated to the client — which means no client-side script can truly prevent incoming damage.

VESP Hub uses three simultaneous methods to minimize death chance:

1. `MaxHealth = math.huge` + `Health = math.huge` loop
2. Invisible `ForceField` parented to your character
3. Attempts to disable local damage scripts

**Recommended strategy:** Combine Aimbot + Trigger Bot + Big Head to eliminate enemies before they can kill you.

---

## ✦ Compatibility

| Game Type | Compatibility |
|---|---|
| Arsenal / Arsenal forks | ✅ Supported | ⚠️ Some features limited |
| Standard Roblox FPS | ✅ Supported |
| Server-sided anti-cheat games | ⚠️ Some features limited |
| Filtering Enabled games | ✅ Client-side features work |

---

## ✦ Tech Stack

- **Language:** Lua (Roblox Luau)
- **Rendering:** `RunService.RenderStepped` for frame-perfect loops
- **Drawing:** Roblox `Drawing` API for tracers & FOV circle
- **UI:** `CoreGui` injection with `TweenService` animations
- **Input:** `UserInputService` for all keybind and drag logic

---

<div align="center">

**VESP Hub** — *built for those who already won*

![Made with Lua](https://img.shields.io/badge/made%20with-Lua-blue?style=flat-square&logo=lua)

</div>

</detials>

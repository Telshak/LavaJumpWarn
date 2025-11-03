README — LavaJumpWarn (WoW Classic 1.12)
Project summary
LavaJumpWarn is a small World of Warcraft Classic (1.12) addon that displays a progress bar when your character receives the "swimming in lava" combat message. 
It supports repeating cycles (automatic restarts), a visible jump window region, and a simple slash-command interface for manual testing and control.

Features
- Visual status bar with spark and jump-window highlight
- Cycle support (start with N cycles, automatically restarts until exhausted)
- Slash command to start, set cycles, or stop (/jumpbar)
- Works with Classic WoW / Lua constraints (safe string handling, chat escaping)
- Small, dependency-free single-file addon (drop into AddOns folder)

Installation
- Place this folder into your Addons directory or manually create a folder named LavaJumpBar inside your AddOns directory (e.g., World of Warcraft/Interface/AddOns/LavaJumpWarn).
- Put LavaJumpWarn.lua and LavaJumpWarn.toc into that folder.
- Restart the client if it's active.

API / exposed functions
- JumpBar_Reset() — global helper to stop and hide the bar (for macros).

Slash commands
- /jumpbar
- No argument or "show": start default 3 cycles.
- /jumpbar N: start with N cycles (e.g., /jumpbar 5).
- /jumpbar stop or /jumpbar reset: stop and hide the bar.
Notes:
- Help text prints in chat.

Example usage
- Manual start with default cycles:
- Type /jumpbar in chat.
- Start with 5 cycles:
- Type /jumpbar 5
- Stop:
- Type /jumpbar stop or /jumpbar reset
- Macro example to reset:
- /run JumpBar_Reset()

Configuration ideas (future)
- Saved variables for position, scale, colors, duration, cycles default.
- Small options panel (Ace or custom) for non-dev users.
- Sound cue and subtle flash on cycle boundaries.
- Locale-aware (other languages) message matching (capture real combat string across clients).

Troubleshooting
- Nothing shows on /jumpbar:
- Check the file loaded (look for Lua errors on reload).
- Ensure JumpBar.frame exists and isn’t accidentally hidden by another addon.

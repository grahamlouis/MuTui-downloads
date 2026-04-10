# MuTui — Terminal DAW Manual

MuTui is a terminal-based Digital Audio Workstation inspired by the Teenage Engineering OP-1. It combines a 4-track tape recorder, dual sound engines (Synth and Drum), pattern sequencers, and a mixer with master effects — all controllable via keyboard shortcuts in a text-based interface.

---

## 1. Getting Started

### Running the App
```bash
cargo run --release
```

### Interface Overview
The TUI displays:
- **Header**: Current mode, BPM, transport status
- **Main Area**: Active view (Synth/Drum/Tape/Mixer)
- **Footer**: Context-sensitive key hints
- **Meters**: Real-time stereo level meters

### Color-Coded Parameters
MuTui uses OP-1 style color encoding:
- **Blue**: Core parameters, track selection
- **Green**: Navigation, lift/drop operations
- **White**: Value adjustment, standard controls
- **Orange**: Output levels, modifier functions
- **Purple**: Sequencer operations, storage

---

## 2. Mode Switching

| Key | Mode | Description |
|-----|------|-------------|
| `1` | Tape | 4-track tape recorder with editing |
| `2` | Synth | Synthesizer with engine/ENV/FX/LFO pages |
| `3` | Drum | Drum sampler with 4 pads and FX |
| `4` | Mixer | 4-channel mixer with EQ and master FX |

### Global Controls
| Key | Action |
|-----|--------|
| `Tab` | Toggle help overlay |
| `\` | Open tempo/BPM editor |
| `|` | Open album export view |
| `Esc` | Close dialogs / Quit |

---

## 3. Synth Mode (`2`)

Synth mode provides a polyphonic synthesizer with selectable engines, ADSR envelope, insert effects, and LFO modulation.

### Sub-Pages (F1–F4)
| Key | Page | Controls |
|-----|------|----------|
| `F1` | Engine | Select synth engine type |
| `F2` | Envelope | ADSR amplitude envelope |
| `F3` | FX | Insert effect selection |
| `F4` | LFO | Low-frequency oscillator |

### Engine Selection (`Shift+F1`)
Press `Shift+F1` to open the engine selector, then use arrow keys and Enter.

**Available Synth Engines:**
| Engine | Description |
|--------|-------------|
| `CLUSTER` | 48-oscillator supersaw with LPF |
| `FM` | 2-operator frequency modulation |
| `PHASE` | Phase distortion synthesis |
| `PULSE` | Dual pulse-width oscillator |
| `STRING` | Waveguide physical modeling |
| `DR.WAVE` | 8-bit style frequency domain |
| `SYNTH-SAMPLER` | Sample playback engine |
| `BASIC` | Virtual analog (sine/saw/square/triangle) |

### Playing Notes
| Key | Note |
|-----|------|
| `A` `S` `D` `F` `G` `H` `J` `K` `L` | White keys (C–D) |
| `W` `E` | Black keys (C# D#) |
| `T` `Y` `U` `O` `P` | Upper octave white keys |
| `Z` | Decrease octave |
| `X` | Increase octave |

### Envelope (F2)
| Keys | Parameter |
|------|-----------|
| `5` | Attack |
| `6` | Decay |
| `7` | Sustain |
| `8` | Release |
| `Shift+-` | Toggle Poly/Mono play mode |

### Effects (F3)
Press `F3` to toggle the insert effect on/off.
Press `Shift+F3` to open the effect browser.

**Available Effects:**
| Effect | Description |
|--------|-------------|
| `DELAY` | Stereo delay with feedback |
| `GRID` | Grid-based plate reverb |
| `NITRO` | Multi-mode filter with envelope follow |
| `PHONE` | Telephone/lo-fi filter |
| `PUNCH` | Resonant low-pass with punch |
| `SPRING` | Spring reverb |

### LFO (F4)
| Keys | Parameter |
|------|-----------|
| `5` | Rate |
| `6` | Depth |
| `7` | Target parameter |
| `8` | Waveform selection |
| `F4` | Toggle LFO on/off |
| `Shift+F4` | Open LFO browser |
| `A` `S` `D`... | Preview note with LFO |

### Sound Slots (F5–F10)
| Key | Action |
|-----|--------|
| `F5`–`F10` tap | Load the active sound slot |
| `F5`–`F10` hold | Save a snapshot and assign it into the slot |
| `Shift+F5`–`Shift+F10` | Open the sound browser for that slot |

Browser model:
- `SNAPSHOT` is a special family.
- `USER` is the default starter pack.
- any top-level folder dropped into `synth/` or `drum/` becomes a pack family
- engine families such as `FM`, `CLUSTER`, `PHASE`, and `SYNTH SAMPLER` also appear as virtual browser filters
- while the browser is open, the highlighted preset is loaded for audition and the keybed can play it live

---

## 4. Drum Mode (`3`)

Drum mode provides a 4-pad sampler with per-part envelope and effects.

### Pads
| Key | Pad |
|-----|-----|
| `A` | Kick / Pad 1 |
| `S` | Snare / Pad 2 |
| `D` | Tom / Pad 3 |
| `F` | Cymbal / Pad 4 |

### Sub-Pages (F1–F4)
| Key | Page |
|-----|------|
| `F1` | Engine (sample/level/pitch) |
| `F2` | Envelope (per-part ADSR) |
| `F3` | FX |
| `F4` | LFO |

### Navigation
| Key | Action |
|-----|--------|
| `↑` `↓` `←` `→` | Navigate pad/parameter |
| `C` / `V` | Adjust velocity |

### Drum Effects (F3)
Same as Synth — see Section 3.6.

---

## 5. Tape Mode (`1`)

Tape mode is a 4-track recorder with 6 minutes of recording time. Audio is recorded at 44.1kHz/16-bit.

### Transport Controls
| Key | Action |
|-----|--------|
| `F1`–`F4` | Select track 1–4 |
| `Enter` | Arm track for recording |
| `Shift+Enter` | Scrub arm (hold and play to record) |
| `Space` | Play / Record (if armed) |
| `Backspace` | Stop |
| `←` / `→` | Seek sample-by-sample |
| `Shift+←` / `Shift+→` | Seek by bars |

### Tape Editing
| Key | Action |
|-----|--------|
| `↑` | Lift selection to clipboard |
| `↓` | Drop clipboard to position |
| `B` | Split selection at playhead |
| `Shift+B` | Join adjacent takes |
| `?` | Input source selector |

### Input Page
| Key | Action |
|-----|--------|
| `5` / `6` | Cycle audio input source |
| `7` / `8` | Toggle input monitor |
| `9` / `0` | Adjust input threshold |
| `-` / `=` | Adjust input gain |
| `Shift+5` / `Shift+6` | Cycle MIDI input port |
| `Shift+7` / `Shift+8` | Cycle MIDI output port |
| `Shift+9` / `Shift+0` | Toggle MIDI clock out |
| `Shift+-` / `Shift+=` | Rescan MIDI ports |

The Input page also shows a live resource monitor:
- app CPU and memory
- system CPU and memory
- audio callback work vs budget
- audio overrun count and buffer size
- UI draw time

Generic MIDI encoder defaults:
- `CC16-19` -> coarse `Blue / Green / White / Orange`
- `CC20-23` -> fine `Blue / Green / White / Orange`
- `CC71` -> coarse `Blue` alias, useful for simple Pico controllers sending either absolute or common relative encoder values

Push 2 setup:
- MuTui prefers the Push 2 User ports when they are available.
- When a Push 2 output User port is selected, MuTui switches the controller into User mode automatically.
- Push 2 Track encoders `1-4` are translated to the same keyboard encoder keys as `5/6`, `7/8`, `9/0`, `- /=`.
- Hold Push `Shift` while turning encoders `1-4` to access the secondary fine layer.
- Push encoders `5-8` are currently unused by MuTui.
- Push 2 pads play notes directly; encoder-touch notes are ignored so touching encoders does not trigger sound.
- Push 2 buttons are translated through MuTui's keyboard router instead of a separate controller-only action map.
- Default Push 2 button translation:
  - `Play` -> `Space`
  - `Stop` -> `Backspace`
  - `Record` -> `Enter`
  - `Note` / `Session` / `Clip` / `Mix` -> `1` / `2` / `3` / `4`
  - `Octave - / +` -> `z` / `x`
  - display buttons above the screen (`CC102-109`) -> `F1-F8`
  - display buttons below the screen (`CC20-27`) -> `1-8`
  - arrows -> arrow keys
  - page left/right -> `PageUp` / `PageDown`
  - `Shift` -> keyboard `Shift`
- Secondary behavior comes from holding Push `Shift`; MuTui does not directly map any Push control to a shifted function by itself.
- Push 2 LEDs stay lit on the User output port, with mode/state shown by brightness: mode buttons, transport, octave, arrows, page buttons, shift, and both display-button rows.
- When the Push 2 User output is active, MuTui mirrors the active MuTui pane onto the Push display using an offscreen 120x20 terminal render rasterized to the Push screen; the Push mirror omits MuTui's header and footer so the main view has more room.

### Tape Parameters
| Key | Parameter |
|-----|-----------|
| `9` / `0` | Tape speed (0.25x – 2.0x) |
| `-` / `=` | Tape level (input gain) |
| `#` | Erase current reel |

### Loop Controls
| Key | Action |
|-----|--------|
| `F5` | Set loop in point |
| `F6` | Set loop out point |
| `F7` | Toggle loop on/off |
| `F8` | Toggle reverse play |
| `F9` | Toggle chop (stutter) mode |

### Bounce Mode
Press `Shift+R` in Tape mode to enable bounce mode — the master output is recorded to the selected track.

---

## 6. Mixer Mode (`4`)

Mixer mode provides 4 track volumes, pan, mute/solo, and master effects.

### Track Controls
| Key | Action |
|-----|--------|
| `,` | Previous track |
| `.` | Next track |
| `↑` / `↓` | Adjust volume |
| `[` / `]` | Adjust pan |
| `M` | Mute selected track |
| `S` | Solo selected track |

### Sub-Pages (F1–F4)
| Key | Page |
|-----|------|
| `F1` | Main (volume/pan/mute/solo) |
| `F2` | EQ (4-band per track) |
| `F3` | FX (insert effect) |
| `F4` | Master Out (compressor/limiter) |

### Master Effects (F4)
| Keys | Parameter |
|------|-----------|
| `5` | Compressor threshold |
| `6` | Compressor ratio |
| `7` | Compressor attack |
| `8` | Limiter ceiling |
| `9` | Master EQ low |
| `0` | Master EQ mid |
| `-` | Master EQ high |

---

## 7. Sequencer (Q)

Both Synth and Drum modes share the sequencer, toggled with `Q`.

### Sequencer Types
| Key | Type | Description |
|-----|------|-------------|
| `Q` cycles | Pattern | 16-step drum grid |
| `Q` cycles | Endless | 99-step melodic sequencer |
| `Q` cycles | Finger | 32-step performance sequencer with 11 trigger patterns |

### Pattern Sequencer (Drum)
| Key | Action |
|-----|--------|
| `5` / `6` | Select step |
| `7` / `8` | Adjust swing |
| `9` / `0` | Adjust length |
| `-` / `=` | Toggle hold |
| `A` `S` `D` `F` | Toggle pads on current step |
| `Shift+key` | Write velocity |

### Endless Sequencer (Synth)
| Key | Action |
|-----|--------|
| `7` / `8` | Adjust swing |
| `9` / `0` | Move playhead |
| `-` / `=` | Toggle hold |
| `key` | Add note at playhead |
| `Shift+key` | Add chord |

### Finger Sequencer (Synth / Drum)
| Key | Action |
|-----|--------|
| `A` `S` `D` `F` `G` `H` `J` `K` `L` `;` `'` | Trigger the 11 Finger patterns |
| `Shift+key` | Insert/remove note on the selected step |
| `←` / `→` | Move selected step |
| `↑` / `↓` | Select pattern |
| `Blue encoder` | Step sweep |
| `Shift+Blue` | Clear the current step |
| `Green encoder` | Swing |
| `White encoder` | Pattern length |
| `Orange encoder` | Hold |
| `Shift+Orange` | Cycle `Join` / `Replace` / `Fill In` |

Finger notes:
- Finger patterns are 32 steps long.
- Each step supports up to 2 notes.
- `Join` queues the second pattern to the next beat and layers it as Player B.
- `Replace` queues the next pattern and swaps on release.
- `Fill In` temporarily takes over playback while held, then returns to the base pattern.

---

## 8. Tempo (\\)

Press `\` to open the tempo editor.

| Key | Action |
|-----|--------|
| `5` / `6` | Adjust BPM |
| `-` / `=` | Adjust metronome pitch |
| `Esc` | Close |

### Tempo Modes
| Mode | Behavior |
|------|----------|
| `SYNC` | Fixed BPM |
| `BEAT MATCH` | Tape playback speed matches BPM |

---

## 9. Audio Routing

### Signal Flow
```
Engine → Insert FX → Mixer Track → Master FX → Output
                ↓
           Tape (record)
```

### Recording Path
- **Live monitoring**: Engine → Insert FX → Mixer → Master FX → Speakers
- **Recording**: Engine output → Tape (captures dry signal before master effects)
- **Playback**: Tape → Mixer → Master FX → Speakers

### Tape Level
The tape level knob (`-` / `=` in Tape mode) controls the live monitoring volume only. Once recorded, audio is unaffected by tape level — only mixer track volumes and master effects apply.

---

## 10. Keyboard Quick Reference

### Mode Selection
```
1 = Tape    2 = Synth    3 = Drum    4 = Mixer
```

### Global
```
Tab = Help    \ = Tempo    | = Album    Esc = Close/Quit
```

### Synth/Drum
```
F1-F4 = Pages           Shift+F1 = Engine select
Q    = Sequencer        Z/X = Octave
F5-F10 = Slot load/save Shift+F5-10 = Sound browser
```

### Tape
```
Enter   = Arm          Space = Play/Record    Backspace = Stop
← →     = Seek         ↑ ↓   = Lift/Drop
B       = Split        #    = Style
F1-F4   = Track        Shift+F1-F4 = Reel bank
F5-F9   = Loop/Reverse/Chop
```

### Mixer
```
, . = Track     ↑ ↓ = Volume     [ ] = Pan     M = Mute     S = Solo
```

---

## 11. File Operations

### Project Files
- `project/manifest.toml` — Session state
- `project/tapes/slot-*/track-*.f32le` — Per-reel audio data

### Import/Export
- Place `import.wav` in project root to import sample
- Press `e` in Tape mode to export active track to `exported.wav`

### Snapshots
- `F1` = Save snapshot
- `Shift+F1` = Load snapshot

### Sound Library Layout
- `synth/slots/1-6.aif` and `drum/slots/1-6.aif` are the active quick slots
- `synth/snapshot/` and `drum/snapshot/` store snapshots
- `synth/user/` and `drum/user/` are starter packs
- any additional top-level pack folder under `synth/` or `drum/` is scanned into the preset browser automatically

---

## 12. Known Limitations

- **Terminal**: Requires Kitty Keyboard Protocol for key release events
- **Resolution**: Optimized for 80x24 terminals or larger
- **Audio**: Build with `--release` for lowest latency

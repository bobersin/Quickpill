> [!IMPORTANT]
> 🐧 Quickpill is designed for Linux desktops running Wayland and uses [Quickshell](https://quickshell.outfoxxed.me/) as its shell framework.

> [!NOTE]
> 🚧 Quickpill is currently under active development. Features, configuration, and installation steps may change over time.

---

Quickpill is a customizable **Dynamic Island-style desktop interface for Linux**, built with [Quickshell](https://quickshell.outfoxxed.me/).

It provides a small, animated interface that can expand to display useful information and controls when you need them, while staying out of the way when you don't.

Quickpill includes music detection, an application launcher, a clock, animated transitions, a music visualizer/equalizer, and extensive customization options.

## ✨ Features

- 🎵 Automatic music detection
- 🎶 Music player information and controls
- 📊 Animated music visualizer and equalizer
- 🚀 Application launcher
- 🕐 Customizable clock
- ✨ Smooth transitions and animations
- 🎨 Customizable appearance and layout
- ⚙️ Configurable colors, sizes, and behavior
- 🪶 Lightweight and unobtrusive
- 🐧 Designed specifically for Linux and Wayland

## 🖥️ Requirements

Quickpill currently requires:

- 🐧 Linux
- 🌐 A Wayland session
- ⚡ [Quickshell](https://quickshell.outfoxxed.me/)

A compatible Wayland compositor is also required.

## 📦 Installing

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/Quickpill.git
cd Quickpill
```

Then launch Quickpill through Quickshell:

```bash
quickshell -c .
```

For a permanent setup, you can configure Quickpill to launch automatically with your Wayland compositor or desktop environment.

Installation instructions may change as development continues.

## 🎨 Configuration

Quickpill is designed to be highly customizable.

Depending on the configuration, you can change things such as:

- 🎨 Colors and appearance
- 📐 Pill size
- ✨ Animation speed
- 🎵 Music visualizer
- 📊 Equalizer behavior
- 🕐 Clock format
- 🚀 Application shortcuts
- ⚙️ Launcher behavior
- 🧩 Individual modules
- 📍 Layout and positioning

More customization options will be added as Quickpill develops.

## ❓ Frequently Asked Questions

**Q: Is Quickpill a Dynamic Island clone?**

**A:** Quickpill is inspired by the concept of Apple's Dynamic Island, but it is designed specifically for Linux and is intended to be highly customizable.

**Q: What desktop environments are supported?**

**A:** Quickpill is designed for Wayland compositors. Compatibility can vary depending on your compositor and system configuration.

**Q: Does Quickpill work on X11?**

**A:** Quickpill is currently designed around Wayland and Quickshell, so X11 is not supported.

**Q: Can I customize Quickpill?**

**A:** Yes. Customization is one of the main goals of the project. You can modify its appearance, animations, modules, launcher, music display, and other behavior.

**Q: What music players are supported?**

**A:** Quickpill uses Linux's media-control infrastructure to detect currently playing media, allowing it to work with compatible applications rather than being tied to a specific music player.

## 💻 Code

Quickpill is built using [Quickshell](https://quickshell.outfoxxed.me/) and QML.

Quickshell provides shell integration and system-level functionality, while QML is used to build Quickpill's interface, animations, and components.

## 🤝 Contributing

Contributions, bug reports, feature requests, and other improvements are welcome.

If you encounter a problem or have an idea for Quickpill, please open an issue on the repository.

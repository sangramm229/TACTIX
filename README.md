# TACTIX Pro 🛡️
### Enterprise Incident & Crisis Decision Simulator

**TACTIX Pro** is a high-performance, cross-platform critical incident decision simulator designed for emergency commanders, enterprise risk teams, healthcare triage operators, and critical infrastructure managers. 

Built with Flutter and a **Liquid Crystal / Glassmorphic Design System**, TACTIX Pro immerses operators in high-stakes operational environments subject to realistic **telemetry degradation** (latency jitter, packet drop, contradictory field intelligence, and sensor blackouts).

---

## 💎 Features

- **Liquid Crystal & Glassmorphic UI**: High-contrast, frosted glass containers (`BackdropFilter`), specular highlight borders, ambient glow mesh, and modern typography (Google Fonts Inter, Rajdhani & JetBrains Mono).
- **Multi-Sector Crisis Drills**:
  - 🏥 **Healthcare & Mass Casualty**: Code Black Hospital Surge & ICU Oxygen/Power Bus Isolation.
  - ⚡ **Energy & Smart Grid**: Substation 9 Cascading Blackout & SCADA Telemetry Disruption.
  - 🏭 **Industrial & Petrochemical**: Hydrocarbon Refinery Rupture with Conflicting Ground Intel.
  - 🧪 **Chemical & Hazmat**: Highway Corridor Ammonia Plume Dispersion with Anemometer Conflicts.
  - 🌊 **Municipal Disaster Resilience**: Flash Flood Dam Spillway Emergency & Civil Siren Failure.
  - 🛡️ **Critical Infrastructure**: Facility Perimeter Defense Breach & CCTV Lag.
- **Interactive Live Simulation Engine**:
  - Real-time mission countdown clock with pause/resume and `1x`/`2x` speed multipliers.
  - Multi-channel degraded communications feed with packet loss and jitter simulation.
  - Branching multi-stage tactical decision checkpoints with live risk, latency, and consequence feedback.
- **AI-Grounded After-Action Reports (AAR)**:
  - Comprehensive composite scoring and letter grades (`A+`, `A`, `B`).
  - Core competency gauges: Tactical Soundness, Information Triage, and Resource Conservation.
  - Chronological decision timeline with latency step tracking.
  - Executive AI Incident Commander debrief and ISO 22301 / ICS-300 compliance recommendations.
  - Exportable audit reports.
- **Multi-Platform Support**: Android, iOS, Windows, macOS, Linux, and Web.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Typography & Icons**: [google_fonts](https://pub.dev/packages/google_fonts), Cupertino & Material Icons
- **Design Tokens**: Custom `AppColors`, `AppTypography`, `CrystalCard`, and `CrystalBackground`

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.13.4)
- Android Studio / VS Code / IntelliJ
- Connected device or emulator (Android, Windows desktop, or Chrome)

### Installation
```bash
# Clone the repository
git clone https://github.com/sangramm229/TACTIX.git
cd TACTIX

# Fetch dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run unit & widget tests
flutter test

# Launch the app
flutter run
```

---

## 📄 License & Compliance
Compliant with **NIMS / ICS-300 / FEMA Ready** incident command standards. Licensed for enterprise incident management and simulation training.

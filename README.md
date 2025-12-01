# earnly
Earnly is a Flutter application that lets users complete tasks (watching ads, playing games, etc.) to earn rewards and manage their wallet with deposits and withdrawals.

## Features

- **Onboarding & Auth**
  - Email registration & login
  - Forgot password + OTP verification
  - Password reset flow

- **Wallet**
  - View current balance and earnings
  - Withdraw funds to different networks
  - Transaction history (withdrawals list with pagination)

- **Games & Earning**
  - Dice game
  - Wheel spin game
  - Watch-ad flow (opens external URL)

- **Profile & Settings**
  - View basic profile information
  - Account / notifications / security / invite friends / about app sections
  - Logout support

## Tech Stack

- **Framework:** Flutter
- **State management & navigation:** GetX
- **HTTP:** `package:http`
- **Fonts & UI:** Google Fonts, custom widgets, responsive layouts

## Project Structure

```text
lib/
  app/
    controllers/        # GetX controllers (auth, user, earn, etc.)
    data/
      models/           # Data models (e.g. user, withdraw)
      services/         # API services (auth, user)
    modules/
      auth/             # Login, register, forgot/reset password screens
      games/            # Dice game, wheel spin, game hub
      onboarding/       # Welcome & onboarding screens
      settings/         # Settings screen
      wallet/           # Wallet, withdraw, history screens & widgets
    resources/          # Colors, themes, etc.
    routes/             # App routes (named routes with GetX)
    utils/              # Helpers like `base_url.dart`
    widgets/            # Reusable widgets (buttons, textfields, snackbars)
  main.dart             # App entry point
```

## Getting Started

1. **Clone the repo**

   ```bash
   git clone <your-repo-url>
   cd earnly
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API base URL**

   Edit `lib/app/utils/base_url.dart`:

   ```dart
   const String baseUrl = "http://<your-ip-or-domain>:5000/api";
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

## Backend Expectations

The app expects a backend exposing endpoints similar to:

- `POST /api/auth/login`
- `POST /api/auth/register`
- `POST /api/auth/send-otp`
- `POST /api/auth/reset-password`
- `POST /api/auth/logout`
- `GET  /api/user/details`
- `GET  /api/user/withdraw-history`
- `POST /api/user/withdraw`

Update `baseUrl` to match your backend host.

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m "Add feature"`
4. Push and open a Pull Request

## License

This project is currently private. Add a license here if you plan to open-source it.

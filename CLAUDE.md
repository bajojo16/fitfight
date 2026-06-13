# FightFit

App fitness — **Fitness · Diet · Boxing**.

## Structure monorepo

```
fightfit/
├── web/        ← React + Vite + TypeScript  (npm run dev → localhost:5173)
├── mobile/     ← Expo React Native + TypeScript (npm run ios / android)
└── Logo/       ← assets visuels
```

Depuis racine : `npm run web` ou `npm run mobile`.

## Identité visuelle

- Logo : gant de boxe noir + flamme orange (`Logo/ChatGPT Image 13 juin 2026, 02_36_05.png`)
- Couleurs : noir `#1A1A1A` + orange `#F47B20` (approx., à extraire précisément du logo)
- Tagline : Fitness · Diet · Boxing

## Démarrage

```bash
# Web
npm run web        # → localhost:5173

# Mobile
npm run mobile     # → Expo Go (scan QR iOS/Android)
```

## Conventions

- Branche principale : `main`
- À compléter au fil du développement

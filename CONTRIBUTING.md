# Contributing to Pak Ludo

Thanks for taking the time to contribute to **Pak Ludo**. Contributions of all kinds are welcome, whether that's fixing bugs, improving the UI, adding features, writing tests, or even improving documentation.

---

## Core Development Principles

Pak Ludo is designed to be a fast, privacy-respecting cross-platform game (Web, Chrome Extension, Android). To keep the codebase clean and performant, please keep the following boundaries in mind before starting work:

- Architecture: We use React, TypeScript, React Router, Redux Toolkit for Web/Extension, and Flutter for Android. Ensure changes align with existing patterns and maintain strict type safety.
- Dependencies: We actively minimize external dependencies to keep the app lightweight.
- Privacy First: We are committed to an ad-free, untracked experience. PRs introducing telemetry, analytics, or any form of data collection will not be merged.

---

## Prerequisites

This project uses **[pnpm](https://pnpm.io/)** as its JavaScript package manager and **Flutter SDK** for Android.

---

## Local setup

```bash
# Clone the repository
git clone https://github.com/adrees20222/pak-ludo.git
cd pak-ludo

# Install web dependencies
pnpm install

# Start web development server
pnpm run dev
```

# Install dependencies
pnpm install

# Start the development server
pnpm run dev

# Optionally, compile and preview the production build
pnpm run build && pnpm run preview
```

After running the dev server, the project should be available locally in your browser.

---

## Branch naming

Please create branches using the following naming pattern. It helps keep the commit history easier to read.

| Type     | Pattern        | Example                    |
| -------- | -------------- | -------------------------- |
| Feature  | `feat/...`     | `feat/animated-dice`       |
| Bug fix  | `fix/...`      | `fix/token-overlap`        |
| Refactor | `refactor/...` | `refactor/turn-reducer`    |
| Build    | `build/...`    | `build/upgrade-vite`       |
| Docs     | `docs/...`     | `docs/update-contributing` |
| Chore    | `chore/...`    | `chore/update-gitignore`   |

Keep branch names short but descriptive.

---

## Code quality checks

This repository uses **ESLint**, **Prettier**, and **EditorConfig** to keep the codebase consistent.

Before opening a pull request, please make sure everything passes locally.

```bash
# Linting
pnpm run lint

# Type checking
pnpm run type-check

# Run tests
pnpm test
```

Formatting is handled automatically by **Prettier** if your editor supports it. Installing the Prettier extension for your editor is recommended.

EditorConfig settings are also included in the repo. Many editors support it automatically.

---

## Commit messages

Commits must follow the **Conventional Commits** format.

Providing a scope is encouraged, but not mandatory.

```text
<type>([scope]): <short description>

[body]
```

The body is optional but helpful when the reason behind the change isn't obvious.

### Commit types

| Type     | Description                                                   |
| -------- | ------------------------------------------------------------- |
| feat     | New feature                                                   |
| fix      | Bug fix                                                       |
| docs     | Documentation only                                            |
| style    | Formatting or style changes                                   |
| refactor | Code restructuring without changing behavior                  |
| build    | Changes that affect the build system or external dependencies |
| test     | Adding or updating tests                                      |
| chore    | Routine repository maintenance tasks                          |
| perf     | Performance improvements                                      |
| ci       | CI/CD related changes                                         |

### Example commits

```text
feat(board): animate token movement
fix(dice): correct roll distribution
refactor(game-state): simplify turn reducer
build(deps): update workbox-window to v7
docs(contributing): clarify commit guidelines
test(bot): add move scoring tests
chore: run prettier across codebase
```

---

## Submitting a pull request

When you're ready to submit your work:

1. Create a branch from `main`
2. Commit your changes using the format above
3. Write or update tests if your change affects game logic or existing behavior
4. Push the branch to your fork
5. Open a Pull Request against `main`
6. Add a short explanation of what the change does and why it was needed
   A review may request changes before the PR is merged.

---

## License

By contributing to this project, you agree that your contributions will be licensed under the **GNU Affero General Public License, version 3**.

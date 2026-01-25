# Global Rules

Follow [omnidotdev/golden](https://github.com/omnidotdev/golden) for code style.

Never commit or push, or open PRs for Brian without explicit consent, but you can ask.

---

<!-- @cache source="https://github.com/omnidotdev/golden" lastSync="2025-01-25" -->
<!-- TODO: reconciliation script to sync from Golden repo -->

# Omni AI Agent Rules

- Never hallucinate paths, APIs, or environment variables
- Make minimal, focused changes
- Match existing patterns and style

## TypeScript

- Use `bun` (not npm, yarn, or pnpm)
- Enforce [Biome](https://biomejs.dev) for formatting and linting
- Enforce [Knip](https://knip.dev) for dead code and unused dependency detection

## Rust

- Use [thiserror](https://docs.rs/thiserror) for library errors, [anyhow](https://docs.rs/anyhow) for application errors
- Return `Result<T, E>`; avoid panics

## Error Handling

- Validate at system boundaries (user input, external APIs)
- Use typed errors; avoid stringly-typed error messages
- Never log secrets, tokens, PII, or full request bodies

---

# Omni Code Style Guide

## Hierarchy

1. Global rules (this file)
2. Language guides (below)
3. Tool configs (Biome, rustfmt, Tilt)
4. Project overrides (only when justified)

## Principles

- **Consistency over preference**: match existing patterns
- **Small, composable units**: small files, small functions
- **Explicit over implicit**: no magic behavior
- **Predictable by default**: standard patterns first

## Structure

Group by feature/domain, not type:

```
src/
  billing/
  auth/
tests/
scripts/
```

Prefer small files. If a file is getting unwieldy, split it.

## Comments

- Sentence case: `// Ensure database exists.`
- Wrap code in backticks: `// Parse \`userId\` param`
- TODO format: `// TODO: description` or `// TODO(assignee): description`
- Explain **why**, not what
- Use singular imperative: `// Parse a timestamp.` not `// Parses a timestamp.`

## Testing

- Fast, deterministic tests
- Integration tests at boundaries, unit tests for tricky logic
- Single command per repo: `bun test`, `cargo test`
- Arrange-Act-Assert structure
- Test naming: `describe` the unit, `it` the behavior
- Mock at boundaries (external APIs, databases), not internal modules

## API Design

- GraphQL-first: schema as the contract
- REST only when GraphQL doesn't fit (webhooks, file uploads, health checks)

## Accessibility

- Semantic HTML first; ARIA only when needed
- Keyboard navigable; visible focus states
- Sufficient color contrast; don't rely on color alone

## Git

Extended Conventional Commits (ECC):

- **Default branch**: `master`
- **Format**: `type(scope): description`
- **Types**: `feature` (or `feat`), `fix`, `documentation` (or `docs`), `style`, `refactor`, `test`, `chore`, `build`, `ci`, `performance` (or `perf`), `revert`
- **Branch naming**: `feature/`, `fix/`, `chore/` prefixes
- **Atomic commits**: one focused, logical change per commit
- **No `Co-Authored-By`**: do not add co-author lines to commits

## Dependencies

- Prefer standard library when sufficient
- Pin versions in lockfiles
- Audit regularly (`bun audit`, `cargo deny`)
- Justify new dependencies; prefer well-maintained packages

---

# TypeScript Style Guide

## Tooling

- **Biome** for formatting and linting
- **Knip** for dead code and unused dependency detection
- **bun** for package management and scripts
- `bun lint` / `bun test` exposed in all projects

## Pre-commit Hooks

Run in order via husky:

1. `bun knip` - catch unused code/dependencies
2. `bun biome check --write --staged` - format and lint
3. `bun tsc --noEmit` - type check

## TypeScript

- Strict mode always
- Prefer `type` over `interface` (use interface only for declaration merging)
- Avoid `any` (use `unknown`)
- Prefer union types over enums
- Use `satisfies` for type narrowing with inference

## Exports

- One export per file, `export default` at bottom
- Named exports allowed for: config files, barrel files, type definitions
- Barrel files must be small and explicit

## Imports

Use `@/` for internal imports.

Order (Biome enforces):

1. Node/Bun builtins
2. External packages
3. Internal modules (`@/*`)
4. Relative imports
5. Type imports (separated)

Avoid wildcard imports except for namespaced libraries.

## Naming

- **PascalCase**: Components, types
- **camelCase**: Variables, functions, hooks
- **SCREAMING_SNAKE**: True constants (exported only)

File names:

- Components: `ComponentName.tsx`
- Hooks: `useThing.ts`
- Utils: `thing.ts`
- Tests: `*.test.ts`

## Error Handling

- Return `null`/`undefined` for expected failures (not found, empty results)
- Throw for unexpected failures (network errors, invalid state)
- Use typed error classes for domain-specific errors
- Error boundaries at route level minimum

## React

- One component per file
- Props type when non-trivial
- Prefer local state; context sparingly
- Use the project's CSS framework (Panda, Tailwind); avoid raw inline styles

## Accessibility

- Semantic HTML first; ARIA only when needed
- All interactive elements keyboard accessible
- Visible focus states; never `outline: none` without replacement
- Images need `alt`; decorative images use `alt=""`
- Form inputs need associated labels

## JSDoc

- **`@returns`** not `@return`
- **No blank line** between description and tags
- **Hyphen after param name**: `@param name - Description.`
- **Period at end** of descriptions
- **Skip obvious docs**: don't document self-evident params/returns
- **`@throws`** not `@exception`
- **`@example`** with language identifier

```ts
/**
 * Parse a timestamp.
 * @param input - ISO 8601 string.
 * @returns Parsed date or null if invalid.
 */
```

## Discouraged

- `any` without justification
- Giant barrel re-exports
- Wildcard imports
- Inline styles (except dynamic values)

---

# Rust Style Guide

## Tooling

- **rustfmt** for formatting
- **Clippy** with `clippy::pedantic` preferred
- **cargo-deny** for dependency auditing

Expose: `cargo fmt --check && cargo clippy && cargo test`

## Structure

```
src/
  lib.rs
  main.rs (thin entry point only)
  module_name/
tests/
```

Lib-first: put logic in `lib.rs`, not `main.rs`.

## Naming

- **snake_case**: modules, functions, variables
- **PascalCase**: types, enums, structs, traits
- **SCREAMING_SNAKE**: constants
- Acronyms: `HttpClient`, `JsonValue`

## Derives

- Always `#[derive(Debug)]` on structs/enums
- `Clone` only when semantically appropriate
- Consider `Default`, `PartialEq` when useful

## Error Handling

- Use `Result<T, E>` for fallible operations
- **thiserror** for library error types
- **anyhow** for application error handling
- Propagate with `?`; handle at appropriate level
- Add context: `.context("failed to parse config")?`

## Logging

Use **tracing**, not `log`. Never log secrets.

```rust
tracing::info!(user_id = %id, "user logged in");
```

## Imports

Order:

1. `std::` modules
2. External crates
3. Internal modules

Sort alphabetically within groups.

## Doc Comments

- **`///`** for items, **`//!`** for module-level docs only
- **First line is the summary**: one sentence, imperative mood
- **Blank line** between summary and body
- **Standard sections** (in order): `# Examples`, `# Errors`, `# Panics`, `# Safety`
- **`# Examples`** required for public APIs
- **`# Errors`** required if returning `Result`
- **`# Panics`** required if function can panic
- **`# Safety`** required for `unsafe` functions

```rust
/// Parse a timestamp from an ISO 8601 string.
///
/// Returns `None` if the input is malformed.
///
/// # Examples
///
/// ```rust
/// let ts = parse_timestamp("2024-01-01T00:00:00Z");
/// assert!(ts.is_some());
/// ```
```

## Release Profile

```toml
[profile.release]
lto = true
codegen-units = 1
panic = "abort"
```

## Discouraged

- `unwrap()` / `expect()` in non-test code
- Global mutable state (`static mut`)
- `unsafe` without justification
- Catch-all error handling without context

---

# Starlark Style Guide

## Structure

```
Tiltfile                # Main entry point (keep short)
tilt/
  services.tilt         # Service declarations
  k8s.tilt              # K8s wiring
starlark/
  env.tilt              # Reusable env helpers
  utils.tilt            # Generic functions
```

Single responsibility per file.

## Naming

- **snake_case**: functions, variables
- **SCREAMING_SNAKE**: constants (rare)
- Files: `*.tilt`, named by purpose

## Imports

- Prefer local `load()` from `starlark/` or `tilt/`
- Centralize `ext://` extensions
- Avoid scattering `ext://` loads

## Environment

- Use dedicated env helpers
- Support `.env`, `.env.local`
- Never hardcode secrets

## Services

Declarative, no magic globals:

```python
register_service(
    name='api',
    path='services/api',
    dockerfile='services/api/Dockerfile',
)
```

## Discouraged

- Hardcoded secrets
- Complex business logic (Tilt is orchestration only)
- Hidden side effects

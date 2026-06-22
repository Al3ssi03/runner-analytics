# CLAUDE.md — Engineering Rulebook

> **This file is law.** Every agent operating on this repository reads it before any action
> and follows it **without exception**. There are no "special cases" that justify deviations.

---

## 0. BOOTSTRAP — First time on this repo

If you have not run the initial setup yet:

```
/setup-matt-pocock-skills
```

Configures the issue tracker (GitHub or GitLab), the triage label vocabulary, and the domain doc layout.
**Run it once. The other skills assume it.**

### 0.1 Caveman Mode — always active

> Respond terse like smart caveman. Active from first response, every session.

Drop: articles, filler, pleasantries, hedging. Fragments OK. Technical terms exact. Code blocks unchanged.

Full rules: `.agents/skills/caveman/SKILL.md`

**Off only when user says:** `"stop caveman"` or `"normal mode"`

---

## 1. ENGINEERING WORKFLOW — MANDATORY FOR EVERY CODE REQUEST

> ⚠️ **STOP.** Every time you receive a request to add, modify, or remove code,
> **you must follow this sequence in its entirety.** There is no shortcut. There is no "obvious case."

### 1.1 Main flow: idea → ship

The canonical path of every feature or fix. Follow the steps in order.

```
STEP 1 ─ /grill-with-docs
          In-depth interview about the idea. Update CONTEXT.md and the ADRs inline.
          Do not proceed to step 2 until every open question is resolved.

STEP 2 ─ Can you settle everything in conversation?
          YES → go to STEP 3
          NO  → /prototype (throwaway session) → /handoff (bring the result back) → return to STEP 1

STEP 3 ─ Is this a multi-session build? (> 1 issue, > 1 component, estimate > 2h)
          YES → /to-prd   (PRD as an issue)
                /to-issues (split into independent, vertically sliced issues)
                Then: a NEW session per issue → /implement with PRD + single issue
          NO  → /implement in the same context window

STEP 4 ─ Git workflow (see §2)
          Feature branch → atomic commits → PR toward develop → stop, no autonomous merge

STEP 5 ─ /tdd
          Every implementation follows red-green-refactor.
          Do not close an issue without a corresponding passing test.
```

### 1.2 On-ramp: incoming bugs and requests

```
Bug report / feature request received externally?
→ /triage before anything else
→ Only issues marked agent-ready enter the main flow at STEP 1
```

### 1.3 Codebase maintenance

```
Have a spare moment between tasks? Run:
→ /improve-codebase-architecture
   Reads CONTEXT.md and docs/adr/ and identifies deepening opportunities.
   Each opportunity becomes an idea → re-enters the main flow at STEP 1.
```

### 1.4 Periodic architecture review — every 10 commits (MANDATORY)

Every **10 commits**, run `/improve-codebase-architecture` before any other work.

```bash
# Check commits since last review
git rev-list --count HEAD ^$(git describe --match "arch-review-*" --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)

# When count reaches 10:
# 1. Run /improve-codebase-architecture
# 2. Tag the commit: git tag arch-review-N  (increment N)
```

No skipping. Review is mandatory before commit 11.

### 1.5 Context hygiene rules

- Keep STEPS 1-3 in **a single context window** without compacting.
- Every `/implement` starts from a **fresh** context, with PRD + issue as its only input.
- If the context approaches the smart zone (~120k tokens), run `/handoff` and open
  a new session before it degrades.
- Do not compact mid-phase: `/handoff` to fork, `/compact` only between completed phases.

---

## 2. GIT WORKFLOW — GITHUB FLOW (MANDATORY)

### 2.1 Rule zero

> **Do not touch a single file** before verifying the current branch.

```bash
git branch --show-current
```

If the result is `main`, `master`, or `develop`: **create a feature branch immediately.**

### 2.2 Branch naming

```
<type>/<short-description-kebab-case>

allowed types:
  feature/   → new functionality
  fix/        → bugfix
  chore/      → infrastructure updates, dependencies, config
  refactor/   → refactoring with no behavior change
  docs/       → documentation only
  test/       → adding or fixing tests
  hotfix/     → urgent fix on main/production (exceptional case, requires human approval)

valid examples:
  feature/user-geolocation-timetable
  fix/null-pointer-knx-cover
  chore/docker-compose-v3-upgrade
  refactor/rails-jsonapi-layer
```

### 2.3 Workflow step-by-step

```bash
# 1. Verify branch
git branch --show-current          # STOP if you are on main/develop

# 2. Create and switch to the feature branch
git checkout -b feature/<description>

# 3. Work in atomic commits (one commit = one logical change)
git add -p                         # always add -p, never git add .
git commit -m "<type>(<scope>): <description>"   # Conventional Commits

# 4. Keep the branch up to date
git fetch origin develop
git rebase origin/develop          # prefer rebase over merge for a linear history

# 5. When the task is complete: push + open a PR
# → see §2.5 for gh vs glab
```

### 2.4 Conventional Commits — mandatory format

```
<type>(<scope>): <imperative description in English>

types: feat | fix | chore | refactor | docs | test | ci | perf | revert
scope: module or area (e.g. rails, docker, react, migrations, auth, api)

examples:
  feat(rails): add geolocation fields to TimeTable migration
  fix(docker): resolve nginx SSL cert path for imas.it subdomains
  chore(deps): bump rack from 3.0.1 to 3.1.0
  test(react): add unit tests for JsonApiClient adapter
  ci(gitlab): add rspec stage to .gitlab-ci.yml pipeline

BREAKING CHANGE: add it as a footer or with ! after the type
  feat(api)!: remove deprecated v1 endpoint
```

### 2.5 PR destination — GitHub vs GitLab

This repo may live on GitHub (open source libraries) or on the on-premise GitLab
(Bancolini proprietary libraries). Determine the destination before pushing:

```bash
# Check the configured remote
git remote -v
```

**If the remote points to github.com:**

```bash
git push -u origin feature/<your-branch>
gh pr create \
  --base develop \
  --title "<type>(<scope>): <description>" \
  --body "$(cat .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || echo 'See commits.')" \
  --draft
```

**If the remote points to the on-premise GitLab:**

```bash
git push -u origin feature/<your-branch>
glab mr create \
  --target-branch develop \
  --title "<type>(<scope>): <description>" \
  --description "$(cat .gitlab/merge_request_templates/Default.md 2>/dev/null || echo 'See commits.')" \
  --draft \
  --remove-source-branch
```

**Common rules:**
- PR/MR always toward `develop`, **never toward `main`**.
- Always open as a **draft** — human review is mandatory before merge.
- Do not merge autonomously. **Ever.**
- After opening the PR/MR, return the URL to the user and stop.

### 2.6 Submodules and mixed dependencies

This project may include submodules from different remotes:

```bash
# Check the submodule configuration
cat .gitmodules
```

When you update a submodule:

```bash
# Update all submodules to the latest commit of the tracked branch
git submodule update --remote --rebase

# Or a single submodule
git submodule update --remote --rebase <path/to/submodule>

# Commit the pointer update
git add <path/to/submodule>
git commit -m "chore(deps): update <submodule-name> to <new-sha>"
```

**Rule:** never modify the code inside a submodule directly from this repo.
Open a PR/MR in the submodule's own repo, wait for the merge, then update the pointer here.

### 2.7 FORBIDDEN git commands (without explicit human approval)

```bash
# NEVER run these commands autonomously:
git push --force
git push --force-with-lease     # only with explicit approval
git reset --hard
git clean -fd
git rebase origin/main          # on shared branches
git push origin main
git push origin develop
git merge --no-ff main
```

If you need one of these, **explain the reason to the user and wait for written confirmation**.

---

## 4. ARCHITECTURE DECISION RECORDS

Architectural decisions live in `docs/adr/`.
Format: `docs/adr/NNNN-<kebab-title>.md` (Lightweight ADR, Michael Nygard).

When you make a decision that impacts the architecture:
1. Create or update the corresponding ADR.
2. Commit it in the same PR as the change that motivated the decision.
3. Update `CONTEXT.md` if the decision introduces new domain language.

---

## 5. CI/CD — GitHub

# Stack: React + TypeScript + Vite (frontend) / Python FastAPI (backend)
# Frontend: npm run test, npm run build
# Backend: pytest, ruff (linter)
# Branch protection: green CI + 1 review before merge

### GitHub (open source libraries)

```yaml
# .github/workflows/ci.yml must include:
# - bundle exec rspec (Rails)
# - bundle exec rubocop
# - yarn test (React)
# - docker compose build (smoke test)
# Branch protection: a PR requires a green CI + 1 review before merge
```

---

## 6. PRE-PUSH CHECKLIST

Before every `git push`, mentally verify:

- [ ] Am I on a feature branch (not main/develop)?
- [ ] Did I follow the flow `/grill-with-docs` → `/to-prd` → `/implement` → `/tdd`?
- [ ] Do all commits follow the Conventional Commits format?
- [ ] Are code, comments, and documentation **in English** (see §3.5)?
- [ ] No secrets or credentials in the diff?
- [ ] Do the tests pass locally?
- [ ] Did I update `CONTEXT.md` and/or `docs/adr/` if needed?
- [ ] Is the PR/MR targeted at `develop` (not main)?
- [ ] Is the PR/MR opened as a draft?

---

## 7. QUICK SKILL REFERENCE

| Skill                        | When to use it                                             |
|------------------------------|------------------------------------------------------------|
| `/ask-matt`                  | Don't know which skill to use → start here                 |
| `/setup-matt-pocock-skills`  | First time on this repo                                     |
| `/grill-with-docs`           | **Every** new idea or feature — mandatory STEP 1            |
| `/grill-me`                  | No codebase yet, design only                               |
| `/to-prd`                    | Turn the conversation into a formal PRD                    |
| `/to-issues`                 | Split the PRD into independent, vertical issues            |
| `/triage`                    | Incoming external bugs/requests                            |
| `/implement`                 | Execution of a single issue                                |
| `/tdd`                       | Red-green-refactor for every implementation                |
| `/diagnose`                  | Hard bug or performance regression                         |
| `/improve-codebase-architecture` | Proactive codebase maintenance                        |
| `/zoom-out`                  | Lost in the code? Ask for system context                   |
| `/prototype`                 | A question that needs throwaway code to be answered        |
| `/handoff`                   | Hand the context to a new session                          |

---

## 8. SELF-MAINTENANCE — CLAUDE.md updates itself

> This file is a living document. The three rules below are **mandatory** and trigger
> as a side-effect of other operations. When you update an AUTO block, modify **only** the
> content between the `<!-- AUTO:... -->` and `<!-- /AUTO:... -->` markers, never the rest of the file.
> Every update to this file is a separate, atomic `docs(claude): ...` commit.

### 8.1 Domain Language → after every `/grill-with-docs`

**Trigger:** at the end of every `/grill-with-docs` session.

**Mandatory action:**
1. Extract the new domain terms that emerged from the session (entities, concepts, resolved jargon).
2. Compare against the table in the `<!-- AUTO:DOMAIN-LANGUAGE -->` block.
3. Add the **new** rows (do not duplicate terms already present, do not remove existing ones
   unless the user explicitly asks for it).
4. `CONTEXT.md` remains the canonical document: if you update the table, verify it is consistent
   with `CONTEXT.md`; in case of conflict, `CONTEXT.md` wins and the table aligns to it.
5. **Show the user the table diff and ask for confirmation** before committing.
   (Domain terms are semantic: the human validates.)
6. Commit: `docs(claude): update domain language after grilling session`

### 8.2 Remote paths → on every PR/MR opening (or on-demand)

**Trigger:** before opening a PR/MR (§2.5), or when the user asks to sync the paths.

**Mandatory action (deterministic, no confirmation needed):**
1. Read the real remotes:
   ```bash
   git remote -v
   ```
2. For each remote, extract host + org/group + repo. Normalize SSH and HTTPS to the same format:
   ```bash
   # normalization example (adapt to the actual remotes)
   git remote get-url origin | sed -E 's#git@([^:]+):#https://\1/#; s#\.git$##'
   ```
3. Regenerate the `<!-- AUTO:REMOTE-PATHS -->` block with the real URLs:
   - if a remote points to `github.com` → GitHub line with `/issues`
   - if a remote points to the on-premise GitLab → GitLab line with `/-/issues`
   - if both exist, include both lines; if only one exists, remove the other.
4. If the block is already aligned with the real remotes, **do nothing** (no empty commit).
5. Commit only if changed: `docs(claude): sync remote paths from git config`

> This is the only one of the three rules that may run without human confirmation, because its output
> derives entirely from `git remote -v` and is verifiable deterministically.

### 8.3 CI section → when dependencies change

**Trigger:** every commit that modifies one of these files:
`Gemfile`, `Gemfile.lock`, `*.gemspec`, `package.json`, `yarn.lock`, `pnpm-lock.yaml`.

**Mandatory action:**
1. Detect what changed:
   ```bash
   git diff --cached --name-only | grep -E '(Gemfile|\.gemspec|package\.json|yarn\.lock|pnpm-lock\.yaml)$'
   ```
2. Determine the correct CI commands **from the real files**, not from assumptions:
   - Ruby test runner: look for `rspec`, `minitest` in the Gemfile → use the matching command
   - Ruby linter: look for `rubocop`, `standard` → use whichever is present
   - JS package manager: presence of `yarn.lock` → `yarn`; `pnpm-lock.yaml` → `pnpm`;
     only `package-lock.json` → `npm`
   - JS test script: read `scripts.test` from `package.json` and use it exactly
3. Update the `<!-- AUTO:CI-COMMANDS -->` block with the real commands, keeping the
   two-section structure (GitHub Actions / GitLab CI).
4. If `.github/workflows/*.yml` or `.gitlab-ci.yml` already exist, **align CLAUDE.md to those files**
   (they are the source of truth for CI), not the other way around.
5. **Show the user the diff and ask for confirmation** before committing (the commands are semantic).
6. Commit: `docs(claude): update CI commands after dependency change`

### 8.4 Limits and safety principle

- Rules §8.1 and §8.3 are **best-effort with human validation**: the agent proposes, the user
  confirms. Do not commit them without showing the diff.
- Rule §8.2 is deterministic and may proceed autonomously.
- **Never** modify portions of the file outside the AUTO markers as part of these rules.
- When in doubt about what counts as a domain term or a CI command, **ask**, don't guess.
- If a canonical file (`CONTEXT.md`, existing CI workflows) conflicts with CLAUDE.md,
  the canonical file wins and CLAUDE.md aligns to it.

---

## 9. CONTACTS AND RESOURCES

<!-- AUTO:REMOTE-PATHS — managed by rule §9.2. Derived from `git remote -v`. Do not edit by hand. -->

- **Public issue tracker (GitHub):** https://github.com/Al3ssi03/runner-analytics/issues

<!-- /AUTO:REMOTE-PATHS -->

- **Domain documentation:** `CONTEXT.md` (root) + `docs/adr/`
- **Skills reference:** https://github.com/mattpocock/skills

---

*Last manual revision: update this date after every significant change to the file.*
*Generated with the support of Claude — review and adapt to the specific project.*

---

## Agent skills

### Issue tracker

GitHub Issues (`github.com/Al3ssi03/runner-analytics`). External PRs are a triage surface. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` at root + `docs/adr/`. See `docs/agents/domain.md`.

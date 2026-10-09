---
name: git-commit
description: Generate git commit messages following conventional commits format. Use when creating commit messages from unstaged or uncommitted changes.
---
# Git Commit Skill

This skill generates git commit messages following the conventional commits specification.

## Usage

When invoked, this skill will:
1. Check unstaged and uncommitted changes
2. Analyze the purpose of each change
3. Ask for clarification if the purpose is unclear
4. Generate a commit message in lowercase following conventional commits format

## Clarification

If the purpose of a change is unclear, ask the user for context before generating the commit message.

## Verification

After generating the commit message, display it and ask for verification before proceeding with the commit.

## Output Format

- Type and scope in lowercase
- Single line summary starting with `fix:`, `feat:`, `docs:`, etc.
- Multiple changes listed as bullet points in body
- Purpose-focused descriptions

## Conventional Commits Types

- `fix:` - bug fixes
- `feat:` - new features
- `docs:` - documentation changes
- `refactor:` - code refactoring
- `test:` - test changes
- `chore:` - maintenance tasks

## Examples

```
feat(ui): add dark mode toggle

- Enable users to switch between light and dark themes for reduced eye strain
- Persist theme preference in local storage
```

```
fix(api): resolve null pointer in user fetch

- Prevent crashes when user profile data is missing
- Ensure graceful degradation with empty object fallback
```

```
refactor: improve data validation pipeline

- Migrate to schema-based validation for type safety and maintainability
- Add edge case coverage to reduce production bugs
- Improve error messages to help users understand input requirements
```

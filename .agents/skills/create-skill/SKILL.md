---
name: create-skill
description: Create a new skill file with proper YAML frontmatter and documentation structure following the agentskills.io specification.
---

# Create Skill

Use this skill to create new Agent Skills following the [Agent Skills](https://agentskills.io) specification.

## What is an Agent Skill?

Agent Skills are a lightweight, open format for extending AI agent capabilities with specialized knowledge and workflows. A skill is a directory containing, at minimum, a `SKILL.md` file with metadata and instructions.

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── assets/           # Optional: templates, resources
└── ...               # Any additional files
```

## SKILL.md Format

### Frontmatter Fields

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen. Must match the parent directory name. |
| `description` | Yes | Max 1024 characters. Describes what the skill does and when to use it. |
| `license` | No | License name or reference to a bundled license file. |
| `compatibility` | No | Max 500 characters. Environment requirements (intended product, system packages, network access, etc.). |
| `metadata` | No | Map from string keys to string values for additional metadata. |
| `allowed-tools` | No | Space-separated string of pre-approved tools the skill may use (Experimental). |

### Minimal Example

```markdown
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

### Example with Optional Fields

```markdown
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
license: Apache-2.0
metadata:
  author: example-org
  version: "1.0"
---
```

### Name Field Rules

- Must be 1-64 characters
- May only contain lowercase alphanumeric characters (`a-z`, `0-9`) and hyphens (`-`)
- Must not start or end with a hyphen (`-`)
- Must not contain consecutive hyphens (`--`)
- Must match the parent directory name

### Description Best Practices

- Must be 1-1024 characters
- Should describe both what the skill does and when to use it
- Should include specific keywords that help agents identify relevant tasks

**Good example:**
```yaml
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
```

**Poor example:**
```yaml
description: Helps with PDFs.
```

### Compatibility Field

Must be 1-500 characters if provided. Only include if the skill has specific environment requirements.

**Examples:**
```yaml
compatibility: Designed for Claude Code (or similar products)
```
```yaml
compatibility: Requires git, docker, jq, and access to the internet
```
```yaml
compatibility: Requires Python 3.14+ and uv
```

Most skills do not need the `compatibility` field.

### Metadata Field

A map from string keys to string values. Clients can use this to store additional properties. Make key names reasonably unique to avoid conflicts.

**Example:**
```yaml
metadata:
  author: example-org
  version: "1.0"
```

### Allowed-Tools Field

A space-separated string of tools that are pre-approved to run. Experimental. Support varies between agent implementations.

**Example:**
```yaml
allowed-tools: Bash(git:*) Bash(jq:*) Read
```

### Body Content

The Markdown body after the frontmatter contains the skill instructions. There are no format restrictions.

Recommended sections:
- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases

Note that the agent will load this entire file once it's decided to activate a skill. Consider splitting longer `SKILL.md` content into referenced files.

## Optional Directories

### `scripts/`

Contains executable code that agents can run. Scripts should be self-contained, clearly document dependencies, include helpful error messages, and handle edge cases gracefully.

### `references/`

Contains additional documentation that agents can read when needed:
- `REFERENCE.md` - Detailed technical reference
- `FORMS.md` - Form templates or structured data formats
- Domain-specific files (`finance.md`, `legal.md`, etc.)

Keep individual reference files focused. Agents load these on demand, so smaller files mean less use of context.

### `assets/`

Contains static resources:
- Templates (document templates, configuration templates)
- Images (diagrams, examples)
- Data files (lookup tables, schemas)

## Progressive Disclosure

Agents load skills progressively, pulling in more detail only as a task calls for it:

1. **Metadata** (~100 tokens): The `name` and `description` fields are loaded at startup for all skills
2. **Instructions** (< 5000 tokens recommended): The full `SKILL.md` body is loaded when the skill is activated
3. **Resources** (as needed): Files (e.g. those in `scripts/`, `references/`, or `assets/`) are loaded only when required

Keep your main `SKILL.md` under 500 lines. Move detailed reference material to separate files.

## File References

When referencing other files in your skill, use relative paths from the skill root:

```markdown
See [the reference guide](references/REFERENCE.md) for details.

Run the extraction script:
scripts/extract.py
```

Keep file references one level deep from `SKILL.md`. Avoid deeply nested reference chains.

## Validation

Use the [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref) reference library to validate your skills:

```bash
skills-ref validate ./my-skill
```

This checks that your `SKILL.md` frontmatter is valid and follows all naming conventions.

## Examples

### Example 1: Simple Skill

```yaml
---
name: format-code
description: Format code files using the appropriate formatter for each language.
---

# Format Code
```

### Example 2: Complex Skill

```yaml
---
name: git-commit
description: Guide commit creation following Conventional Commits specification. Never amend pushed commits. Ask before pushing.
---

# Git Commit
```

## Usage

When you want to create a new skill:

1. Specify the skill name (kebab-case)
2. Provide a brief description
3. The agent will create the file with proper frontmatter and structure
4. Add specific documentation content for the skill

## Location

Skills should be placed in `.agents/skills/` directory, with the skill name as the directory name.

## Example Creation

To create a "lint-changes" skill:

```
Create a new skill called "lint-changes" that checks code for linting issues before committing.
```

The agent will:

1. Create `./.agents/skills/lint-changes/SKILL.md`
2. Add the YAML frontmatter with name and description
3. Include proper documentation structure

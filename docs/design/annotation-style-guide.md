# Annotation Style Guide

**Version:** 1.0
**Applies to:** `CommandAnnotation` data authored in `types/exercises.ts`-typed step objects across all Foundation lesson MDX files.

---

## 1. Display Policy

Annotations are ALWAYS VISIBLE below the command block. They are static text: never tooltips, never hover-to-reveal, never click-to-expand, never hidden behind an interaction.

The command itself is displayed first (copyable). Below it, a per-token breakdown table lists each annotated flag or argument with its description and optional example. This layout is intentional:

- Mobile users get the same experience as desktop users — no hover required.
- Screen readers encounter annotations as normal text, not hidden ARIA descriptions.
- Learners can read annotations before running the command, reinforcing understanding.
- The command remains immediately usable even if the learner skips the annotation panel.

This policy is non-negotiable. Do not use tooltips or collapsible panels for annotation content. If you need a collapsible wrapper, it belongs on the `ExerciseCard` level (the full exercise), not the annotation panel.

---

## 2. Token Format Rules

The `token` field identifies exactly which part of the command is being annotated.

**Flags with a leading dash:**
- Short flags: `-l`, `-r`, `-a`, `-v`
- Long flags: `--recursive`, `--all`, `--verbose`, `--format=json`
- Flags with attached values: `--output=file.txt`, `-n 10`

**Positional arguments:**
- Relative paths: `.` (current directory), `..` (parent directory), `./src`
- Absolute paths: `/etc/hosts`, `/var/log/syslog`
- Literal values: `80` (port number), `root` (username), `nginx` (service name)

**Subcommands:**
- `ps` in `docker ps`
- `status` in `git status`
- `commit` in `git commit`

**Combined short flags:**
Do not annotate combined flags as a unit. Split them and annotate each separately.

| Command fragment | Incorrect | Correct |
|-----------------|-----------|---------|
| `ls -la` | `-la: long format, all files` | Two annotations: `-l` and `-a` |
| `tar -xzf` | `-xzf: extract, gzip, file` | Three annotations: `-x`, `-z`, `-f` |

The base command (`ls`, `grep`, `docker`) is always the first token. It must be annotated to orient learners who have never seen the command.

---

## 3. Description Rules

The `description` field explains what the token does to a learner encountering it for the first time.

**Length limit:** Maximum 120 characters. If you cannot explain the flag in 120 characters, split the explanation into `description` + `example`.

**Plain prose only.** Forbidden characters in description values:
- Backticks `` ` `` — these break MDX parsing when annotations are written inline
- Curly braces `{}` — these break MDX parsing when annotations are written inline
- Angle brackets `<>` — these break MDX parsing when annotations are written inline
- Unescaped double quotes `"` — these break MDX parsing when annotations are written inline

**Start with a verb.** The first word must be an imperative or third-person present-tense verb:
- "Lists", "Filters", "Specifies", "Enables", "Suppresses", "Sets", "Prints", "Shows", "Writes"

**Explain what the flag DOES, not what it IS.** The description must state the effect on the program's behavior.

| Incorrect (names the flag) | Correct (describes the effect) |
|---------------------------|-------------------------------|
| "Long format flag" | "Lists files in long format showing permissions, owner, size, and modification date" |
| "Recursive option" | "Processes all files and subdirectories within the target path, not just the immediate contents" |
| "Verbose mode" | "Prints each action as it is performed so you can follow what the command is doing" |

**Self-sufficiency standard:** After reading the annotation, a learner must never need to run `man` or google the flag to understand what it does in this context. If the annotation leaves the learner with a question, rewrite it.

---

## 4. Example Field (Optional)

The `example` field provides a concrete illustration of the flag's effect. It is always optional.

When to include an example:
- When the description alone is abstract ("Specifies the output format")
- When a concrete value clarifies the effect that prose cannot ("Maps host port 8080 to container port 80" for `-p 8080:80`)
- When showing the difference between "with" and "without" the flag is educational

Examples must follow the same character restrictions as descriptions: no backticks, no curly braces, no angle brackets, no unescaped double quotes.

---

## 5. Ordering

Annotations in the `annotations` array must appear in the same order the tokens appear in the command string, reading left to right.

Order: base command first, then subcommand (if any), then flags in left-to-right order, then positional arguments.

Example — `docker run -d -p 8080:80 nginx`:
1. `docker` — the base command
2. `run` — the subcommand
3. `-d` — first flag
4. `-p` — second flag
5. `nginx` — positional argument (image name)

Do not re-order annotations for "logical" grouping. The left-to-right order matches how a learner reads the command and lets them find the annotation for any token by scanning downward.

---

## 6. Completeness Rule

Every token in the command must be annotated — no partial annotations allowed.

If a command has 5 flags, all 5 must have `CommandAnnotation` entries. If a command uses a subcommand, the subcommand must be annotated. If a command ends with a positional argument, the argument must be annotated.

The `annotated={true}` gate on `ExerciseCard` ensures that exercises with incomplete annotations never show annotation UI to learners. Use this gate:

1. Only add `annotated={true}` to an `ExerciseCard` after ALL steps in that exercise have complete `annotations` arrays.
2. Do not add `annotated={true}` to exercises where some steps have commands with no annotations yet.
3. Complete one module fully before starting the next. Do not leave a module in a partial state.
4. The `annotated` prop is a migration gate — it will be removed once full coverage is achieved across all Foundation lessons. Do not treat it as a permanent feature toggle.

**Audit check:** Before setting `annotated={true}`, count the tokens in each command and verify that `annotations.length` matches the token count for every step.

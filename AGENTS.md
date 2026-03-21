# AGENTS.md

## Build / Lint / Test Commands

### Local Development

```bash
# Start the dashboard server
cd dashboard
npm install
node server.js

# Run single test
node test-feishu-webhook.js

# Clean environment
npm run clean
```

### Docker Commands

```bash
# Build Docker image
make build

# Start services
make up

# Stop services
make down

# View logs
make logs

# Rebuild and restart
make rebuild
```

### Running a Single Test

```bash
# Test Feishu webhook integration
node dashboard/test-feishu-webhook.js
```

---

## Code Style Guidelines

### Core Principles

- **Vanilla JavaScript** — No frameworks, no build step, no bundlers
- **ES Modules** for frontend (imports/exports)
- **CommonJS** for backend (require/module.exports)
- **File-based state** — JSON + Markdown, no database
- **Dark theme**, mobile-responsive design

### Formatting

- **No semicolons** (project convention)
- **2 spaces** indentation
- **Single quotes** for strings
- **Arrow functions** preferred
- **Trailing commas** in objects/arrays

### Naming Conventions

- **Functions/Variables**: `camelCase`
  - `buildFileTree`, `readTasksFile`, `activeProject`
- **Constants**: `UPPER_SNAKE_CASE`
  - `API_HOST`, `PRIORITY_ORDER`, `STATUS_KEYS`
- **Classes**: `PascalCase` (if used)
- **Files**: `kebab-case`
  - `file-explorer.js`, `kanban.js`, `utils.js`
- **IDs**: `PREFIX-XXX` (e.g., `T-001`, `N-001`)

### Import Style

**Frontend (ES Modules):**
```javascript
import { api, toast } from './utils.js?v=6'
import { kanbanState, buildBoard } from './kanban.js?v=23'
```

**Backend (CommonJS):**
```javascript
const express = require('express')
const fs = require('fs')
```

### Variable Declarations

- **`const`** over `let`, **no `var`**
- Use `let` only when reassignment is needed
- Declare at the top of functions when possible

### Error Handling

- Use `try/catch` for file operations and async code
- Return error objects or status codes in API responses
- Use `console.warn()` for non-critical issues
- Use `console.error()` for critical failures

Example:
```javascript
try {
  const data = JSON.parse(fs.readFileSync(file, 'utf8'))
  return data
} catch (err) {
  console.warn('[readFile]', err.message)
  return null
}
```

### API Response Format

Success:
```javascript
res.json({ ok: true, data: result })
```

Error:
```javascript
res.status(400).json({ error: 'Error message' })
```

### File Structure

```
dashboard/
├── server.js           # Express API + auth
├── index.html          # SPA shell
├── js/
│   ├── app.js          # Main app, routing, sidebar
│   ├── kanban.js       # Kanban board logic
│   ├── file-explorer.js # File browser logic
│   ├── utils.js        # Shared helpers
│   └── canvas/         # Idea Canvas modules
└── styles/
    ├── dashboard.css   # Global styles
    └── canvas.css      # Canvas-specific styles
```

### Security Best Practices

- Use environment variables for secrets (never hardcode)
- Implement rate limiting on API endpoints
- Validate and sanitize user input
- Prevent path traversal attacks
- Use JWT for authentication with secure secrets

### Comments

- Keep comments minimal and meaningful
- Use JSDoc for function documentation
- Add inline comments for complex logic
- No comments for obvious code

### Dependencies

- **Avoid adding dependencies** unless there's a clear, significant win
- Prefer native Node.js APIs over external packages
- Use built-in browser APIs when possible
- Keep `package.json` lightweight

### Project-Specific Patterns

- **Task IDs**: `T-{number}` (e.g., `T-001`, `T-002`)
- **Note IDs**: `N-{number}` (e.g., `N-001`, `N-002`)
- **Subtask IDs**: `{parentId}-{number}` (e.g., `T-001-1`)
- **Status workflow**: `open → in-progress → review → done`
- **Priority levels**: `high`, `medium`, `low`
- **Spec files**: `specs/{taskId}-{slug}.md`

### Testing

- Test scripts use `node test-*.js` pattern
- Integration tests verify webhook connections
- Manual testing required for UI changes

---

## Development Workflow

```bash
# Create feature branch
git checkout dev
git checkout -b feat/my-feature

# Make changes and test locally
cd dashboard
npm install
node server.js

# Commit changes
git add .
git commit -m "feat: description"
```

---

**Author**: hehuosheng
**Version**: 1.0.0
**Last Updated**: 2026-03-21

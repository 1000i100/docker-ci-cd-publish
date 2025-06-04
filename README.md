# docker-ci-cd-publish

Bun Alpine image with rsync, openssh, git, ftp, zip, tar, and browser testing capabilities

https://github.com/1000i100/docker-ci-cd-publish

https://hub.docker.com/r/1000i100/docker-ci-cd-publish

Last update : 04/06/2025

## Features

- **Runtime**: Bun (fast JavaScript/TypeScript runtime)
- **Base**: Alpine Linux (lightweight)
- **CI/CD Tools**: rsync, openssh-client, git, lftp, tar, zip, bash
- **Testing**: Vitest, Jest, Playwright
- **Browser Support**: Chromium, Firefox, WebKit (Safari)
- **Package Manager**: Bun (built-in)

## Usage

### Basic Docker Usage

```bash
# Pull the image
docker pull 1000i100/docker-ci-cd-publish

# Run interactive container
docker run -it 1000i100/docker-ci-cd-publish /bin/bash

# Mount your project and run tests
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bun test
```

## Testing Examples

### Project Structure
```
your-project/
├── src/
│   ├── code.ts
│   └── code.test.ts
├── package.json
└── vitest.config.ts
```

### 1. Basic Vitest Configuration

**vitest.config.ts**
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'node', // or 'bun'
  },
})
```

### 2. Example Source Code

**src/code.ts**
```typescript
export function add(a: number, b: number): number {
  return a + b
}

export function multiply(a: number, b: number): number {
  return a * b
}

export async function fetchData(url: string): Promise<any> {
  const response = await fetch(url)
  return response.json()
}
```

### 3. Basic Unit Tests

**tests/code.test.ts**
```typescript
import { describe, it, expect } from 'vitest'
import { add, multiply, fetchData } from '../src/code'

describe('Math Functions', () => {
  it('should add two numbers', () => {
    expect(add(2, 3)).toBe(5)
  })

  it('should multiply two numbers', () => {
    expect(multiply(4, 5)).toBe(20)
  })
})

describe('Async Functions', () => {
  it('should fetch data', async () => {
    // Mock or use actual API
    const data = await fetchData('https://api.example.com/data')
    expect(data).toBeDefined()
  })
})
```

### 4. Testing with Bun Runtime

```bash
# Install dependencies
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bun install

# Run tests with Bun runtime
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bun test

# Run specific test file
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bun test tests/code.test.ts
```

### 5. Testing with Node.js Runtime

**vitest.config.node.ts**
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
  },
})
```

```bash
# Run tests with Node.js environment
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bunx vitest --config vitest.config.node.ts
```

### 6. Browser Testing with @vitest/browser

**vitest.config.browser.ts**
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    browser: {
      enabled: true,
      name: 'chromium', // or 'firefox', 'webkit'
      provider: 'playwright',
      headless: true,
    },
  },
})
```

### 7. DOM Testing Example

**tests/dom.test.ts**
```typescript
import { describe, it, expect } from 'vitest'

describe('DOM Tests', () => {
  it('should create and manipulate DOM elements', () => {
    // This runs in actual browser environment
    const div = document.createElement('div')
    div.textContent = 'Hello World'
    document.body.appendChild(div)

    expect(document.querySelector('div')?.textContent).toBe('Hello World')
  })

  it('should handle events', () => {
    const button = document.createElement('button')
    let clicked = false

    button.addEventListener('click', () => {
      clicked = true
    })

    button.click()
    expect(clicked).toBe(true)
  })
})
```

### 8. Multi-Browser Testing Commands

```bash
# Test with Chromium (Chrome)
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bunx vitest --config vitest.config.browser.ts --browser.name=chromium

# Test with Firefox
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bunx vitest --config vitest.config.browser.ts --browser.name=firefox

# Test with WebKit (Safari)
docker run -v $(pwd):/workspace -w /workspace 1000i100/docker-ci-cd-publish bunx vitest --config vitest.config.browser.ts --browser.name=webkit
```

### 9. Complete Multi-Browser Configuration

**vitest.config.multi-browser.ts**
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    browser: {
      enabled: true,
      provider: 'playwright',
      headless: true,
      instances: [
        {
          browser: 'chromium',
        },
        {
          browser: 'firefox',
        },
        {
          browser: 'webkit',
        },
      ],
    },
  },
})
```

### 10. Package.json Scripts

**package.json**
```json
{
  "scripts": {
    "test": "vitest",
    "test:bun": "bun test",
    "test:node": "vitest --config vitest.config.node.ts",
    "test:browser": "vitest --config vitest.config.browser.ts",
    "test:chrome": "vitest --config vitest.config.browser.ts --browser.name=chromium",
    "test:firefox": "vitest --config vitest.config.browser.ts --browser.name=firefox",
    "test:safari": "vitest --config vitest.config.browser.ts --browser.name=webkit",
    "test:all": "vitest --config vitest.config.multi-browser.ts"
  },
  "devDependencies": {
    "vitest": "latest",
    "@vitest/browser": "latest",
    "playwright": "latest"
  }
}
```

### 11. CI/CD Integration

**docker-compose.test.yml**
```yaml
version: '3.8'
services:
  test:
    image: 1000i100/docker-ci-cd-publish
    volumes:
      - .:/workspace
    working_dir: /workspace
    command: bun run test:all
```

## Available Tools

- **bun**: Fast JavaScript runtime and package manager
- **bunx**: Execute packages (like npx)
- **vitest**: Fast unit test framework
- **playwright**: End-to-end testing framework
- **git**: Version control
- **rsync**: File synchronization
- **openssh-client**: SSH client for remote operations
- **lftp**: Advanced FTP client
- **tar**: Archive utility
- **zip**: Compression utility

## Environment Variables

- `PLAYWRIGHT_BROWSERS_PATH=/usr/bin`: Use system browsers
- `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`: Skip browser download

## Building the Image

```bash
docker build -t your-name/docker-ci-cd-publish .
```

## License

This project is licensed under the same terms as the original project.

# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: api.spec.ts >> health endpoint
- Location: api.spec.ts:3:1

# Error details

```
TypeError: apiRequestContext.get: Invalid URL
```

# Test source

```ts
  1 | import { test, expect } from '@playwright/test';
  2 | 
  3 | test('health endpoint', async ({ request }) => {
> 4 |   const res = await request.get('/health');
    |                             ^ TypeError: apiRequestContext.get: Invalid URL
  5 |   expect (res.status()).toBe(200);
  6 | }); 
```
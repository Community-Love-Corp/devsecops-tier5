import { test, expect } from '@playwright/test';

test('health endpoint', async ({ request }) => {
  const url = new URL ('/health', process.env.API_URL).toString();
  const res = await request.get(url);
  expect (res.status()).toBe(200);
}); 



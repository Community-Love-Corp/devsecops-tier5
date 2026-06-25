import { test, expect } from '@playwright/test';
import { allure } from 'allure-playwright';
test('health endpoint', async ({ request }) => {
  const base = process.env.API_URL ?? 'http://localhost:9999';
  const url = new URL ('/health', base).toString();
  await allure.step(`Calling ${url}`, async () => {
    const res = await request.get(url);   
    expect(res.status()).toBe(200);
  });
  
//  const res = await request.get(url);
//  expect (res.status()).toBe(200);
}); 

test('dummy test', async () => {
  await allure.step(`Validate stub`, async () => {
    expect(true).toBe(true);
  });
});




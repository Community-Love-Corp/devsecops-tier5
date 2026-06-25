import { defineConfig } from '@playwright/test';

export default defineConfig ({
  use: {
   baseURL: process.env.API_URL, 
  },
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['allure-playwright']
  ],
});
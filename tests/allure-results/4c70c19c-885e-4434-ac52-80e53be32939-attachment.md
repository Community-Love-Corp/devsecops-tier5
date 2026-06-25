# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: api.spec.ts >> health endpoint
- Location: api.spec.ts:3:1

# Error details

```
Error: apiRequestContext.get: connect ECONNREFUSED ::1:9999
Call log:
  - → GET http://localhost:9999/health
    - user-agent: Playwright/1.61.0 (x64; kali 2024.2) node/22.23
    - accept: */*
    - accept-encoding: gzip,deflate,br

```
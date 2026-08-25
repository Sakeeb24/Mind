import { test, expect } from '@playwright/test';

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';

test.describe('MindSpace E2E Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(BASE_URL);
    await page.waitForLoadState('networkidle');
  });

  test('Login screen renders correctly', async ({ page }) => {
    // Check title
    await expect(page.locator('text=Welcome Back')).toBeVisible();
    await expect(page.locator('text=Sign in to continue studying')).toBeVisible();
    
    // Check form fields
    await expect(page.locator('input[placeholder*="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    
    // Check buttons
    await expect(page.locator('text=Sign In')).toBeVisible();
    await expect(page.locator('text=Continue with Google')).toBeVisible();
    
    // Check sign up link
    await expect(page.locator('text=Sign Up')).toBeVisible();
  });

  test('Sign Up screen navigation works', async ({ page }) => {
    // Click Sign Up link
    await page.click('text=Sign Up');
    await page.waitForLoadState('networkidle');
    
    // Check sign up screen
    await expect(page.locator('text=Create Account')).toBeVisible();
    await expect(page.locator('text=Start your free study assistant')).toBeVisible();
    
    // Check form fields
    await expect(page.locator('input[placeholder*="name"]')).toBeVisible();
    await expect(page.locator('input[placeholder*="email"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
  });

  test('Forgot password navigation works', async ({ page }) => {
    // Click forgot password
    await page.click('text=Forgot password');
    await page.waitForLoadState('networkidle');
    
    // Check forgot password screen
    await expect(page.locator('text=Reset Password')).toBeVisible();
  });

  test('Dashboard shows empty state', async ({ page }) => {
    // Login with mock credentials (will redirect to dashboard)
    await page.fill('input[placeholder*="email"]', 'test@example.com');
    await page.fill('input[type="password"]', 'password123');
    await page.click('text=Sign In');
    
    // Wait for navigation
    await page.waitForLoadState('networkidle');
    
    // Check dashboard elements
    await expect(page.locator('text=MindSpace')).toBeVisible();
    await expect(page.locator('text=Search documents')).toBeVisible();
  });

  test('Document viewer renders', async ({ page }) => {
    // Navigate to viewer (would need a document first)
    // This test verifies the viewer screen structure
    await page.goto(`${BASE_URL}/viewer/test-doc`);
    await page.waitForLoadState('networkidle');
    
    // Check viewer elements
    await expect(page.locator('text=Page 1')).toBeVisible();
    await expect(page.locator('text=Prev')).toBeVisible();
    await expect(page.locator('text=Next')).toBeVisible();
  });

  test('AI Chat screen renders', async ({ page }) => {
    // Navigate to AI chat
    await page.goto(`${BASE_URL}/ai-chat`);
    await page.waitForLoadState('networkidle');
    
    // Check chat elements
    await expect(page.locator('text=AI Chat')).toBeVisible();
    await expect(page.locator('input[placeholder*="Ask"]')).toBeVisible();
  });

  test('AI Summary screen renders', async ({ page }) => {
    // Navigate to AI summary
    await page.goto(`${BASE_URL}/summary`);
    await page.waitForLoadState('networkidle');
    
    // Check summary elements
    await expect(page.locator('text=AI Summary')).toBeVisible();
    await expect(page.locator('text=Generate Summary')).toBeVisible();
    await expect(page.locator('text=This Page')).toBeVisible();
    await expect(page.locator('text=Section')).toBeVisible();
    await expect(page.locator('text=Selection')).toBeVisible();
  });

  test('Navigation between screens works', async ({ page }) => {
    // Start at login
    await expect(page.locator('text=Welcome Back')).toBeVisible();
    
    // Go to sign up
    await page.click('text=Sign Up');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('text=Create Account')).toBeVisible();
    
    // Go back to login
    await page.click('text=Sign In');
    await page.waitForLoadState('networkidle');
    await expect(page.locator('text=Welcome Back')).toBeVisible();
  });

  test('Form validation works', async ({ page }) => {
    // Try to submit empty form
    await page.click('text=Sign In');
    
    // Should show validation errors
    await expect(page.locator('text=Required')).toBeVisible();
  });

  test('Responsive layout works', async ({ page }) => {
    // Test mobile viewport
    await page.setViewportSize({ width: 375, height: 812 });
    await page.reload();
    await page.waitForLoadState('networkidle');
    
    // Check that elements are still visible
    await expect(page.locator('text=Welcome Back')).toBeVisible();
    await expect(page.locator('text=Sign In')).toBeVisible();
  });
});

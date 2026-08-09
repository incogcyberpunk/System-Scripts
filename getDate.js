import { chromium } from "playwright";

(
    async () => {
        const browser = await chromium.launch({ headless: true });
        const context = await browser.newContext();

        const page = await context.newPage();
        await page.goto("https://hamropatro.com/date-converter")
        const date = await page.locator('div > p.font-np.text-title-lg.font-bold.text-primary').allTextContents();
        console.log(date[0])

        await browser.close();
        await process.exit(0);
    }
)();

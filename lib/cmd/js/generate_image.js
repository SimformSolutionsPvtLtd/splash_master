const puppeteer = require('puppeteer');
const fs = require('fs');

(async () => {
    // Get the Lottie file path from command-line arguments
    const lottieFilePath = process.argv[2];
    const outputLocation = process.argv[3];
    const height = parseInt(process.argv[4],10);
    const width = parseInt(process.argv[5],10);

    const workingDir = process.cwd()

    if (!lottieFilePath) {
        console.error('Please provide a path to the Lottie JSON file.');
        process.exit(1);
    }

    // Load the Lottie JSON file
    const lottieAnimationData = require(workingDir + '/' + lottieFilePath);

    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.setViewport({ width: width, height: height });

    // Set up the HTML content with a container for Lottie
    const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.2/lottie.min.js"></script>
            <style>
                            body {
                                margin: 0; /* Remove default body margin */
                                overflow: hidden; /* Prevent scrollbars */
                                background: transparent; /* Set background to transparent */
                            }
                            #lottie {
                                width: 100%;
                                height: 100%;
                            }
                        </style>
        </head>
        <body>
            <div id="lottie" style="width: 100%; height: 100%;"></div>
            <script>
                const animationData = ${JSON.stringify(lottieAnimationData)};
                const lottieContainer = document.getElementById('lottie');
                const lottieAnimation = lottie.loadAnimation({
                    container: lottieContainer,
                    renderer: 'svg',
                    loop: false,
                    autoplay: false,
                    animationData: animationData,
                    height: ${height},
                    width: ${width},
                });
            </script>
        </body>
        </html>
    `;

    // Set the content of the page to the generated HTML
    await page.setContent(htmlContent);

    // Wait for the animation to render (alternative delay method)
    await page.evaluate(() => new Promise(resolve => {
            const waitForAnimation = () => {
                const lottieContainer = document.getElementById('lottie');
                if (lottieContainer.children.length > 0) {
                    resolve();
                } else {
                    setTimeout(waitForAnimation, 50); // Check every 50ms
                }
            };
            waitForAnimation();
        })); // Wait for the animation to load

    // Create a screenshot from the animation
    const image = await page.screenshot();

    const saveLocation = workingDir + '/' +outputLocation

    // Save the image
    fs.writeFileSync(saveLocation, image);
    console.log(`Image saved at ${saveLocation}`);

    await browser.close();
})();

const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://h3pniu4x6kr2dv2u7mhgyad3se0ovypn.lambda-url.us-east-1.on.aws/"
    );
    let data = await response.json();
    counter.innerHTML = `Visitors: ${data}`;
}
updateCounter();
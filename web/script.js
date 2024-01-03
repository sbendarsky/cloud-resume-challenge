const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch(
        "https://rrch6yoqsmpsln5qbissoy3vk40jnglm.lambda-url.us-east-1.on.aws/"
    );
    let data = await response.json();
    counter.innerHTML = `Visitors: ${data}`;
}
updateCounter();
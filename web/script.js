const counter = document.querySelector(".counter-number");

async function updateCounter() {
    try {
        // Fetch the URL mentioned in api.txt
        let response = await fetch("./api.txt");
        
        if (!response.ok) {
            throw new Error(`Failed to fetch the URL from api.txt. Status: ${response.status}`);
        }

        // Read the text file content (which is a URL)
        let apiUrl = await response.text();

        // Fetch data from the specified URL
        let dataResponse = await fetch(apiUrl);

        if (!dataResponse.ok) {
            throw new Error(`Failed to fetch data from the specified URL. Status: ${dataResponse.status}`);
        }

        // Parse the content as needed (assuming it contains a number)
        let data = await dataResponse.json();

        // Update the counter with the retrieved data
        counter.innerHTML = `Visitors: ${data}`;
    } catch (error) {
        console.error("An error occurred while updating the counter:", error.message);
    }
}

updateCounter();

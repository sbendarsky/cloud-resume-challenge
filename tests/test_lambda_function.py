import json
import requests
import pytest

# Replace this URL with your Lambda function URL
LAMBDA_URL = "https://aon7cp4yadxpwhaunz5cj55qcy0qlsux.lambda-url.us-east-1.on.aws/"

@pytest.fixture
def lambda_url():
    return LAMBDA_URL

def test_lambda_function(lambda_url):
    # Prepare a sample event (you may need to adjust this based on your actual Lambda function input)
    event = {"key": "value"}

    # Send a POST request to the Lambda function
    response = requests.post(lambda_url, data=json.dumps(event))

    # Check if the request was successful (status code 200)
    assert response.status_code == 200

    try:
        result = response.json()
        if isinstance(result, int):
            result = {"views": result}
        assert "views" in result
        assert isinstance(result["views"], int)

    except json.JSONDecodeError:
        # Handle the case where the response is not a valid JSON
        pytest.fail("Response is not a valid JSON")

if __name__ == "__main__":
    pytest.main()

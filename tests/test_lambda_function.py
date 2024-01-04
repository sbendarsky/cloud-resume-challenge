import json
import requests
import pytest

def get_lambda_url():
    api_url = "https://resume.sbendarsky.me/api.txt"
    response = requests.get(api_url)
    if response.status_code == 200:
        return response.text.strip()
    else:
        raise ValueError(f"Failed to fetch Lambda URL. Status code: {response.status_code}")

@pytest.fixture
def lambda_url():
    return get_lambda_url()

def test_lambda_function(lambda_url):
    event = {}
    response = requests.post(lambda_url, data=json.dumps(event))
    assert response.status_code == 200

    try:
        result = response.json()
        assert "views" in result
        assert isinstance(result["views"], int)
    except json.JSONDecodeError:
        pytest.fail("Response is not a valid JSON")

if __name__ == "__main__":
    pytest.main()
# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
import requests
import json
from firebase_admin import initialize_app

initialize_app()

@https_fn.on_request()
def get_food_details(request: https_fn.Request) -> https_fn.Response:
    fdcId = request.args.get('fdcId', '')  # Retrieve the fdcId from the query parameters
    api_key = 'KnbgdtX65ISaS5jKyDefHDsbrfiVOUKULfHgZMS0'
    details_url = f'https://api.nal.usda.gov/fdc/v1/food/{fdcId}?api_key={api_key}'
    
    details_response = requests.get(details_url)
    if details_response.status_code == 200:
        details_data = details_response.json()
        
        # Extract specific fields from the response
        extracted_data = {
            'publicationDate': details_data.get('publicationDate'),
            'foodNutrients': details_data.get('foodNutrients', []),
            'brandOwner': details_data.get('brandOwner'),
            'brandName': details_data.get('brandName'),
            'brandedFoodCategory': details_data.get('brandedFoodCategory'),
            'householdServingFullText': details_data.get('householdServingFullText'),
            'ingredients': details_data.get('ingredients'),
            'packageWeight': details_data.get('packageWeight'),
            'notaSignificantSourceOf': details_data.get('notaSignificantSourceOf'),
            'labelNutrients': details_data.get('labelNutrients', []),
        }
        return https_fn.Response(json.dumps(extracted_data), status=200, headers={'Content-Type': 'application/json'})
    else:
        return https_fn.Response('Failed to retrieve food details', status=details_response.status_code)



@https_fn.on_request()
def search_food(request: https_fn.Request) -> https_fn.Response:
    query = request.args.get('query', '')
    api_key = 'KnbgdtX65ISaS5jKyDefHDsbrfiVOUKULfHgZMS0'
    search_url = f'https://api.nal.usda.gov/fdc/v1/foods/search?api_key={api_key}&query={query}&pageSize=30'
    
    search_response = requests.get(search_url)
    if search_response.status_code == 200:
        search_data = search_response.json()
        formatted_results = [
            {
                'brandName': item.get('brandOwner'),
                'description': item.get('description', 'No description available'),
                'brandOwner': item.get('brandOwner'),
                'fdcId': item.get('fdcId'),  # Include the fdcId in the response
                'gtinUpc': item.get('gtinUpc', 'No UPC available')  # Include the gtinUpc in the response
            }
            for item in search_data.get('foods', [])
            if item.get('brandOwner') and item.get('brandOwner') != 'Unknown Brand'  # Filter out unknown brands and owners
        ][:30]  # Ensure only up to 30 items are included even if more are fetched
        return https_fn.Response(json.dumps(formatted_results), status=200, headers={'Content-Type': 'application/json'})
    else:
        return https_fn.Response('Failed to retrieve data', status=500)


# Deploy these functions using `firebase deploy` in the Firebase CLI

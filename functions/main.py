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
    
@https_fn.on_request()
def generate_food_analysis(request: https_fn.Request) -> https_fn.Response:
    fdcId = request.args.get('fdcId', '')
    if not fdcId:
        return https_fn.Response('Missing fdcId parameter', status=400)

    api_key_food = 'KnbgdtX65ISaS5jKyDefHDsbrfiVOUKULfHgZMS0'
    food_details_url = f'https://api.nal.usda.gov/fdc/v1/food/{fdcId}?api_key={api_key_food}'
    
    details_response = requests.get(food_details_url)
    if details_response.status_code != 200:
        return https_fn.Response('Failed to retrieve food details', status=details_response.status_code)
    
    food_details = details_response.json()

    # Assuming you have the food details in the required format, now generate the content
    gen_api_key = 'AIzaSyDEcqPIsunXJGt7AqT_-7uumdVDoovGZbs'
    gen_response = generate_content(gen_api_key, food_details)
    
    if isinstance(gen_response, dict):
        return https_fn.Response(json.dumps(gen_response), status=200, headers={'Content-Type': 'application/json'})
    else:
        return https_fn.Response('Failed to generate analysis', status=500)

def generate_content(api_key, food_details):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={api_key}"
    headers = {'Content-Type': 'application/json'}
    
    prompt_text = (
                    "You are acting as a health advisor analyzing a food product. Please analyze all the provided information "
                    "and return a detailed analysis in a JSON format with the following keys. Please store items with ':' as a key, "
                    "and items in '[]' as a value. In the response, do not include anything such as the word JSON literal and "
                    "DO NOT INCLUDE ANY * or ** or ***. I want this response to be easily parsable for later usage:"
                    "    Brand: [Brand Name]"
                    "    Ingredients: [Ingredients List]"
                    "    Potential Allergens: [List Potential Allergens, or 'None' if not apparent from ingredients]"
                    "    Health Evaluation: "
                    "        Positives: [Highlight potential benefits.]"
                    "        Negatives: [Highlight potential drawbacks or concerns.]"
                    "        Considerations: [Additional factors to keep in mind.]"
                    "    Disclaimers: [Include any necessary disclaimers regarding individual health or dietary restrictions.]"
                    "    Dietary Suitability: "
                    "        Vegan: [Yes/No]"
                    "        Vegetarian: [Yes/No]"
                    "        Gluten-Free: [Yes/No - Or indicate if it cannot be determined from the provided ingredients]"
                    "        Keto: [Yes/No]"
                    "        Diabetic: [Suitable, Suitable with moderation, Not suitable - Explain briefly]"
                    "    Overall Analysis: Provide a concise two-paragraph summary. In the first paragraph, outline the product's "
                    "suitability for weight management and sugar control, alongside any notable benefits. In the second paragraph, "
                    "address potential health concerns, long-term effects of ingredients, and suggest healthier alternatives where relevant."
                    "Please analyze the following product: " + json.dumps(food_details)
    )
    
    data = {
        "contents": [{
            "parts": [{"text": prompt_text}]
        }]
    }
    
    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        text_response = response.json()['candidates'][0]['content']['parts'][0]['text']
        parsed_data = parse_health_analysis(text_response)
        return parsed_data
    else:
        return {'error': response.status_code, 'message': response.text}
    
def parse_health_analysis(text):
    data = {}
    lines = text.split('\n')
    current_key = None
    buffer = []

    def commit_data():
        if current_key and buffer:
            # Clean the key by stripping leading/trailing whitespace and quotes
            cleaned_key = current_key.strip(' "')
            # Join the buffer into a single string if it's a multi-line value
            if len(buffer) == 1:
                data[cleaned_key] = buffer[0].strip(' ",')
            else:
                data[cleaned_key] = [line.strip(' ",') for line in buffer if line.strip(' ",')]
        buffer.clear()

    for line in lines:
        if ':' in line and not line.startswith('  - '):  # Checks if the line is a key and not a list item
            commit_data()  # Commit the previous key and its values to the dictionary
            current_key, _, remainder = line.partition(':')
            buffer = [remainder.strip()] if remainder else []
        else:
            buffer.append(line.strip())

    commit_data()  # Ensure the last key-value pair is added to the dictionary

    return data


# Deploy these functions using `firebase deploy` in the Firebase CLI

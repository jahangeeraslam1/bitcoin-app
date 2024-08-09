# app.py

from flask import Flask, render_template, jsonify
import requests
from datetime import datetime
import logging
from flask_caching import Cache
import os

app = Flask(__name__)

# Use simple in-memory caching
cache = Cache(app, config={'CACHE_TYPE': 'simple'})

# Set up logging
logging.basicConfig(level=logging.INFO)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/get_price')
@cache.cached(timeout=10)  # Cache for 10 seconds
def get_price():
    try:
        response = requests.get('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,gbp,eur', timeout=10)
        response.raise_for_status()
        data = response.json()

        price_usd = data['bitcoin']['usd']
        price_gbp = data['bitcoin']['gbp']
        price_eur = data['bitcoin']['eur']
        last_updated = datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')

        return jsonify({
            'price_usd': price_usd,
            'price_gbp': price_gbp,
            'price_eur': price_eur,
            'last_updated': last_updated
        })
    except requests.RequestException as e:
        app.logger.error(f"Request error: {str(e)}")
        return jsonify({'error': 'Failed to fetch price data'}), 503
    except KeyError as e:
        app.logger.error(f"Unexpected API response format: {str(e)}")
        return jsonify({'error': 'Unexpected API response format'}), 500
    except Exception as e:
        app.logger.error(f"Unexpected error: {str(e)}")
        return jsonify({'error': 'An unexpected error occurred'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8000)))
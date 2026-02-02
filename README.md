# Translator Payment Backend

Backend server for handling Paystack payments for the Translator Extension.

## Setup

1. **Install dependencies:**
   ```bash
   cd backend
   npm install
   ```

2. **Create `.env` file** (copy from `.env.example`):
   ```bash
   cp .env.example .env
   ```

3. **Add your Paystack credentials:**
   - Sign up at https://paystack.com
   - Get your Secret Key from Dashboard → Settings → API Keys & Webhooks
   - Add it to `.env`:
     ```
     PAYSTACK_SECRET_KEY=sk_test_xxxxx...
     ```

4. **Run the server:**
   ```bash
   npm start
   ```

   For development with auto-reload:
   ```bash
   npm run dev
   ```

## API Endpoints

### Initialize Payment
- **Endpoint:** `POST /api/payment/initialize`
- **Body:**
  ```json
  {
    "email": "user@example.com",
    "amount": 1999
  }
  ```
- **Response:**
  ```json
  {
    "status": true,
    "data": {
      "authorization_url": "https://checkout.paystack.com/...",
      "access_code": "xxxxx",
      "reference": "xxxxx"
    }
  }
  ```

### Verify Payment
- **Endpoint:** `GET /api/payment/verify/:reference`
- **Response:** (on success)
  ```json
  {
    "status": true,
    "message": "Payment verified successfully",
    "data": {
      "licenseKey": "TRX-xxxxx-xxxxx",
      "email": "user@example.com"
    }
  }
  ```

### Validate License
- **Endpoint:** `POST /api/license/validate`
- **Body:**
  ```json
  {
    "licenseKey": "TRX-xxxxx-xxxxx"
  }
  ```
- **Response:**
  ```json
  {
    "status": true,
    "message": "License valid",
    "data": {
      "email": "user@example.com",
      "expiresAt": "2025-01-19T10:00:00.000Z"
    }
  }
  ```

## Deployment

For production, use:
- Heroku: `git push heroku main`
- Railway: Connect your GitHub repo
- Render: Deploy from GitHub
- Google Cloud Run: Deploy as containerized service

Make sure to use production Paystack keys and a real database (MongoDB, PostgreSQL) instead of in-memory storage.

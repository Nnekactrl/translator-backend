const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin) return callback(null, true);
    
    // Allow chrome extensions
    if (origin.startsWith('chrome-extension://')) return callback(null, true);
    
    // Allow localhost for development
    if (origin.includes('localhost')) return callback(null, true);
    
    // Allow your deployed frontend URL (add your actual deployed URL here)
    const allowedOrigins = [
      'https://your-deployed-extension-backend.com', // Replace with your actual deployed URL
      'https://translator-extension-backend.herokuapp.com', // Example Heroku URL
      'https://translator-extension-backend.onrender.com', // Example Render URL
    ];
    
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true
}));
app.use(express.json());

const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;
const PAYSTACK_BASE_URL = 'https://api.paystack.co';

// Store for license keys (in production, use a database)
const licenses = new Map();

/**
 * Initialize Paystack payment
 * POST /api/payment/initialize
 */
app.post('/api/payment/initialize', async (req, res) => {
  try {
    const { email, amount } = req.body;

    if (!email || !amount) {
      return res.status(400).json({ error: 'Email and amount required' });
    }

    // Amount should be in kobo (1 NGN = 100 kobo)
    const amountInKobo = amount * 100;

    const response = await axios.post(
      `${PAYSTACK_BASE_URL}/transaction/initialize`,
      {
        email,
        amount: amountInKobo,
        metadata: {
          product: 'translator_premium'
        }
      },
      {
        headers: {
          Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    res.json({
      status: true,
      data: {
        authorization_url: response.data.data.authorization_url,
        access_code: response.data.data.access_code,
        reference: response.data.data.reference
      }
    });
  } catch (error) {
    console.error('Payment initialization error:', error.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to initialize payment',
      details: error.response?.data?.message || error.message
    });
  }
});

/**
 * Verify Paystack payment
 * GET /api/payment/verify/:reference
 */
app.get('/api/payment/verify/:reference', async (req, res) => {
  try {
    const { reference } = req.params;

    if (!reference) {
      return res.status(400).json({ 
        status: false,
        error: 'Reference required' 
      });
    }

    const response = await axios.get(
      `${PAYSTACK_BASE_URL}/transaction/verify/${reference}`,
      {
        headers: {
          Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`
        }
      }
    );

    if (response.data.data.status === 'success') {
      // Generate license key
      const licenseKey = generateLicenseKey();
      const email = response.data.data.customer.email;

      // Store license
      licenses.set(licenseKey, {
        email,
        reference,
        createdAt: new Date(),
        expiresAt: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000) // 1 year
      });

      return res.json({
        status: true,
        message: 'Payment verified successfully',
        data: {
          licenseKey,
          email
        }
      });
    } else {
      // Payment still pending or in other state
      return res.json({
        status: false,
        message: `Payment status: ${response.data.data.status}`,
        paymentStatus: response.data.data.status
      });
    }
  } catch (error) {
    console.error('Payment verification error:', error.response?.data || error.message);
    
    // If it's a 404 or verification failed, don't retry
    if (error.response?.status === 404) {
      return res.status(404).json({
        status: false,
        error: 'Payment reference not found',
        details: 'The payment reference is invalid or expired'
      });
    }
    
    res.status(500).json({
      error: 'Failed to verify payment',
      details: error.response?.data?.message || error.message
    });
  }
});

/**
 * Validate license key
 * POST /api/license/validate
 */
app.post('/api/license/validate', (req, res) => {
  try {
    const { licenseKey } = req.body;

    if (!licenseKey) {
      return res.status(400).json({ error: 'License key required' });
    }

    const license = licenses.get(licenseKey);

    if (!license) {
      return res.status(400).json({
        status: false,
        message: 'Invalid license key'
      });
    }

    if (new Date() > license.expiresAt) {
      return res.status(400).json({
        status: false,
        message: 'License expired'
      });
    }

    res.json({
      status: true,
      message: 'License valid',
      data: {
        email: license.email,
        expiresAt: license.expiresAt
      }
    });
  } catch (error) {
    console.error('License validation error:', error.message);
    res.status(500).json({ error: 'Failed to validate license' });
  }
});

/**
 * Health check
 */
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

// Generate license key
function generateLicenseKey() {
  return `TRX-${Date.now()}-${Math.random().toString(36).substr(2, 9).toUpperCase()}`;
}

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Payment server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

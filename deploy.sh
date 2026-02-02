#!/bin/bash

# Translator Backend Deployment Script
# This script helps deploy the backend to various platforms

echo "🚀 Translator Backend Deployment Helper"
echo "======================================"

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please copy .env.example to .env and add your Paystack keys"
    exit 1
fi

echo "✅ Environment file found"

# Check if Paystack key is set
if ! grep -q "PAYSTACK_SECRET_KEY=sk_live" .env; then
    echo "⚠️  Warning: Paystack live key not detected in .env"
    echo "Make sure to use your live key for production!"
fi

echo "📦 Installing dependencies..."
npm install

echo "🧪 Testing server startup..."
timeout 5s npm start > /dev/null 2>&1 &
SERVER_PID=$!

sleep 3

if kill -0 $SERVER_PID 2>/dev/null; then
    echo "✅ Server starts successfully"
    kill $SERVER_PID
else
    echo "❌ Server failed to start"
    exit 1
fi

echo ""
echo "🎯 Deployment Options:"
echo "1. Railway (Recommended - Free tier)"
echo "2. Render (Free tier)"
echo "3. Heroku"
echo "4. Manual deployment"
echo ""
echo "Choose your deployment platform and follow the instructions in DEPLOYMENT.md"

echo ""
echo "📋 Next Steps:"
echo "1. Create a GitHub repository"
echo "2. Push this code to GitHub"
echo "3. Deploy using one of the options above"
echo "4. Update your extension's BACKEND_URL with the deployed URL"
echo "5. Republish your extension to Edge Store"
echo ""
echo "Good luck! 🎉"
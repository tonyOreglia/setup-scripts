#!/bin/bash

# URL to fetch
URL="https://caple.letras.ulisboa.pt/centers/getCentersExamsByCountry.json?country_id=193&exam_id=2"

# Fetch the data
RESULT=$(curl -s "$URL")

# Check for centers or no_seasons
CENTERS=$(echo "$RESULT" | jq '.centers | length')
NO_SEASONS=$(echo "$RESULT" | jq '.no_seasons')

# Telegram Bot settings
CHAT_ID="<in dashlane>"
BOT_TOKEN="<in dashlane>"
TELEGRAM_URL="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
MESSAGE="Ciple Exam Centers Result: Centers: $CENTERS, No Seasons: $NO_SEASONS"

# Only send Telegram message if there are centers or no_seasons is false
if [ "$CENTERS" -gt 0 ] || [ "$NO_SEASONS" = false ]; then
    curl -s -X POST "$TELEGRAM_URL" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE"
fi

# Send the full result to Telegram (optional if you want detailed data)
curl -s -X POST "$TELEGRAM_URL" -d "chat_id=$CHAT_ID" -d "text=$(echo "$RESULT" | jq)"

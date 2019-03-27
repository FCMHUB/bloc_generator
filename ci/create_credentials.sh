cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken": "$ACCESS_TOKEN",
  "refreshToken": "$REFRESH_TOKEN",
  "tokenEndpoint": "https://accounts.google.com/o/oauth2/token",
  "scopes": [
    "https://www.googleapis.com/auth/plus.me",
    "https://www.googleapis.com/auth/userinfo.email"
  ],
  "expiration": $TOKEN_EXPIRATION
}
EOF

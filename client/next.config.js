const withCss = require("@zeit/next-css");
const withPlugins = require("next-compose-plugins");

const nextConfig = {
  webpack: config => {
    return config;
  },
  serverRuntimeConfig: {
    mySecret: "secret"
  },
  env: {
    // Will be available on both server and client
    API_URL: process.env.REACT_APP_SERVICE_URL
  }
};

// next.config.js
module.exports = withPlugins([withCss], nextConfig);
module.exports =
  mongodb:
    development:
      name: "retrus-development"
      port: 27017
      host: "127.0.0.1"
    test:
      name: "retrus-test"
      port: 27017
      host: "127.0.0.1"
    staging:
      name: "retrus-staging"
      port: 27017
      host: "127.0.0.1"
    production:
      name: "retrus-production"
      port: 27017
      host: "127.0.0.1"
    
  redis:
    development:
      name: "retrus-development"
      port: 6397
      host: "127.0.0.1"
    test:
      name: "retrus-test"
      port: 6397
      host: "127.0.0.1"
    staging:
      name: "retrus-staging"
      port: 6397
      host: "127.0.0.1"
    production:
      name: "retrus-production"
      port: 6397
      host: "127.0.0.1"

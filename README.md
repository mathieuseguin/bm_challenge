# Baremetrics Challenge

Proxy avalaible at: http://bm-challenge.herokuapp.com

example (not cached):
```
$ curl http://bm-challenge.herokuapp.com/v1/balance -u sk_test_BQokikJOvBiI2HlWgH4olfQ2:
```

example (cached):
```
$ curl http://bm-challenge.herokuapp.com/v1/events/evt_17RpOo2eZvKYlo2Cn21QRTq5 -u sk_test_BQokikJOvBiI2HlWgH4olfQ2:
```

## Setup

### Get the source code

```
git clone https://github.com/ozgor/bm_challenge.git
cd bm_challenge
```

### Test env

```
$ psql
```

```
DROP DATABASE IF EXISTS bm_test;
CREATE DATABASE bm_test;
\c bm_test
CREATE TABLE IF NOT EXISTS cache (id serial PRIMARY KEY, url varchar(255), access_token varchar(255), data json);
CREATE UNIQUE INDEX url_and_access_token_idx ON cache(url, access_token);
```

### Development env
```
$ psql
```

```
DROP DATABASE IF EXISTS bm_development;
CREATE DATABASE bm_development;
\c bm_development
CREATE TABLE IF NOT EXISTS cache (id serial PRIMARY KEY, url varchar(255), access_token varchar(255), data json);
CREATE UNIQUE INDEX url_and_access_token_idx ON cache(url, access_token);
```

### Install dependencies

```
$ bundle install
```

### Run tests

```
$ bundle exec guard
[ENTER]
```

### Start the application

```
$ rackup
```

### Configure the Stripe gem

```
require 'stripe'
Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
Stripe.api_base = "http://localhost:9292"
```
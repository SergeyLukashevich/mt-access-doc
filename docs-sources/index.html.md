---
title: MT Remote API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - json
  - java

toc_footers:
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

search: true
---

# Introduction

Welcome to the MT Remote! It's an application that provide you easy accessable API to [MT4 server](https://en.wikipedia.org/wiki/MetaTrader_4).
You can use our API based on [WebSocket](https://en.wikipedia.org/wiki/WebSocket) to use most functions provided by [MT4 Manager API](https://www.metatrader4.com/en/brokers/api)

# Native API cons

Native MT4 Manager API provided by Metaquotes has few dissadvantages;

1. Client application can be launched either on Windows, or use Windows emulator
1. Client application should be written either on C++ or C#. As an option is possible to use language specific wrappers that cause performance drop and leads to neccessity to wrap every DLL function.

# MT Remote pros

1. Modern, Web based connnection based on WebSockets
1. Platform independant API
1. Possibility to use ready client library. We have language bindings in Java. Python and PHP clients are in progress.
1. Easy to use API to make you own client for any modern programming language.
1. Hiden complexity of native API.

# Language bindings

1. Java - TODO

# Authentication

Not yet implemented. Is available native MT4 authentification.


# Message format

## Request

```json
{
  "id": 3,
  "name": "ticks.get",
  "data": {
    "symbol": "EURUSD"
  }
}
```

Client to MT Remote

* `id`. Request/response ID. Unique per session.
* `name`. Called function name
* `data`. Function specific parameters. Optional.

## Successful response

```json
{
  "id": 3,
  "status": "OK",
  "result": [
    {
      "ask": 2.02001,
      "bid": 2.00001,
      "symbol": "EURUSD",
      "time": 1578993915
    }
  ]
}
```

MT Remote to client

* `id`. Response ID. Matches the respective request.
* `status`. Response if successful if `OK`. All other values should treated as error.
* `result`. Contains response data. Optional. 

## Error response

```json
{
  "id": 3,
  "status": "ERROR",
  "message": "Cannot find group 'test'"
}
```

MT Remote to client

* `id`. Response ID. Matches the respective request.
* `status`. Response contains error if value is not `OK`.
* `message`. Contains error description

## Event

```json
{
  "event": "tick",
  "event_id": 0,
  "data": {
    "ask": 2.02011,
    "bid": 2.00011,
    "symbol": "EURUSD",
    "time": 1579083573
  }
}
```

MT Remote to client

* `event`. Event name.
* `event_id`. Incremental event ID. Unique per session.
* `data`. Contains event data.


# Protocol workflow (TODO)

1. `*.set` functions allows to update only few fields in existing record.
1. Some field are read only.


# Connection

## Connection to MT Remote

```java
import com.finplant.mt_remote_client.MtRemoteClient;

MtRemoteClient client = new MtRemoteClient()
client.connect(URI.create("ws://127.0.0.1")).block();
```

Connects to MT Remote service.

## Connection to MT4 server

```json

// Request
{
  "name": "connect",
  "id": 0,
  "data": {
    "server": "127.0.0.1",
    "login": 1,
    "password": "password",
    "reconnect_delay": 10000
  }
}

// Response
{
  "id": 0,
  "status": "OK"
}
```

```java
client.connectToMt("127.0.0.1", 1, "password", Duration.ofSeconds(10)).block();
```

Connects to MT4 server. Only one connection is allowed per WebSocket session.

Function: `connect`

Request:

* `server`. MT4 server hostname
* `login`. MT4 manager login
* `password`. MT4 manager password
* `reconnect_delay`. MT4 connection restoration delay in milliseconds. Use 0 to disable.


# Configuration

## Get common configuration

```json
// Request
{
  "name": "config.common.get",
  "id": 3
}

// Response
{
  "id": 3,
  "result": {
    "account_url": "https://127.0.0.1",
    "adapters": "Killer Wireless-n_a_ac 1535 Wireless Network Adapter|",
    "address": "127.0.0.1",
    "antiflood": false,
    "antiflood_max_connections": 10,
    "bind_adresses": [],
    "daylight_correction": false,
    "end_of_day_hour": 12,
    "end_of_day_minute": 0,
    "feeder_timeout_seconds": 30,
    "keep_emails_days": 30,
    "keep_ticks_days": 31,
    "last_activate_time": 10,
    "last_login": 249967816,
    "last_order": 249967816,
    "liveupdate_mode": 0,
    "lost_commission_login": 1000215517,
    "monthly_state_mode": 0,
    "name": "Demo",
    "optimization_last_time": 0,
    "optimization_time_minutes": "23:0",
    "overmonth_last_month": 1,
    "overnight_last_day": 30,
    "overnight_last_time": 31,
    "overnight_prev_time": 32,
    "owner": "Broker name",
    "path_database": "C:\\dev\\Tools\\Servers\\MetaTrader4Server\\bases",
    "path_history": "C:\\dev\\Tools\\Servers\\MetaTrader4Server\\history",
    "path_log": "C:\\dev\\Tools\\Servers\\MetaTrader4Server\\logs",
    "port": 443,
    "rollovers_mode": 0,
    "server_build": 1220,
    "server_version": 400,
    "statement_mode": 0,
    "statement_weekend": true,
    "stop_delay_seconds": 60,
    "stop_last_time": 11,
    "stop_reason": 2,
    "time_of_demo_days": 60,
    "timeout": 180,
    "timesync_server": "",
    "timezone": 0,
    "type_of_demo": 1,
    "web_adresses": [
      "127.0.0.1"
    ]
  },
  "status": "OK"
}
```

```java
client.config().common().get().block();
```

Function: `config.common.get`

Returns [Mt4ConCommon](#mt4concommon)

## Set common configuration

```json
// Request
{
  "name": "config.common.set",
  "id": 2,
  "data": {
    "name": "Demo",
    "address": "127.0.0.1",
    "port": 443,
    "timeout": 180,
    "type_of_demo": 1,
    "time_of_demo_days": 60,
    "daylight_correction": false,
    "timezone": 0,
    "timesync_server": "",
    "feeder_timeout_seconds": 30,
    "keep_emails_days": 30,
    "keep_ticks_days": 31,
    "statement_weekend": true,
    "end_of_day_hour": 12,
    "end_of_day_minute": 0,
    "optimization_time_minutes": "23:0",
    "overmonth_last_month": 1,
    "antiflood": false,
    "antiflood_max_connections": 10,
    "web_adresses": [
      "127.0.0.1"
    ],
    "statement_mode": 0,
    "liveupdate_mode": 0,
    "last_activate_time": 10,
    "stop_last_time": 11,
    "monthly_state_mode": 0,
    "rollovers_mode": 0,
    "overnight_last_day": 30,
    "overnight_last_time": 31,
    "overnight_prev_time": 32,
    "stop_delay_seconds": 60,
    "stop_reason": 2,
    "account_url": "https://127.0.0.1"
  }
}

// Response
{
  "id": 2,
  "status": "OK"
}
```

```java
var config = ConCommon.builder()
        .name("Demo")
        .timeout(180)
        .build();

client.config().common().set(config).block();
```

Function: `config.common.set`

Parameter:

* [Mt4ConCommon](#mt4concommon)

## Group creation

```json
// Request
{
  "name": "config.group.add",
  "id": 3,
  "data": {
    "group": "test",
    "enable": true,
    "timeout_seconds": 60,
    "otp_mode": 0,
    "company": "Company",
    "signature": "Signature",
    "support_page": "localhost",
    "smtp_server": "127.0.0.1",
    "smtp_login": "login",
    "smtp_password": "password",
    "support_email": "a@a.lv",
    "templates_path": "c:/",
    "copies": 10,
    "reports": true,
    "default_leverage": 1000,
    "default_deposit": 100000.0,
    "max_symbols": 0,
    "currency": "EUR",
    "credit": 100.0,
    "margin_call": 0,
    "margin_mode": 1,
    "margin_stopout": 0,
    "interest_rate": 0.0,
    "use_swap": true,
    "news": 1,
    "rights": [
      "trailing",
      "email"
    ],
    "check_ie_prices": false,
    "max_positions": 0,
    "close_reopen": true,
    "hedge_prohibited": true,
    "close_fifo": true,
    "hedge_large_leg": true,
    "margin_type": 1,
    "archive_period": 90,
    "archive_max_balance": 10,
    "stopout_skip_hedged": true,
    "archive_pending_period": true,
    "news_languages": [
      "en-EN",
      "ru-RU"
    ]
  }
}

// Response
{
  "id": 3,
  "status": "OK"
}
```

```java
var group = Mt4ConGroup.builder()
    .group("test")
    .enable(true)
    .timeoutSeconds(60)
    .otpMode(Mt4ConGroup.OtpMode.DISABLED)
    .company("Company")
    .signature("Signature")
    .supportPage("localhost")
    .smtpServer(MT_URL)
    .smtpLogin("login")
    .smtpPassword("password")
    .supportEmail("a@a.lv")
    .templatesPath("c:/")
    .copies(10)
    .reports(true)
    .defaultLeverage(1000) // TODO
    .defaultDeposit(100000.0)
    .maxSymbols(0)
    .currency("EUR")
    .credit(100.0)
    .marginCall(0)
    .marginMode(Mt4ConGroup.MarginMode.USE_ALL)
    .marginStopout(0)
    .interestRate(0.0)
    .useSwap(true)
    .news(Mt4ConGroup.NewsMode.TOPICS)
    .rights(Set.of(Mt4ConGroup.Rights.EMAIL, Mt4ConGroup.Rights.TRAILING))
    .checkIePrices(false)
    .maxPositions(0)
    .closeReopen(true)
    .hedgeProhibited(true)
    .closeFifo(true)
    .hedgeLargeLeg(true)
    .marginType(Mt4ConGroup.MarginType.CURRENCY)
    .archivePeriod(90)
    .archiveMaxBalance(10)
    .stopoutSkipHedged(true)
    .archivePendingPeriod(true)
    .newsLanguages(Set.of("ru-RU", "en-EN"))
    .build();

client.config().groups().add(group).block();
```

Function: `config.group.add`

Parameter:

* [Mt4ConGroup](#mt4congroup)


## Group modification

```json
// Request
{
  "name": "config.group.set",
  "id": 5,
  "data": {
    "group": "test",
    "enable": false
  }
}

// Response
{
  "id": 5,
  "status": "OK"
}
```

```java
var group = Mt4ConGroup.builder()
        .group("test")
        .enable(false)
        .build();

client.config().groups().set(group).block();
```

Function: `config.group.set`

Parameter:

* [Mt4ConGroup](#mt4congroup)

## Group receiving

```json
// Request
{
  "name": "config.group.get",
  "id": 6,
  "data": {
    "group": "test"
  }
}

// Response
{
  "id": 6,
  "result": {
    "archive_max_balance": 10,
    "archive_pending_period": true,
    "archive_period": 90,
    "check_ie_prices": false,
    "close_fifo": true,
    "close_reopen": true,
    "company": "Company",
    "copies": 10,
    "credit": 100.0,
    "currency": "EUR",
    "default_deposit": 100000.0,
    "default_leverage": 1000,
    "enable": true,
    "group": "test",
    "hedge_large_leg": true,
    "hedge_prohibited": true,
    "interest_rate": 0.0,
    "margin_call": 0,
    "margin_mode": 1,
    "margin_stopout": 0,
    "margin_type": 1,
    "max_positions": 0,
    "max_symbols": 0,
    "news": 1,
    "news_languages": [
      "ru-RU",
      "en-EN"
    ],
    "otp_mode": 0,
    "reports": true,
    "rights": [
      "email",
      "trailing"
    ],
    "securities": {
      "CFD": {
        "auto_closeout_mode": 0,
        "commission_agent": 0.0,
        "commission_agent_mode": 0,
        "commission_agent_type": 0,
        "commission_base": 0.0,
        "commission_lots_mode": 0,
        "commission_tax": 0.0,
        "commission_type": 0,
        "execution_mode": 0,
        "free_margin_mode": 0,
        "ie_deviation": 0,
        "ie_quick_mode": false,
        "lot_max": 0.0,
        "lot_min": 0.0,
        "lot_step": 0.0,
        "request_confirmation": false,
        "show": false,
        "spread_diff": 0,
        "trade": false,
        "trade_rights": null
      },
      "Forex": {
        "auto_closeout_mode": 0,
        "commission_agent": 0.0,
        "commission_agent_mode": 0,
        "commission_agent_type": 0,
        "commission_base": 0.0,
        "commission_lots_mode": 0,
        "commission_tax": 0.0,
        "commission_type": 0,
        "execution_mode": 0,
        "free_margin_mode": 0,
        "ie_deviation": 0,
        "ie_quick_mode": false,
        "lot_max": 0.0,
        "lot_min": 0.0,
        "lot_step": 0.0,
        "request_confirmation": false,
        "show": false,
        "spread_diff": 0,
        "trade": false,
        "trade_rights": null
      },
      "Futures2": {
        "auto_closeout_mode": 0,
        "commission_agent": 0.0,
        "commission_agent_mode": 0,
        "commission_agent_type": 0,
        "commission_base": 0.0,
        "commission_lots_mode": 0,
        "commission_tax": 0.0,
        "commission_type": 0,
        "execution_mode": 0,
        "free_margin_mode": 0,
        "ie_deviation": 0,
        "ie_quick_mode": false,
        "lot_max": 0.0,
        "lot_min": 0.0,
        "lot_step": 0.0,
        "request_confirmation": false,
        "show": false,
        "spread_diff": 0,
        "trade": false,
        "trade_rights": null
      },
      "Indexes": {
        "auto_closeout_mode": 0,
        "commission_agent": 0.0,
        "commission_agent_mode": 0,
        "commission_agent_type": 0,
        "commission_base": 0.0,
        "commission_lots_mode": 0,
        "commission_tax": 0.0,
        "commission_type": 0,
        "execution_mode": 0,
        "free_margin_mode": 0,
        "ie_deviation": 0,
        "ie_quick_mode": false,
        "lot_max": 0.0,
        "lot_min": 0.0,
        "lot_step": 0.0,
        "request_confirmation": false,
        "show": false,
        "spread_diff": 0,
        "trade": false,
        "trade_rights": null
      },
      "TEST": {
        "auto_closeout_mode": 0,
        "commission_agent": 0.0,
        "commission_agent_mode": 0,
        "commission_agent_type": 0,
        "commission_base": 0.0,
        "commission_lots_mode": 0,
        "commission_tax": 0.0,
        "commission_type": 0,
        "execution_mode": 0,
        "free_margin_mode": 0,
        "ie_deviation": 0,
        "ie_quick_mode": false,
        "lot_max": 0.0,
        "lot_min": 0.0,
        "lot_step": 0.0,
        "request_confirmation": false,
        "show": false,
        "spread_diff": 0,
        "trade": false,
        "trade_rights": null
      }
    },
    "signature": "Signature",
    "smtp_login": "login",
    "smtp_password": "password",
    "smtp_server": "127.0.0.1",
    "stopout_skip_hedged": true,
    "support_email": "a@a.lv",
    "support_page": "localhost",
    "symbols": {
      "EURUSD": {
        "margin_pct": 10.0,
        "swap_long": 0.1,
        "swap_short": 0.2
      }
    },
    "templates_path": "c:/",
    "timeout_seconds": 60,
    "use_swap": true
  },
  "status": "OK"
}
```

```java
client.config().groups().get("test").block()
```

Function: `config.group.get`

Returns:

* [Mt4ConGroup](#mt4congroup)

## Group deletion

```json
// Request
{
  "name": "config.group.del",
  "id": 2,
  "data": {
    "group": "test"
  }
}

// Response
{
  "id": 2,
  "status": "OK"
}
```

```java
client.config().groups().delete("test").block();
```

Function: `config.group.del`

Parameters:

* `group`. Group name

## TMP


```json
```

```java
```java

Function: `xxx`

Parameters:
* [Mt4ConGroup](#mt4congroup)

Returns:

* [Mt4ConGroup](#mt4congroup)



# Types

## Mt4ConCommon

Parameter| Type | Note
--------- | ----------- | -----------
owner | string | Read only
name | string | 
adapters | string | Read only
optimization_last_time | unix time | Read only
server_version | integer | | Read only
server_build | integer | | Read only
last_order | integer | Read only
last_login | integer | Read only
lost_commission_login | integer | Read only 
address | string | 
port | integer | 
timeout | integer | 
type_of_demo | integer | 
time_of_demo_days | integer | 
daylight_correction | boolean | 
timezone | integer | 
timesync_server | string | 
feeder_timeout_seconds | integer | 
keep_emails_days | integer | 
keep_ticks_days | integer | 
statement_weekend | boolean | 
end_of_day_hour | integer | 
end_of_day_minute | integer | 
optimization_time_minutes | string | 
overmonth_last_month | integer | 
antiflood | boolean | 
antiflood_max_connections | integer | 
bind_adresses | array of strings | 
web_adresses | array of strings | 
statement_mode | integer | 
liveupdate_mode | integer | 
last_activate_time | integer | 
stop_last_time | integer | 
monthly_state_mode | integer | 
rollovers_mode | integer | 
path_database | string | 
path_history | string | 
path_log | string | 
overnight_last_day | integer | 
overnight_last_time | integer | 
overnight_prev_time | integer | 
stop_delay_seconds | integer | 
stop_reason | integer | 
account_url | string | 

## Mt4ConGroup

Parameter| Type | Note
--------- | ----------- | -----------
group | string |
enable | boolean |
timeout_seconds | integer |
otp_mode | integer |
company | string |
signature | string |
support_page | string |
smtp_server | string |
smtp_login | string |
smtp_password | string |
support_email | string |
templates_path | string |
copies | integer |
reports | boolean |
default_leverage | integer |
default_deposit | float |
max_symbols | integer |
currency | string |
credit | float |
margin_call | integer |
margin_mode | integer |
margin_stopout | integer |
interest_rate | float |
use_swap | boolean |
news | integer |
rights | list of strings | Possible values: ["email", "trailing", "advisor", "expiration", "signals_all", "signals_own", "risk_warning", "forced_otp"]
check_ie_prices | boolean |
max_positions | integer |
close_reopen | boolean |
hedge_prohibited | boolean |
close_fifo | boolean |
hedge_large_leg | boolean |
margin_type | integer |
archive_period | integer |
archive_max_balance | integer |
stopout_skip_hedged | boolean |
archive_pending_period | boolean |
news_languages | list of strings | Max size is 7 elements
securities | map of [Mt4ConGroupSecurity](#mt4congroupsecurity) |
symbols | map of [Mt4ConGroupMargin](#mt4congroupmargin) |

## Mt4ConGroupSecurity

Parameter| Type | Note
--------- | ----------- | -----------
show | boolean | 
trade | boolean | 
execution_mode | integer | 
commission_base | float | 
commission_type | integer | 
commission_lots_mode | integer | 
commission_agent | float | 
commission_agent_type | integer | 
spread_diff | integer | 
lot_min | float | 
lot_max | float | 
lot_step | float | 
ie_deviation | integer | 
request_confirmation | boolean | 
trade_rights | string enum | One of ["deny-close-by", "deny-multiple-close-by"]
ie_quick_mode | boolean | 
auto_closeout_mode | integer | 
commission_tax | float | 
commission_agent_mode | integer | 
free_margin_mode | integer | 

## Mt4ConGroupMargin

Parameter| Type | Note
--------- | ----------- | -----------
swap_long | float |
swap_short | float |
margin_pct | float |

---
title: MT Access API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - json
  - java

toc_footers:
  - <a href='mailto:sergey.lukashevi4@gmail.com?subject=MT Access request'>Contacts</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

search: true
---

# Introduction

Welcome to the MT Access! It's an application that provides you easy accessible API to [MT4 server](https://en.wikipedia.org/wiki/MetaTrader_4).
You can use our API based on [WebSocket](https://en.wikipedia.org/wiki/WebSocket) to use most functions provided by [MT4 Manager API](https://www.metatrader4.com/en/brokers/api)

# Native API cons

Native MT4 Manager API client provided by Metaquotes as a DLL file has few disadvantages;

1. A client application can be launched either on Windows or use Windows emulator
1. A client application should be written either on C++ or C#. As an option is possible to use language-specific wrappers that cause performance drop and leads to the necessity to wrap every DLL function.

# MT Access pros

1. Modern, Web-based connection based on WebSocket
1. Platform independent API
1. Possibility to use a ready client library. We have language bindings in Java. Python and JavaScript clients are in progress.
1. Easy to use API that allows to make your client application for any modern programming language.
1. Hiden complexity of a native API.

# Language bindings

1. [Java](https://github.com/SergeyLukashevich/mt-access-java)

# Security

* MT Access provides only encrypted communication. 
* MT4 manager credentials are used for authentification on the MT4 server side.

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

Client to MT Access

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

MT Access to client

* `id`. Response ID. Matches the respective request.
* `status`. Response if successful if `OK`. All other values should be treated as an error.
* `result`. It contains response data. Optional. 

## Error response

```json
{
  "id": 3,
  "status": "ERROR",
  "message": "Cannot find group 'test'"
}
```

MT Access to client

* `id`. Response ID. Matches the respective request.
* `status`. The response contains error if a value is not `OK`.
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

MT Access to client

* `event`. Event name.
* `event_id`. Incremental event ID. Unique per session.
* `data`. Contains event data.

# Connection

## Connection to MT Access and MT4 server

```java
import lv.sergluka.mt_access.MtAccessClient;

var params = MtAccessClient.ConnectionParameters.builder()
        .uri("wss://127.0.0.1")
        .server("127.0.0.1")
        .login(1)
        .password("password")
        .build()
var client = MtAccessClient.create(params,
       BaseSpecification.classLoader.getResourceAsStream("keystore.jks"), "keystore_password")

client.connect().timeut(Duration.ofSeconds(20)).block();
```

Connects to the MT4 server. MT4 server credential are passed in UpgradeRequest headers

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
    .defaultLeverage(1000)
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

* [Mt4TradeRecord](#mt4traderecord)


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

* [Mt4TradeRecord](#mt4traderecord)

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

* [Mt4TradeRecord](#mt4traderecord)

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

## Add/update manager


```json
// Request
{
  "name": "config.manager.set",
  "id": 3,
  "data": {
    "login": 123,
    "name": "Manager1",
    "manager": true,
    "money": true,
    "online": true,
    "riskman": true,
    "broker": true,
    "admin": true,
    "logs": true,
    "reports": true,
    "trades": true,
    "market_watch": true,
    "email": true,
    "user_details": true,
    "see_trades": true,
    "news": true,
    "plugins": true,
    "server_reports": true,
    "techsupport": true,
    "market": true,
    "notifications": true,
    "ip_filter": true,
    "ip_from": "128.0.0.0",
    "ip_to": "128.255.255.255",
    "mailbox": "MAILBOX",
    "groups": [
      "manager",
      "mini*",
      "*"
    ],
    "info_depth": 10,
    "securities": {
      "Forex": {
        "enable": true,
        "minimum_lots": 2,
        "maximum_lots": 100
      }
    }
  }
}

// Response
{
  "id": 3,
  "status": "OK"
}
```

```java
var forexSecurity = Mt4ConManagerSecurity.builder()
        .enable(true)
        .maximumLots(100.0)
        .minimumLots(2.0)
        .build();
var manager = Mt4ConManager.builder()
        .login(123)
        .name("Manager1")
        .manager(true)
        .money(true)
        .online(true)
        .riskman(true)
        .broker(true)
        .admin(true)
        .logs(true)
        .reports(true)
        .trades(true)
        .marketWatch(true)
        .email(true)
        .userDetails(true)
        .seeTrades(true)
        .news(true)
        .plugins(true)
        .serverReports(true)
        .techSupport(true)
        .market(true)
        .notifications(true)
        .ipFilter(true)
        .ipFrom("128.0.0.0")
        .ipTo("128.255.255.255")
        .mailbox("MAILBOX")
        .groups(List.of("manager", "mini*", "*"))
        .infoDepth(10)
        .securities(Map.of("Forex", forexSecurity))
        .build();

when:
client.config().managers().add(manager).timeout(Duration.ofSeconds(30)).block();
```

Creates new, or updates existing manager

Function: `config.manager.set`

Parameters:

* [Mt4ConManager](#mt4conmanager)


## Get a manager

```json
// Request
{
  "name": "config.manager.get",
  "id": 4,
  "data": {
    "login": 123
  }
}

// Response
{
  "id": 4,
  "result": {
    "admin": true,
    "broker": true,
    "email": true,
    "groups": [
      "manager",
      "mini*",
      "*"
    ],
    "info_depth": 10,
    "ip_filter": true,
    "ip_from": "128.0.0.0",
    "ip_to": "128.255.255.255",
    "login": 123,
    "logs": true,
    "mailbox": "MAILBOX",
    "manager": true,
    "market": true,
    "market_watch": true,
    "money": true,
    "name": "Manager1",
    "news": true,
    "notifications": true,
    "online": true,
    "plugins": true,
    "reports": true,
    "riskman": true,
    "securities": {
      "CFD": {
        "enable": false,
        "maximum_lots": 0.0,
        "minimum_lots": 0.0
      },
      "Forex": {
        "enable": true,
        "maximum_lots": 100.0,
        "minimum_lots": 2.0
      },
      "Futures2": {
        "enable": false,
        "maximum_lots": 0.0,
        "minimum_lots": 0.0
      },
      "Indexes": {
        "enable": false,
        "maximum_lots": 0.0,
        "minimum_lots": 0.0
      },
      "TEST": {
        "enable": false,
        "maximum_lots": 0.0,
        "minimum_lots": 0.0
      }
    },
    "see_trades": true,
    "server_reports": true,
    "techsupport": true,
    "trades": true,
    "user_details": true
  },
  "status": "OK"
}
```

```java
client.config().managers().get(123).timeout(Duration.ofSeconds(30)).block()
```

Gets existing manager

Function: `config.manager.get`

Parameters:

* `login`. Manager's login

Returns:

* [Mt4ConManager](#mt4conmanager)

## Delete manager

```json
// Request
{
  "name": "config.manager.del",
  "id": 2,
  "data": {
    "login": 123
  }
}

// Response
{
  "id": 2,
  "status": "OK"
}
```

```java
client.config().managers().delete(123).onErrorResume { Mono.empty() }.block()
```

Removes existing manager

Function: `config.manager.del`

Parameters:

* `login`. Manager's login

# Users

## New user


```json
// Request
{
  "name": "user.add",
  "id": 3,
  "data": {
    "login": 100,
    "group": "miniforex",
    "enable": true,
    "enable_change_password": true,
    "read_only": false,
    "enable_otp": false,
    "password_phone": "PhonePass",
    "name": "User1",
    "country": "Latvia",
    "city": "Riga",
    "state": "n/a",
    "zipcode": "LV-1063",
    "address": "Maskavas 322",
    "lead_source": "Source",
    "phone": "+37100112233",
    "email": "sergey.lukashevi4@gmail.com",
    "comment": "User comment",
    "id": "id1",
    "status": "STATUS",
    "leverage": 1000,
    "agent_account": 1,
    "taxes": 30.33,
    "send_reports": false,
    "mqid": 123456,
    "user_color": 16711935,
    "api_data": "",
    "password": "Pass1",
    "password_investor": "Pass2"
  }
}

// Response
{
  "id": 3,
  "result": {
    "login": 100
  },
  "status": "OK"
}
```

```java
var user = UserRecord.builder()
        .login(100)
        .enable(true)
        .group("miniforex")
        .enableChangePassword(true)
        .readOnly(false)
        .enableOtp(false)
        .passwordPhone("PhonePass")
        .name("FinPlant")
        .country("Latvia")
        .city("Riga")
        .state("n/a")
        .zipcode("LV-1063")
        .address("Maskavas 322")
        .leadSource("Source")
        .phone("+37100112233")
        .email("sergey.lukashevi4@gmail.com")
        .comment("User comment")
        .id("id1")
        .status("STATUS")
        .leverage(1000)
        .agentAccount(1)
        .taxes(30.33)
        .sendReports(false)
        .mqid(123456)
        .userColor(0xFF00FF)
        .apiData(new byte[0])
        .password("Pass1")
        .passwordInvestor("Pass2")
        .build();

var newLogin = client.users().add(user).timeout(Duration.ofSeconds(3)).block();
```

Creates new user

Function: `user.add`

Parameters:

* [Mt4UserRecord](#mt4userrecord)

Returns:

* `login`. New login

## User update


```json
// Request
{
  "name": "user.set",
  "id": 4,
  "data": {
    "login": 100,
    "read_only": true
  }
}

// Response
{
  "id": 4,
  "status": "OK"
}
```

```java
var user = UserRecord.builder()
        .login(100)
        .readOnly(true)
        .build();

client.users().set(user).timeout(Duration.ofSeconds(3)).block();
```

Function: `user.set`

Parameters:

* [Mt4UserRecord](#mt4userrecord)

## Get users by logins

```json
// Request
{
  "name": "users.get",
  "id": 5,
  "data": {
    "logins": [
      100
    ]
  }
}

// Response
{
  "id": 5,
  "result": [
    {
      "address": "",
      "agent_account": 0,
      "api_data": "",
      "balance": 0.0,
      "city": "",
      "comment": "",
      "country": "",
      "credit": 0.0,
      "email": "",
      "enable": false,
      "enable_change_password": true,
      "enable_otp": false,
      "group": "miniforex",
      "id": "",
      "interestrate": 0.0,
      "last_date": 1579187128,
      "last_ip": "0.0.0.0",
      "lead_source": "",
      "leverage": 0,
      "login": 100,
      "mqid": 0,
      "name": "Johans Smits",
      "password_phone": "",
      "phone": "",
      "prev_day_balance": 0.0,
      "prev_day_equity": 0.0,
      "prev_month_balance": 0.0,
      "prev_month_equity": 0.0,
      "read_only": true,
      "reg_date": 1579187128,
      "send_reports": false,
      "state": "",
      "status": "",
      "taxes": 0.0,
      "timestamp": 1579187128,
      "user_color": 0,
      "zipcode": ""
    }
  ],
  "status": "OK"
}
```

```java
client.users().get(100).timeout(Duration.ofSeconds(5)).block();
```

Requests one or many users by logins

Function: `users.get`

Parameters:

* list of logins

Returns:

* List of [Mt4UserRecord](#mt4userrecord)

## Get all users

```json
// Request
{
  "name": "users.get.all",
  "id": 1
}

// Response
{
  "id": 1,
  "result": [
    {
      "address": "",
      "agent_account": 0,
      "api_data": "",
      "balance": 0.0,
      "city": "",
      "comment": "automaticaly generated on startup",
      "country": "",
      "credit": 0.0,
      "email": "",
      "enable": true,
      "enable_change_password": true,
      "enable_otp": true,
      "group": "manager",
      "id": "",
      "interestrate": 0.0,
      "last_date": 1579187128,
      "last_ip": "127.0.0.1",
      "lead_source": "",
      "leverage": 0,
      "login": 1,
      "mqid": 0,
      "name": "First Admin",
      "password_phone": "",
      "phone": "",
      "prev_day_balance": 0.0,
      "prev_day_equity": 0.0,
      "prev_month_balance": 0.0,
      "prev_month_equity": 0.0,
      "read_only": false,
      "reg_date": 1557141402,
      "send_reports": false,
      "state": "",
      "status": "",
      "taxes": 0.0,
      "timestamp": 1557141402,
      "user_color": 4278190080,
      "zipcode": ""
    },
    {
      "address": "Maskavas 322",
      "agent_account": 1,
      "api_data": "",
      "balance": 0.0,
      "city": "Riga",
      "comment": "User comment",
      "country": "Latvia",
      "credit": 0.0,
      "email": "a@a.lv",
      "enable": true,
      "enable_change_password": true,
      "enable_otp": false,
      "group": "miniforex",
      "id": "id1",
      "interestrate": 0.0,
      "last_date": 1579186737,
      "last_ip": "0.0.0.0",
      "lead_source": "Source",
      "leverage": 1000,
      "login": 100,
      "mqid": 123456,
      "name": "Johans Smits",
      "password_phone": "PhonePass",
      "phone": "+37100112233",
      "prev_day_balance": 0.0,
      "prev_day_equity": 0.0,
      "prev_month_balance": 0.0,
      "prev_month_equity": 0.0,
      "read_only": false,
      "reg_date": 1579186737,
      "send_reports": false,
      "state": "n/a",
      "status": "STATUS",
      "taxes": 30.33,
      "timestamp": 0,
      "user_color": 16711935,
      "zipcode": "LV-1063"
    }
  ],
  "status": "OK"
}
```

```java
client.users().getAll().blockLast(Duration.ofSeconds(30));
```

Returns list of all existing users

Function: `users.get.all`

Returns:

* List of [Mt4UserRecord](#mt4userrecord)

## Users removal

```json
// Request
{
  "name": "users.del",
  "id": 2,
  "data": {
    "logins": [
      100
    ]
  }
}

// Response
{
  "id": 2,
  "status": "OK"
}
```

```java
client.users().delete(100).block();
```

Removes one or few users

Function: `users.del`

Parameters:

* list of logins

# Symbols

## Show symbol

```json
// Request
{
  "name": "symbol.show",
  "id": 3,
  "data": {
    "symbol": "EURUSD"
  }
}

// Response
{
  "id": 3,
  "status": "OK"
}
```

```java
client.symbols().show("EURUSD").block();
```

Shows symbol in the Market Watch window. 
Should be called before start listens or get ticks for this symbol.

Function: `symbol.show`

Parameters:

* `symbol`. Name of symbol

## Hide symbol

```json
// Request
{
  "name": "symbol.hide",
  "id": 3,
  "data": {
    "symbol": "EURUSD"
  }
}

// Response
{
  "id": 3,
  "status": "OK"
}
```

```java
client.symbols().hide("EURUSD").block();
```

Hides symbol in the Market Watch window. 
Is necessary to call to stop listen or get ticks for this symbol.

Function: `symbol.hide`

Parameters:

* `symbol`. Name of symbol

# Market data

## Add a new tick

```json
// Request
{
  "name": "tick.add",
  "id": 5,
  "data": {
    "ask": 1.1141,
    "bid": 1.1142,
    "symbol": "EURUSD"
  }
}

// Response
{
  "id": 5,
  "status": "OK"
}
```

```java
client.market().add("EURUSD", new BigDecimal("1.1141"), new BigDecimal("1.1142")).block()
```

Function: `tick.add`

Parameters:

* `symbol`. Name of symbol
* `bid`. New bid
* `ask`. New ask

## Get recent ticks

```json
// Request
{
  "name": "ticks.get",
  "id": 3,
  "data": {
    "symbol": "EURUSD"
  }
}
// Response
{
  "id": 3,
  "result": [
    {
      "bid": 2.00021,
      "ask": 2.02021,
      "symbol": "EURUSD",
      "time": 1579190122
    }
  ],
  "status": "OK"
}
```

```java
client.market().get("EURUSD").blockLast();
```

Function: `tick.add`

Parameters:

* `symbol`. Name of symbol

Returns:

* list of [Mt4Tick](#mt4tick)

# Orders

<aside class="info">Note that all orders operations called via MT4 Manager API are executed on MT4 server instantly and as is, without trading request to a dealer</aside>


## Open order

```json
// Request
{
  "name": "order.open",
  "id": 5,
  "data": {
    "login": 100,
    "symbol": "EURUSD",
    "command": "buy",
    "volume": 0.01,
    "price": 2.0
  }
}

// Response
{
  "id": 5,
  "result": {
    "order": 249967817
  },
  "status": "OK"
}
```

```java
var openParams = OrderProcedures.OpenOrderParameters.builder()
        .login(100)
        .symbol("EURUSD")
        .command(TradeRecord.Command.BUY)
        .volume(new BigDecimal("0.01"))
        .price(new BigDecimal("2.0"))
        .build();

var order = client.orders().open(openParams).block();
```

Creates an order.

Function: `order.open`

Parameters:

* `login`. User login
* `symbol`. Currency pair
* `command`. Type of order. One of "buy", "sell", "buy_limit", "buy_stop", "sell_limit", "sell_stop"
* `volume`. Amount of order
* `price`. Open price

* `sl`. Stop loss. Optional.
* `tp`. take profit. Optional.
* `expiration`. Order expiration. Optional.
* `comment`. comment. Optional.

Returns:

* `order`. Order ID (aka `ticket`)

## Limit order modify

```json
// Request
{
  "name": "order.modify",
  "id": 6,
  "data": {
    "order": 249967824,
    "price": 2.1,
    "sl": 1.0,
    "tp": 1000.0,
    "expiration": 1764630000,
    "comment": "new comment"
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
var modifyParams = OrderProcedures.ModifyOrderParameters.builder()
        .order(249967817)
        .price(new BigDecimal("2.1"))
        .stopLoss(new BigDecimal("1.0"))
        .takeProfit(new BigDecimal("1000.0"))
        .expiration(LocalDateTime.of(2025, 12, 1, 23, 0, 0))
        .comment("new comment")
        .build();

client.orders().modify(modifyParams).block();
```

Limit order parameters change.

Function: `order.modify`

Parameters:

* `order`. Order ID

* `price`. New activation price. Optional.
* `sl`. New stop loss. Optional.
* `tp`. New take profit. Optional.
* `expiration`. New order expiration. Unix time. It shouldn't contain minutes and seconds. Optional.
* `comment`. New order comment. Optional.

## Order close

```json
// Request
{
  "name": "order.close",
  "id": 6,
  "data": {
    "volume": 0.02,
    "order": 249967826,
    "price": 2.0
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.orders().close(123456, new BigDecimal("2.0"), new BigDecimal("0.02")).block()
```

Function: `order.close`

Parameters:

* `order`. Order ID
* `volume`. Closing amount. If this amount is below the order amount, MT4 closes order partially.
* `price`. Close price.

## Orders close by

```json
// Request
{
  "name": "order.close_by",
  "id": 7,
  "data": {
    "order": 249967828,
    "order_by": 249967829
  }
}

// Response
{
  "id": 7,
  "status": "OK"
}
```

```java
client.orders().closeBy(249967828, 249967829).block();
```

Function: `order.close_by`

Parameters:

* `order`. 1st order ID
* `order_by`. 2nd order ID

## Close all orders per symbol

```json
// Request
{
  "name": "order.close_all",
  "id": 8,
  "data": {
    "symbol": "EURUSD",
    "login": 100
  }
}

// Response
{
  "id": 8,
  "status": "OK"
}
```

```java
client.orders().closeAll(100, "EURUSD").block();
```

Function: `order.close_all`

Parameters:

* `symbol`. Currency pair
* `login`. User's login

## Order cancel

```json
// Request
{
  "name": "order.cancel",
  "id": 6,
  "data": {
    "order": 249967839,
    "command": "sell_limit"
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.orders().cancel(249967839, TradeRecord.Command.SELL_LIMIT).block();
```

Function: `order.cancel`

Parameters:

* `order`. Order ID
* `command`. Type of order

## Order activation

```json
// Request
{
  "name": "order.activate",
  "id": 6,
  "data": {
    "order": 249967842,
    "price": 10.0
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.orders().activate(order, new BigDecimal("10.0")).block();
```

Activation of LMT order

Function: `order.activate`

Parameters:

* `order`. Order ID
* `price`. Activation price.

## Balance/credit operation

```json
// Request
{
  "name": "order.balance",
  "id": 4,
  "data": {
    "login": 100,
    "command": "balance",
    "amount": 1000000.0,
    "comment": "Initial deposit"
  }
}

// Response
{
  "id": 4,
  "result": {
    "order": 249967841
  },
  "status": "OK"
}
```

```java
var request = OrderProcedures.BalanceOrderParameters.builder()
        .login(100)
        .command(TradeRecord.Command.BALANCE)
        .amount(new BigDecimal("1000000.0"))
        .comment("Initial deposit")
        .build();
client.orders().balance(request).block();
```

Function: `order.balance`

Parameters:

* `login`. User's login
* `command`. One of "balance" or "credit"
* `amount`. Operation amount

* `expiration`. Credit expiration date. Unix time. Shouldn't contain minutes and seconds. Optional.
* `comment`. Order comment. Optional.

Returns:

* `order`. New order ID

## Get open order by ID

```json
// Request
{
  "name": "trade.get",
  "id": 7,
  "data": {
    "order": 249967842
  }
}

// Response
{
  "id": 7,
  "result": {
    "api_data": "",
    "close_price": 2.02021,
    "close_time": 0,
    "cmd": "sell",
    "comment": "",
    "commission": 0.0,
    "commission_agent": 0.0,
    "conv_rates": [
      10.0,
      0.0
    ],
    "digits": 5,
    "expiration": 0,
    "login": 100,
    "magic": 0,
    "margin_rate": 10.0,
    "open_price": 10.0,
    "open_time": 1579272795,
    "order": 249967842,
    "profit": 15959.58,
    "reason": "dealer",
    "sl": 0.0,
    "storage": 0.0,
    "symbol": "EURUSD",
    "taxes": 0.0,
    "timestamp": 1579272796,
    "tp": 0.0,
    "volume": 0.02
  },
  "status": "OK"
}
```

```java
```

Function: `trade.get`

Parameters:

* `order`. Order ID

Returns:

* [Mt4TradeRecord](#mt4traderecord)

## Get all open orders

```json
// Request
{
  "name": "trades.get",
  "id": 7
}

// Response
{
  "id": 7,
  "result": [
    {
      "api_data": "",
      "close_price": 2.02021,
      "close_time": 0,
      "cmd": "sell",
      "comment": "",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        2.0,
        0.0
      ],
      "digits": 5,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 2.0,
      "open_price": 2.0,
      "open_time": 1579274066,
      "order": 249967844,
      "profit": -40.42,
      "reason": "dealer",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "EURUSD",
      "taxes": 0.0,
      "timestamp": 1579274066,
      "tp": 0.0,
      "volume": 0.02
    },
    {
      "api_data": "",
      "close_price": 2.02021,
      "close_time": 0,
      "cmd": "sell",
      "comment": "",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        2.0,
        0.0
      ],
      "digits": 5,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 2.0,
      "open_price": 2.0,
      "open_time": 1579274066,
      "order": 249967845,
      "profit": -40.42,
      "reason": "dealer",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "EURUSD",
      "taxes": 0.0,
      "timestamp": 1579274066,
      "tp": 0.0,
      "volume": 0.02
    }
  ],
  "status": "OK"
}
```

```java
var openOrders = client.orders().getAll().collectList().block();
```

<aside class="info">Returns all open orders between all users. Use with caution</aside>

Function: `trades.get`

Returns:

* list of [Mt4TradeRecord](#mt4traderecord)

## Get all open order for a user

```json
// Request
{
  "name": "trades.get.by_login",
  "id": 7,
  "data": {
    "login": 100,
    "group": "demoforex"
  }
}

// Response
{
  "id": 7,
  "result": [
    {
      "api_data": "",
      "close_price": 2.02021,
      "close_time": 0,
      "cmd": "sell",
      "comment": "",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        2.0,
        0.0
      ],
      "digits": 5,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 2.0,
      "open_price": 2.0,
      "open_time": 1579274230,
      "order": 249967847,
      "profit": -40.42,
      "reason": "dealer",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "EURUSD",
      "taxes": 0.0,
      "timestamp": 1579274230,
      "tp": 0.0,
      "volume": 0.02
    },
    {
      "api_data": "",
      "close_price": 2.02021,
      "close_time": 0,
      "cmd": "sell",
      "comment": "",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        2.0,
        0.0
      ],
      "digits": 5,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 2.0,
      "open_price": 2.0,
      "open_time": 1579274230,
      "order": 249967848,
      "profit": -40.42,
      "reason": "dealer",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "EURUSD",
      "taxes": 0.0,
      "timestamp": 1579274230,
      "tp": 0.0,
      "volume": 0.02
    }
  ],
  "status": "OK"
}
```

```java
var openOrders = client.orders().getByLogin(100, "demoforex").collectList().block();
```

Function: `trades.get.by_login`

Parameters:

* `login`. User's login
* `group`. User's group

Returns:

*  list of [Mt4TradeRecord](#mt4traderecord)

## Get closed trades 

```json
// Request
{
  "name": "trades.history",
  "id": 7,
  "data": {
    "from": 1577836800,
    "to": 1893456000,
    "login": 100
  }
}

// Response
{
  "id": 7,
  "result": [
    {
      "api_data": "",
      "close_price": 0.0,
      "close_time": 1579274453,
      "cmd": "balance",
      "comment": "Initial deposit",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        0.0,
        0.0
      ],
      "digits": 0,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 0.0,
      "open_price": 0.0,
      "open_time": 1579274453,
      "order": 249967849,
      "profit": 1000000.0,
      "reason": "client",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "",
      "taxes": 0.0,
      "timestamp": 1579274453,
      "tp": 0.0,
      "volume": 0.01
    },
    {
      "api_data": "",
      "close_price": 2.0,
      "close_time": 1579274453,
      "cmd": "sell",
      "comment": "",
      "commission": 0.0,
      "commission_agent": 0.0,
      "conv_rates": [
        2.0,
        2.0
      ],
      "digits": 5,
      "expiration": 0,
      "login": 100,
      "magic": 0,
      "margin_rate": 2.0,
      "open_price": 2.0,
      "open_time": 1579274453,
      "order": 249967850,
      "profit": 0.0,
      "reason": "dealer",
      "sl": 0.0,
      "storage": 0.0,
      "symbol": "EURUSD",
      "taxes": 0.0,
      "timestamp": 1579274454,
      "tp": 0.0,
      "volume": 0.02
    }
  ],
  "status": "OK"
}
```

```java
var closedTrades = client.orders().getHistory(login, null, null).takeLast(2).collectList().block();
```

Returns all closed trade for defined login.

Function: `trades.history`

Parameters:

* `login`. User's login

* `from`. Start of the time range. Unix time. Trade close time is used. Optional. If absent - 1970-01-01 is used.
* `to`. End of the time range. Unix time. Trade close time is used. Optional. If absent - current time is used.

Returns:

* list of [Mt4TradeRecord](#mt4congroup)


# Dealing

MT4 Manager API allows a client application to work as a dealer and handle trade request from the traders. 

To subscribe to trading requests and start dealing see [Events: Trade requests](#trade-requests).

## Request confirmation

```json
// Request
{
  "name": "request.confirm",
  "id": 7,
  "data": {
    "bid": 2.11,
    "ask": 2.12,
    "mode": "normal",
    "request_id": 2
  }
}

// Response
{
  "id": 7,
  "status": "OK"
}
```

```java
client.dealing().confirm(1, new BigDecimal("2.11"), new BigDecimal("2.12"), DealingProcedures.ConfirmMode.NORMAL).block();
```

Function: `request.confirm`

Parameters:

* `request_id`. Trade request ID
* `bid`. New bid price
* `ask`. New ask price
* `mode`. Confirmation mode. One of "normal", "add_prices" or "packet"

Returns:

* [Mt4ConGroup](#mt4congroup)

## Request requote

```json
// Request
{
  "name": "request.requote",
  "id": 6,
  "data": {
    "request_id": 10,
    "ask": 1.1,
    "bid": 1.0
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.dealing().requote(1, new BigDecimal("2.11"), new BigDecimal("2.12"), DealingProcedures.ConfirmMode.NORMAL).block();
```

Requote trading request by asking trader to confirm new prices

<aside class="warning">Note that requote request for Market execution symbol will confirms it, instead of requote</aside>

Function: `request.requote`

Parameters:

* `request_id`. Trade request ID
* `bid`. New bid price
* `ask`. New ask price

## Request reject

```json
// Request
{
  "name": "request.reject",
  "id": 6,
  "data": {
    "request_id": 5
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.dealing().reject(request.id).block()
```

Function: `request.reject`

Parameters:

* `request_id`. Request ID

## Request reset

```json
// Request
{
  "name": "request.reset",
  "id": 6,
  "data": {
    "request_id": 5
  }
}

// Response
{
  "id": 6,
  "status": "OK"
}
```

```java
client.dealing().reset(6).block();
```

Skip handling of the request, and allows dealer next by priority to handle it.

Function: `request.reset`

Parameters:

* `request_id`. Request ID


# Protocol extension

## Data sending to MT4 plugin

```json
// Request
{
  "name": "external.command",
  "id": 3,
  "data": {
    "encoding": "base64",
    "command": "AQL/"
  }
}

// Response
{
  "id": 3,
  "result": "EBES",
  "status": "OK"
}
```

```java
byte[] request = {0x01, 0x02, 0xFF};
byte[] response = client.protocolExtensions().externalCommand(request).block();
```

Sends text or binary data to MT4 server plugin that implement `MtSrvManagerProtocol` hook

Function: `external.command`

Parameters:

* `command`. Data to send. May be either plain text or Base64 encoded binary data
* `encoding`. Encoding of sent/received data. One of "plain" or "base64"

Returns:

* string

# Events

MT Access allows us to listen to a certain type of MT4 events and propagate them.

Function: `subscribe` and `unsubscribe`

Parameters:

* `event`. One of "connection", "group", "user", "trade", "tick" or "trade_request".

## MT4 server status

```json
// Request
{
  "name": "subscribe",
  "id": 3,
  "data": {
    "event": "connection"
  }
}

// Response
{
  "id": 3,
  "status": "OK"
}

// Event
{
  "data": false,
  "event": "connection",
  "event_id": 0
}
```

```java
```

MT4 server connection status. 

Payload:

* boolean

## Groups

```json
// Request
{
  "name": "subscribe",
  "id": 4,
  "data": {
    "event": "group"
  }
}

// Response
{
  "id": 4,
  "status": "OK"
}

// Event
{
  "data": {
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
    "max_symbols": 4096,
    "news": 1,
    "news_languages": [
      "ru-RU",
      "en-150"
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
  "event": "group",
  "event_id": 0
}
```

```java
client.config().groups().listen().subscribe(group -> System.out.printf("Group update: %s", group));
```

Payload:

* [Mt4ConGroup](#mt4congroup)

## Users

```json
// Request
{
  "name": "subscribe",
  "id": 2,
  "data": {
    "event": "user"
  }
}

// Response
{
  "id": 2,
  "status": "OK"
}

// Event
{
  "data": {
    "address": "Maskavas 322",
    "agent_account": 1,
    "api_data": "AAECAwQFBgcICQoLDA0ODw==",
    "balance": 0.0,
    "city": "Riga",
    "comment": "User comment",
    "country": "Latvia",
    "credit": 0.0,
    "email": "a@a.lv",
    "enable": true,
    "enable_change_password": true,
    "enable_otp": false,
    "group": "miniforex",
    "id": "id1",
    "interestrate": 0.0,
    "last_date": 1579509418,
    "last_ip": "0.0.0.0",
    "lead_source": "Source",
    "leverage": 1000,
    "login": 101,
    "mqid": 123456,
    "name": "Johans Smits",
    "password_phone": "PhonePass",
    "phone": "+37100112233",
    "prev_day_balance": 0.0,
    "prev_day_equity": 0.0,
    "prev_month_balance": 0.0,
    "prev_month_equity": 0.0,
    "read_only": false,
    "reg_date": 1579509418,
    "send_reports": false,
    "state": "n/a",
    "status": "STATUS",
    "taxes": 30.33,
    "timestamp": 0,
    "user_color": 16711935,
    "zipcode": "LV-1063"
  },
  "event": "user",
  "event_id": 0
}
```

```java
client.config().users().listen().subscribe(user -> System.out.printf("User update: %s", user));
```

Payload

* [Mt4UserRecord](#mt4userrecord)

## Tick

```json
// Request
{
  "name": "subscribe",
  "id": 5,
  "data": {
    "event": "tick"
  }
}

// Response
{
  "id": 5,
  "status": "OK"
}

// Event
{
  "data": {
    "ask": 2.02031,
    "bid": 2.00031,
    "symbol": "EURUSD",
    "time": 1579510356
  },
  "event": "tick",
  "event_id": 0
}
```

```java
client.symbols().show("EURUSD").block();
client.config().market().listen().subscribe(tick -> System.out.printf("Tick: %s", tick));
```

Listens for tick feed for the selected symbol

<aside class="info">Subscription emits ticks only for shown symbols. See <a href='#show-symbol'>Show symbol</a></aside>

Payload:

* [Mt4Tick](#mt4tick)

## Orders

```json
// Request
{"name":"subscribe","id":4,"data":{"event":"trade"}}

// Response
{"id":4,"status":"OK"}

// Event
{
  "data": {
    "api_data": "",
    "close_price": 2.02031,
    "close_time": 0,
    "cmd": "sell",
    "comment": "",
    "commission": 0.0,
    "commission_agent": 0.0,
    "conv_rates": [
      2.0,
      0.0
    ],
    "digits": 5,
    "expiration": 0,
    "login": 100,
    "magic": 0,
    "margin_rate": 2.0,
    "open_price": 2.0,
    "open_time": 1579510449,
    "order": 249967854,
    "profit": -40.62,
    "reason": "dealer",
    "sl": 0.0,
    "storage": 0.0,
    "symbol": "EURUSD",
    "taxes": 0.0,
    "timestamp": 1579510449,
    "tp": 0.0,
    "volume": 0.02
  },
  "event": "trade",
  "event_id": 0
}
```

```java
client.config().orders().listen().subscribe(order -> System.out.printf("New order: %s", order));
```

Payload:

* [Mt4TradeRecord](#mt4traderecord)

## Trade requests

```json
// Request
{"name":"subscribe","id":5,"data":{"event":"trade_request"}}

// Response
{"id":5,"status":"OK"}

// Event
{
  "data": {
    "balance": 1000000.0,
    "credit": 0.0,
    "group": "miniforex",
    "id": 10,
    "login": 100,
    "manager": 1,
    "prices": [
      1.26753,
      1.26748
    ],
    "status": "locked",
    "time": 941469836,
    "trade": {
      "cmd": "buy",
      "comment": "",
      "crc": -1652762336,
      "expiration": 0,
      "ie_deviation": 0,
      "order": 0,
      "order_by": 0,
      "price": 1.26753,
      "sl": 0.0,
      "symbol": "GBPUSD",
      "tp": 0.0,
      "type": "order_ie_open",
      "volume": 0.01
    }
  },
  "event": "trade_request",
  "event_id": 0
}
```

```java
client.config().dealing().listen().subscribe(request -> System.out.printf("New request: %s", request));
```

Enable dealing mode and listens for trade requests for the traders.

Payload:

* [Mt4TradeRequest](#mt4traderequest)


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

## Mt4ConGroupMargin

Parameter| Type | Note
--------- | ----------- | -----------
swap_long | float |
swap_short | float |
margin_pct | float |
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
## Mt4ConManager

Parameter| Type | Note
--------- | ----------- | -----------
login | integer |
name | string |
manager | boolean |
money | boolean |
online | boolean |
riskman | boolean |
broker | boolean |
admin | boolean |
logs | boolean |
reports | boolean |
trades | boolean |
market_watch | boolean |
email | boolean |
user_details | boolean |
see_trades | boolean |
news | boolean |
plugins | boolean |
server_reports | boolean |
techsupport | boolean |
market | boolean |
notifications | boolean |
ip_filter | boolean |
ip_from | string |
ip_to | string |
mailbox | string |
groups | list of strings |
info_depth | integer |
securities | map of [Mt4ConManagerSecurity](#mt4conmanagersecurity) |
## Mt4ConManagerSecurity

Parameter| Type | Note
--------- | ----------- | -----------
enable | boolean |
minimum_lots | float |
maximum_lots | float |
## Mt4Tick

Parameter| Type | Note
--------- | ----------- | -----------
symbol | string |
time | integer | Unix time
bid | float |
ask | float |
## Mt4TradeRecord

Parameter| Type | Note
--------- | ----------- | -----------
order | integer | 
login | integer | 
symbol | string | 
digits | integer | 
cmd | string | Type of order. One of "buy", "sell", "buy_limit", "buy_stop", "sell_limit", "sell_stop", "balance", "credit"
reason | string | Source of order opening. One of "client", "expert", "dealer", "signal", "gateway"
volume | float | 
open_time | intger | Unix time
close_time | intger | Unix time
expiration | intger | Unix time
open_price | float | 
close_price | float | 
sl | float | 
tp | float | 
conv_rates | array of 2 floats | 
commission | float | 
commission_agent | integer | 
storage | float | 
profit | float | 
taxes | float | 
magic | integer | 
comment | string | 
margin_rate | float | 
timestamp | intger | Unix time
api_data | string | Binary data encoded in Base64## Mt4TradeRequest

Parameter| Type | Note
--------- | ----------- | -----------
id | integer |
status | string | one of "empty", "request", "locked", "answered", "reseted", "canceled"
time | integer | Unix time
manager | integer |
login | integer |
group | string |
balance | float |
credit | float |
prices | array of 2 floats |
trade | [Mt4TradeTransaction](#mt4tradetransaction) |
## Mt4TradeTransaction

Parameter| Type | Note
--------- | ----------- | -----------
type | Type | one of "prices_get", "prices_requote", "order_io_open", "order_req_open", "order_mk_open", "order_pending_open", "order_ie_close", "order_req_close", "order_mk_close", "order_modify", "order_delete", "order_close_by", "order_close_all"
cmd | string | one of "buy", "sell", "buy_limit", "buy_stop", "sell_limit", "sell_stop"
order | integer |
order_by | integer |
symbol | string |
volume | float |
price | float |
sl | float |
tp | float |
ie_deviation | integer |
comment | string |
expiration | integer | Unix time
crc | integer |## Mt4UserRecord

Parameter| Type | Note
--------- | ----------- | -----------
login | integer |
group | string |
enable | boolean |
enable_change_password | boolean |
read_only | boolean |
enable_otp | boolean |
password_phone | string |
name | string |
country | string |
city | string |
state | string |
zipcode | string |
address | string |
lead_source | string |
phone | string |
email | string |
comment | string |
id | string |
status | string |
leverage | integer |
agent_account | integer |
taxes | float |
send_reports | boolean |
mqid | integer |
user_color | Long |
api_data | string | binary data encoded in Base64
password | string |
password_investor | string |
last_date | integer | Unix time
reg_date | integer | Unix time
timestamp | integer | Unix time
last_ip | string |
prev_month_balance | float |
prev_day_balance | float |
prev_month_equity | float |
prev_day_equity | float |
interestrate | float |
balance | float |
credit | float |

# How to get MT Access?

Please [contact us](mailto:sergey.lukashevi4@gmail.com?subject=MT%20Access%20request)

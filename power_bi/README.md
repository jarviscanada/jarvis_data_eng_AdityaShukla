# Stock Market Analytics Dashboard  Power BI Project

## Overview

This Power BI project focuses on building an interactive, multi-dashboard stock analytics tool that provides users with financial insights for publicly traded companies. It pulls real-time and historical data directly from the Alpha Vantage API, processes it using Power Query (M language), and displays rich visuals through Power BI reports and dashboards.

The project covers a range of functionalities, from visualizing daily stock prices and volumes to comparing analyst estimates and company financial metrics. It was designed to help users quickly evaluate performance, trends, and investment potential for various companies like Apple, Microsoft, Google, Amazon, and Meta.

## Technologies Used

- Power BI Desktop
- Power Query (M Language) for data ingestion and transformation
- DAX (Data Analysis Expressions) for calculated metrics and custom measures
- Alpha Vantage API to fetch:
  - Daily Time Series Data
  - Company Overview Data
  - Earnings Calendar Estimates

## Project Structure

The Power BI solution is divided into three primary dashboards:

### 1. Daily Stock Price Dashboard

**Purpose:** Visualizes historical stock prices and volumes for selected companies.

**Key Features:**
- OHLC (Open, High, Low, Close) line chart
- Volume trend overlay
- Dynamic slicers for custom date ranges (1 month, 3 months, 6 months, 1 year, 5 years)
- Time period filtering using DAX and calculated StartDate logic

### 2. Company Overview Metrics Dashboard

**Purpose:** Provides financial snapshots for selected companies using Company Overview API.

**Key Metrics Displayed:**
- Market Capitalization
- PE Ratio and Forward PE
- Price-to-Sales, Price-to-Book
- Dividend Yield
- Analyst Target Price
- 52-week High/Low

**Visual Elements:**
- KPI cards
- Company logo loaded dynamically using ticker-based URL
- Summary table of all financial metrics

### 3. Stocks  Dashboard

**Purpose:** Compares analyst earnings estimates for top tech stocks.

**Data Source:** Alpha Vantage Earnings Calendar API

**Features:**
- Bar chart comparing estimated earnings for AAPL, MSFT, GOOG, META, AMZN
- Dynamically filtered bar for selected ticker
- Tooltip-rich visuals for fiscal dates and currency
- Fallback handling for missing estimate data

## Data Flow & M Query Setup

### API Connections

**Primary APIs Used:**
- TIME_SERIES_DAILY
- OVERVIEW
- EARNINGS_CALENDAR

**Authentication:** Uses API key stored in a parameter

### Power Query (M) Steps

1. Created dynamic parameters for:
   - Ticker (e.g., AAPL, MSFT, etc.)
   - API Key (stored securely)
2. Pulled daily stock data from Alpha Vantage and expanded JSON into structured tables.
3. Converted nested records into clean tables using Record.ToTable, Table.ExpandRecordColumn, and Table.TransformColumnTypes.
4. Built company overview and earnings calendar data pipelines

## Custom DAX Measures

The following DAX measures were created to enable dynamic and flexible analysis:

- **Close Date Filtered**  Aggregates closing price from selected period.
- **Volume Date Filtered**  Aggregates trading volume from selected period.
- **Apple Estimate, Meta Estimate, Microsoft Estimate, etc.**  Extracts analyst earnings estimates from the Earnings Calendar API for specific tickers.
- **Market Cap, Dividend Yield, PE Ratio, Forward PE, Price-to-Book, etc.**  Extracted from the Company Overview API.

---

## Filters and Parameters

- **Dynamic Ticker Selection**: Controlled via a Power Query parameter.
- **Time Period Slicers**: Enables filtering for:
  - 1 month
  - 3 months
  - 6 months
  - 1 year
  - 5 years
- **Cross-Page Filters**: Ensure consistent context across multiple dashboard pages.

---

## Known Issues & Limitations

- Alpha Vantage API has a **rate limit** of:
  - 5 API calls per minute
  - 500 API calls per day (free tier)
- Some stock tickers may return:
  - Missing or incomplete records
  - Missing earnings estimates in the `EARNINGS_CALENDAR` endpoint
- Company logos use third-party URL formatting and **may not load** for unsupported tickers.

---

## Future Improvements

Planned enhancements to increase the functionality of the dashboard:

- Add technical indicators such as:
  - **RSI**
  - **MACD**
  - **Moving Averages**
- Introduce **forecasting and time series models** for trend prediction.
- Integrate **Power BI custom visuals**, such as:
  - **Candlestick charts**
  - **Bullet charts** for KPI comparison
- Enable users to **upload their own stock portfolio** for personalized insights.

---

## How to Use

Follow these steps to use the Power BI Stock Dashboard:

1. Claim a free API key from [Alpha Vantage](https://www.alphavantage.co/support/#api-key).
2. Open the `.pbix` file in Power BI Desktop.
3. Navigate to **Transform Data > Manage Parameters**, and paste your API key.
4. Set the `Ticker` parameter to a valid symbol (e.g., `AAPL`, `MSFT`, `GOOG`).
5. Click **Close & Apply** to refresh the data.
6. Explore the dashboards:
   - Daily Stock Performance
   - Company Overview Metrics
   - Analyst Earnings Estimates

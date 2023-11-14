# SQL COVID-19 Data Analysis

## Overview

This repository contains SQL queries for analyzing COVID-19 data (Taken from World Health Organization website as of September 2023). The queries cover a range of topics, including cases, deaths, vaccinations, and population statistics. The data is sourced from the PortfolioProjectSQL database.

## Table of Contents

- [Queries](#queries)
  - [Exploratory Data Analysis](#exploratory-data-analysis)
  - [Vaccination Analysis](#vaccination-analysis)
  - [Population vs Vaccination](#population-vs-vaccination)

## Queries

### Exploratory Data Analysis

- `CovidDeaths$` Table:
  - Retrieve data for COVID deaths by continent.
  - Calculate death rates and case percentages.
  - Identify countries with the highest infection rates and death numbers.

### Vaccination Analysis

- `CovidVaccinations$` Table:
  - Compare population vs new vaccinations.
  - Calculate the rolling number of people vaccinated.

### Population vs Vaccination

- Utilize Common Table Expressions (CTEs) and temporary tables to analyze the percentage of the population vaccinated.



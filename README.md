# Metrocar User Funnel & Drop-off Analysis

## Overview
This project looks at the user funnel of a ride-hailing platform (Metrocar) to understand where users drop off and why.  
The main goal was not only to measure funnel conversion, but also to explore what might be driving ride cancellations.

The analysis focuses on funnel performance, basic user segmentation, and operational factors such as waiting time.  
This project was built as an end-to-end product analytics case and can be used as a portfolio example.

---

## Objectives
- Understand the main drop-off points in the user funnel  
- Compare funnel performance across platforms and age groups  
- Check whether waiting time is related to ride cancellations  
- Turn analytical findings into clear, actionable insights  

---

## Dataset Description
The analysis is based on several relational tables that describe different stages of the user journey:

- **app_downloads** – application installs and platform information  
- **signups** – user registrations and basic demographics  
- **ride_requests** – ride-level events with detailed timestamps  
- **transactions** – completed payments  
- **reviews** – post-ride user feedback  

A pre-aggregated table (**funnel_analysis**) is used as the main source for funnel-level metrics.

Raw data is not included in this repository.

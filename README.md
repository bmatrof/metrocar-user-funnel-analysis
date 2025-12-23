# Metrocar User Funnel & Drop-off Analysis

## Overview
This project explores the user funnel of a ride-hailing platform (Metrocar) to see where users drop off and what might be causing it.  
The goal was not only to measure funnel conversion, but also to better understand why some rides end up being cancelled.

The analysis focuses on funnel performance, simple user segmentation, and operational factors such as waiting time.  
The project is designed as a practical product analytics case and can be used as a portfolio example.

---

## Objectives
- Identify the main drop-off points in the user funnel  
- Look at funnel performance across platforms and age groups  
- Check whether longer waiting times are linked to ride cancellations  
- Turn data findings into clear and practical insights  

---

## Dataset Description
The analysis uses several related tables that represent different steps of the user journey:

- **app_downloads** – app installs and platform details  
- **signups** – user registrations and basic demographic data  
- **ride_requests** – ride-level events with timestamps  
- **transactions** – payment information for completed rides  
- **reviews** – user feedback after rides  

A pre-aggregated table (**funnel_analysis**) is used to analyze funnel-level metrics.

Raw data is not included in this repository.

---

## Key insights
- Most users drop off after they request a ride, not during app download or signup.
- Cancelled rides tend to have a longer waiting time than completed rides, suggesting waiting time plays a key role in cancellations.
- Waiting time increases during certain hours of the day, which likely leads to more cancellations.
- Differences in waiting time across platforms exist, but time-related patterns seem to matter more than the platform itself.

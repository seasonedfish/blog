---
layout: default
title:  "Data Input"
date:   2020-07-11
categories: ecis
---

I read about the .json format from this
[series on Tutorialspoint](https://www.tutorialspoint.com/json/json_overview.htm).

Looking at the test data (`STC_dx.json`) that I've been given,
`"data"` is an array of objects.
Each object contains a diagnosis code, date, patient id, and diagnosis name.

My first task is to convert this data into DataFrame format, with the rows
representing each patient and the columns representing 2-year intervals.
So, each cell should contain a patient's diagnoses for a 2-year interval.
It should look like this:

---
layout: default
title:  "Data Input"
date:   2020-07-11
categories: ecis
---

I read about the `.json` format from this
[series on Tutorialspoint](https://www.tutorialspoint.com/json/json_overview.htm).

Looking at the test data (`STC_dx.json`) that I've been given,
`"data"` is an array of objects.
Each object represents a single diagnosis,
containing a diagnosis code, date, patient id, and diagnosis name.
Here are an example 2 objects (out of 9):
```json
{
    "data": [
        {
            "DX_CODE": "427.31",
            "DIAG_DATE": "2012/03/25 00:00:00.000000000",
            "P_ID": "Z324563",
            "DX_NM": "Atrial fibrillation (CMS/HCC)",
            "P_MRN_ID": "000167426",
            "E_ID": null
        },
        {
            "DX_CODE": "725",
            "DIAG_DATE": "2011/11/10 00:00:00.000000000",
            "P_ID": "Z273652",
            "DX_NM": "Polymyalgia rheumatica (CMS/HCC)",
            "P_MRN_ID": "000256352",
            "E_ID": 12256152437
        }
    ]
}
```

My first task is to convert this data into `DataFrame` format, with the rows
representing each patient and the columns representing 2-year intervals.
So, each cell should contain a patient's diagnoses for a 2-year interval.
Here is a table I made to visualize the general form:

|       | YYYY–YYYY+1                      | YYYY+2–YYYY+3                    |
|-------|----------------------------------|----------------------------------|
| P_IDA | DX_CODE1—DX_NM1; DX_CODE2—DX_NM2 | DX_CODE3—DX_NM3; DX_CODE4—DX_NM4 |
| P_IDB | DX_CODE5—DX_NM5; DX_CODE6—DX_NM6 | DX_CODE7—DX_NM7; DX_CODE8—DX_NM8 |

I began by simply reading the `.json` file with `pd.read_json(json_file)`.
The resulting DataFrame looked like this:
```
                                           diagnosis
0  {'DX_CODE': '427.31', 'DIAG_DATE': '2012/03/25...
1  {'DX_CODE': 'H53.9', 'DIAG_DATE': '2014/07/17 ...
2  {'DX_CODE': '725', 'DIAG_DATE': '2009/11/10 00...
3  {'DX_CODE': '725', 'DIAG_DATE': '2011/08/11 00...
4  {'DX_CODE': None, 'DIAG_DATE': '2004/10/15 00:...
5  {'DX_CODE': '272.0', 'DIAG_DATE': '2006/09/21 ...
6  {'DX_CODE': '729.81', 'DIAG_DATE': '2012/11/10...
7  {'DX_CODE': '446.5', 'DIAG_DATE': '2010/07/11 ...
8  {'DX_CODE': '725', 'DIAG_DATE': '2011/11/10 00...
```

All the data was stored in one column;
I needed to distribute it to take advantage of Pandas' functions.
Following [this Stack Overflow answer](https://stackoverflow.com/a/53967353/14106506),
I added code to flatten the object, and I dropped the unnecessary columns.
Here is the resulting DataFrame:
```
  DX_CODE  DIAG_DATE 	P_ID                         	DX_NM
0  427.31 2012-03-25  Z324563 	Atrial fibrillation (CMS/HCC)
1   H53.9 2014-07-17  Z324563            	Visual disturbance
2 	725 2009-11-10  Z324563  Polymyalgia rheumatica (CMS/HCC)
3 	725 2011-08-11  Z324563  Polymyalgia rheumatica (CMS/HCC)
4	None 2004-10-15  Z273652	Disorder of bone and cartilage
5   272.0 2006-09-21  Z273652     	Pure hypercholesterolemia
6  729.81 2012-11-10  Z273652              	Swelling of limb
7   446.5 2010-07-11  Z273652	Giant cell arteritis (CMS/HCC)
8 	725 2011-11-10  Z273652  Polymyalgia rheumatica (CMS/HCC)
```

Now we're talking. My plan now to transform the data is:
1. Get the earliest and latest years.
2. Create a list of lists for rows.
3. Iterate through the year ranges to fill in the sublists.
4. Create a new `DataFrame` from the list of lists.

---
layout: default
title:  "Refactoring"
date:   2020-07-13
categories: ecis
---

Today, I joined a Python-focused Discord server for code review.
My algorithm used a nested loop to iterate within the range of years
and my new list of lists, and it didn't feel very elegant.
We discussed ways that it could be refactored.
One member brought up a Cartesian Product using
[itertools.product()](https://docs.python.org/3/library/itertools.html#itertools.product).

This sounded smart, but what is a Cartesian Product?
It turned out to just be the set of all pairs whose first element is from the first
set and second element is from the second set.
For example, here is the Cartesian Product of {x,y,z}×{1,2,3}.
<img src="/assets/img/cartesian.png" alt="Example Cartesian Product" class="centered-image">

If I replaced my nested loop using `itertools.product()`, it would look like this:
```python
product = itertools.product(range(earliest_year, latest_year + 1, 2), rows)
for year, row in product:
...
```

But, there wasn't a good method to get the column names this way.

I then thought that I might as well create a DataFrame before the loop and append rows to it,
but I read through the documentation of `DataFrame.append()`
and saw that this was not recommended.
The Notes section reads,
> Iteratively appending rows to a DataFrame can be more computationally intensive than a single concatenate. A better solution is to append those rows to a list and then concatenate the list with the original DataFrame all at once.

This was what I had before, so I decided to leave it for now.

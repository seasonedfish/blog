---
layout: post
title:  "Pokésummary Version 2"
date:   2022-05-24
---

This past week, I made some technical changes to Pokésummary, my command-line Python program.
The biggest change was in how the program stores Pokémon data in memory.

## Some background
Pokésummary version 1 consisted of three modules:
`__main__.py`, which contained the logic for reading Pokémon data into memory and handled the command-line interface;
`displaying.py`, which handled displaying Pokémon summaries;
and `parsing.py`, which contained a utility function for reading `csv` files into dictionaries.
I was unsatisfied with this structure--I didn't like how `__main__.py`
violated the single responsibility principle.

Additionally, with the way I stored Pokémon data into memory,
it was hard to reason about my program.
In `__main__.py`, I had the following code to get the data of every Pokémon:
```python
data_dictionary = parsing.csv_to_nested_dict(
    "pokesummary.data",
    "pokemon_modified.csv",
    "pokemon_name"
)
```
This gave me a 2D dictionary: the outer dictionary mapped Pokémon names to stats,
and the inner dictionaries (the stats) mapped specific attributes (e.g. "attack_stat") to values (e.g. 49).
The problem was that my code didn't explicitly define which attributes the stats should have.
The attributes were given by my *dataset*,
so my code in `displaying.py` had to know the column names of my dataset to access data.
Surely there was a better way.

## The model-view-controller design pattern
I remembered someone had once told me about the model-view-controller design pattern.
The idea was to separate your program into three components:
the model manages the program's data,
the view displays the data,
and the controller responds to user input.

It seemed like this could work well for Pokésummary.
I had the view already, `displaying.py`.
I also had the controller, `__main__.py`.
I just needed a model for Pokémon stats.
Creating this model would satisfy the single responsibility principle
and explicitly define which attributes were available.

## Data Classes
Since my Pokémon stats model would store data,
I implemented it using frozen Data Classes.
I made a `Pokemon` class, which contains a `PokemonBaseStats`--here is the code:
```python
@dataclass(frozen=True)
class PokemonBaseStats:
    hp: int
    attack: int
    defense: int
    special_attack: int
    special_defense: int
    speed: int


@dataclass(frozen=True)
class Pokemon:
    name: str
    classification: str
    height: float
    weight: float

    primary_type: PokemonType
    secondary_type: Optional[PokemonType]

    base_stats: PokemonBaseStats
```
Using the `@dataclass` decorator,
all I needed to write were the instance variables and their types;
Python generated the `__init__()` functions for me[^1].
Additionally, I used `frozen=true` to make the objects immutable.

[^1]: Python also generates `__repr__()`, `__eq__()`, and `__hash__()`, but these aren't relevant in Pokésummary.

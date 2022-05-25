---
layout: post
title:  "Pokésummary Version 2"
date:   2022-05-24
---

This past week, I made some technical changes to Pokésummary, my command-line Python program. The biggest change was in how the program stores Pokémon data in memory.

## A basic comparison
Previously, Pokesummary used dictionaries to store the Pokemon data,
and the dictionary format was defined by the dataset that it read from.
So, the module responsible for printing out the summaries had to have the dictionary keys hard-coded as the dataset column names.

Here is how I printed out a Pokémon's name and classification in version 1:
```python
print(
    f"{Color.BOLD}{Color.UNDERLINE}{pokemon_name.upper()}, "
    f"{pokemon_stats['classification'].upper()}{Color.END}"
)
```
Since the column name for Pokémon classifications in the dataset is
`classfication`, I must use that string as my dictionary key.
This is the same for any other column.
The result is that I'm tied down to that one dataset format;
if I were to switch to using a different dataset,
I would need to change everything in my printing module.

Here is the same functionality in version 2:
```python
print(
    f"{Color.BOLD}{Color.UNDERLINE}{pokemon.name.upper()}, "
    f"{pokemon.classification.upper()}{Color.END}"
)
```
In version 2, I use Data Classes for store Pokémon information.
With this, I can access a `Pokemon` object's attributes
without worrying about how the original dataset was structured.

## Dataclasses
The `Pokemon` class is defined in `model.py` as a Data Class;
here is its source code:
```python
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
The `dataclass` decorator 

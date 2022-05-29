---
layout: post
title:  "A New Data Model for Pokésummary"
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
so my code in `displaying.py` had to know the column names of my dataset to access attributes.
For example, here is how I printed the name of a Pokémon and its classification:
```python
print(
    f"{Color.BOLD}{Color.UNDERLINE}{pokemon_name.upper()}, "
    f"{pokemon_stats['classification'].upper()}{Color.END}"
)
```
Since the column name for Pokémon classifications in the dataset is
"classification", I had to use that string as my dictionary key.
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
Creating this model would explicitly define which attributes were available,
and writing a new module to read the data into it
would satisfy the single responsibility principle.

## Data Classes
Since my Pokémon stats model would store data,
I implemented it using Data Classes.
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
all I needed in the class bodies were the instance variables and their types;
Python generated the `__init__()` functions for me[^1].

(Don't worry about PokemonType for now; we'll get to that in a bit.)

Now, with data classes, the available attributes are explicitly defined.
I can also now use the dot operator,
which is much cleaner than using a key lookup.
```python
print(
    f"{Color.BOLD}{Color.UNDERLINE}{pokemon.name.upper()}, "
    f"{pokemon.classification.upper()}{Color.END}"
)
```

## Inheriting from UserDict
Next, I needed a way to read my dataset into a collection of `Pokemon` objects.
I thought it'd be nice to create my own class that mapped strings to `Pokemon`;
the class could encapsulate reading from my dataset.
Maybe inherit from `dict`?
But, reading an article on this,
I saw that inheriting from `dict` had some [unexpected behavior](https://treyhunner.com/2019/04/why-you-shouldnt-inherit-from-list-and-dict-in-python/).
So, I followed the article's advice and inherited from `UserDict` instead.

`UserDict` is a wrapper around a dictionary object,
but it is implemented such that values can be accessed just like a dictionary.

The `UserDict` constructor allowed me to give the internal dictionary some initial data.
So, to implement `PokemonDict`,
I created a static method to read my dataset into a dictionary,
and I passed the output of this method into the constructor.
```python
class PokemonDict(UserDict):
    def __init__(self):
        pokemon_dict = self._read_dataset_to_dict()
        UserDict.__init__(self, pokemon_dict)

    @staticmethod
    def _read_dataset_to_dict():
        with resources.open_text(data, "pokemon_modified.csv") as f:
            csv_iterator = csv.DictReader(f)

            dataset_dict = {
                csv_row["pokemon_name"]: Pokemon(
                    name=csv_row["pokemon_name"],
                    classification=csv_row["classification"],
                    height=float(csv_row["pokemon_height"]),
                    weight=float(csv_row["pokemon_weight"]),
                    primary_type=PokemonType(csv_row["primary_type"]),
                    secondary_type=PokemonType.optional_pokemon_type(csv_row["secondary_type"]),
                    base_stats=PokemonBaseStats(
                        hp=int(csv_row["health_stat"]),
                        attack=int(csv_row["attack_stat"]),
                        defense=int(csv_row["defense_stat"]),
                        special_attack=int(csv_row["special_attack_stat"]),
                        special_defense=int(csv_row["special_defense_stat"]),
                        speed=int(csv_row["speed_stat"]),
                    )
                )
                for csv_row in csv_iterator
            }
        return dataset_dict
```
Although this dictionary comprehension isn't too pretty,
it's much more explicit than before.
Each attribute of the `Pokemon` class is mapped to a value from the current row.

And with this, I was able to replace the complicated `csv_to_nested_dict` call with one line:
```python
pokemon_dict = PokemonDict()
```
The logic of reading Pokémon data is no longer in the controller part of the program,
thus satisfying the single responsibility principle.

[^1]: Python also generates `__repr__()`, `__eq__()`, and `__hash__()`, but these aren't relevant in Pokésummary.

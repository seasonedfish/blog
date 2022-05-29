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
For example, here is how I accessed a Pokémon's classification:
```python
pokemon_stats['classification']
```
Since the column name for Pokémon classifications in the dataset is
"classification", I had to use that string as my dictionary key.
Surely there was a better way.

## The model-view-controller design pattern
I remembered someone had once told me about the model-view-controller design pattern.
The idea is to separate your program into three components:
the model manages the program's data,
the view displays the data,
and the controller responds to user input.

It seemed like this could work well for Pokésummary.
I had the view already, `displaying.py`.
I also had the controller, `__main__.py`.
I just needed a model for Pokémon stats.
Creating this model would explicitly define which attributes were available,
and separating out the logic that read data into it from the controller
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

(Don't worry about `PokemonType` for now; we'll get to that in a bit.)

Now, with data classes, the available attributes are explicitly defined.
I can also now use the dot operator,
which is much cleaner than using a key lookup:
```python
pokemon.classification
```

## Inheriting from UserDict
Next, I needed a way to read my dataset into a collection of `Pokemon` objects.
I thought it'd be nice to create my own class that mapped strings to `Pokemon`;
the class could encapsulate reading from my dataset.
Maybe inherit from `dict`?
But, reading an [article](https://treyhunner.com/2019/04/why-you-shouldnt-inherit-from-list-and-dict-in-python/) on this,
I saw that inheriting from `dict` had some unexpected behavior.
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

## Enums
And now, back to `PokemonType`.

I used to store a Pokémon's types as strings.
But, I realized it would be better to represent types using an enum, since there is a small set of possible types.
To allow for the absence of a type (Pokémon with a primary type and no secondary type),
I created a class method, `optional_pokemon_type()`.
This method returns None if the input string is empty; otherwise, it returns the corresponding `PokemonType`.

With `PokemonType` as an enum, I could use its members as the keys of a dictionary.
So, I rewrote the code for the grid of type defenses so that it used `PokemonType`.
I made a `TypeDefensesDict` class; although similar to `PokemonDict`, it caused me a fair amount of pain to write.
Here is its `_read_dataset_to_dict()` method:
```python
@staticmethod
def _read_dataset_to_dict() -> Dict[PokemonType, TypeDefenses]:
    """
    Parse the grid of type defenses.
    """
    with resources.open_text(data, "type_defenses_modified.csv") as f:
        # The QUOTE_NONNUMERIC part allows us to read numbers directly as floats.
        data_iterator = csv.reader(f, quoting=csv.QUOTE_NONNUMERIC)
        # Gets the column names as a list of PokemonType members.
        attacking_types = list(
            map(PokemonType, data_iterator.__next__()[1:])
        )

        all_type_defenses: Dict[PokemonType, TypeDefenses] = {
            PokemonType(row[0]): dict(
                zip(attacking_types, cast(List[float], row[1:]))
            )
            for row in data_iterator
        }
    return all_type_defenses
```
I found that you could read numbers directly as floats using `quoting=csv.QUOTE_NONNUMERIC`,
but the problem was, Python couldn't know that each `row` contained all floats besides the first element.
mypy kept giving me errors, thinking that the elements of each `row` were all supposed to be strings.
I came up with some ideas to resolve this,
but they didn't work,
so I ended up using the `cast` function from `typing` to make mypy happy.

## Addendum: Why not use namedtuples?
I experimented with using namedtuples to store Pokémon data instead of Data Classes.
From a purely practical standpoint, namedtuples are better--they are slightly faster,
reducing the time to print two summaries by around 10ms.
They also use less memory; when I left `pokesummary -i` open,
the version with Data Classes used 11MB of memory,
while the version with namedtuples used 10MB of memory.

However, using namedtuples makes less sense than using Data Classes from a design standpoint.
From my understanding, namedtuples should only be used as a replacement for tuples[^2];
they keep all the functionality of tuples.
So, namedtuples are iterable, and they can be unpacked.
This kind of functionality makes no sense for a Pokémon object.

[^1]: Python also generates `__repr__()`, `__eq__()`, and `__hash__()`, but these aren't relevant in Pokésummary.
[^2]: I gathered this from reading this [thread](https://news.ycombinator.com/item?id=15132670) on Hacker News.
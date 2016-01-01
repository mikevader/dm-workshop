# Dungeon Master Workshop #

This rails app is meant as a help tool for Dungeons & Dragons Dungeon Masters
for creating the usual paperwork at the table like: Spell cards for the dm or
players, creature sheets for encounters or npcs, tresure cards for the players
to loot in the feature.

At the moment and unfinished version can be accessed at
(https://dm-development.herokuapp.com).

The final version will be accessable under:
(https://dmw.herokuapp.com).

### In the final first version the idea is to be able to: ###

* inscribe spells, which list all relevant attributes including required classes
* create creatures with all stats and as many calculated stats as possible
** an image would be great but not required
** calculated CR would be great but not required
* create magic items to be used in shops, loot or treasures
** here the image is a must
* search/filter the items
** filter all cleric spells for example
** filter 3rd-level spells and lower
* layout all items from a filter as cards for two-sided printing
* (optional) Multilingual for at least english and german


### Cool features but not in scope for a first release are: ###

* Calculate CR from creature stats
* DB with all possible traits
* Reference creature's spells and display/print the according cards.
* Group a list of creatures, spells, treasures as encounters or for episodes in an adventure


## Release notes ##
We had the following releases:

### Dungeon Master Workshop 0.1 ###

* Create Spells

### Dungeon Master Workshop 0.2

* Create monster cards
* Create item cards
* Export cards to PDF
* Search for monsters, spells and items with all attributes
* (you don't see it:) Admin interface for manipulating master data and export and import all cards.

### Dungeon Master Workshop 0.3

* Create free form cards
* Preview for free form cards

### Dungeon Master Workshop 0.4

* Preview for item cards
* Preview for spell cards
* Preview for monster cards
* Affix behaviour for all previews
* All cards use the same template
* Add new card elements
    * bullet
    * dndstats

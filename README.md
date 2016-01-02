# Dungeon Master Workshop #

This dungeon master support tool is all about cards and managing them: Spell
card for the dm or players, creature sheets for encounters or NPCs, item cards
for treasures or loot, or just any card you want to have.

The rails app can help you create and manage those cards and especially print
them: Except from the monster cards all have the same dimensions as Magic cards
so you can use the familiar sleeves.

The current in development state can be viewed under:
(https://dmw-development.herokuapp.com).

The final version is accessible under:
(https://dmw.herokuapp.com).

### In the final first version the idea is to be able to: ###

* inscribe spells, which list all relevant attributes including required classes :ballot_box_with_check:
* create creatures with all stats and as many calculated stats as possible :ballot_box_with_check:
    * an image would be great but not required
    * calculated CR would be great but not required
* create magic items to be used in shops, loot or treasures :ballot_box_with_check:
    * here the image is a must
* search/filter the items :ballot_box_with_check:
    * filter all cleric spells for example :ballot_box_with_check:
    * filter 3rd-level spells and lower :ballot_box_with_check:
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

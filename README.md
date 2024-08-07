# Dungeon Master Workshop #

[![Ruby on Rails CI](https://github.com/mikevader/dm-workshop/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/mikevader/dm-workshop/actions/workflows/rubyonrails.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Maintainability](https://api.codeclimate.com/v1/badges/9ae2f2d5ea2082575ed6/maintainability)](https://codeclimate.com/github/mikevader/dm-workshop/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/9ae2f2d5ea2082575ed6/test_coverage)](https://codeclimate.com/github/mikevader/dm-workshop/test_coverage)
[![Coverage Status](https://coveralls.io/repos/github/mikevader/dm-workshop/badge.svg?branch=master)](https://coveralls.io/github/mikevader/dm-workshop?branch=master)


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


## Local development

```bash
bundle install
rails s 
```



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

## Newly added features
* You can now use markdown in description fields and text nodes for formatting your text.
* Labels usable in search


### Cool features but not in scope for a first release are: ###

* Calculate CR from creature stats
* DB with all possible traits
* Reference creature's spells and display/print the according cards.
* Group a list of creatures, spells, treasures as encounters or for episodes in an adventure

## Planned Features:
* Overridable skill value
* Overridable saving throw value
* Auto complete for search
* Access rights
* Private cards
* Dynamic calculation of card per sheet to allow mix of card sizes
* Backside of cards
* Working SSL over anduin.ch


## How to ... ##

### Create a release ###
> 1. git flow release start '0.x'
> 2. update README.md
> 3. git flow release finish '0.x'
> 4. git push origin master (both together don't trigger a build)
> 5. test release on dmw-staging.herokuapp.com
> 6. rake release_from_stage


## Release notes ##
We had the following releases:

### Dungeon Master Workshop 0.28 ###
* Add detailed print layout for spell books


### Dungeon Master Workshop 0.27 ###
* Add rake cleanup tasks for sessions
* Better detail view for spells and spellbooks

### Dungeon Master Workshop 0.26 ###
* Create and manage spellbooks
* You can add spells to spellsbooks easily over an auto complete field
* In the spells overview you can select an active spellbook.
* Spells in the overview can easily be inscribed to or erased from the currently selected spellbook
* Update libraries.

### Dungeon Master Workshop 0.25 ###
* Placing of cards on print page for minimal use of paper.

### Dungeon Master Workshop 0.24 ###
* New attribute source.

### Dungeon Master Workshop 0.22 ###
* Orderby keyword in searches for ordering result.

### Dungeon Master Workshop 0.21 ###
* Make card size configurable.

### Dungeon Master Workshop 0.20 ###
* You can now use markdown in description fields and text nodes for formatting your text.
* Preview view of cards is generated with invalid or incomplete card data as well.

### Dungeon Master Workshop 0.19 ###
* Force SSL
* Update various libraries

### Dungeon Master Workshop 0.18 ###
* Add verification files for hostpoint ssl certificates. 

### Dungeon Master Workshop 0.17 ###
* Add ordering for
    * Traits in monster cards
    * Actions in monster cards
    * Properties in item cards
* Add drag & drop support for changing the ordering
* Add copyright disclaimers
* Fixed issues with redirect from save or cancel 
* Fixed some styling issues


### Dungeon Master Workshop 0.16 ###
* Migration to Rails 5
* Aggregate all search fields
* Cancel button in card forms


### Dungeon Master Workshop 0.15 ###
*

### Dungeon Master Workshop 0.14 (failed on stage: not released) ###
*

### Dungeon Master Workshop 0.13 ###
* Admin section can now export and import free form cards.

### Dungeon Master Workshop 0.12 ###
* Added color picker to the card background.
* Entering a string defaults in a "name ~ " search.
* Added cite field to Spells.
* Disable autocorrect for tags field.
* Challenge rating contains now all related infos like bonus and XP.
* Fixed wobbling of the preview card in the edit form.

### Dungeon Master Workshop 0.11 ###
* Add authorization with roles for DM, Players and Admins
    * DMs can create new cards, duplicate existing and edit or delete their own. (restricted to free-form, item and monster cards)
    * Players can view all type of cards and can create their own filters.
    * Anonymous users can just view spell cards.
* Add security scan (brakeman) and enable it with the default guard execution.
* Add cite field to free form card and extend import/export.
* Cards and filters can be marked shared so other users are able to see them.

### Dungeon Master Workshop 0.10 ###
* Improved skills
    * Add new skills individually over drop down and add button
    * Ability to override the calculated value
* Improved skills
    * Ability to define the category of actions aka actions, reactions or legendary actions
    * Flag for melee or ranged weapon attack which generates the prefix in the description
* Removed explicit field for bonus and calculate it from challenge rating.

### Dungeon Master Workshop 0.9.1 ###
* Fix: Empty tag result search produce exception on postgres.

### Dungeon Master Workshop 0.9 ###
* Searchable tags in the form of 'tags in (jdf)'
* reCaptcha added for the register screen
* Adapted a fixed width style for all the login, user profile and registration views.

### Dungeon Master Workshop 0.8 ###
* Savable filters
* Tags or labels for all cards (do not work in searches atm)
* Ritual is now correctly usable in searches and gets imported correctly
* Fixes for import
* Help for search and card formatting

### Dungeon Master Workshop 0.7 ###
* Challenge ratings can now be fractions as well like .5, .25, .124 and are rendered as 1/2, 1/4, 1/8.
* Search queries work now with multiple AND/ORs
* Duplication work for all cards
* Spells have now a dedicated flag for being rituals


### Dungeon Master Workshop 0.6 ###

* Close button for modal views for better usability on mobile screens
* Scraper for spells on http://dnd-spells.com
* Duplication action for Monsters

### Dungeon Master Workshop 0.5 ###

* Preview for for cards during creation of new ones
* All cards share now the same layout for the index and creating or editing.
* All cards share the same layout for the modal view
* Layout has been updated and beautified

### Dungeon Master Workshop 0.4 ###

* Preview for item cards
* Preview for spell cards
* Preview for monster cards
* Affix behaviour for all previews
* All cards use the same template
* Add new card elements
    * bullet
    * dndstats

### Dungeon Master Workshop 0.3 ###

* Create free form cards
* Preview for free form cards

### Dungeon Master Workshop 0.2 ###

* Create monster cards
* Create item cards
* Export cards to PDF
* Search for monsters, spells and items with all attributes
* (you don't see it:) Admin interface for manipulating master data and export and import all cards.

### Dungeon Master Workshop 0.1 ###

* Create Spells


## Resources

* https://github.com/learnenough/rails_tutorial_sample_app_7th_ed/blob/main/Gemfile
* https://www.learnenough.com/blog/migrating-away-from-rails-webpacker#Step%203:%20Migrating%20from%20turbolinks%20to%20Turbo
* https://www.shakacode.com/blog/upgrade-rails-6-1-to-7/
* https://medium.com/simform-engineering/a-step-by-step-guide-to-upgrading-a-rails-6-project-to-rails-7-27ae225fdfe9
* https://www.fastruby.io/blog/rails/upgrades/upgrade-rails-7-0-to-7-1.html
* https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#autoloaded-paths-are-no-longer-in-$load-path
* 

#ObjectMapper Changelog

##Version 1.0 (2012-07-21)

####Highlights
* First official release of the framework
* Renamed all annotation marcos **This change is not backwards compatible**
  * `MapKeyToProperty(key, property)`
  * `MapClassToArray(class, array)`
  * `MapKeyToBlock(key, block)`
* Renamed the SimpleDateConverter marcos **This change is not backwards compatible**
  * `MapUnixTimestampToDate(key)`
  * `MapISO8601ToDate(key)`
  * `MapNETDateToDate(key)`
  
####New features
None

####Major bugfixes
None

####Known problems
None

##Version 0.95 (2012-07-16)

####Highlights
* Renamed all annotation marcos **This change is not backwards compatible**
  * `MAP_KEY_TO_PROPERY(key, property)`
  * `MAP_CLASS_TO_ARRAY(class, array)`
* Support for custom converter blocks (new feature)

####New features
* Support for running custom converter blocks before assigning a value to a property. A custom converter block can be used to perform calculations or transformations on JSON values before assigning it to the property
  * `MAP_KEY_TO_BLOCK(key, block)`
* Added a SimpleDateConverter implementing a couple of custom converters from JSON dates to NSDate
  * Unix timestamp
  * ISO8601 (partly)
  * .NET date

####Major bugfixes
None

####Known problems
None

##Version 0.90 (2012-07-16)

####Highlights
Fully functiona beta release.

####New features
N/A

####Major bugfixes
N/A

####Known problems
N/A

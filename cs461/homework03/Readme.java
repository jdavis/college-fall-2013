/*
 * Hi!
 *
 * This DBMS was designed to allow a developer to swap out RecordFormat and
 * PageFormat. This allows someone to customize how the DBMS stores Records and
 * how Records are stored in each Page.
 *
 * This abstraction is done through the Strategy design pattern, where an
 * algorithm is abstracted out into another class to allow swapping at runtime.
 *
 * Everything else should be self explanatory, it is just very rigid pseudocode
 * (some things are missing) but I tried to be explicit as possible.
 *
 * Hopefully it's easy to read, I tried to add Java Docs to help with that.
 *
 * Let me know if you need any help!
 *
 * - Josh
 */


separator 1 byte
 * `"AbbABcccB"`   = `A` `"bb"` `A`, `B` `"ccc"` `B`
 * `"AbbABcccBCC"` = `A` `"bb"` `A`, `B` `"ccc"` `B`, `C` `""` `C` 

separator 2 bytes
 * `"AAbbAABBcccBB"`  = `AA` `"bb"` `AA`, `BB` `"ccc"` `BB`
 * `"AbbAbBcccBcCxx"` = `Ab` `"b"` `Ab`, `Bc` `"cc"` `Bc`, (`Cxx`)


```
$ lua test.streampack.lua
AbbABcccB
{
        "bb",
        "ccc",
}
AbbABcccBCC
{
        "bb",
        "ccc",
        "",
}
AAbbAABBcccBB
{
        "bb",
        "ccc",
}
AbbAbBcccBcCxx
{
        "b",
        "cc",
        trailing = "Cxx",
}
```

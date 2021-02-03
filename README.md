# knim

### Descripion
K language in 60 minutes :) Not really, it is very primitive concept made in one hour, just trying to add template system to redefine some K's monadic and dyadic verbs and adverbs, and to check if it helps with some type-errors.

### Limitations
I am not 100% sure how to redefine system ops like ``==`` or ``#`` that is why I use ``===`` or long names for them.

Nim does not type inference which calculates backward, that is why you have to use lamdas with type annotations

### Advantage
Because the templates go via preprocessor of the static language, it can catch some cases which duck-typed K cant:

### Comparison
| k                            | knim                  | result        |
|------------------------------|-----------------------|---------------|
| 10 20 30+1 2 3               | [10,20,30]+[1,2,3]    |               |
| - 1 2 3                      | -[1,2,3]              | eq            |
| ~ 1 2 3                      | ~[1,2,3]              | compile error |
| 2>1 2 3                      | 2>[1,2,3]             | eq            |
| 1&2                          | 1 & 2                 | eq            |
| "abc"="acc"                  | "abc"==="acc"         | eq            |
| "acc"@&"acc"="c"             | "acc"[`&`"acc"==='c'] | eq            |
| 1+101b                       | 1+[true,false,true]   | compile error |
| +/1 2 3                      | ((x,y:int) => x+y)/[1,2,3] | eq       |
...

**I will add more cases here**

```
l2021.01.29 9GB (c)shakti 2.0
 (1 2 3)+1b    // I did not set prev version, but I expected 2 3 4
-9223372036854775807 -9223372036854775806 -9223372036854775805
 "hello"+100   // not a fun to catch it in prod
204 201 208 208 211
```

```
knim: [1,2,3]+true
Error: type mismatch: got <array[0..2, int], bool>
but expected one of:
...

knim: "hello"+100
Error: type mismatch: got <string, int literal(100)>
but expected one of:
```

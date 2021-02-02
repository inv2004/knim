# knim

### Descripion
K language in 60 minutes :) Not really, it is very primitive concept made in one hour, just trying to add template system to redefine some K's monadic and dyadic verbs and adverbs, and to check if it helps with some type-errors.

### Limitations
I am not 100% sure how to redefine system ops like ``==`` or ``#`` that is why I use ``===`` or long names for them.

Nim does not type inference which calculates backward, that is why you have to use lamdas with type annotations

### Advantage
Because the templates go via preprocessor of the static language, it can catch some cases which duck-typed K cant:

**I will add more cases here**

```
l2021.01.29 9GB (c)shakti 2.0
 (1 2 3)+1b    // I did not find the old version, but I expected 2 3 4
-9223372036854775807 -9223372036854775806 -9223372036854775805
```

```
knim: [1,2,3]+true
type mismatch: got <array[0..2, int], bool>
but expected one of:
...
proc `+`[T: SomeNumber](a`gensym1, b`gensym1: openArray[T]): seq[T]
  first type mismatch at position: 2
  required type for b`gensym1: openArray[T: SomeNumber]
  but expression 'true' is of type: bool
```

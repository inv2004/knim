# knim

### Desc
K language in 15 minutes :) Not really, it is very primitive concept made in one hour, just trying to add template system to redefine some K's monadic and dyadic verbs and adverbs, and to check if it helps with some type-errors.

### Limitations
At the moment I am not 100% sure how to redefine system functions like ``==``, that is why I use ``===`` for it.
Also, redefinition of the return type is not possible in static-language of course, but there is workaround via templates applied - it is not very generic, but, because K has limited amount of types it can work, but, would be better to rewrite it into some more generic.

### Advantage
Because the templates go via preprocessor of the static language it can catch some cases which duck-typed K cant:

```
l2021.01.29 9GB (c)shakti 2.0
 (1,2,3)+1b
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

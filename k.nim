# verb                      adverb                 noun
# :   x          y          f' each                char " ab"              \l a.k
# +   flip       plus    [x]f/ over (c/join)       name ``ab               \t:n x
# -   minus      minus   [x]f\ scan (c\split)      int  0 2 3              \u:n x
# *   first      times   [x]f':eachp               flt  0 2 3.             \v
# %              divide     f/:eachr g/:over       date 2021.01.23   .z.d
# &   where      min/and    f\:eachl g\:scan       time 12:34:56.789 .z.t
# |   reverse    max/or     
# <   asc        less       i/o  *enterprise       class                   \f
# >   desc       more       0: r/w line            list (2;3.4;`c)         \fl x
# =   group      equal      1: r/w char            dict [a:2;b:`c]         \fc x     
# ~   not        match     *2: r/w data            func {[a;b]a+b}         \fs x
# !   key        key       *3: k-ipc set           expr :a+b               \cd [d]   
# ,   enlist     cat       *4: https get           
# ^   sort    [f]cut       *5: ffi/py/js/..        
# #   count   [f]take                        table t:[[]i:2 3;f:2.3 4]
# _   floor   [f]drop                       utable u:[[x:..]y:..]
# $   string     parse      $[b;t;f] cond   ntable n:`..![[]y:..]
# ?   unique  [n]find                             
# @   type    [n]at         @[r;i;f[;y]] amend    `js?`js d
# .   value      dot        .[r;i;f[;y]] dmend    `csv?`csv t

# select[G]A from T where C; update A from T where C; delete from T where C
# count first last sum min max *[avg var dev med ..]; in within bin freq rand 
# exp log sin cos sqr sqrt div mod bar prm cmb; msum mavg sums deltas differ

# \\ exit  /comment \trace [:return 'signal if do while]

import algorithm
import sugar
import unittest

proc checkLen[T, G](a: openArray[T], b: openArray[G]) =
  if a.len != b.len:
    raise newException(ValueError, "len")

template math(opn: untyped, op: untyped = opn) =
  proc opn[T: SomeNumber](a, b: openArray[T]): seq[T] =
    checkLen(a, b)
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b[i])

  proc opn[T: SomeInteger, G: SomeFloat](a: openArray[T], b: openArray[G]): seq[G] =
    checkLen(a, b)
    result = newSeq[G](a.len)
    for i, x in a:
      result[i] = op(x.G, b[i])

  proc opn[T: SomeFloat, G: SomeInteger](a: openArray[T], b: openArray[G]): seq[T] =
    checkLen(a, b)
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b[i].T)

math(`+`, `+`)
math(`-`, `-`)
math(`*`, `*`)
math(`%`, `/`)

proc `+`[T](x: openArray[T]): seq[T] =
  reversed(x)

proc `-`[T](x: openArray[T]): seq[T] =
  result = newSeq[T](x.len)
  for i, x in x:
    result[i] = -x

proc `*`[T](x: openArray[T]): T =
  if x.len > 0:
    result = x[0]

proc `===`[T](a, b: openArray[T]): seq[bool] =
  checkLen(a, b)
  result = newSeq[bool](a.len)
  for i, x in a:
    result[i] = x == b[i]

proc `===`[T](a: openArray[T], b: T): seq[bool] =
  result = newSeq[bool](a.len)
  for i, x in a:
    result[i] = x == b

proc `===`[T](a: T, b: openArray[T]): seq[bool] =
  result = newSeq[bool](b.len)
  for i, x in b:
    result[i] = x == a

proc `&`(x: openArray[bool]): seq[int] =
  for i, x in x:
    if x:
      result.add i

proc `[]`[T](a: openArray[T], idx: openArray[int]): seq[T] =
  result = newSeq[T](idx.len)
  for i, idx in idx:
    result[i] = a[idx]

func each[T](f: proc(_: T): T, x: openArray[T]): seq[T] =   # TODO: Cannot redefine backtick: probably can do via AST processing
  result = newSeq[T](x.len)
  for i, x in x:
    result[i] = f(x)

func each[T](f: proc(_, u: T): T, a, b: openArray[T]): seq[T] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = f(x, b[i])

func each[T](f: proc(_, u, uu: T): T, a, b, c: openArray[T]): seq[T] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = f(x, b[i], c[i])

func `/`[T](f: proc(_, u: T): T, x: openArray[T]): T =
  result = x[0]
  for x in x[1..^1]:
    result = f(result, x)

func `\`[T](f: proc(_, u: T): T, x: openArray[T]): seq[T] =
  result = newSeq[T](x.len)
  result[0] = x[0]
  for i, x in x[1..^1]:
    result[i+1] = f(result[i], x)

test "plus":
  check @[1,2,3] + @[10,10,10] == @[11, 12, 13]
  check @[1.0,2,3] + @[10.0,10,10] == @[11.0, 12, 13]
  check @[1,2,3] + @[10.0,10,10] == @[11.0, 12, 13]
  check @[1.0,2,3] + @[10,10,10] == @[11.0, 12, 13]

test "div":
  check @[1,2,3] % @[10.0,10,10] == @[0.1, 0.2, 0.3]  # TODO

test "flip":
  check +[1,2,3] == @[3,2,1]

test "minus":
  check -[1,2,3] == @[-1,-2,-3]

test "first":
  check *[1,2,3] == 1
  let emptyI: seq[int] = @[]
  check *emptyI == 0
  let emptyF: seq[float] = @[]
  check *emptyF == 0.0

test "equal":
  check ([1,2,3] === [1,12,3]) == @[true, false, true]
  check ([3,2,3] === 3) == @[true, false, true]
  check (3 === [3,2,3]) == @[true, false, true]

test "where":
  check &[true, false, true] == @[0,2]
  check (`&` [3,2,3] === 3) == @[0,2]

test "index":
  check [3,2,3][[0,2]] == @[3,3]
  check [3,2,3][`&` [3,2,3] === 3] == @[3,3]

test "each":
  proc add10(x: int): int =
    x + 10
  check each(add10, [1,2,3]) == [11,12,13]
  proc sum(x, y: int): int =
    x + y
  check each(sum, [1,2,3], [10,20,30]) == [11,22,33]
  proc sum2(x, y, z: float): float =
    x + y + z
  check each(sum2, [1.0,2,3], [10.0,20,30], [100.0,200,300]) == [111.0,222,333]

test "over":
  proc sum(x, y: int): int =
    x + y
  check sum/[1,2,3] == 6
  proc sumA(x, y: seq[int]): seq[int] =
    x + y
  check sumA/[@[1,2,3], @[10,20,30]] == [11,22,33]

test "scan":
  proc sum(x, y: int): int =
    x + y
  check sum\[1,2,3] == [1,3,6]

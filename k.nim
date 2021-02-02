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

proc checkLen[T, G](a: openArray[T], b: openArray[G]) =
  if a.len != b.len:
    raise newException(ValueError, "len")

template math(opn: untyped, op: untyped = opn) =
  proc opn*[T](a, b: openArray[T]): seq[T] =
    checkLen(a, b)
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b[i])

  proc opn*[T: SomeInteger, G: SomeFloat](a: openArray[T], b: openArray[G]): seq[G] =
    checkLen(a, b)
    result = newSeq[G](a.len)
    for i, x in a:
      result[i] = op(x.G, b[i])

  proc opn*[T: SomeFloat, G: SomeInteger](a: openArray[T], b: openArray[G]): seq[T] =
    checkLen(a, b)
    result = newSeq[T](a.len)
    for i, x in a:
      result[i] = op(x, b[i].T)

math(`+`, `+`)
math(`-`, `-`)
math(`*`, `*`)
math(`%`, `/`)

func `-`*[T](x: openArray[T]): seq[T] =
  result = newSeq[T](x.len)
  for i, x in x:
    result[i] = -x

func `+`*[T](x: openArray[seq[T]]): seq[seq[T]] =   # TODO more checks
  var maxL = 0
  for x in x:
    if x.len > maxL:
      for _ in (result.len+1)..x.len:
        result.add newSeq[T]()
      maxL = x.len
    for i, y in x:
      result[i].add y

func `*`*[T](x: openArray[T]): T =
  if x.len > 0:
    result = x[0]

func `~`*[T,G](a: T, b: G): bool =
  a == b

func `~`*(x: bool): bool =
  not x

func `~`*(x: openArray[bool]): seq[bool] =
  result = newSeq[bool](x.len)
  for i, x in x:
    result[i] = `~`(x)

func `===`*[T](a, b: openArray[T]): seq[bool] =
  checkLen(a, b)
  result = newSeq[bool](a.len)
  for i, x in a:
    result[i] = x == b[i]

func `===`*[T](a: openArray[T], b: T): seq[bool] =
  result = newSeq[bool](a.len)
  for i, x in a:
    result[i] = x == b

func `===`*[T](a: T, b: openArray[T]): seq[bool] =
  result = newSeq[bool](b.len)
  for i, x in b:
    result[i] = x == a

func `===`*(a, b: not openArray): bool =
  a == b

func `|`*[T](x: openArray[T]): seq[T] =
  reversed(x)

func `|`*[T](a, b: openArray[T]): seq[int] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = x | b[i]

func `|`*(a, b: not openArray): SomeNumber =
  max(a, b)

func count*[T](x: openArray[T]): int =
  x.len

func take*[T](n: int, x: openArray[T]): seq[T] =
  if n >= 0:
    x[0..^n]
  else:
    x[^(-n)..^1]

func `&`*[T](a, b: openArray[T]): seq[int] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = x & b[i]

func `&`*(x: openArray[bool]): seq[int] =
  for i, x in x:
    if x:
      result.add i

func `&`*(a, b: not openArray): SomeNumber =
  min(a, b)

template where*(x: untyped): untyped =
  `&` x

func asc*[T](x: openArray[T]): seq[T] =
  debugEcho "asc"
  x.sorted()

func desc*[T](x: openArray[T]): seq[T] =
  x.sorted(order = Descending)

func `[]`*[T](a: openArray[T], idx: openArray[int]): seq[T] =
  result = newSeq[T](idx.len)
  for i, idx in idx:
    result[i] = a[idx]

func `each`*[T](f: proc(_: T): T, x: openArray[T]): seq[T] =   # TODO: Cannot redefine backtick: probably can do via AST processing
  result = newSeq[T](x.len)
  for i, x in x:
    result[i] = f(x)

func `each`*[T](f: proc(_, u: T): T, a, b: openArray[T]): seq[T] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = f(x, b[i])

func `each`*[T](f: proc(_, u, uu: T): T, a, b, c: openArray[T]): seq[T] =
  checkLen(a, b)
  result = newSeq[T](a.len)
  for i, x in a:
    result[i] = f(x, b[i], c[i])

func `/`*[T](f: proc(_, u: T): T, x: openArray[T]): T =
  result = x[0]
  for x in x[1..^1]:
    result = f(result, x)

func `over`*[T](n: int, f: proc(_: T): T, x: T): T =
  result = x
  for i in 0..<n:
    result = f(result)

func `over`*[T](f0: proc(_: T): bool, f1: proc(_: T): T, x: T): T =
  result = x
  while f0(result):
    result = f1(result)

func `\`*[T](f: proc(_, u: T): T, x: openArray[T]): seq[T] =
  result = newSeq[T](x.len)
  result[0] = x[0]
  for i, x in x[1..^1]:
    result[i+1] = f(result[i], x)

func `scan`*[T](n: int, f: proc(_: T): T, x: T): seq[T] =
  result = newSeq[T](n+1)
  if n <= 0:
    return
  result[0] = x
  for i in 1..n:
    result[i] = f(result[i-1])

func `scan`*[T](f0: proc(_: T): bool, f1: proc(_: T): T, x: T): seq[T] =
  result = newSeq[T]()
  result.add(x)
  while f0(result[^1]):
    result.add f1(result[^1])

template t*{`*` asc x}(x:openArray) =
  x.min()

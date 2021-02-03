import k
import sugar
import math
import unittest

test "plus":
  check [1,2,3] + [10,10,10] ~ [11,12,13]
  check [1.0,2,3] + [10.0,10,10] ~ [11.0,12,13]
  check [1,2,3] + [10.0,10,10] ~ [11.0,12,13]
  check [1.0,2,3] + [10,10,10] ~ [11.0,12,13]
  check [1,2,3] + 10 ~ [11,12,13]
  # check 10 + [1,2,3] ~ [11,12,13]

test "div":
  check [1,2,3] % [10.0,10,10] ~ [0.1, 0.2, 0.3]  # TODO

test "flip":
  check +([@[1],@[1,2],@[1,2,3]]) == [@[1,1,1],@[2,2],@[3]]
  check +([@[1],@[1,2,3],@[1]]) == [@[1,1,1],@[2],@[3]]

test "reversed":
  check (|[1,2,3]) ~ [3,2,1]

test "minus":
  check -[1,2,3] ~ [-1,-2,-3]

test "first":
  check *[1,2,3] ~ 1
  let emptyI: seq[int] = @[]
  check *emptyI ~ 0
  let emptyF: seq[float] = @[]
  check *emptyF ~ 0.0

test "equal":
  check ([1,2,3] === [1,12,3]) ~ [true, false, true]
  check ([3,2,3] === 3) ~ [true, false, true]
  check (3 === [3,2,3]) ~ [true, false, true]
  check (3 === 3) ~ true
  check ("abc" === "aac") ~ [true, false, true]
  check ("aba" === 'a') ~ [true, false, true]
  check ('c' === "cbc") ~ [true, false, true]
  check ('c' === 'c') ~ true

test "where":
  check &[true, false, true] ~ @[0,2]
  check (`&` [3,2,3] === 3) ~ @[0,2]
  check ("acc"[`&`"acc"==='c']) ~ "cc"

test "index":
  check [3,2,3][[0,2]] ~ [3,3]
  check [3,2,3][where [3,2,3] === 3] ~ [3,3]

test "min":
  check ([3,2,1] & [1,2,3]) ~ [1,2,1]
  check ([3,2,1] & [1,2,3]) ~ [1,2,1]
  check (3 & 1) ~ 1

test "max":
  check ([3,2,1] | [1,2,3]) ~ [3,2,3]
  check (3 | 1) ~ 3

test "not":
  check (~[true, false, true]) ~ [false, true, false]
  check ~true ~ false

test "count/take":
  check count([1,2,3]) ~ 3
  check take(2, [1,2,3]) ~ [1,2]
  check take(-2, [1,2,3,4,5]) ~ [4,5]

test "each":
  check each((x:int) => x+10, [1,2,3]) ~ [11,12,13]
  check each((x,y:int) => x+y, [1,2,3], [10,20,30]) ~ [11,22,33]
  check each((x,y,z:float) => x+y+z, [1.0,2,3], [10.0,20,30], [100.0,200,300]) ~ [111.0,222,333]
  check ~each((x:int) => x>5, [1,5,10]) ~ [true,true,false]

test "over":
  check ((x,y:int) => x+y)/[1,2,3] ~ 6
  check ((x,y:seq[int]) => x+y)/[@[1,2,3], @[10,20,30]] ~ [11,22,33]
  check over(3, (x:int) => x+1, 10) == 13
  check over((x:int) => x<13, (x:int) => x+1, 10) == 13

test "scan":
  check ((x,y:int) => x+y)\[1,2,3] ~ [1,3,6]
  check ((x,y:seq[int]) => x+y)\[@[1,2,3], @[10,20,30]] ~ [@[1,2,3], @[11,22,33]]
  check scan(3, (x:int) => x+1, 10) == [10,11,12,13]
  check scan((x:int) => x<13, (x:int) => x+1, 10) ~ [10,11,12,13]

test "eachright":
  check eachright(10, (x,y:int) => x+y, [1,2,3]) ~ [11,12,13]
  check eachright(@[10,20,30], (x:seq[int],y:int) => x+y, [1,2,3]) == [@[11,21,31],@[12,22,32],@[13,23,33]]

test "eachleft":
  check eachleft(@[10,20,30], (x,y:int) => x+y, 1) ~ [11,21,31]
  check eachleft([10,20,30], (x:int,y:seq[int]) => x+y, @[1,2,3]) == [@[11,12,13],@[21,22,23],@[31,32,33]]

test "cross":
  check cross([1,2], (x,y:int) => x+y, [10,20]) ~ [@[11,12], @[21,22]]

test "fibonacci":
  let fibs = over(10, (x:seq[int]) => x & ((x,y:int) => x+y)/take(-2, x), @[1,1])
  check fibs == [1,1,2,3,5,8,13,21,34,55,89,144]

template o*{k.`*` k.asc x}(x: untyped): untyped =
  x.min()

test "optimization":
  let a = `*` asc [13,12,11]
  check a ~ 11

test "compile_error":
  check compiles(100+"abc") == false

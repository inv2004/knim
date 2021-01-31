import k
import sugar
import unittest

test "plus":
  check [1,2,3] + [10,10,10] ~ [11, 12, 13]
  check [1.0,2,3] + [10.0,10,10] ~ [11.0, 12, 13]
  check [1,2,3] + [10.0,10,10] ~ [11.0, 12, 13]
  check [1.0,2,3] + [10,10,10] ~ [11.0, 12, 13]

test "div":
  check [1,2,3] % [10.0,10,10] ~ [0.1, 0.2, 0.3]  # TODO

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

test "where":
  check &[true, false, true] ~ @[0,2]
  check (`&` [3,2,3] === 3) ~ @[0,2]

test "index":
  check [3,2,3][[0,2]] ~ [3,3]
  check [3,2,3][`&` [3,2,3] === 3] ~ [3,3]

test "min":
  check ([3,2,1] & [1,2,3]) ~ [1,2,1]
  check (3 & 1) ~ 1

test "max":
  check ([3,2,1] | [1,2,3]) ~ [3,2,3]
  check (3 | 1) ~ 3

test "each":
  check each((x:int) => x+10, [1,2,3]) ~ [11,12,13]
  check each((x,y:int) => x+y, [1,2,3], [10,20,30]) ~ [11,22,33]
  check each((x,y,z:float) => x+y+z, [1.0,2,3], [10.0,20,30], [100.0,200,300]) ~ [111.0,222,333]

test "over":
  check ((x,y:int) => x+y)/[1,2,3] ~ 6
  check ((x,y:seq[int]) => x+y)/[@[1,2,3], @[10,20,30]] ~ [11,22,33]

test "scan":
  check ((x,y:int) => x+y)\[1,2,3] ~ [1,3,6]
  check ((x,y:seq[int]) => x+y)\[@[1,2,3], @[10,20,30]] ~ [@[1,2,3], @[11,22,33]]

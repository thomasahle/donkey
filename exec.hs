

import Data.List
import Data.Maybe

type Val = Integer
type Ref = String
type Ass = [(Ref, Val)]
type Rel = [Ass] -> [Ass]

-- Rel a = [b in ASS | Ez in a (z R b)]

sigma :: [Ref]
sigma = ["x","y"]

domain :: [Val]
domain = [0,1,2]

everything :: [Ass]
everything = sequence [[(k,v) | v <- domain] | k <- sigma]



true :: Rel
true = id

false :: Rel
false = const []

-- like and
comp :: Rel -> Rel -> Rel
comp = flip (.)

test :: Rel -> Ass -> Bool
test s ass = s [ass] /= []

rnot :: Rel -> Rel
rnot s = filter (\as -> not (test s as))

impl :: Rel -> Rel -> Rel
impl s r = rnot (s `comp` (rnot r))

exist :: Ref -> [Val] -> Rel
exist k vs ass = nub [set (k,v) as | v <- vs, as <- ass]

predi1 :: [Val] -> Ref -> Rel
predi1 f k = filter (\as -> elem (get k as) f)

predi2 :: [(Val,Val)] -> Ref -> Ref -> Rel
predi2 f k l = filter (\as -> elem (get k as, get l as) f)

-- like or
union :: Rel -> Rel -> Rel
union s r ass = (s ass) ++ (r ass)


-- Will fail if ref not in ass
get :: Ref -> Ass -> Val
get k = fromJust . (lookup k)

set :: (Ref, Val) -> Ass -> Ass
set (k,v) as = (k,v) : filter ((/=k).fst) as




farmer = predi1 [0]
donkey = predi1 [1]
beats = predi2 [(0,1)]

-- If a farmer owns a donkey, he beats it.
-- This doesn't work because E doesn't bind over -> it does
-- Ex.farmer(x).Ey.donkey(y) -> beats(x,y)


r = ((exist "x" domain) `comp` (farmer "x") `comp` (exist "y" domain) `comp` (donkey "y")) `impl` (beats "x" "y")

--[(v,k) | v <- vals, k <- ["x","y","z"]]
-- test r []

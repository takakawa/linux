{-
 Problem 1 
 Find the last element of a list. 
-}

{-1-}
myLast:: [a]->a
myLast []  = error "Empty List"
myLast [a] = a
myLast (a:last) = myLast last
{-2-}
myLast2 = last
{-3-}
myLast3::[int]->Maybe int
myLast3 []   = Nothing
myLast3 [a] = Just a
myLast3  (a:last) = myLast3 last

{-
 Problem 2
 Find the last but one element of a list. 
-}

{-1-}
myButLast::[a]->a
myButLast [] = error "Empty List"
myButLast [a] = error "List too short"
myButLast [a,b] = a
myButLast (a:last) = myButLast last

{-
 Problem 3
 Find the K'th element of a list. The first element in the list is number 1. 
-}

{-1-}
elementAt::[a]->Int -> a
elementAt [] _ = error "Empty List"
elementAt (a:_) 1 = a
elementAt  listA b
 | null listA = error "Empty List2"
 | b >= length listA = error "index too long"
 | b < 0 = error "cannot less than 0"
 | True = elementAt la index
   where index = b -1;(_:la) = listA
 		 
{-2-}
elementAt2::[a]->Int -> a
elementAt2 [] _ = error "Empty List"
elementAt2  a b= a!!b


























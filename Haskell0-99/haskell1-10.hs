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

{-
 Problem 4
 Find the number of elements of a list
-}

{-1-}
myLength     ::    [a]   ->Int
myLength [] = 0
myLength (a:b) = 1 + myLength b
{-2-}
myLength2::[a]->Int
myLength2 a = fst.last$zip [1..] a
{-3-}
myLength3::[a]->Int
myLength3 a = foldl (+) 0 $ map fst $ zip (repeat 1) a



{-
 Problem 5
 Reverse a list
-}

{-1-}
myReverse::[a]->[a]
myReverse [] = []
myReverse (a:lst) = myReverse lst ++ [a]
{-2-}
myReverse2::[a]->[a]
myReverse2 [] = []
myReverse2 a  = last a : myReverse2  (init a)
{-3-}
myReverse3::[a]->[a]
myReverse3 a = foldl f [] a
    where f a b = b : a



{-
 Problem 6
 Find out whether a list is a palindrome. A palindrome can be read forward or backward; e.g. (x a m a x). 
-}

{-1-}
isPalindrome::(Eq a)=>[a]->Bool
isPalindrome [] = False
isPalindrome a =compRet
	where  compRet = a == b;
		    b = reverse a
{-2-}
isPalindrome2::(Eq a)=>[a]->Bool
isPalindrome2 [] = False
isPalindrome2 [a] = True
isPalindrome2 (a:ls) = a == (last ls) && isPalindrome2 (init ls)


{-
 Problem 7
 Flatten a nested list structure. Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements 
-}

{-1-}
data NestedList a = Elem a | List [NestedList a] 

data MyList














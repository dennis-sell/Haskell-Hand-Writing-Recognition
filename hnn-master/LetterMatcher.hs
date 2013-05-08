
import ImageInput
import Codec.BMP
import Control.Monad
import Data.Char
import Data.String
import qualified Data.Vector as V
import Data.Word
import Data.Maybe
import AI.HNN.FF.Network 
import Numeric.LinearAlgebra

--Person represents who wrote a particular letter or alphabet. D represents
--Dennis, R represents Richard, and DR represents samples from both Dennis
--and Richard's alphabets.
data Person = D
            | R
            | DR
          deriving Show

--stringToPerson parses a string as a Maybe person. If the provided string
--differs from "D", "R", or "DR", Nothing is returned
stringToPerson :: String -> Maybe Person
stringToPerson s
            | s == "D" = Just D 
            | s == "R" = Just R
            | s == "DR" = Just DR
            | otherwise = Nothing

--mapBoth maps two independent functions to a tuple of two values, and
--returns the resulting tuple.
mapBoth :: (a -> c) -> (b -> d) -> (a,b) -> (c,d)
mapBoth f g (fir,sec) = (f fir, g sec) 

--chars is a string with every letter of the alphabet.
chars = ['a'..'z']

--sets takes an integer n and returns a string containing the integers
--from 1 to n.
sets :: Integer -> String
sets i = map (chr . fromIntegral . (+48)) [1..i]


-------------- Letter Recognition --------------------------------------------

--getFileNames takes in a Person and an Integer. The function returns a list
--of tuples, each with a string representing a filename and the character that
--the image in that file represents. The Person argument represents whose 
--alphabets to use, and the integer argument represnts how many alphabets
--to get filenames for.
getFileNames :: Person -> Integer -> [(String, Char)]
getFileNames p s  = [(name ++ (letter : set : ".bmp"), letter) |
                            name <- names p, set <- sets s, letter <- chars]
    where
        names D = ["Dennis/d"]
        names R = ["Richie/r"]
        names DR = ["Dennis/d", "Richie/r"]

--charToVector takes a char and returns a list of 26 doubles, with each double
--being 0.0 except for the position of the provided character in the alphabet,
--which will be a 1.0.
charToVector :: Char -> [Double]
charToVector c = (replicate (numLetter - 1) 0) ++ [1]
                         ++ (replicate (26 - numLetter) 0)
    where
        numLetter = Data.Char.ord c - 96 

--getSamples takes in a list of FileName/character tuples, and returns a list
--of tuples with the double representation of the provided image in the file
--and the double representation of the character.
getSamples :: [(String, Char)] -> [(IO(Maybe [Double]), [Double] )]
getSamples = map (mapBoth getSample charToVector)

-------------- Style Recognition ---------------------------------------------

--getFileNamesStyle takes an integer representing a number of alphabets and
--and returns a list of tuples, with the string representation of the image's
--filenames and the Person, D or R, who wrote that picture
getFileNamesStyle :: Integer -> [(String, Person)]
getFileNamesStyle s  = [("Dennis/d" ++ (letter : set : ".bmp"), D) |
                            set <- sets s, letter <- chars] ++ 
                       [("Richie/r" ++ (letter : set : ".bmp"), R) |
                            set <- sets s, letter <- chars]

--personToVector takes in a person and returns a double list representation
--of the Person provided, with [1.0, 0.0] representing D and [0.0, 1.0]
--representing R
personToVector :: Person -> [Double]
personToVector D = [1.0,0.0]
personToVector R = [0.0,1.0]
personToVector _ = [0.0,0.0]

--getSamples takes in a list of FileName/character tuples, and returns a list
--of tuples with the double representation of the provided image in the file
--and the double representation of the Person.
getStyleSamples :: [(String, Person)] -> [(IO(Maybe [Double]), [Double] )]
getStyleSamples = map (mapBoth getSample personToVector)

-------------- Processing ----------------------------------------------------

--processSamples takes in a list containing information on several images and
--their ascoiated characters or Persons, and returns an IO(Samples Double), 
--which is data that can be used to train a Neural Network
processSamples :: [(IO(Maybe [Double]), [Double] )] -> IO(Samples Double)
processSamples = sequence . map (helper2 . helper)
    where
      helper :: (IO(Maybe [Double]), [Double] ) -> (IO(Vector Double), Vector Double)
      helper s = mapBoth (fmap (fromList . fromJust)) fromList s
        -- A note on types : IO(Sample Double) = IO((Vector Double, Vector Double))
      helper2 :: (IO(Vector Double), Vector Double) -> IO(Sample Double)
      helper2 (i, v) =  fmap (\ j -> (j,v)) i

------------------------------------------------------------------------------

--main contains the interface that allows the user to choose what data to train
--a Neural Network with, and what data to test against that Neural Network
main :: IO ()
main = do
    putStrLn "Person?"
    person <- personGetLoop
    putStrLn "Number of sets in training data? (1-3)"
    tests <- testsGetLoop
    putStrLn "Creating Neural Network"
    n <- createNetwork 256 [2560] 26
    samples <- processSamples . getSample $ getFileNames person tests
    n' <- trainNTimes 1000 0.5 tanh tanh' n samples
    putStrLn . show . output n' tanh . processSamples . getSample $ "da4.bmp"
    putStrLn . show . output n' tanh . processSamples . getSample $ "rq4.bmp"
    putStrLn "Done"

    where 
      personGetLoop :: IO Person
      personGetLoop = (fmap stringToPerson getLine) >>= \ input ->
        case input of
          Just p -> return p
          Nothing -> putStrLn "Is not a valid person" >> personGetLoop
      testsGetLoop :: IO Integer
      testsGetLoop = (fmap integerOfString getLine) >>= \ input ->
        case input of
          Just n -> if n <= 4 && n >= 1 then return n else testsGetLoop  
          Nothing -> putStrLn "Is not a valid test number" >> testsGetLoop
      integerOfString :: String -> Maybe Integer
      integerOfString s = case head s of
                            '1' -> Just 1
                            '2' -> Just 2
                            '3' -> Just 3
                            _   -> Nothing

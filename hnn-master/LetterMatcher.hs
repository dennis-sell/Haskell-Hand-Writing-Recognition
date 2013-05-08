
import ImageInput
import Codec.BMP
import Control.Monad
import Data.Char
import Data.String
--import Data.ByteString
import Data.Word

data Person = D
            | R
            | DR

stringToPerson :: String -> Maybe Person
stringToPerson s
            | s == "D" = Just D 
            | s == "R" = Just R
            | s == "DR" = Just DR
            | otherwise = Nothing

getFileNames :: Person -> Integer -> [(String, Char)]
getFileNames p s  = [(name ++ (letter : set : ".bmp"), letter) |
                            name <- names p, set <- sets, letter <- chars]
    where
        sets = map (chr . fromIntegral . (+48)) [1..s]
        chars = ['a','b','c','d','e','f','g','h','i','j','k','l','m']
             ++ ['n','o','p','q','r','s','t','u','v','w','x','y','z']
        names D = ["Dennis/d"]
        names R = ["Richie/r"]
        names DR = ["Dennis/d", "Richie/r"]


mapBoth :: (a -> c) -> (b -> d) -> (a,b) -> (c,d)
mapBoth f g (fir,sec) = (f fir, g sec) 

charToVector :: Char -> [Double]
charToVector c = (replicate (numLetter - 1) 0) ++ [1] ++ (replicate (26 - numLetter) 0)
    where
        numLetter = Data.Char.ord c - 96 

getSamples :: Person -> Integer -> [(IO(Maybe [Double]), [Double] )]
getSamples p i = map (mapBoth getSample charToVector) files
    where files = getFileNames p i


main :: IO ()
main = do
    putStrLn "Person?"
    person <- personGetLoop
    putStrLn "Number of sets in training data? (1-4)"
    tests <- testsGetLoop
    putStrLn "Creating Neural Network"
    --n <- createNetwork 256 [2560] 26
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
          Just num -> if num <= 4 && num >= 1 then return num else testsGetLoop  
          Nothing -> putStrLn "Is not a valid test number" >> testsGetLoop
      integerOfString :: String -> Maybe Integer
      integerOfString s = case head s of
                            '1' -> Just 1
                            '2' -> Just 2
                            '3' -> Just 3
                            '4' -> Just 4
                            _   -> Nothing

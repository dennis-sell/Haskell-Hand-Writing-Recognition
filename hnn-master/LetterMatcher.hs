
import ImageInput
import Codec.BMP
import Control.Monad
import Data.Char
--import Data.ByteString
import Data.Word

data Person = D
            | R
            | DR


getFileNames :: Person -> Integer -> [(Char,String)]
getFileNames p s  = [(letter,  name ++ (letter : set : ".bmp")) |
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

getSamples :: Person -> Integer -> [([Double], IO(Maybe [Double]) )]
getSamples p i = map (mapBoth charToVector getSample) files
    where files = getFileNames p i

{-
main :: IO ()
main = do
    n <- createNetwork 256 [2560] 26
    putStrLn "Done" -}

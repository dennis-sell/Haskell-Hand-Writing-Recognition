
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


mapSnd :: (b -> c) -> (a,b) -> (a,c)
mapSnd f (fir,sec) = (fir, f sec) 

getSamples :: Person -> Integer -> [(Char, IO(Maybe [Word8]) )]
getSamples p i = map (mapSnd (unpackB . getByteStringFromFile)) files
    where files = getFileNames p i 



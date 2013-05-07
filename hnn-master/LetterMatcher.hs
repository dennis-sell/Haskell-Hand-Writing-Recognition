
import ImageInput
import Codec.BMP
import Control.Monad
import Data.Char
--import Data.ByteString
import Data.Word

data Person = D
            | R
            | DR


getFileNames :: Person -> Integer -> [String]
getFileNames p s  = [name : letter : set : ".bmp" |
                            name <- names p, set <- sets, letter <- chars]
    where
        sets = map (chr . fromIntegral . (+48)) [1..s]

        chars = ['a','b','c','d','e','f','g','h','i','j','k','l','m']
             ++ ['n','o','p','q','r','s','t','u','v','w','x','y','z']
        names D = ['d']
        names R = ['r']
        names DR = ['d', 'r']


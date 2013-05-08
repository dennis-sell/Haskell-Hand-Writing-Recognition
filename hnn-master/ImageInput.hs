module ImageInput where

import Codec.BMP
import Control.Monad
import Data.Either
import Data.ByteString
import Data.Word


--GetRightM Will take in an Either wrapped in a monad. If the Either is
--it's Right value, the function will return a Maybe of Just that value
--wrapped in the original monad. Otherwise it will return a Nothing
--wrapped int he original monad.
getRightM :: Monad m => m (Either a b) -> m (Maybe b)
getRightM  x = x >>= (\c -> case c of
                            Right x -> return (Just x)
                            Left _ -> return Nothing)


--GetRightM Will take in an Either wrapped in a monad. If the Either is
--it's Left value, the function will return a Maybe of Just that value
--wrapped in the original monad. Otherwise it will return a Nothing
--wrapped int he original monad.
getLeftM :: Monad m => m (Either a b) -> m (Maybe a)
getLeftM  x = x >>= (\c -> case c of
                            Right _ -> return Nothing
                            Left x -> return (Just x))


--getByteStringFromFile takes a bmp image's Filepath as a string and returns
--a Maybe of the Bytestring representation of the file wrapped in IO
getByteStringFromFile :: String -> IO (Maybe ByteString)
getByteStringFromFile x = fmap (fmap bmpRawImageData) (getRightM . readBMP $ x) 


--unpackB takes in a Maybe Bytstring representation of a file wrapped in IO
--and returns a Maybe list of numerical values representing the bytes contained
--in the bytestring, wrapped in IO
unpackB :: IO (Maybe ByteString) -> IO (Maybe [Word8])
unpackB = fmap (fmap unpack)


--proccessImage takes in the Maybe list of Word8 values and returns a list
--of 1s and 0s, where a 0 represents a white pixel in the image, and a 1
--represents a black pixel in the image
processImage :: IO(Maybe [Word8]) -> IO(Maybe [Double])
processImage = fmap (fmap processing)
    where
        processing :: [Word8] -> [Double]
        processing (255:255:255:xs) = 0 : processing xs
        processing (0:0:0:xs)       = 1 : processing xs
        processing _                = []

--getSample will take a bmp image's Filepath as a string and return a list of 
--1's and 0's that represent the white and black pixels in the image
getSample :: String -> IO(Maybe [Double])
getSample = processImage . unpackB . getByteStringFromFile


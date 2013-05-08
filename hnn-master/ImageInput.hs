module ImageInput where

import Codec.BMP
import Control.Monad
import Data.Either
import Data.ByteString
import Data.Word


getRightM :: Monad m => m (Either a b) -> m (Maybe b)
getRightM  x = x >>= (\c -> case c of
                            Right x -> return (Just x)
                            Left _ -> return Nothing)

getLeftM :: Monad m => m (Either a b) -> m (Maybe a)
getLeftM  x = x >>= (\c -> case c of
                            Right _ -> return Nothing
                            Left x -> return (Just x))

{-
getBitmap :: String -> IO (Maybe BMP)
getBitmap x = getRightM (readBMP x)

getByteString :: IO (Maybe BMP) -> IO (Maybe ByteString)
getByteString x = x >>= (\c -> case c of
                                Nothing -> return Nothing
                                Just x -> return (Just (bmpRawImageData x)))
-}

getByteStringFromFile :: String -> IO (Maybe ByteString)
getByteStringFromFile x = (getRightM . readBMP $ x) >>= (\c -> case c of
                                Nothing -> return Nothing
                                Just y -> return (Just (bmpRawImageData y)))


unpackB :: IO (Maybe ByteString) -> IO (Maybe [Word8])
unpackB = fmap (fmap unpack)


processImage :: IO(Maybe [Word8]) -> IO(Maybe [Double])
processImage = fmap (fmap processing)
    where
        processing :: [Word8] -> [Double]
        processing (255:255:255:xs) = 0 : processing xs
        processing (0:0:0:xs)       = 1 : processing xs
        processing _                = []

getSample :: String -> IO(Maybe [Double])
getSample = processImage . unpackB . getByteStringFromFile


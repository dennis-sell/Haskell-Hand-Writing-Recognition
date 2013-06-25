Haskell-Hand-Writing-Recognition
================================

CIS194: Haskell Final Project

Names: Dennis Sell, Richard Roberts

Goal: Letter recognition: Given samples of different, known letters of the 
alphabet and an image representing an unknown letter, can a program determine 
what letter is written? 

Instructions to Run: Several packages must be installed to run our
project: HNN, Numeric.LinearAlgebra, and Codec.BMP. Once installed,
run LetterMacher.hs. You will be provided with several choices. First, you 
choose which sets to train on. Recommended settings are to train on DR, which
represents both persons' sets of data, and 3, which will run it on 3 sets of
letters (leaving the 4th to be tested as unknowns). Next you must choose what
image to test as an unknown. Choose between D for Dennis or R for Richard,
provide a character to represent which you would like test, and provide a
number representing which alphabet to take it from (given the previous settings,
4 is recommended). The Neural Network will be configured to your settings,
and the results of the given test will be provided.



Overview:

The first step in writing a letter recognition program is to obtain
handwriting samples. At first, we used a tablet to write directly onto a
16x16 pixel canvas. However, both of us felt that the letters the tablet
resulted in were not representative of our individual handwriting. Instead,
we printed blank grids with 1 inch by 1 inch squares on them, and filled each
grid with a letter of the alphabet (uppercase) using a sharpie marker.
These can be found as the Unprocessed files in the TestImages folder. The
marker ensured that our strokes were thick enough to be visible even when the
resolution of the images was scaled down. Then, using Adobe Photoshop, we
individually removed each letter from the grid, scaled it down to fit the 
16x16 image, and ran a threshold on the letter to ensure that each pixel was
either black or white. Given the fact that each of us provided four full
alphabets, this was an extremely time consuming task. However, we feel that this was
worth the time commitment. The letters seem much closer to their unedited
counterparts, and we were able to maintain a level of consistency with each letter
in terms of size and position that is necessary in a project such as this.
However, the tablet route has its benefits as well. Shorter times lead to a
greater output of letters, which provides a much larger sample set to train
a Neural Network with. 

Once the letter images were created, we had to process them using Haskell. We
decided to use Codec.BMP to do so. Codec.BMP allowed to obtain a String representation
of the bytes used to make up each image. That string then becomes a list of numbers
representing the bytes. Finally, we looked at the byte values to determine the
color of each pixel, and given that color created a new list of doubles that acted
as bits, with 1.0 representing a black pixel and 0.0 representing a white pixel.
This work is done in ImageInput.hs. The TestImages folder contains several one,
two, and four pixel images that were used to test the functionality of ImageInput.

A bulk of the assignment's functionality is included in LetterMacher.hs. Aside
from the main method and accompanying IO functions, other functions set up the
images an data in a way that can be used by the Neural Network. We provide the
newtork with a list of images of letters and what letter they represent (they
are presented to the Network as vectors), in order to "train" the network to
recognize what makes a given character that character. After the network is
trained, we can then test an image that the Network has not been trained on. The
network will compare the unknown image to the known ones, and determine which
letter it believes is most like the unknown image.


Resources:

HNN: https://github.com/alpmestan/hnn
http://alpmestan.com/hnn/doc/AI-HNN-FF-Network.html
    HNN (Haskell Nural Networks) is an open source feed-forward neural network
    implementation in Haskell, headed by  Alp Mestanogullari, and is the core of
    our project

Codec.BMP: http://hackage.haskell.org/package/bmp 
http://hackage.haskell.org/packages/archive/bmp/1.2.4.1/doc/html/Codec-BMP.html
    Codec.BMP is the Haskell package that we chose to use to take BMP
    image representations of written letters and transform them into data
    that HNN can utilize. 

Wikipedia (Neural Networks): 
http://en.wikipedia.org/wiki/Artificial_neural_network
    When we first decided to implement a project using Neural Networks, we were
    directed to this article, in particular the section on applications, for
    ideas on what Neural Networks could be used for.

CSS-499, Neural Networks: http://www.willamette.edu/~gorr/classes/cs449/intro.html
    This online course provides an overview of what Neural Networks are and how
    they are implemented. The course provided us with a stronger understanding
    of the different types of Neural Networks, and also explained the mathematical
    foundations upon which they were built. A majority of the knowledge we
    gained about generic, non Haskell-specific Neural Networks came from this
    website. The information needed to complete our project can be found in
    the first four lectures.

Identify Handwriting Individually Using Feed Forward Neural Networks:
http://infonomics-society.org/IJICR/Identify%20Handwriting%20Individually%20Using%20Feed%20Forward%20Neural%20Networks.pdf
    At first, we wanted to use Neural Networks to determine whether or not the
    subject of an image was a cat. Mr. Mestanogullari explained to us that this
    would be an excessively difficult task using HNN, given variables such as
    image size, colors, and the position of a given cat. He instead linked us to
    this article, which discusses the use of Feed Forward Neural Networks to
    determine who among a group of subjects wrote a particular letter. The
    article makes no mention of Haskell, and upon suggestion from Mr.
    Mestanogullari we took care of cropping letters into images of uniform size
    and setting the pixels to pure black or white before feeding them into
    the network.

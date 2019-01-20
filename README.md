# nicar_ocr
A tutorial on optical character recognition using tesseract, ImageMagick and other open source tools

## Introduction

Optical Character Recognition, or OCR, is a key tool in today's journalism. 



## Installation

First things first, we need to install the tools we'll be using.

* Xpdf (We'll be using the pdftotext)
* tesseract
* ImageMagick


we need to install our OCR engine, [tesseract]('https://github.com/tesseract-ocr/tesseract/wiki').

Since this is a Mac-based class, we'll following those install instructions but you can find Windows and Linux in the tesseract [documention]('https://github.com/tesseract-ocr/tesseract/wiki').

For Mac, we'll be using the Homebrew package manager. So for tesseract, you will use the following command.
```
brew install tesseract
```

And for Xpdf, you will use this.
```
brew install xpdf
```

## Files


## Scenario 1: Analyzing a computer generated pdf with embedded text (searchable pdf)

This is probably the easiest problem to solve dealing with pdfs. We want to extract the text from a searchable pdf for analysis of some type.

There are many GUI software programs you can use to do this. They all have strengths and weaknesses.
    Cometdocs
    Tabula (free and great for tabular data!)
    Adobe Acrobat Pro ($$)
    Abbyy Finereader ($$ but also very accurate)

For this tutorial, we're going to use an open source powertool from Xpdf called pdftotext. The construction of the command is pretty intuitive. You point it at a file and it outputs a text file.

```
pdftotext /path/to/my/file.pdf name-of-my-text-file.txt
```

Our example is going to be a rather well known one from just a few months ago. I often use this tool to check for hidden text, particularly in documents that are redacted. 


![Alt Text](/imgs/Manafort_2.png)




But that's just one limited use case. Extracting this text can then be fed into databases or used for visualations.

EXAMPLES HERE.


## Scenario 2: Extracting text from image files

#### Basics of tesseract

```
tesseract imagename outputbase [-l lang] [-psm pagesegmode] [configfile...]
```

Let's look at a single image file. In this case, that's the wh_salaries.png file in our imgs folder. This is the first page of our White House salaries pdf but notice that it is not searchable.

This is perhaps the most simple use of tesseract. We will feed in our image file and have it output a searchable pdf.

In the imgs directory, use the following command. 

```
tesseract wh_salaries.png out pdf
```

You should get a file name out.pdf.


#### Using tesseract

tesseract command construction

```
tesseract imagename|stdin outputbase|stdout [options...] [configfile...]
```


```
tesseract myscan.png out pdf
```

## Scenario 3: Combining our skills to make a searchable pdf out of an image pdf.

#### Converting pdfs to images to prepare for OCR using ImageMagick

ImageMagick command construction

```
convert [options ...] file [ [options ...] file ...] [options ...] file
```

Explanation of best practices, why density and resolution matters, getting the best results


Let's do this with our Manafort documents.


```
convert -density 300 Exhibit_342.pdf -depth 8 -strip -background white -alpha off exhibit_342.tiff
```

#### Now we run this tiff through tesseract

Let's look at the text

Let's make a searchable pdf.


## Where to go from here: 


## Sources and references
I created this tutorial for [NICAR 2019]('https://www.ire.org/events-and-training/conferences/nicar-2019') but it relies on many helpful open source resources that deserve credit. Each of the tutorials, tipsheets and documentation were used in the creation of this tutorial and deserve credit for their excellent work and thanks for sharing it with the world.



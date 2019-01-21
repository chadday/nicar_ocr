# nicar_ocr
A tutorial on optical character recognition using tesseract, ImageMagick and other open source tools

## Introduction

Optical Character Recognition, or OCR, is a key tool in today's journalism. MORE HERE.


## Installation

First things first, we need to install the tools we'll be using.

* [Xpdf](https://www.xpdfreader.com/) is an open source toolkit to work with pdfs. We'll be using its tool, [pdftotext](https://www.xpdfreader.com/pdftotext-man.html).

* [tesseract](https://github.com/tesseract-ocr/tesseract/wiki) is our OCR engine. It was first developed by HP but for the last decade or so it's been maintained by Google.

* ImageMagick

Since this is a Mac-based class, we'll be following Mac install instructions but you can find Windows and Linux in the following documentation.

* Xpdf [documentation]()
* tesseract [documention](https://github.com/tesseract-ocr/tesseract/wiki).
* ImageMagick [documentation]()

For Mac, we'll be using the Homebrew package manager. You can install it [here](). So for tesseract, you will use the following command.
```
brew install tesseract
```

For Xpdf, you will use this.
```
brew install xpdf
```

And for ImageMagick you will use this
```
brew install imagemagick
```

## Files

We'll  be using a number of files for our examples. You can find them in [here](/files).



## Scenario 1: Analyzing a computer generated pdf with embedded text (searchable pdf)

This is probably the easiest problem to solve dealing with pdfs. We want to extract the text from a searchable pdf for analysis of some type.

There are many GUI software programs you can use to do this. They all have strengths and weaknesses.

* [Cometdocs](https://www.cometdocs.com/)
* [Tabula](https://tabula.technology/) (free and great for tabular data!)
* [Adobe Acrobat Pro](https://acrobat.adobe.com/us/en/acrobat/pricing.html?mv=search&sdid=J7XBWTSV&ef_id=CjwKCAiA1ZDiBRAXEiwAIWyNC62H_xFn3sW5k3JAETpc_MeS9HOq-7l-qD2cvFXcU-Qkl-v_TPYjSxoC4bsQAvD_BwE:G:s&s_kwcid=AL!3085!3!99546333262!e!!g!!%2Badobe%20%2Bacrobat%20%2Bpro&gclid=CjwKCAiA1ZDiBRAXEiwAIWyNC62H_xFn3sW5k3JAETpc_MeS9HOq-7l-qD2cvFXcU-Qkl-v_TPYjSxoC4bsQAvD_BwE) ($$)
* [Abbyy Finereader](https://www.abbyy.com/en-us/finereader/?redirect-from=old-fr-pro&__c=1) ($$ but also very accurate)

For this tutorial, we're going to use an open source powertool from Xpdf called pdftotext. The construction of the command is pretty intuitive. You point it at a file and it outputs a text file.

I often use this tool to check for hidden text, particularly in documents that are redacted. Our example is from just a few months ago when lawyers for Paul Manafort accidentally filed a document that wasn't properly redacted. Reporters, including my colleague Michael Balsamo, quickly realized that even though the document contained blacked out sections, the text of those passages was still present. That text [revealed](https://www.apnews.com/608b9fcbca5941348e2ac8796e94c8cd) that Manafort had shared polling data with a Russian associate during the 2016 election.

One way to get to this text is just copy and paste the sections out. But this can be tedious, particularly if there are a lot of sections or you have a large document. A faster and easier to read method is what we're going to do with Xpdf's pdftotext.

Our [document](files/manafort/Manafort_filing.pdf) has several sections like this.

![Alt Text](/imgs/Manafort_2.png)

But since we can tell that there's text underneath there, let's run it through pdftotext and see what comes out.

#### pdftotext command construction

```
pdftotext /path/to/my/file.pdf name-of-my-text-file.txt
```
So for our file it would look something like this.

```
pdftotext Manafort_filing.pdf manafort_filing.txt
```

But that's just one limited use case. Extracting this text can then be fed into databases or used for visualations.

Let's take a look another one of our files involving tabular data, found [here](). This is a salary roster of Trump White House employees. We'll be using a single image page of this file for a later example.


<-- LEFT OFF HERE -->



## Scenario 2: Extracting text from image files

#### Basics of tesseract

```
tesseract imagename outputbase [-l lang] [--oem ocrenginemode] [--psm pagesegmode] [configfiles...]
```


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



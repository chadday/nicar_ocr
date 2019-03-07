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

* Xpdf [documentation](https://www.xpdfreader.com/download.html)
* tesseract [documention](https://github.com/tesseract-ocr/tesseract/wiki).
* ImageMagick [documentation](http://www.imagemagick.org/script/command-line-processing.php)

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

I often use this tool to check for hidden text, particularly in documents that are redacted. Our example is from just a few months ago when lawyers for Paul Manafort accidentally filed a document that wasn't properly redacted. Reporters, including my colleague Michael Balsamo, quickly realized that even though the document contained blacked out sections, the text of those passages was still present. That text [revealed](https://www.apnews.com/608b9fcbca5941348e2ac8796e94c8cd) Manafort had shared polling data with a Russian associate during the 2016 election.

One way to get to this text is just to copy and paste the sections out. But this can be tedious, particularly if there are a lot of sections or you have a large document. A faster and easier to read method is what we're going to do with Xpdf's pdftotext.

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

Let's take a look at another one of our files involving tabular data, found [here](/files/tabular/07012018-report-final.pdf). This is a salary roster of Trump White House employees. We'll be using a single image page of this file for a later example.

![Alt Text](/imgs/wh_salaries.png)

As mentioned before, Tabula is a great tool for getting tabular data out of pdf files, but I wanted to give you another option using pdftotext that works well with fixed-width data files like this White House salaries listing. It also has the added benefit of being easily scriptable.

### pdftotext command for tables

```
pdftotext -table /path/to/my/file name-of-my-text-file.txt
```

We'll test it out on the [file](/files/tabular/07012018-report-final.pdf). You can ```cd``` to it in the ```/files/tabular``` directory.

```
pdftotext -table 07012018-report-final.pdf tabular-test.txt
```

You should get something like this: 

![Alt Text](/imgs/structured.png)

For comparison, try using just pdftotext.

```
pdftotext 07012018-report-final.pdf test.txt
```

You should get something like this (very bad stuff):

![Alt Text](/imgs/unstructured.png)

Now that we've walked through the basics of text extraction with computer generated (nice) pdfs, let's go onto the harder use cases.

## Scenario 2: Basic text extraction from image files

Extracting text from image files is perhaps one of the most common problems reporters face when they get data from government agencies or are trying to build their own databases from scratch (paper records, the dreaded image pdf of an Excel spreadsheet, etc.) To do this, we use OCR and in this example, Tesseract.

#### Basics of tesseract

Tesseract has many options. You can see them by typing:

```
tesseract -h
```

We're not going to go into detail on many of these options but you can read me [here](https://github.com/tesseract-ocr/tesseract/wiki)

The basic command structure looks like this:

```
tesseract imagename outputbase [-l lang] [--oem ocrenginemode] [--psm pagesegmode] [configfiles...]
```

Let's look at a single image file. In this case, that's the wh_salaries.png file in our imgs folder. This is the first page of our White House salaries pdf but notice that it is not searchable.

This is perhaps the most simple use of tesseract. We will feed in our image file and have it output a searchable pdf.

In ```/files/single_img``` directory, use the following command.

```
tesseract wh_salaries.png out pdf
```

You start with a file like this:

![Alt Text](/imgs/wh_salaries.png)

You should get a file name out.pdf and you can see that it's searchable.

![Alt Text](/imgs/searchable_salaries.png)

## Scenario 3: Combining our skills to make a searchable pdf out of an image pdf.

#### Converting pdfs to images to prepare for OCR using ImageMagick

So far, we've covered extracting text from computer generated files and doing some basic OCR. Now, we'll turn to creating searchable pdfs out of image files. To do this, we'll be adding another command line tool called ImageMagick, an image editing and manipulation software.

We will be using the ```convert``` tool from ImageMagick.

ImageMagick has some great documentation that explains all of its many options. You can find it [here](http://www.imagemagick.org/script/command-line-options.php#page)

```
convert [options ...] file [ [options ...] file ...] [options ...] file
```

If you're familiar with photography or document scanning, you know that the proper image resolution is essential for electronic imaging. When it comes to OCR, this is even more true. 

The general standard for OCR is 300 dpi, or 300 dots per inch, though [ABBYY recommends](https://knowledgebase.abbyy.com/article/489) using 400-600 for font sizes smaller than 10 point. In ImageMagick, this is specified using the density flag. Below we are telling ImageMagick to take our pdf document and convert it to an image with 300 dpi.


#### Example with the image file Manafort document

First, we have to convert it to an image so we can run it through tesseract.

We'll use ImageMagick's ```convert``` tool.

```
convert russia_findings.pdf russia_findings.tiff
```

On a Mac, an easy way to find the dpi of an image is to use Preview. Open the image in preview, go to ```Tools``` and click ```Show Inspector```.

So let's take a look at our image we just created.


Explanation of best practices, why density and resolution matters, getting the best results


Let's do this with our Russia document.

```
convert -density 300 russia_findings.pdf -depth 8 -strip -background white -alpha off russia_findings.tiff
```

#### Now we run this tiff through tesseract

```
tesseract russia_findings.tiff -l eng russia_findings_enh pdf
```

(Insert photo here)



## Where to go from here:

OCRing is not a perfect science and most of the time, it isn't simple. One recent example: public financial disclosures of federal judges are multi-page documents but they are released as extremely long, single tiff files.

![Alt Text](/imgs/Walker16.png)

And you'll notice that the pages need to be split.

![Alt Text](/imgs/Walker16_pages.png)

The workflow below walks through one example of how to solve the problem using ImageMagick and Tesseract.

This blows up the images, adjusts the image resolution, ups the contrast to help bring out the text. It then outputs a grayscale version, set at 8-bit depth, named Walker16_enh.tiff.
```
convert -resize 400% -density 450 -brightness-contrast 5x0 Walker16.tiff -set colorspace Gray -separate -average -depth 8 -strip Walker16_enh.tiff
```

Next we use ImageMagick's crop to split it up into a multi-page pdf. (Add details of how to find the dimensions)

```
convert Walker16_enh.tiff -crop 3172x4200 Walker16_to_ocr.tiff
```

Then we convert that image into a searchable pdf.

```
tesseract Walker16_to_ocr.tiff -l eng Walker16 pdf
```

Exploring the various options and fine-tuning your skills with ImageMagick can help prepare you for the next big step: Batch processing of documents, which you can hear more about [here at NICAR](https://www.ire.org/events-and-training/event/3433/4227/).


## Sources and references
I created this tutorial for [NICAR 2019]('https://www.ire.org/events-and-training/conferences/nicar-2019') but it relies on many helpful open source resources that deserve credit. They are listed below. Thanks for sharing your work with the rest of the world.

[Tesseract](https://github.com/tesseract-ocr/tesseract/wiki/Command-Line-Usage) documentation

[ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) documentation

[pdftotext](https://www.xpdfreader.com/pdftotext-man.html) documentation



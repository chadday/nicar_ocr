# NICAR: Advanced PDF processing with OCR and command-line tools
A tutorial on extracting text from PDFs and optical character recognition using tesseract, ImageMagick and other open source tools. Updated for NICAR 2023.

## Introduction

This class seeks to help you solve a common problem in journalism: Data stored in a computer generated PDF or worse an image PDF. We'll first walk through how to extract text from a computer-generated PDF using command line tools. Then we'll step up to Optical Character Recognition, or OCR, to work on image files. 

## New for NICAR 2023

We had some extra time at the end of class to show how you can use `pdfplumber` to extract data from one of the searchable PDFs we created. You can find the notebook [here](/notebooks/pdfplumber_example.ipynb).

## Installation

First things first, we need to install the tools we'll be using. (NICAR attendees using lab laptops: IRE has already completed the install).

* [Xpdf](https://www.xpdfreader.com/) is an open source toolkit to work with pdfs. We'll be using its tool, [pdftotext](https://www.xpdfreader.com/pdftotext-man.html).

* [tesseract](https://github.com/tesseract-ocr/tesseract/wiki) is our OCR engine. It was first developed by HP but for the last decade or so it's been maintained by Google.

* [ImageMagick](http://www.imagemagick.org/script/command-line-processing.php) is an open source image processing and conversion power tool.

* [Ghostscript](https://www.ghostscript.com/index.html) is an interpreter for PDFs and Adobe's PostScript language.

This class will be following the Mac install instructions but you can find Windows and Linux in the following documentation.

* Xpdf [documentation](https://www.xpdfreader.com/download.html)
* tesseract [documention](https://github.com/tesseract-ocr/tesseract/wiki).
* ImageMagick [documentation](http://www.imagemagick.org/script/command-line-processing.php)
* Ghostscript [documentation](https://ghostscript.com/doc/9.21/Install.htm)

For Mac, we'll be using the Homebrew package manager. You can install it [here](https://brew.sh/). 

For tesseract, you will use the following command.
```bash
brew install tesseract
```

For Xpdf, you will use this.
```bash
brew install xpdf
```

We will also install libtiff, a dependency for ImageMagick that we will need.
```bash
brew install libtiff
```

Then we'll install ghostscipt
```bash
brew install ghostscript
```

And for ImageMagick you will use this.
```bash
brew install imagemagick
```

To install all of them at once, you can run the following
```bash
brew install xpdf tesseract libtiff ghostscript imagemagick
```

## Some important updates for 2023

This class doesn't assume that you're working on a Mac with an OS greater than 13 but if you are, you can take advantage of some built-in OCR features. For example, some of the image PDFs you open up from this repo will be automatically OCR'd and have selectable text when you open them on newer Macs. 

You can also try out [textra](https://github.com/freedmand/textra) an open-source project from The Washington Post's Dylan Freedman that uses those built in Mac OCR tools to extra text from image PDFs. 

All of the tools below are also available to you on Mac OS 13 or higher.

If you're not on a newer Mac, fear not! Hopefully some of the tools below will help you out.


## How to think about this class
Text extraction from PDFs and OCRing image files is much more of an art than a science. The tools below are meant to give you a lot of different options to try to get the text out of an image PDF and into a format that you can work with. Sometimes they will work amazingly well. Sometimes they won't work at all. Oftentimes, it's somewhere in the middle where the data will require some clean up.

If you're comforable in Python, I recommend pairing these tools with other great open-source projects such as Jeremy Singer-Vine's [`pdfplumber`](https://github.com/jsvine/pdfplumber), which we used extensively to build several Python parsers for [the Capital Assets project](https://www.wsj.com/articles/capital-assets-11665673055) and many others at The Wall Street Journal.

## Files

We'll be using a number of files for our examples. You can find them in [here](/files).

## Scenario 1: Analyzing a computer generated pdf with embedded text (searchable pdf)

We want to extract the text from a searchable pdf for analysis of some type. There are many GUI software programs you can use to do this. They all have strengths and weaknesses.

* [Cometdocs](https://www.cometdocs.com/)
* [Tabula](https://tabula.technology/) (free and great for tabular data!)
* [Adobe Acrobat Pro](https://acrobat.adobe.com/us/en/acrobat/pricing.html?mv=search&sdid=J7XBWTSV&ef_id=CjwKCAiA1ZDiBRAXEiwAIWyNC62H_xFn3sW5k3JAETpc_MeS9HOq-7l-qD2cvFXcU-Qkl-v_TPYjSxoC4bsQAvD_BwE:G:s&s_kwcid=AL!3085!3!99546333262!e!!g!!%2Badobe%20%2Bacrobat%20%2Bpro&gclid=CjwKCAiA1ZDiBRAXEiwAIWyNC62H_xFn3sW5k3JAETpc_MeS9HOq-7l-qD2cvFXcU-Qkl-v_TPYjSxoC4bsQAvD_BwE) ($$)
* [Abbyy Finereader](https://www.abbyy.com/en-us/finereader/?redirect-from=old-fr-pro&__c=1) ($$ but also very accurate)
* [PDFElement](https://pdf.wondershare.net/ad/pdf-editor-mac.html?gclid=Cj0KCQiA9YugBhCZARIsAACXxeIuIJnFM5WV8YzhxqnEVl_cP7dwNYTGuzNZ-w0AhQiEn6AWrWZZ9TEaAvuXEALw_wcB) 


For this tutorial, we're going to use an open source powertool from Xpdf called `pdftotext`. The construction of the command is pretty intuitive. You point it at a file and it outputs a text file.

I often use this tool to check for hidden text, particularly in documents that have redactions. 

Our example is from 2019 when lawyers for Paul Manafort accidentally filed a document in court that wasn't properly redacted — even though the document contained blacked out sections, the text was still present in the document. You can read more about it [here](https://www.apnews.com/608b9fcbca5941348e2ac8796e94c8cd).

One way to get to this text is just to copy and paste the sections out. But this can be tedious if there are a lot of sections or you have a large document. A faster and easier method is Xpdf's pdftotext.

Our [document](files/manafort/Manafort_filing.pdf) has several sections like this.

![Alt Text](/imgs/Manafort_2.png)

But since we can tell that there's text underneath there, let's run it through `pdftotext` and see what comes out.

#### `pdftotext` command construction

```bash
pdftotext /path/to/my/file.pdf name-of-my-text-file.txt
```
So for our file it would look something like this within the files directory.

```bash
pdftotext Manafort_filing.pdf manafort_filing.txt
```

You can also run it from the repo parent directory.

```bash
pdftotext files/manafort/Manafort_filing.pdf files/manafort/manafort_filing.txt
```

Now, if we look in our newly created text file, we can find full extracted text — including the parts that are blacked out in the PDF. 

Let's take a look at another one of our files involving tabular data, found [here](/files/tabular/07012018-report-final.pdf). This is a salary roster of Trump White House employees. We'll be using a single image page of this file for a later example.

![Alt Text](/imgs/wh_salaries.png)

As mentioned before, Tabula is a great tool for getting tabular data out of pdf files, but I wanted to give you another option using pdftotext that works well with fixed-width data files like this White House salaries listing. It also has the added benefit of being easily scriptable.

### pdftotext command for tables

```bash
pdftotext -table /path/to/my/file name-of-my-text-file.txt
```

We'll test it out on the [file](/files/tabular/07012018-report-final.pdf). You can ```cd``` to it in the ```/files/tabular``` directory or just use the path.

```bash
pdftotext -table 07012018-report-final.pdf tabular-test.txt
```

Or use this command from the repo parent directory

```bash
pdftotext -table files/tabular/07012018-report-final.pdf files/tabular/tabular-test.txt```
```

You should get something like this: 

![Alt Text](/imgs/structured.png)

For comparison, try using just pdftotext.

```bash
pdftotext files/tabular/07012018-report-final.pdf files/tabular/raw-test.txt
```

You should get something like this (very bad stuff):

![Alt Text](/imgs/unstructured.png)

Now that we've walked through one way to extract text from computer generated (nice) pdfs, let's move on to working with image pdfs.

## Scenario 2: Basic text extraction from image files

Extracting text from image files is perhaps one of the most common problems reporters face when they get data from government agencies or are trying to build their own databases from scratch (paper records, the dreaded image pdf of an Excel spreadsheet, etc.) To do this, we use OCR and in this example, `tesseract`.

#### Basics of `tesseract`

`tesseract` has many options. You can see them by typing:

```bash
tesseract -h
```

We're not going to go into detail on many of these options but you can read more [here](https://github.com/tesseract-ocr/tesseract/wiki)

The basic command structure looks like this:

```bash
tesseract imagename outputbase [-l lang] [--oem ocrenginemode] [--psm pagesegmode] [configfiles...]
```

Let's look at a single image file. In this case, that's the wh_salaries.png file in our imgs folder. This is the first page of our White House salaries PDF but notice that it is not searchable.

This is perhaps the most simple use of `tesseract`. We will feed in our image file and have it output a searchable pdf.

In ```/files/single_img``` directory, use the following command.

```bash
tesseract wh_salaries.png out pdf
```

You start with a file like this:

![Alt Text](/imgs/wh_salaries.png)

You should get a file name out.pdf and you can see that it's searchable.

![Alt Text](/imgs/searchable_salaries.png)

## Scenario 3: Combining our skills to make a searchable pdf out of an image pdf.

#### Converting pdfs to images to prepare for OCR using ImageMagick

So far, we've covered extracting text from computer generated files and doing some basic OCR. Now, we'll turn to creating searchable pdfs out of image files. To do this, we'll be adding another command line tool called ImageMagick, an image editing and manipulation software.

We will be using the `convert` tool from ImageMagick.

ImageMagick has some great documentation that explains its many options. You can find it [here](http://www.imagemagick.org/script/command-line-options.php#page)

```bash
convert [options ...] file [ [options ...] file ...] [options ...] file
```

If you're familiar with photography or document scanning, you know that the proper image resolution is essential for electronic imaging. When it comes to OCR, this is even more true. 

The general standard for OCR is 300 dpi, or 300 dots per inch, though [ABBYY recommends](https://knowledgebase.abbyy.com/article/489) using 400-600 for font sizes smaller than 10 point. In ImageMagick, this is specified using the density flag. Below we are telling ImageMagick to take our pdf document and convert it to an image with 300 dpi.

#### Important 

Before we go on from here, let's make sure we have the tiff delegate installed. You can check like this:

```bash
convert -list configure
```

Scroll down to `DELEGATES` and make sure it includes `tiff`

For example:

```bash
DELEGATES      bzlib mpeg freetype jng jpeg lzma png tiff xml zlib
```

#### If you don't have tiff in the list, follow these steps:

First check to make sure that libtiff and ghostscript are installed. You can do this by running

```bash
brew list
```

If ghostscript is not in the list, then install it using brew.
```bash
brew install ghostscript
```

If libtiff is not in the list, then install it using brew.
```bash
brew install libtiff
```

Now check to make sure that imagemagick is recognizing libtiff is installed as a dependency.
```bash
brew info imagemagick
```

If you're good to go, it should look something like this:

```bash
==> Dependencies
Build: pkg-config ✔
Required: freetype ✔, jpeg ✔, libheif ✔, libomp ✔, libpng ✔, libtiff ✔, libtool ✔, little-cms2 ✔, openexr ✔, openjpeg ✔, webp ✔, xz ✔
```
Now that we've installed ghostscript and the tiff delegate, let's continue on with our example.

#### Example with the image file Russia findings document

![Alt Text](/imgs/Screen%20Shot%202019-03-07%20at%208.51.54%20AM.png)

First, we have to convert it to an image so we can run it through tesseract.

We'll use ImageMagick's `convert` tool.

```
convert russia_findings.pdf russia_findings.tiff
```

On a Mac, an easy way to find the dpi of an image is to use Preview. Open the image in preview, go to `Tools` and click `Show Inspector`.

So let's take a look at our image we just created.

#### Open in Preview

![Alt Text](/imgs/preview.png)

#### Go to `Show Inspector`

![Alt Text](/imgs/show_inspector.png)

#### Inspector pane 1

![Alt Text](/imgs/inspector_1.png)

#### Inspector pane 2

![Alt Text](/imgs/inspector_2.png)

So our dpi is `72`, which likely is fine for this document but let's go ahead and up that using convert. This will increase the file size of the tiff we create (so warning about file bloat) but it's only a temporary file that we're using to get the best text recognition.

Let's do this with our Russia document.

```bash
convert -density 300 russia_findings.pdf -depth 8 -strip -background white -alpha off russia_findings.tiff
```

So let's break this down.

`convert` - invokes ImageMagick's convert tool

`-density` - ups the dpi of our image to 300

`russia_finding.pdf ` - our file that we're converting to an image.

`-depth 8` - "This the number of bits in a color sample within a pixel. Use this option to specify the depth of raw images whose depth is unknown such as GRAY, RGB, or CMYK, or to change the depth of any image after it has been read", according to ImageMagick documentation.

`-strip` - strips off any junk on the file (profiles, comments, etc.)

`-background white` - sets the background to white to help with contrasting our text

`-alpha off` -generally the transparency of the image. A great explanation [here](https://www.quora.com/What-exactly-is-an-alpha-channel-in-an-image)

#### Now we run this tiff through tesseract

```bash
tesseract russia_findings.tiff russia_findings_enh pdf 
```

And you've got a searchable pdf!

Let's take a look at the underlying text now.

```bash
pdftotext russia_findings_enh.pdf russia_text.txt
```

## Where to go from here:

#### Scripting and Batch process

Now that we've walked through how some of these tools work, you can put them all together into bash scripts if you like. I've included an example script in this repo that seeks to hold down file bloat but it may require some tweaking for your specific use case. OCRing is not a perfect science and most of the time, it takes some trial and error to find the right settings for the documents you're working with.

Try it out on `russia_findings.pdf` in the `image_pdfs` folder. (You will likely need to run `chmod u+x im_ocr.sh`)

##### Output a searchable pdf

```bash
./im_ocr.sh /files/image_pdfs/russia_findings.pdf pdf
```

In the IRE mac lab, the terminals by default use zsh, so we'll want to invoke bash manually instead like below.

```bash
bash im_ocr.sh /files/image_pdfs/russia_findings.pdf pdf
```

##### Output a text file
```bash
./im_ocr.sh /files/image_pdfs/russia_findings.pdf txt
```

In the IRE mac lab, the terminals by default use zsh, so we'll want to invoke bash manually instead like below.

```bash
bash im_ocr.sh /files/image_pdfs/russia_findings.pdf txt
```
#### Judicial Public Financial Disclosure Example

Public financial disclosures of federal judges are multi-page documents but they are released as extremely long, single tiff files. You can find a similar test file [here](https://drive.google.com/open?id=11YpC2-0yYyuJL7AJnvG48q9H8hrrDQon)

![Alt Text](/imgs/Walker16.png)

And you'll notice that the pages need to be split.

![Alt Text](/imgs/Walker16_pages.png)

The workflow below walks through one example of how to solve the problem using ImageMagick and Tesseract.

This blows up the images, adjusts the image resolution, ups the contrast to help bring out the text. It then outputs a grayscale version, set at 8-bit depth, named `Walker16_enh.tiff`.
```bash
convert -resize 400% -density 450 -brightness-contrast 5x0 Walker16.tiff -set colorspace Gray -separate -average -depth 8 -strip Walker16_enh.tiff
```

Next we use ImageMagick's crop to split it up into a multi-page pdf. 

To find the dimensions, first use Preview's Inspector tool. You 'll see the dimensions of the entire image file. (NOTE: This screenshot is from a different file since I added this later.)

![Alt Text](/imgs/find_inspector.png)

The first value is the width and the second value is the length. To get the pixel length of each page, just divide by the number of pages you should have in the final file.

![Alt Text](/imgs/dimensions.png)

```bash
convert Walker16_enh.tiff -crop 3172x4200 Walker16_to_ocr.tiff
```

Then we convert that image into a searchable pdf.

```bash
tesseract Walker16_to_ocr.tiff -l eng Walker16 pdf
```

Exploring the various options and fine-tuning your skills with ImageMagick can help prepare you for the next big step: Batch processing of documents. 

As mentioned above, you should definitely check out [`pdfplumber`](https://github.com/jsvine/pdfplumber#extracting-tables) and Jeremy's tutorial on how to get started with it found [here](https://mybinder.org/v2/gh/jsvine/nicar-2023-pdfplumber-workshop/HEAD?labpath=notebooks/00-hello-world.ipynb).

## Sources and references
I originally created this tutorial for [NICAR 2019]('https://www.ire.org/events-and-training/conferences/nicar-2019'). It was update for [NICAR 2022](https://schedules.ire.org/nicar-2022/). It relies on many helpful open source resources that deserve credit. They are listed below. Thanks for sharing your work with the rest of the world.

[Tesseract](https://github.com/tesseract-ocr/tesseract/wiki/Command-Line-Usage) documentation

[ImageMagick](https://www.imagemagick.org/script/command-line-processing.php) documentation

[pdftotext](https://www.xpdfreader.com/pdftotext-man.html) documentation

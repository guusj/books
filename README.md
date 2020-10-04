# Warbreaker (Brandon Sanderson) rev1.

- Please read the Brandon Sanderson web page ([https://brandonsanderson.com](https://brandonsanderson.com)) about the author's view of releasing this book free to the public. Please respect the author's rights and buy his books if you like this one (or try another one even if you are not convinced by this book, he has written awesome books).
- The books on github are created mechanically from the markdown file and it shows. This may be a good reason for buying the book if you liked it.
- The generated DOCX and PDF files are not perfect. Probably they require manual adjustments. It is probably better to create a PDF from the DOCX file after making some manual changes. This may be the best way to create prettier EPUB/MOBI files as well (eg using LibreOffice).
- Since the original (Warbreaker_hardcover_1st_ed.pdf) was stored in PDF (notoriously difficult to convert to markdown) it is possible that minor differences slipped through during the conversion.

**Building EPUB, MOBI, PDF and DOCX versions**

The following programs are needed:
- GNU make
- Calibre
- Info-ZIP zip for creating the release zip file
- A Unix-like shell (present on Linux or MacOS, on Windows something like MSYS2 or Busybox for Windows can be used)
Make sure that make and ebook-convert are in your PATH (eg "/c/Program Files (x86)/Calibre2").
Building is similar to building software: just type "make" on the prompt. See Makefile contents for other options.

**Differences compared to the original Warbreaker_hardcover_1st_ed.pdf**

* The front page was not included in Warbreaker_hardcover_1st_ed.pdf, so it may not be covered by the license. Since I doubt that the license allows adding own additions the official releases here will have a text-only front page.
* Paragraph markers are horizontal lines instead of fancy drawings.
* The numbers in the list on the first page are written as "1." instead of "1)" so they are interpreted as a list.
* The map is a merge of the pictures in the original. Rotated clockwise.
* The table of contents is a lot longer since all chapters are included.
* The chapters do not start with an initial (so in some cases a quotation mark needed to be added).
* The paragraphs do not start indented in the DOCX and PDF formats.
* Some obvious fixes were made (see BUGS).

guusj

# web-scraping-and-OCR

The code uses `rvest` and `tesseract` to scrape the details of [H.C.Wainwright](https://hcwco.com/) transactions.

H.C.Wainwright regularly updates there website with small images of their transaction details. To scrape these details the code does the following.

- Scrapes the image url with `rvest`
- Extracts the image text using `tesseract`
- Processes the text for details
- Searches yahoo for the ticker and scraped again with `rvest`



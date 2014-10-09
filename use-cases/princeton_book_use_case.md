# Princeton Book Use Case

Sponsor: @jpstroop

```
Given a book with many pages, and many images of each page  
As a repository comprised of digitized books and manuscripts  
I want to maintain the relationships between images of a page and technical, 
    descriptive, and provenance metadata about each image, while also 
    maintaining the sorting and label information about the page in one place  
So that I can have multiple images of a page tied to one instance of a model 
    without relying on naming conventions (e.g. jp2_md5_checksum)  
```

Formalities aside, I'd like to see a model that does something like the following (`GenericWork` carries way too much baggage for me, so I'm going to use `GenericThing`):



More info: https://github.com/projecthydra-labs/hydra-works/issues/9

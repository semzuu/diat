# Diat

Small Markdown-based presentation app written in Elm and Go

## Usage

Presentations are written in Markdown. Each slide is seperated by `---`  
HTML tags can be used directly, including `<style>` tags for custom slides.  
Code highlighting is not supported.  

### Example Presentation:
```markdown
# First Slide
Some Text in the first Slide  
---
# Second Slide
Can use images and links

[link](https://www.example.com)

![cat_image](https://cataas.com/cat)  
---
# Third Slide
Can use <mark>HTML</mark> Tags directly  

![img](./img.jpg)
---
<style>
    .slide{ background: linear-gradient(140deg, rgba(0,189,77,1) 0%, rgba(233,0,255,1) 100%);
    h1{font-size: 50px; font-weight: 100; font-style: italic;}
    h2{color: cyan;}
</style>
# Custom Styles Test
## Cyan SubHeading
```

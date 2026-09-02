# Headless HTML rendering

This native sample builds a complete HTML document with typed DOM tags. It
demonstrates canonical attribute ordering, escaped text and attributes, form
control state, and `domDocument().serializeHtml()`.

Run it from the standard-library workspace:

```sh
doof run dom/samples/headless-render
```

The output is a single HTML document, so it can also be redirected to a file:

```sh
doof run dom/samples/headless-render > page.html
```

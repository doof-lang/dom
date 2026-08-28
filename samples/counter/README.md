# `std/dom` counter sample

From the standard-library workspace:

```sh
doof build dom/samples/counter
cd dom/samples/counter/build
python3 -m http.server 8080
```

Open `http://localhost:8080/web/`. The development build contains the adapter
at `std/dom/doof-dom.js`. When packaging a standalone site, copy that adapter
into the application's own resource tree and update the import path. Alongside
the DOM and Canvas 2D examples, the page renders a small WebGL textured card
batch using interleaved vertices, indexed drawing, and instancing with a
single-draw fallback.

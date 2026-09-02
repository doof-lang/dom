# std/dom

`std/dom` lets a Doof program create and mutate DOM elements with typed-tag
syntax. In browser-Wasm builds elements are live: calling `div` immediately
calls `document.createElement("div")`, and every placement or mutation is
applied synchronously.

Native builds use an in-memory headless DOM with the same element and placement
API. `outerHtml()`, `innerHtml()`, and `domDocument().serializeHtml()` produce
canonical HTML with sorted attributes and current form-control state, making
the native backend suitable for server rendering and deterministic snapshots.

Two native samples exercise that backend:

```sh
doof run dom/samples/headless-render
doof run dom/samples/headless-components
```

`headless-render` emits a complete HTML document suitable for static or server
rendering. `headless-components` shows state mutation, retained-handle
reordering, unmounting and reattachment, replacement, handler cleanup, and
recursive disposal as a sequence of snapshots.

The API intentionally does not expose parent or child navigation. The browser
DOM is the hierarchy source of truth; Doof code moves known element handles.

## Basic use

```doof
import { button, div, domDocument } from "std/dom"

export function start(): none {
  let count = 0
  label := <div className="count">Count: 0</div>
  increment := <button onClick=>{
    count += 1
    label.setText("Count: " + string(count))
  }>Increment</button>

  <div>{label}{increment}</div>.appendTo(domDocument().body())
}
```

The HTML shell should have an empty body. Loading `doof-dom.js`, instantiating
the compiled module, and calling `start` looks like this:

```js
import { loadDoofDom } from "./doof-dom.js";

const app = await loadDoofDom("./app.wasm");
app.call("start");
```

The adapter is copied into the native build workspace with the module. For a
packaged site, copy `doof-dom.js` into the application's own declared web
resources.

## Placement

Placement methods operate on the element being moved and return that element:

```doof
item.appendTo(container)
item.insertBefore(reference)
item.insertAfter(reference)
replacement.replace(existing)
item.unmount()
```

All operations preserve element identity. `unmount` only detaches, so the same
handle and its event callbacks can be placed again. The borrowed values from
`domDocument().head()` and `.body()` are placement targets and cannot
themselves be replaced or unmounted.

`dispose()` is the permanent lifecycle boundary for dynamically removed UI. It
recursively unregisters event handlers, disposes managed descendants, removes
the subtree, and releases browser resources. It is safe to call more than once;
other operations on a disposed element panic. Use `unmount()` when the element
will be reattached, and `dispose()` when it will not.

## Elements

The module exports typed constructors for `div`, `span`, `p`, `section`,
`heading`, `label`, `input`, `form`, and `button`. Every constructor creates its
DOM element immediately. Container elements accept element or string children;
strings use text nodes and are never interpreted as HTML.

Common named arguments include `id`, `className`, `role`, `title`, `ariaLabel`,
and `tabIndex`. Form controls add their expected properties: inputs support
`name`, `value`, `placeholder`, `inputType`, `checked`, and `disabled`; labels
support `htmlFor`; buttons default to `buttonType="button"` so they do not
accidentally submit a containing form.

```doof
name := <input
  id="name"
  placeholder="Your name"
  ariaLabel="Your name"
  onInput=>{ output.setText(event.value ?? "") }
/>

profile := <form onSubmit=>{ event.preventDefault() }>
  <heading level=2>Profile</heading>
  <label htmlFor="name">Name</label>
  {name}
  <button buttonType="submit">Save</button>
</form>
```

Live elements support fluent `setText`, `setId`, `setClassName`, `setDisabled`,
`setValue`, `setChecked`, `setAttribute`, `removeAttribute`, `focus`, and
`blur` mutations. `setAttribute` is the escape hatch for attributes that do not
yet merit a typed constructor argument.

## Events

Constructors support `onClick`, `onInput`, `onChange`, and `onSubmit` where
appropriate. These handlers are optional; an omitted handler does not register
a browser listener. A contextual `=>` closure inherits the callback parameter
name even though the expected callback is optional, so `event` is in scope
without an explicit parameter:

```doof
button := <button onClick=>{
  println(event.eventType)
  event.preventDefault()
}>Inspect</button>
```

The event is a snapshot containing target metadata, the current control's
`value` and `checked` state, timestamp, pointer/key details, and modifier flags.
It also supports `preventDefault`,
`stopPropagation`, and `stopImmediatePropagation`.

Handlers can also be replaced or cleared without recreating the element:

```doof
field.setOnInput(handleInput)
field.clearOnInput()
```

`clearEventHandlers()` removes every handler on an element while keeping the
element alive. Pass `true` to clear handlers throughout its managed subtree.
This is useful for breaking reference-counting cycles before handing a retained
tree to different code; `dispose()` always performs recursive cleanup.

The same retained-handler methods are available for click, change, and submit.

## Canvas

`canvas` creates a live canvas element and returns a `Canvas` handle. It can be
placed, moved, unmounted, and used as a child without exposing DOM traversal.
Calling `context2d()` returns an opaque retained `Canvas2DContext`:

```doof
surface := <canvas width=320 height=120 ariaLabel="Chart preview">
  Canvas unavailable
</canvas>

surface.context2d()
  .setFillStyle("#111827")
  .fillRect(0.0, 0.0, 320.0, 120.0)
  .setStrokeStyle("#60a5fa")
  .setLineWidth(4.0)
  .beginPath()
  .moveTo(20.0, 90.0)
  .lineTo(120.0, 30.0)
  .stroke()

surface.appendTo(domDocument().body())
```

The initial 2D surface covers state save/restore, paths, rectangles, arcs,
transforms, fill/stroke styles, text, and text-width measurement. Canvas bitmap
dimensions use `width` and `height`; CSS sizing remains available through
classes or attributes. Images, gradients, pixel buffers, clipping, and line
dash arrays are intentionally deferred until the core bridge has real usage.

## WebGL

`Canvas.contextWebgl()` creates a WebGL 2 context. WebGL 2 is required; context
creation fails on browsers or GPUs that do not provide it. Shaders, programs,
buffers,
and textures are opaque retained handles; their browser resources are deleted
when their Doof handles are released. Shader compilation and program linking
return `Result` values containing the browser's diagnostic log on failure.
Context attributes can be selected up front with `WebGLContextOptions`,
including alpha, antialiasing, depth, stencil, retained drawing buffers, and
the browser power preference.

```doof
import {
  canvas, domDocument, WebGLBufferTarget, WebGLPrimitive,
} from "std/dom"

surface := <canvas width=320 height=180 ariaLabel="Triangle preview"/>
gl := surface.contextWebgl()
program := try! gl.createProgram(
  "#version 300 es\nin vec2 position; void main() { gl_Position = vec4(position, 0.0, 1.0); }",
  "#version 300 es\nprecision mediump float; out vec4 color; void main() { color = vec4(0.3, 0.8, 1.0, 1.0); }",
)
vertices := gl.createBuffer()

gl.useProgram(program)
  .bindBuffer(WebGLBufferTarget.Array, vertices)
  .bufferData(WebGLBufferTarget.Array, [-0.8, -0.8, 0.8, -0.8, 0.0, 0.8])

position := gl.attributeLocation(program, "position")
gl.enableAttribute(position)
  .attributePointer(position, 2)
  .viewport(0, 0, 320, 180)
  .clearColor(0.0, 0.0, 0.0, 1.0)
  .clear()
  .drawArrays(WebGLPrimitive.Triangles, 0, 3)

surface.appendTo(domDocument().body())
```

The foundational surface includes shader/program compilation, interleaved
float attributes, raw byte buffers, unsigned-short and core
unsigned-int index buffers, scalar/vector and 4x4-matrix
uniforms, viewport and clear state, capability toggles, indexed and
non-indexed draws, and explicit flush/finish.

Matrix layout is explicit at the API boundary. `uniformMatrix4ColumnMajor`
accepts WebGL-native column-major values, and `uniformMatrix4` remains its
short alias. `uniformMatrix4Rows` accepts consecutive matrix rows and
reorders them before upload; this matches the `m00` through `m33` convention
used by `std/game`. WebGL's transpose argument remains `false` in both cases.

The first game-oriented layer adds raw RGBA textures, texture units,
filtering/wrapping/mipmap controls, pixel unpack state, and the common render
states needed to express a pass: blending, depth comparison and writes, color
masks, face culling and winding, scissor rectangles, and polygon offset. It is
enough to model the interleaved meshes, texture atlases, alpha passes, and card
or particle batches used by `std/game` without exposing browser objects.

Core WebGL 2 instancing is exposed through `supportsInstancing`,
`attributeDivisor`, and the two instanced draw methods. The capability method
and `bool` draw results remain for API compatibility, but succeed for every
created context. The counter sample demonstrates a tiny textured card batch.

Unsigned-int indices are part of the required WebGL 2 baseline. Consumers can
still call `supportsUnsignedIntIndices` for API compatibility, and inspect
`maxVertexAttributes` and `maxTextureUnits` before selecting a batch layout.
`bufferDataBytes` preserves packed and normalized vertex data;
`bufferDataUnsignedInt` is intended for the 32-bit indices used by
`std/game` meshes.

`loadImage` asynchronously decodes browser images and returns a cancellable
request, which the caller retains until completion. Loaded `BrowserImage`
handles retain the decoded source and can be
uploaded with `textureImage` or `createTextureImage`; both image and texture
resources are released deterministically. Compressed texture formats and
general extension access remain future layers.

Depth textures and render targets are part of the WebGL 2 baseline;
`supportsDepthTextures()` remains as a compatibility query. A depth texture can
be
paired with `createDepthFramebuffer`; framebuffer and renderbuffer handles are
retained resources and are deleted deterministically. The lower-level bind,
attach, storage, and status methods remain available for render-pass code.

## Browser game host primitives

`requestAnimationFrame` returns a cancellable, one-shot retained request.
`domDocument().window()` exposes keyboard, resize, and pointer-up handlers;
canvas handles expose pointer, double-click, wheel, and WebGL
context-loss/restoration handlers. Canvas bitmap and client dimensions,
viewport position, and device pixel ratio let a consumer keep its drawable
correctly sized and translate pointer positions into canvas-local coordinates.
`gamepads()` provides current
connection, button, axis, and controller-id queries through the browser
Gamepad API.

## Testing

```sh
doof test dom
node --test dom/tests/doof-dom.test.mjs
```

The counter sample is under `samples/counter`.

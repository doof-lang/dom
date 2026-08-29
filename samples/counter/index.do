import {
  BrowserImage, ImageLoadRequest,
  button, canvas, div, domDocument, form, heading, input, label, loadImage, p, span,
  WebGLBlendFactor, WebGLBufferTarget, WebGLCapability, WebGLContextOptions,
  WebGLDataType, WebGLFramebufferTarget, WebGLPowerPreference, WebGLPrimitive, WebGLTextureFilter,
  WebGLTextureTarget, WebGLTextureWrap,
} from "std/dom"

let imageRequests: ImageLoadRequest[] = []

export function start(): none {
  let count = 0
  countLabel := <div id="count" className="count">Count: 0</div>
  increment := <button id="increment" onClick=>{
    count += 1
    countLabel.setText("Count: " + string(count))
  }>Increment</button>
  movable := <div id="movable">Move me</div>

  greeting := <span id="greeting">Hello, stranger</span>
  name := <input
    id="name"
    name="name"
    placeholder="Your name"
    ariaLabel="Your name"
    onInput=>{
      value := event.value ?? ""
      greeting.setText(if value == "" then "Hello, stranger" else "Hello, " + value)
    }
  />
  profile := <form id="profile" onSubmit=>{
    event.preventDefault()
    greeting.setAttribute("data-submitted", "true")
  }>
    <heading level=2>Profile</heading>
    <label htmlFor="name">Name</label>
    {name}
    <button id="save" buttonType="submit">Save</button>
    <p>{greeting}</p>
  </form>

  surface := <canvas id="preview" width=320 height=120 ariaLabel="Canvas preview">
    Your browser does not support canvas.
  </canvas>
  drawing := surface.context2d()
  drawing.setFillStyle("#111827").fillRect(0.0, 0.0, 320.0, 120.0)
  drawing.setFillStyle("#22c55e").beginPath().arc(52.0, 60.0, 28.0, 0.0, 6.283185).fill()
  drawing.setStrokeStyle("#60a5fa").setLineWidth(5.0).beginPath()
    .moveTo(96.0, 82.0).lineTo(142.0, 34.0).lineTo(188.0, 82.0).stroke()
  drawing.setFillStyle("#f9fafb").setFont("16px sans-serif").fillText("Doof + Canvas", 204.0, 66.0)

  webglSurface := <canvas id="webgl-preview" width=320 height=160 ariaLabel="WebGL textured instances preview">
    Your browser does not support WebGL 2.
  </canvas>
  gl := webglSurface.contextWebgl(WebGLContextOptions {
    alpha: false,
    antialias: true,
    powerPreference: WebGLPowerPreference.HighPerformance,
  })
  program := try! gl.createProgram(
    "#version 300 es\nin vec2 position; in vec2 uv; in vec2 instanceOffset; uniform mat4 scene; out vec2 textureUv; void main() { textureUv = uv; gl_Position = scene * vec4(position + instanceOffset, 0.0, 1.0); }",
    "#version 300 es\nprecision mediump float; in vec2 textureUv; uniform sampler2D atlas; out vec4 fragmentColor; void main() { fragmentColor = texture(atlas, textureUv); }",
  )
  vertices := gl.createBuffer()
  indices := gl.createBuffer()
  instances := gl.createBuffer()
  pixels: byte[] := [
    34, 197, 94, 255, 96, 165, 250, 255,
    96, 165, 250, 255, 34, 197, 94, 255,
  ]
  texture := gl.createTextureRgba(2, 2, pixels)
  depthTexture := try! gl.createDepthTexture(128, 128)
  depthFramebuffer := try! gl.createDepthFramebuffer(depthTexture)
  gl.bindFramebuffer(WebGLFramebufferTarget.Framebuffer, depthFramebuffer)
    .viewport(0, 0, 128, 128)
    .colorMask(false, false, false, false)
    .clear(false, true)
    .unbindFramebuffer()
    .colorMask(true, true, true, true)
  gl.useProgram(program)
    .bindBuffer(WebGLBufferTarget.Array, vertices)
    .bufferData(WebGLBufferTarget.Array, [
      -0.18, -0.25, 0.0, 0.0,
       0.18, -0.25, 1.0, 0.0,
       0.18,  0.25, 1.0, 1.0,
      -0.18,  0.25, 0.0, 1.0,
    ])
  position := gl.attributeLocation(program, "position")
  uv := gl.attributeLocation(program, "uv")
  instanceOffset := gl.attributeLocation(program, "instanceOffset")
  gl.enableAttribute(position).attributePointer(position, 2, WebGLDataType.Float, false, 16, 0)
    .enableAttribute(uv).attributePointer(uv, 2, WebGLDataType.Float, false, 16, 8)
    .bindBuffer(WebGLBufferTarget.ElementArray, indices)
    .bufferDataUnsignedShort(WebGLBufferTarget.ElementArray, [0, 1, 2, 0, 2, 3])
    .bindBuffer(WebGLBufferTarget.Array, instances)
    .bufferData(WebGLBufferTarget.Array, [
      -0.64, 0.4, 0.0, 0.4, 0.64, 0.4,
      -0.64, -0.4, 0.0, -0.4, 0.64, -0.4,
    ])
    .enableAttribute(instanceOffset).attributePointer(instanceOffset, 2)
    .activeTexture(0).bindTexture(WebGLTextureTarget.Texture2D, texture)
    .setTextureMinFilter(WebGLTextureTarget.Texture2D, WebGLTextureFilter.Nearest)
    .setTextureMagFilter(WebGLTextureTarget.Texture2D, WebGLTextureFilter.Nearest)
    .setTextureWrapS(WebGLTextureTarget.Texture2D, WebGLTextureWrap.ClampToEdge)
    .setTextureWrapT(WebGLTextureTarget.Texture2D, WebGLTextureWrap.ClampToEdge)
    .enable(WebGLCapability.Blend)
    .blendFunc(WebGLBlendFactor.SourceAlpha, WebGLBlendFactor.OneMinusSourceAlpha)
    .viewport(0, 0, 320, 160).clearColor(0.04, 0.07, 0.14, 1.0).clear()
  gl.uniform1i(program, "atlas", 0)
  gl.uniformMatrix4Rows(program, "scene", [
    1.0, 0.0, 0.0, 0.03,
    0.0, 1.0, 0.0, -0.02,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0,
  ])
  gl.attributeDivisor(instanceOffset, 1)
  gl.drawElementsInstanced(WebGLPrimitive.Triangles, 6, WebGLDataType.UnsignedShort, 6)
  gl.flush()

  imageStatus := <p id="image-texture-status">Loading image texture</p>
  imageRequests.push(loadImage(
    "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='2' height='2'%3E%3Cpath fill='%2322c55e' d='M0 0h2v2H0z'/%3E%3C/svg%3E",
    (result: Result<BrowserImage, string>): none => {
      case result {
        success: Success -> {
          image := success.value
          gl.createTextureImage(image)
          imageStatus.setText("Loaded image texture: " + string(image.width()) + "x" + string(image.height()))
        },
        failure: Failure -> imageStatus.setText("Image texture failed: " + failure.error),
      }
    },
  ))

  before := <button onClick=>{ movable.insertBefore(countLabel) }>Move before</button>
  after := <button onClick=>{ movable.insertAfter(increment) }>Move after</button>
  detach := <button onClick=>{ movable.unmount() }>Unmount</button>
  attach := <button onClick=>{ movable.appendTo(domDocument().body()) }>Append to body</button>
  replacement := <button onClick=>{
    <div id="replacement">Replacement</div>.replace(movable)
  }>Replace</button>

  layout := <div id="app" className="app">
    <div className="controls">{countLabel}{increment}</div>
    {profile}
    {surface}
    {webglSurface}
    {imageStatus}
    {movable}
    <div className="controls">{before}{after}{detach}{attach}{replacement}</div>
  </div>
  layout.appendTo(domDocument().body())
}

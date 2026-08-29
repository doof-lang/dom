import { Assert } from "std/assert"
import {
  button, canvas, div, domDocument, DomEvent, Element, form, gamepads, heading, input, label, p,
  ImageCrossOrigin, loadImage, requestAnimationFrame, section, span,
  WebGLBlendEquation, WebGLBlendFactor, WebGLBufferTarget, WebGLBufferUsage,
  WebGLCapability, WebGLCompareFunction, WebGLContextOptions, WebGLCullFace,
  WebGLDataType, WebGLFrontFace, WebGLPowerPreference, WebGLPrimitive,
  WebGLFramebufferAttachment, WebGLFramebufferStatus, WebGLFramebufferTarget,
  WebGLRenderbufferFormat, WebGLRenderbufferTarget, WebGLShaderType,
  WebGLTextureFilter, WebGLTextureTarget, WebGLTextureWrap,
} from "../index"

export function testCreatesAndPlacesElementsImmediately(): none {
  body := domDocument().body()
  first := <div id="first" className="panel">Hello</div>
  second := <button disabled=true>Continue</button>

  Assert.equal(first.appendTo(body), first)
  Assert.equal(second.insertAfter(first), second)
  Assert.equal(second.insertBefore(first), second)
  Assert.equal(second.unmount(), second)
  Assert.equal(second.appendTo(body), second)
}

export function testMovesAndReusesElementHandles(): none {
  body := domDocument().body()
  first := <div>First</div>
  second := <div>Second</div>
  replacement := <div>Replacement</div>

  first.appendTo(body)
  second.appendTo(body)
  replacement.replace(first)
  first.replace(second)
  replacement.unmount().appendTo(body)
}

export function testMutationsAreFluent(): none {
  element := div()
  Assert.equal(element.setText("safe <strong>text</strong>"), element)
  Assert.equal(element.setId("status"), element)
  Assert.equal(element.setClassName("ready"), element)
  Assert.equal(element.setDisabled(true), element)
  Assert.equal(element.setValue("draft"), element)
  Assert.equal(element.setChecked(true), element)
  Assert.equal(element.setAttribute("data-state", "ready"), element)
  Assert.equal(element.removeAttribute("data-state"), element)
  Assert.equal(element.focus(), element)
  Assert.equal(element.blur(), element)
}

export function testContextualTagHandlerReceivesNamedEvent(): none {
  let eventType = ""
  element := <button onClick=>{ eventType = event.eventType }>Inspect</button>
  acceptsElement(element)
  Assert.equal(eventType, "")
}

export function testCreatesFormElementsAndContextualOptionalHandlers(): none {
  let latest = ""
  field := <input
    id="name"
    name="name"
    placeholder="Your name"
    ariaLabel="Name"
    onInput=>{ latest = event.value ?? "" }
    onChange=>{ latest = event.value ?? "" }
  />
  submit := <button buttonType="submit">Save</button>
  view := <form onSubmit=>{ event.preventDefault() }>
    <heading level=2>Profile</heading>
    <label htmlFor="name">Name</label>
    {field}
    <section><p><span>Status</span></p></section>
    {submit}
  </form>

  Assert.equal(latest, "")
  Assert.equal(view.setOnSubmit(acceptsEvent).clearOnSubmit(), view)
  Assert.equal(field.setOnInput(acceptsEvent).clearOnInput(), field)
  Assert.equal(field.setOnChange(acceptsEvent).clearOnChange(), field)
  Assert.equal(submit.setOnClick(acceptsEvent).clearOnClick(), submit)
}

export function testCreatesAndDrawsToCanvas(): none {
  surface := <canvas id="preview" width=320 height=180 ariaLabel="Preview">Canvas unavailable</canvas>
  context := surface.context2d()
  frame := requestAnimationFrame((timestamp: double): none => { Assert.isTrue(timestamp >= 0.0) })
  frame.cancel()
  imageRequest := loadImage(
    "texture.png",
    (result): none => {
      _ := result else error { Assert.stringContains(error, "texture.png") }
    },
    ImageCrossOrigin.Anonymous,
  )
  imageRequest.cancel()
  domDocument().window()
    .setOnKeyDown(acceptsEvent)
    .setOnKeyUp(acceptsEvent)
    .setOnResize(acceptsEvent)
    .clearOnKeyDown().clearOnKeyUp().clearOnResize()
  surface
    .setOnPointerDown(acceptsEvent)
    .setOnPointerMove(acceptsEvent)
    .setOnPointerUp(acceptsEvent)
    .setOnPointerCancel(acceptsEvent)
    .setOnWheel(acceptsEvent)
    .setOnWebglContextLost(acceptsEvent)
    .setOnWebglContextRestored(acceptsEvent)
  pads := gamepads()
  Assert.equal(pads.count(), 0)
  Assert.isFalse(pads.connected(0))
  Assert.equal(pads.id(0), "")
  Assert.isFalse(pads.buttonPressed(0, 0))
  Assert.approxEqual(pads.buttonValue(0, 0), 0.0)
  Assert.approxEqual(pads.axis(0, 0), 0.0)
  Assert.equal(surface.setWidth(640), surface)
  Assert.equal(surface.setHeight(360), surface)
  Assert.equal(surface.setClassName("preview"), surface)
  Assert.equal(surface.setAttribute("data-kind", "chart").removeAttribute("data-kind"), surface)
  Assert.equal(surface.focus().blur(), surface)
  Assert.equal(surface.unmount().appendTo(domDocument().body()), surface)

  Assert.equal(context.save().restore(), context)
  Assert.equal(context.beginPath().moveTo(0.0, 0.0).lineTo(20.0, 20.0).closePath().stroke(), context)
  Assert.equal(context.beginPath().rect(1.0, 2.0, 30.0, 40.0).fill(), context)
  Assert.equal(context.beginPath().arc(10.0, 10.0, 5.0, 0.0, 3.14).stroke(), context)
  Assert.equal(context.clearRect(0.0, 0.0, 10.0, 10.0), context)
  Assert.equal(context.fillRect(0.0, 0.0, 10.0, 10.0), context)
  Assert.equal(context.strokeRect(0.0, 0.0, 10.0, 10.0), context)
  Assert.equal(context.translate(2.0, 3.0).scale(2.0, 2.0).rotate(0.5).resetTransform(), context)
  Assert.equal(context.setTransform(1.0, 0.0, 0.0, 1.0, 4.0, 5.0), context)
  Assert.equal(context.setFillStyle("red").setStrokeStyle("blue").setLineWidth(2.0), context)
  Assert.equal(context.setFont("16px sans-serif").setTextAlign("center").setTextBaseline("middle"), context)
  Assert.equal(context.setLineCap("round").setLineJoin("round").setMiterLimit(4.0), context)
  Assert.equal(context.setGlobalAlpha(0.5).setGlobalCompositeOperation("source-over").setLineDashOffset(1.0), context)
  Assert.equal(context.fillText("Doof", 4.0, 8.0).strokeText("Doof", 4.0, 8.0, 100.0), context)
  Assert.approxEqual(context.measureTextWidth("Doof"), 4.0)

  container := <div>{surface}</div>
  acceptsElement(container)
}

export function testBuildsAFoundationalWebGLPipeline(): none {
  surface := <canvas width=320 height=180 ariaLabel="WebGL preview"/>
  gl := surface.contextWebgl(WebGLContextOptions {
    alpha: false,
    antialias: false,
    stencil: true,
    premultipliedAlpha: false,
    preserveDrawingBuffer: true,
    powerPreference: WebGLPowerPreference.HighPerformance,
  })
  vertex := try! gl.compileShader(
    WebGLShaderType.Vertex,
    "#version 300 es\nin vec2 position; void main() { gl_Position = vec4(position, 0.0, 1.0); }",
  )
  fragment := try! gl.compileShader(
    WebGLShaderType.Fragment,
    "#version 300 es\nprecision mediump float; uniform vec4 color; out vec4 fragmentColor; void main() { fragmentColor = color; }",
  )
  program := try! gl.linkProgram(vertex, fragment)
  convenienceProgram := try! gl.createProgram(
    "#version 300 es\nin vec2 position; void main() { gl_Position = vec4(position, 0.0, 1.0); }",
    "#version 300 es\nprecision mediump float; out vec4 color; void main() { color = vec4(1.0); }",
  )
  buffer := gl.createBuffer()
  indices := gl.createBuffer()
  location := gl.attributeLocation(program, "position")

  Assert.equal(gl.useProgram(program), gl)
  Assert.equal(gl.bindBuffer(WebGLBufferTarget.Array, buffer), gl)
  Assert.equal(gl.bufferData(WebGLBufferTarget.Array, [-0.8, -0.8, 0.8, -0.8, 0.0, 0.8]), gl)
  Assert.equal(gl.enableAttribute(location).attributePointer(location, 2), gl)
  Assert.equal(gl.disableAttribute(location), gl)
  Assert.equal(gl.bindBuffer(WebGLBufferTarget.ElementArray, indices), gl)
  Assert.equal(gl.bufferDataUnsignedShort(WebGLBufferTarget.ElementArray, [0, 1, 2], WebGLBufferUsage.DynamicDraw), gl)
  Assert.isTrue(gl.supportsUnsignedIntIndices())
  Assert.equal(gl.bufferDataUnsignedInt(WebGLBufferTarget.ElementArray, [0, 70000, 2]), gl)
  raw: byte[] := [0, 127, 200, 255]
  Assert.equal(gl.bufferDataBytes(WebGLBufferTarget.Array, raw), gl)
  Assert.equal(gl.maxVertexAttributes(), 16)
  Assert.equal(gl.maxTextureUnits(), 16)
  Assert.isTrue(gl.supportsDepthTextures())
  depthTexture := try! gl.createDepthTexture(256, 128)
  depthFramebuffer := try! gl.createDepthFramebuffer(depthTexture)
  Assert.equal(gl.bindFramebuffer(WebGLFramebufferTarget.Framebuffer, depthFramebuffer), gl)
  Assert.equal(gl.framebufferStatus(), WebGLFramebufferStatus.Complete)
  Assert.equal(gl.unbindFramebuffer(), gl)
  depthRenderbuffer := gl.createRenderbuffer()
  Assert.equal(gl.bindRenderbuffer(WebGLRenderbufferTarget.Renderbuffer, depthRenderbuffer), gl)
  Assert.equal(gl.renderbufferStorage(WebGLRenderbufferTarget.Renderbuffer, WebGLRenderbufferFormat.Depth16, 256, 128), gl)
  framebuffer := gl.createFramebuffer()
  gl.bindFramebuffer(WebGLFramebufferTarget.Framebuffer, framebuffer)
    .framebufferRenderbuffer(
      WebGLFramebufferTarget.Framebuffer, WebGLFramebufferAttachment.Depth,
      WebGLRenderbufferTarget.Renderbuffer, depthRenderbuffer,
    )
    .unbindFramebuffer().unbindRenderbuffer()
  Assert.equal(gl.viewport(0, 0, 320, 180).clearColor(0.0, 0.0, 0.0, 1.0), gl)
  Assert.equal(gl.clearDepth(1.0).clearStencil(0).clear(true, true, true), gl)
  Assert.equal(gl.enable(WebGLCapability.DepthTest).disable(WebGLCapability.DepthTest), gl)
  Assert.isTrue(gl.uniform1f(program, "opacity", 1.0))
  Assert.isTrue(gl.uniform2f(program, "offset", 0.0, 0.0))
  Assert.isTrue(gl.uniform3f(program, "light", 0.0, 0.0, 1.0))
  Assert.isTrue(gl.uniform4f(program, "color", 0.2, 0.7, 1.0, 1.0))
  Assert.isTrue(gl.uniform1i(program, "texture", 0))
  Assert.isTrue(gl.uniformMatrix4ColumnMajor(program, "columnTransform", [
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    2.0, 3.0, 4.0, 1.0,
  ]))
  Assert.isTrue(gl.uniformMatrix4Rows(program, "rowTransform", [
    1.0, 0.0, 0.0, 2.0,
    0.0, 1.0, 0.0, 3.0,
    0.0, 0.0, 1.0, 4.0,
    0.0, 0.0, 0.0, 1.0,
  ]))
  pixels: byte[] := [
    255, 0, 0, 255, 0, 255, 0, 255,
    0, 0, 255, 255, 255, 255, 255, 255,
  ]
  texture := gl.createTextureRgba(2, 2, pixels)
  Assert.equal(gl.activeTexture(0).bindTexture(WebGLTextureTarget.Texture2D, texture), gl)
  Assert.equal(gl.setTextureMinFilter(WebGLTextureTarget.Texture2D, WebGLTextureFilter.Linear), gl)
  Assert.equal(gl.setTextureMagFilter(WebGLTextureTarget.Texture2D, WebGLTextureFilter.Nearest), gl)
  Assert.equal(gl.setTextureWrapS(WebGLTextureTarget.Texture2D, WebGLTextureWrap.ClampToEdge), gl)
  Assert.equal(gl.setTextureWrapT(WebGLTextureTarget.Texture2D, WebGLTextureWrap.MirroredRepeat), gl)
  Assert.equal(gl.setUnpackFlipY(true).setUnpackPremultiplyAlpha(true), gl)
  Assert.equal(gl.generateMipmap(WebGLTextureTarget.Texture2D), gl)
  Assert.equal(gl.unbindTexture(WebGLTextureTarget.Texture2D), gl)
  Assert.equal(gl.blendFunc(WebGLBlendFactor.SourceAlpha, WebGLBlendFactor.OneMinusSourceAlpha), gl)
  Assert.equal(gl.blendEquation(WebGLBlendEquation.Add).depthFunc(WebGLCompareFunction.LessOrEqual), gl)
  Assert.equal(gl.depthMask(true).colorMask(true, true, true, false), gl)
  Assert.equal(gl.cullFace(WebGLCullFace.Back).frontFace(WebGLFrontFace.CounterClockwise), gl)
  Assert.equal(gl.scissor(0, 0, 320, 180).polygonOffset(1.0, 1.0), gl)
  Assert.isTrue(gl.supportsInstancing())
  Assert.isTrue(gl.attributeDivisor(location, 1))
  Assert.isTrue(gl.drawArraysInstanced(WebGLPrimitive.Triangles, 0, 3, 4))
  Assert.isTrue(gl.drawElementsInstanced(WebGLPrimitive.Triangles, 3, WebGLDataType.UnsignedShort, 4))
  Assert.equal(gl.drawArrays(WebGLPrimitive.Triangles, 0, 3), gl)
  Assert.equal(gl.drawElements(WebGLPrimitive.Triangles, 3, WebGLDataType.UnsignedShort), gl)
  Assert.equal(gl.unbindBuffer(WebGLBufferTarget.Array).flush().finish(), gl)
  gl.useProgram(convenienceProgram)
}

function acceptsEvent(event: DomEvent): none {
  event.preventDefault()
  event.stopPropagation()
  event.stopImmediatePropagation()
}

function acceptsElement(element: Element): none {
  element.setText("accepted")
}

import class NativeDomEvent from "native_dom.hpp" as doof_dom::NativeDomEvent {
  eventType(): string
  timeStamp(): double
  targetTagName(): string
  targetId(): string | none
  currentTargetTagName(): string
  currentTargetId(): string | none
  clientX(): double | none
  clientY(): double | none
  deltaX(): double | none
  deltaY(): double | none
  movementX(): double | none
  movementY(): double | none
  button(): int | none
  buttons(): int | none
  pointerId(): int | none
  value(): string | none
  checked(): bool | none
  key(): string | none
  code(): string | none
  altKey(): bool
  ctrlKey(): bool
  metaKey(): bool
  shiftKey(): bool
  repeat(): bool
  preventDefault(): none
  stopPropagation(): none
  stopImmediatePropagation(): none
}

import class NativeElement from "native_dom.hpp" as doof_dom::NativeElement {
  static create(tagName: string): NativeElement
  appendChild(child: NativeElement): none
  appendText(text: string): none
  appendTo(target: NativeElement): none
  insertBefore(target: NativeElement): none
  insertAfter(target: NativeElement): none
  replace(target: NativeElement): none
  unmount(): none
  setText(text: string): none
  setId(id: string): none
  setClassName(className: string): none
  setDisabled(disabled: bool): none
  setValue(value: string): none
  setChecked(checked: bool): none
  setAttribute(name: string, value: string): none
  removeAttribute(name: string): none
  focus(): none
  blur(): none
  numberProperty(property: int): double
  setEventHandler(eventType: string, handler: (event: NativeDomEvent): none): none
  clearEventHandler(eventType: string): none
}

import class NativeDocument from "native_dom.hpp" as doof_dom::NativeDocument {
  static shared(): NativeDocument
  head(): NativeElement
  body(): NativeElement
  window(): NativeElement
}

import class NativeAnimationFrameRequest from "native_dom.hpp" as doof_dom::NativeAnimationFrameRequest {
  static create(handler: (timestamp: double): none): NativeAnimationFrameRequest
  cancel(): none
}

import class NativeImage from "native_dom.hpp" as doof_dom::NativeImage {
  width(): int
  height(): int
}

import class NativeImageLoadRequest from "native_dom.hpp" as doof_dom::NativeImageLoadRequest {
  static create(
    url: string, crossOrigin: int,
    handler: (image: NativeImage | none, error: string): none,
  ): NativeImageLoadRequest
  cancel(): none
}

import class NativeGamepads from "native_dom.hpp" as doof_dom::NativeGamepads {
  static count(): int
  static connected(index: int): bool
  static id(index: int): string
  static buttonPressed(index: int, button: int): bool
  static buttonValue(index: int, button: int): double
  static axis(index: int, axis: int): double
}

import class NativeCanvasContext from "native_dom.hpp" as doof_dom::NativeCanvasContext {
  static create(element: NativeElement): NativeCanvasContext
  save(): none
  restore(): none
  beginPath(): none
  closePath(): none
  fill(): none
  stroke(): none
  resetTransform(): none
  clearRect(x: double, y: double, width: double, height: double): none
  fillRect(x: double, y: double, width: double, height: double): none
  strokeRect(x: double, y: double, width: double, height: double): none
  moveTo(x: double, y: double): none
  lineTo(x: double, y: double): none
  rect(x: double, y: double, width: double, height: double): none
  arc(x: double, y: double, radius: double, startAngle: double, endAngle: double, anticlockwise: bool): none
  translate(x: double, y: double): none
  scale(x: double, y: double): none
  rotate(angle: double): none
  setTransform(a: double, b: double, c: double, d: double, e: double, f: double): none
  setFillStyle(value: string): none
  setStrokeStyle(value: string): none
  setFont(value: string): none
  setTextAlign(value: string): none
  setTextBaseline(value: string): none
  setLineCap(value: string): none
  setLineJoin(value: string): none
  setGlobalCompositeOperation(value: string): none
  setLineWidth(value: double): none
  setGlobalAlpha(value: double): none
  setMiterLimit(value: double): none
  setLineDashOffset(value: double): none
  fillText(text: string, x: double, y: double, maxWidth: double | none): none
  strokeText(text: string, x: double, y: double, maxWidth: double | none): none
  measureTextWidth(text: string): double
}

import class NativeWebGLShader from "native_dom.hpp" as doof_dom::NativeWebGLShader {
  setSource(source: string): none
  compile(): none
  compiled(): bool
  infoLog(): string
}

import class NativeWebGLProgram from "native_dom.hpp" as doof_dom::NativeWebGLProgram {
  attach(shader: NativeWebGLShader): none
  link(): none
  linked(): bool
  infoLog(): string
}

import class NativeWebGLBuffer from "native_dom.hpp" as doof_dom::NativeWebGLBuffer {}
import class NativeWebGLTexture from "native_dom.hpp" as doof_dom::NativeWebGLTexture {}
import class NativeWebGLFramebuffer from "native_dom.hpp" as doof_dom::NativeWebGLFramebuffer {}
import class NativeWebGLRenderbuffer from "native_dom.hpp" as doof_dom::NativeWebGLRenderbuffer {}

import class NativeWebGLContext from "native_dom.hpp" as doof_dom::NativeWebGLContext {
  static create(
    element: NativeElement, alpha: bool, antialias: bool, depth: bool, stencil: bool,
    premultipliedAlpha: bool, preserveDrawingBuffer: bool, powerPreference: int,
  ): NativeWebGLContext
  createShader(shaderType: int): NativeWebGLShader
  createProgram(): NativeWebGLProgram
  createBuffer(): NativeWebGLBuffer
  createTexture(): NativeWebGLTexture
  createFramebuffer(): NativeWebGLFramebuffer
  createRenderbuffer(): NativeWebGLRenderbuffer
  useProgram(program: NativeWebGLProgram): none
  bindBuffer(target: int, buffer: NativeWebGLBuffer): none
  unbindBuffer(target: int): none
  bufferData(target: int, values: double[], usage: int): none
  bufferDataBytes(target: int, values: byte[], usage: int): none
  bufferDataUnsignedShort(target: int, values: int[], usage: int): none
  bufferDataUnsignedInt(target: int, values: int[], usage: int): none
  attributeLocation(program: NativeWebGLProgram, name: string): int
  enableAttribute(location: int): none
  disableAttribute(location: int): none
  attributePointer(location: int, size: int, dataType: int, normalized: bool, stride: int, offset: int): none
  viewport(x: int, y: int, width: int, height: int): none
  clearColor(red: double, green: double, blue: double, alpha: double): none
  clearDepth(depth: double): none
  clearStencil(value: int): none
  clear(color: bool, depth: bool, stencil: bool): none
  enable(capability: int): none
  disable(capability: int): none
  drawArrays(mode: int, first: int, count: int): none
  drawElements(mode: int, count: int, dataType: int, offset: int): none
  uniform1f(program: NativeWebGLProgram, name: string, x: double): bool
  uniform2f(program: NativeWebGLProgram, name: string, x: double, y: double): bool
  uniform3f(program: NativeWebGLProgram, name: string, x: double, y: double, z: double): bool
  uniform4f(program: NativeWebGLProgram, name: string, x: double, y: double, z: double, w: double): bool
  uniform1i(program: NativeWebGLProgram, name: string, value: int): bool
  uniformMatrix4(program: NativeWebGLProgram, name: string, transpose: bool, values: double[]): bool
  activeTexture(unit: int): none
  bindTexture(target: int, texture: NativeWebGLTexture): none
  unbindTexture(target: int): none
  textureImageRgba(target: int, width: int, height: int, pixels: byte[]): none
  textureImageDepth(target: int, width: int, height: int): none
  textureImage(target: int, image: NativeImage): none
  textureParameter(target: int, parameter: int, value: int): none
  generateMipmap(target: int): none
  setUnpackFlipY(enabled: bool): none
  setUnpackPremultiplyAlpha(enabled: bool): none
  blendFunc(source: int, destination: int): none
  blendEquation(equation: int): none
  depthFunc(function_: int): none
  depthMask(enabled: bool): none
  colorMask(red: bool, green: bool, blue: bool, alpha: bool): none
  cullFace(face: int): none
  frontFace(winding: int): none
  scissor(x: int, y: int, width: int, height: int): none
  polygonOffset(factor: double, units: double): none
  supportsInstancing(): bool
  supportsUnsignedIntIndices(): bool
  maxVertexAttributes(): int
  maxTextureUnits(): int
  supportsDepthTextures(): bool
  bindFramebuffer(target: int, framebuffer: NativeWebGLFramebuffer): none
  unbindFramebuffer(target: int): none
  framebufferTexture2d(target: int, attachment: int, textureTarget: int, texture: NativeWebGLTexture): none
  framebufferStatus(target: int): int
  bindRenderbuffer(target: int, renderbuffer: NativeWebGLRenderbuffer): none
  unbindRenderbuffer(target: int): none
  renderbufferStorage(target: int, format: int, width: int, height: int): none
  framebufferRenderbuffer(target: int, attachment: int, renderbufferTarget: int, renderbuffer: NativeWebGLRenderbuffer): none
  attributeDivisor(location: int, divisor: int): bool
  drawArraysInstanced(mode: int, first: int, count: int, instanceCount: int): bool
  drawElementsInstanced(mode: int, count: int, dataType: int, offset: int, instanceCount: int): bool
  flush(): none
  finish(): none
}

export type DomChild = Element | Canvas | string
export type DomEventHandler = (event: DomEvent): none
export type ImageLoadHandler = (result: Result<BrowserImage, string>): none

export enum ImageCrossOrigin { None, Anonymous, UseCredentials }

export class BrowserImage {
  private native: NativeImage
  width(): int => native.width()
  height(): int => native.height()
}

export class ImageLoadRequest {
  private native: NativeImageLoadRequest
  cancel(): none => native.cancel()
}

export function loadImage(
  url: string,
  handler: ImageLoadHandler,
  crossOrigin: ImageCrossOrigin = .None,
): ImageLoadRequest {
  native := NativeImageLoadRequest.create(
    url,
    crossOrigin.value,
    (loaded: NativeImage | none, error: string): none => {
      if loaded == none {
        handler.call(Failure { error: error + ": " + url })
      } else {
        handler.call(Success { value: BrowserImage { native: loaded! } })
      }
    },
  )
  return ImageLoadRequest { native }
}

export class DomEvent {
  readonly eventType: string
  readonly timeStamp: double
  readonly targetTagName: string
  readonly targetId: string | none
  readonly currentTargetTagName: string
  readonly currentTargetId: string | none
  readonly clientX: double | none
  readonly clientY: double | none
  readonly deltaX: double | none
  readonly deltaY: double | none
  readonly movementX: double | none
  readonly movementY: double | none
  readonly button: int | none
  readonly buttons: int | none
  readonly pointerId: int | none
  readonly value: string | none
  readonly checked: bool | none
  readonly key: string | none
  readonly code: string | none
  readonly altKey: bool
  readonly ctrlKey: bool
  readonly metaKey: bool
  readonly shiftKey: bool
  readonly repeat: bool
  private native: NativeDomEvent

  preventDefault(): none { native.preventDefault() }
  stopPropagation(): none { native.stopPropagation() }
  stopImmediatePropagation(): none { native.stopImmediatePropagation() }
}

export class Element {
  private native: NativeElement

  appendTo(target: Element): Element {
    native.appendTo(target.native)
    return this
  }

  insertBefore(target: Element): Element {
    native.insertBefore(target.native)
    return this
  }

  insertAfter(target: Element): Element {
    native.insertAfter(target.native)
    return this
  }

  replace(target: Element): Element {
    native.replace(target.native)
    return this
  }

  unmount(): Element {
    native.unmount()
    return this
  }

  setText(text: string): Element {
    native.setText(text)
    return this
  }

  setId(id: string): Element {
    native.setId(id)
    return this
  }

  setClassName(className: string): Element {
    native.setClassName(className)
    return this
  }

  setDisabled(disabled: bool): Element {
    native.setDisabled(disabled)
    return this
  }

  setValue(value: string): Element {
    native.setValue(value)
    return this
  }

  setChecked(checked: bool): Element {
    native.setChecked(checked)
    return this
  }

  setAttribute(name: string, value: string): Element {
    native.setAttribute(name, value)
    return this
  }

  removeAttribute(name: string): Element {
    native.removeAttribute(name)
    return this
  }

  focus(): Element {
    native.focus()
    return this
  }

  blur(): Element {
    native.blur()
    return this
  }

  setOnClick(handler: DomEventHandler): Element => setHandler("click", handler)
  clearOnClick(): Element => clearHandler("click")
  setOnInput(handler: DomEventHandler): Element => setHandler("input", handler)
  clearOnInput(): Element => clearHandler("input")
  setOnChange(handler: DomEventHandler): Element => setHandler("change", handler)
  clearOnChange(): Element => clearHandler("change")
  setOnSubmit(handler: DomEventHandler): Element => setHandler("submit", handler)
  clearOnSubmit(): Element => clearHandler("submit")
  setOnDoubleClick(handler: DomEventHandler): Element => setHandler("dblclick", handler)
  clearOnDoubleClick(): Element => clearHandler("dblclick")
  setOnPointerDown(handler: DomEventHandler): Element => setHandler("pointerdown", handler)
  clearOnPointerDown(): Element => clearHandler("pointerdown")
  setOnPointerUp(handler: DomEventHandler): Element => setHandler("pointerup", handler)
  clearOnPointerUp(): Element => clearHandler("pointerup")
  setOnPointerMove(handler: DomEventHandler): Element => setHandler("pointermove", handler)
  clearOnPointerMove(): Element => clearHandler("pointermove")
  setOnPointerCancel(handler: DomEventHandler): Element => setHandler("pointercancel", handler)
  clearOnPointerCancel(): Element => clearHandler("pointercancel")
  setOnWheel(handler: DomEventHandler): Element => setHandler("wheel", handler)
  clearOnWheel(): Element => clearHandler("wheel")
  setOnKeyDown(handler: DomEventHandler): Element => setHandler("keydown", handler)
  clearOnKeyDown(): Element => clearHandler("keydown")
  setOnKeyUp(handler: DomEventHandler): Element => setHandler("keyup", handler)
  clearOnKeyUp(): Element => clearHandler("keyup")
  setOnResize(handler: DomEventHandler): Element => setHandler("resize", handler)
  clearOnResize(): Element => clearHandler("resize")
  setOnWebglContextLost(handler: DomEventHandler): Element => setHandler("webglcontextlost", handler)
  clearOnWebglContextLost(): Element => clearHandler("webglcontextlost")
  setOnWebglContextRestored(handler: DomEventHandler): Element => setHandler("webglcontextrestored", handler)
  clearOnWebglContextRestored(): Element => clearHandler("webglcontextrestored")

  private setHandler(eventType: string, handler: DomEventHandler): Element {
    native.setEventHandler(eventType, (nativeEvent: NativeDomEvent): none => {
      handler.call(eventFromNative(nativeEvent))
    })
    return this
  }

  private clearHandler(eventType: string): Element {
    native.clearEventHandler(eventType)
    return this
  }
}

export class Canvas {
  private element: Element

  asElement(): Element => element
  context2d(): Canvas2DContext => Canvas2DContext { native: NativeCanvasContext.create(element.native) }
  contextWebgl(options: WebGLContextOptions = WebGLContextOptions {}): WebGLContext => WebGLContext {
    native: NativeWebGLContext.create(
      element.native,
      options.alpha,
      options.antialias,
      options.depth,
      options.stencil,
      options.premultipliedAlpha,
      options.preserveDrawingBuffer,
      options.powerPreference.value,
    ),
  }

  appendTo(target: Element): Canvas { element.appendTo(target); return this }
  insertBefore(target: Element): Canvas { element.insertBefore(target); return this }
  insertAfter(target: Element): Canvas { element.insertAfter(target); return this }
  replace(target: Element): Canvas { element.replace(target); return this }
  unmount(): Canvas { element.unmount(); return this }
  setWidth(width: int): Canvas { element.setAttribute("width", string(width)); return this }
  setHeight(height: int): Canvas { element.setAttribute("height", string(height)); return this }
  setClassName(className: string): Canvas { element.setClassName(className); return this }
  setAttribute(name: string, value: string): Canvas { element.setAttribute(name, value); return this }
  removeAttribute(name: string): Canvas { element.removeAttribute(name); return this }
  focus(): Canvas { element.focus(); return this }
  blur(): Canvas { element.blur(); return this }
  width(): int => int(element.native.numberProperty(0))
  height(): int => int(element.native.numberProperty(1))
  clientWidth(): double => element.native.numberProperty(2)
  clientHeight(): double => element.native.numberProperty(3)
  devicePixelRatio(): double => element.native.numberProperty(4)
  clientLeft(): double => element.native.numberProperty(5)
  clientTop(): double => element.native.numberProperty(6)
  setOnPointerDown(handler: DomEventHandler): Canvas { element.setOnPointerDown(handler); return this }
  setOnPointerUp(handler: DomEventHandler): Canvas { element.setOnPointerUp(handler); return this }
  setOnPointerMove(handler: DomEventHandler): Canvas { element.setOnPointerMove(handler); return this }
  setOnPointerCancel(handler: DomEventHandler): Canvas { element.setOnPointerCancel(handler); return this }
  setOnWheel(handler: DomEventHandler): Canvas { element.setOnWheel(handler); return this }
  setOnDoubleClick(handler: DomEventHandler): Canvas { element.setOnDoubleClick(handler); return this }
  setOnWebglContextLost(handler: DomEventHandler): Canvas { element.setOnWebglContextLost(handler); return this }
  setOnWebglContextRestored(handler: DomEventHandler): Canvas { element.setOnWebglContextRestored(handler); return this }
}

export class AnimationFrameRequest {
  private native: NativeAnimationFrameRequest
  cancel(): none => native.cancel()
}

export function requestAnimationFrame(handler: (timestamp: double): none): AnimationFrameRequest {
  return AnimationFrameRequest { native: NativeAnimationFrameRequest.create(handler) }
}

export class Gamepads {
  count(): int => NativeGamepads.count()
  connected(index: int): bool => NativeGamepads.connected(index)
  id(index: int): string => NativeGamepads.id(index)
  buttonPressed(index: int, button: int): bool => NativeGamepads.buttonPressed(index, button)
  buttonValue(index: int, button: int): double => NativeGamepads.buttonValue(index, button)
  axis(index: int, axis: int): double => NativeGamepads.axis(index, axis)
}

export function gamepads(): Gamepads => Gamepads {}

export class DomWindow {
  private element: Element
  devicePixelRatio(): double => element.native.numberProperty(4)
  setOnKeyDown(handler: DomEventHandler): DomWindow { element.setOnKeyDown(handler); return this }
  setOnKeyUp(handler: DomEventHandler): DomWindow { element.setOnKeyUp(handler); return this }
  setOnResize(handler: DomEventHandler): DomWindow { element.setOnResize(handler); return this }
  setOnPointerUp(handler: DomEventHandler): DomWindow { element.setOnPointerUp(handler); return this }
  clearOnKeyDown(): DomWindow { element.clearOnKeyDown(); return this }
  clearOnKeyUp(): DomWindow { element.clearOnKeyUp(); return this }
  clearOnResize(): DomWindow { element.clearOnResize(); return this }
  clearOnPointerUp(): DomWindow { element.clearOnPointerUp(); return this }
}

export class Canvas2DContext {
  private native: NativeCanvasContext

  save(): Canvas2DContext { native.save(); return this }
  restore(): Canvas2DContext { native.restore(); return this }
  beginPath(): Canvas2DContext { native.beginPath(); return this }
  closePath(): Canvas2DContext { native.closePath(); return this }
  fill(): Canvas2DContext { native.fill(); return this }
  stroke(): Canvas2DContext { native.stroke(); return this }
  resetTransform(): Canvas2DContext { native.resetTransform(); return this }
  clearRect(x: double, y: double, width: double, height: double): Canvas2DContext { native.clearRect(x, y, width, height); return this }
  fillRect(x: double, y: double, width: double, height: double): Canvas2DContext { native.fillRect(x, y, width, height); return this }
  strokeRect(x: double, y: double, width: double, height: double): Canvas2DContext { native.strokeRect(x, y, width, height); return this }
  moveTo(x: double, y: double): Canvas2DContext { native.moveTo(x, y); return this }
  lineTo(x: double, y: double): Canvas2DContext { native.lineTo(x, y); return this }
  rect(x: double, y: double, width: double, height: double): Canvas2DContext { native.rect(x, y, width, height); return this }
  arc(x: double, y: double, radius: double, startAngle: double, endAngle: double, anticlockwise: bool = false): Canvas2DContext {
    native.arc(x, y, radius, startAngle, endAngle, anticlockwise)
    return this
  }
  translate(x: double, y: double): Canvas2DContext { native.translate(x, y); return this }
  scale(x: double, y: double): Canvas2DContext { native.scale(x, y); return this }
  rotate(angle: double): Canvas2DContext { native.rotate(angle); return this }
  setTransform(a: double, b: double, c: double, d: double, e: double, f: double): Canvas2DContext {
    native.setTransform(a, b, c, d, e, f)
    return this
  }
  setFillStyle(value: string): Canvas2DContext { native.setFillStyle(value); return this }
  setStrokeStyle(value: string): Canvas2DContext { native.setStrokeStyle(value); return this }
  setFont(value: string): Canvas2DContext { native.setFont(value); return this }
  setTextAlign(value: string): Canvas2DContext { native.setTextAlign(value); return this }
  setTextBaseline(value: string): Canvas2DContext { native.setTextBaseline(value); return this }
  setLineCap(value: string): Canvas2DContext { native.setLineCap(value); return this }
  setLineJoin(value: string): Canvas2DContext { native.setLineJoin(value); return this }
  setGlobalCompositeOperation(value: string): Canvas2DContext { native.setGlobalCompositeOperation(value); return this }
  setLineWidth(value: double): Canvas2DContext { native.setLineWidth(value); return this }
  setGlobalAlpha(value: double): Canvas2DContext { native.setGlobalAlpha(value); return this }
  setMiterLimit(value: double): Canvas2DContext { native.setMiterLimit(value); return this }
  setLineDashOffset(value: double): Canvas2DContext { native.setLineDashOffset(value); return this }
  fillText(text: string, x: double, y: double, maxWidth: double | none = none): Canvas2DContext {
    native.fillText(text, x, y, maxWidth)
    return this
  }
  strokeText(text: string, x: double, y: double, maxWidth: double | none = none): Canvas2DContext {
    native.strokeText(text, x, y, maxWidth)
    return this
  }
  measureTextWidth(text: string): double => native.measureTextWidth(text)
}

export enum WebGLShaderType { Vertex = 35633, Fragment = 35632 }
export enum WebGLBufferTarget { Array = 34962, ElementArray = 34963 }
export enum WebGLBufferUsage { StreamDraw = 35040, StaticDraw = 35044, DynamicDraw = 35048 }
export enum WebGLPrimitive {
  Points = 0, Lines = 1, LineLoop = 2, LineStrip = 3,
  Triangles = 4, TriangleStrip = 5, TriangleFan = 6,
}
export enum WebGLDataType {
  Byte = 5120, UnsignedByte = 5121, Short = 5122, UnsignedShort = 5123,
  UnsignedInt = 5125, Float = 5126,
}
export enum WebGLCapability {
  Blend = 3042, CullFace = 2884, DepthTest = 2929, Dither = 3024,
  PolygonOffsetFill = 32823, SampleAlphaToCoverage = 32926,
  SampleCoverage = 32928, ScissorTest = 3089, StencilTest = 2960,
}
export enum WebGLPowerPreference { Default, LowPower, HighPerformance }
export enum WebGLTextureTarget { Texture2D = 3553 }
export enum WebGLTextureFilter {
  Nearest = 9728, Linear = 9729, NearestMipmapNearest = 9984,
  LinearMipmapNearest = 9985, NearestMipmapLinear = 9986, LinearMipmapLinear = 9987,
}
export enum WebGLTextureWrap { Repeat = 10497, ClampToEdge = 33071, MirroredRepeat = 33648 }
export enum WebGLBlendFactor {
  Zero = 0, One = 1, SourceColor = 768, OneMinusSourceColor = 769,
  SourceAlpha = 770, OneMinusSourceAlpha = 771, DestinationAlpha = 772,
  OneMinusDestinationAlpha = 773, DestinationColor = 774,
  OneMinusDestinationColor = 775, SourceAlphaSaturate = 776,
}
export enum WebGLBlendEquation { Add = 32774, Subtract = 32778, ReverseSubtract = 32779 }
export enum WebGLCompareFunction {
  Never = 512, Less = 513, Equal = 514, LessOrEqual = 515,
  Greater = 516, NotEqual = 517, GreaterOrEqual = 518, Always = 519,
}
export enum WebGLCullFace { Front = 1028, Back = 1029, FrontAndBack = 1032 }
export enum WebGLFrontFace { Clockwise = 2304, CounterClockwise = 2305 }
export enum WebGLFramebufferTarget { Framebuffer = 36160 }
export enum WebGLRenderbufferTarget { Renderbuffer = 36161 }
export enum WebGLFramebufferAttachment { Color0 = 36064, Depth = 36096, Stencil = 36128 }
export enum WebGLRenderbufferFormat { Rgba4 = 32854, Depth16 = 33189, Stencil8 = 36168 }
export enum WebGLFramebufferStatus {
  Complete = 36053, IncompleteAttachment = 36054, IncompleteMissingAttachment = 36055,
  IncompleteDimensions = 36057, Unsupported = 36061,
}

export class WebGLContextOptions {
  alpha: bool = true
  antialias: bool = true
  depth: bool = true
  stencil: bool = false
  premultipliedAlpha: bool = true
  preserveDrawingBuffer: bool = false
  powerPreference: WebGLPowerPreference = .Default
}

export class WebGLShader { private native: NativeWebGLShader }
export class WebGLProgram { private native: NativeWebGLProgram }
export class WebGLBuffer { private native: NativeWebGLBuffer }
export class WebGLTexture { private native: NativeWebGLTexture }
export class WebGLFramebuffer { private native: NativeWebGLFramebuffer }
export class WebGLRenderbuffer { private native: NativeWebGLRenderbuffer }

export class WebGLContext {
  private native: NativeWebGLContext

  compileShader(shaderType: WebGLShaderType, source: string): Result<WebGLShader, string> {
    shader := native.createShader(shaderType.value)
    shader.setSource(source)
    shader.compile()
    if !shader.compiled() { return Failure { error: shader.infoLog() } }
    return Success { value: WebGLShader { native: shader } }
  }

  linkProgram(vertex: WebGLShader, fragment: WebGLShader): Result<WebGLProgram, string> {
    program := native.createProgram()
    program.attach(vertex.native)
    program.attach(fragment.native)
    program.link()
    if !program.linked() { return Failure { error: program.infoLog() } }
    return Success { value: WebGLProgram { native: program } }
  }

  createProgram(vertexSource: string, fragmentSource: string): Result<WebGLProgram, string> {
    vertex := compileShader(WebGLShaderType.Vertex, vertexSource) else error {
      return Failure { error: "Vertex shader: " + error }
    }
    fragment := compileShader(WebGLShaderType.Fragment, fragmentSource) else error {
      return Failure { error: "Fragment shader: " + error }
    }
    return linkProgram(vertex, fragment)
  }

  createBuffer(): WebGLBuffer => WebGLBuffer { native: native.createBuffer() }
  createTexture(): WebGLTexture => WebGLTexture { native: native.createTexture() }
  createFramebuffer(): WebGLFramebuffer => WebGLFramebuffer { native: native.createFramebuffer() }
  createRenderbuffer(): WebGLRenderbuffer => WebGLRenderbuffer { native: native.createRenderbuffer() }
  createTextureRgba(
    width: int, height: int, pixels: byte[],
    target: WebGLTextureTarget = .Texture2D,
  ): WebGLTexture {
    texture := createTexture()
    bindTexture(target, texture)
    textureImageRgba(target, width, height, pixels)
    return texture
  }
  createTextureImage(
    image: BrowserImage, target: WebGLTextureTarget = .Texture2D,
  ): WebGLTexture {
    texture := createTexture()
    bindTexture(target, texture)
    textureImage(target, image)
    return texture
  }
  createDepthTexture(
    width: int, height: int, target: WebGLTextureTarget = .Texture2D,
  ): Result<WebGLTexture, string> {
    if width <= 0 || height <= 0 { return Failure { error: "WebGL depth texture dimensions must be positive" } }
    texture := createTexture()
    bindTexture(target, texture)
    native.textureImageDepth(target.value, width, height)
    setTextureMinFilter(target, WebGLTextureFilter.Nearest)
    setTextureMagFilter(target, WebGLTextureFilter.Nearest)
    setTextureWrapS(target, WebGLTextureWrap.ClampToEdge)
    setTextureWrapT(target, WebGLTextureWrap.ClampToEdge)
    return Success { value: texture }
  }
  createDepthFramebuffer(texture: WebGLTexture): Result<WebGLFramebuffer, string> {
    framebuffer := createFramebuffer()
    bindFramebuffer(WebGLFramebufferTarget.Framebuffer, framebuffer)
    framebufferTexture2d(
      WebGLFramebufferTarget.Framebuffer, WebGLFramebufferAttachment.Depth,
      WebGLTextureTarget.Texture2D, texture,
    )
    status := framebufferStatus(WebGLFramebufferTarget.Framebuffer)
    unbindFramebuffer(WebGLFramebufferTarget.Framebuffer)
    if status != WebGLFramebufferStatus.Complete {
      return Failure { error: "WebGL depth framebuffer is incomplete (status " + string(status.value) + ")" }
    }
    return Success { value: framebuffer }
  }
  useProgram(program: WebGLProgram): WebGLContext { native.useProgram(program.native); return this }
  bindBuffer(target: WebGLBufferTarget, buffer: WebGLBuffer): WebGLContext {
    native.bindBuffer(target.value, buffer.native)
    return this
  }
  unbindBuffer(target: WebGLBufferTarget): WebGLContext { native.unbindBuffer(target.value); return this }
  bufferData(target: WebGLBufferTarget, values: double[], usage: WebGLBufferUsage = .StaticDraw): WebGLContext {
    native.bufferData(target.value, values, usage.value)
    return this
  }
  bufferDataBytes(
    target: WebGLBufferTarget, values: byte[], usage: WebGLBufferUsage = .StaticDraw,
  ): WebGLContext {
    native.bufferDataBytes(target.value, values, usage.value)
    return this
  }
  bufferDataUnsignedShort(
    target: WebGLBufferTarget, values: int[], usage: WebGLBufferUsage = .StaticDraw,
  ): WebGLContext {
    native.bufferDataUnsignedShort(target.value, values, usage.value)
    return this
  }
  bufferDataUnsignedInt(
    target: WebGLBufferTarget, values: int[], usage: WebGLBufferUsage = .StaticDraw,
  ): WebGLContext {
    native.bufferDataUnsignedInt(target.value, values, usage.value)
    return this
  }
  attributeLocation(program: WebGLProgram, name: string): int => native.attributeLocation(program.native, name)
  enableAttribute(location: int): WebGLContext { native.enableAttribute(location); return this }
  disableAttribute(location: int): WebGLContext { native.disableAttribute(location); return this }
  attributePointer(
    location: int, size: int, dataType: WebGLDataType = .Float,
    normalized: bool = false, stride: int = 0, offset: int = 0,
  ): WebGLContext {
    native.attributePointer(location, size, dataType.value, normalized, stride, offset)
    return this
  }
  viewport(x: int, y: int, width: int, height: int): WebGLContext {
    native.viewport(x, y, width, height)
    return this
  }
  clearColor(red: double, green: double, blue: double, alpha: double): WebGLContext {
    native.clearColor(red, green, blue, alpha)
    return this
  }
  clearDepth(depth: double): WebGLContext { native.clearDepth(depth); return this }
  clearStencil(value: int): WebGLContext { native.clearStencil(value); return this }
  clear(color: bool = true, depth: bool = false, stencil: bool = false): WebGLContext {
    native.clear(color, depth, stencil)
    return this
  }
  enable(capability: WebGLCapability): WebGLContext { native.enable(capability.value); return this }
  disable(capability: WebGLCapability): WebGLContext { native.disable(capability.value); return this }
  drawArrays(mode: WebGLPrimitive, first: int, count: int): WebGLContext {
    native.drawArrays(mode.value, first, count)
    return this
  }
  drawElements(mode: WebGLPrimitive, count: int, dataType: WebGLDataType, offset: int = 0): WebGLContext {
    native.drawElements(mode.value, count, dataType.value, offset)
    return this
  }
  uniform1f(program: WebGLProgram, name: string, x: double): bool => native.uniform1f(program.native, name, x)
  uniform2f(program: WebGLProgram, name: string, x: double, y: double): bool => native.uniform2f(program.native, name, x, y)
  uniform3f(program: WebGLProgram, name: string, x: double, y: double, z: double): bool => native.uniform3f(program.native, name, x, y, z)
  uniform4f(program: WebGLProgram, name: string, x: double, y: double, z: double, w: double): bool => native.uniform4f(program.native, name, x, y, z, w)
  uniform1i(program: WebGLProgram, name: string, value: int): bool => native.uniform1i(program.native, name, value)
  uniformMatrix4ColumnMajor(program: WebGLProgram, name: string, values: double[]): bool {
    if values.length != 16 { panic("A WebGL 4x4 matrix must contain exactly 16 values") }
    return native.uniformMatrix4(program.native, name, false, values)
  }
  uniformMatrix4(program: WebGLProgram, name: string, values: double[]): bool {
    return uniformMatrix4ColumnMajor(program, name, values)
  }
  uniformMatrix4Rows(program: WebGLProgram, name: string, values: double[]): bool {
    if values.length != 16 { panic("A WebGL 4x4 matrix must contain exactly 16 values") }
    return uniformMatrix4ColumnMajor(program, name, [
      values[0], values[4], values[8], values[12],
      values[1], values[5], values[9], values[13],
      values[2], values[6], values[10], values[14],
      values[3], values[7], values[11], values[15],
    ])
  }
  activeTexture(unit: int): WebGLContext {
    if unit < 0 || unit > 31 { panic("WebGL texture unit must be between 0 and 31") }
    native.activeTexture(unit)
    return this
  }
  bindTexture(target: WebGLTextureTarget, texture: WebGLTexture): WebGLContext {
    native.bindTexture(target.value, texture.native)
    return this
  }
  unbindTexture(target: WebGLTextureTarget): WebGLContext { native.unbindTexture(target.value); return this }
  textureImageRgba(
    target: WebGLTextureTarget, width: int, height: int, pixels: byte[],
  ): WebGLContext {
    if width <= 0 || height <= 0 { panic("WebGL texture dimensions must be positive") }
    if pixels.length != width * height * 4 { panic("WebGL RGBA texture data must contain width * height * 4 bytes") }
    native.textureImageRgba(target.value, width, height, pixels)
    return this
  }
  textureImage(target: WebGLTextureTarget, image: BrowserImage): WebGLContext {
    native.textureImage(target.value, image.native)
    return this
  }
  setTextureMinFilter(target: WebGLTextureTarget, filter: WebGLTextureFilter): WebGLContext {
    native.textureParameter(target.value, 10241, filter.value)
    return this
  }
  setTextureMagFilter(target: WebGLTextureTarget, filter: WebGLTextureFilter): WebGLContext {
    native.textureParameter(target.value, 10240, filter.value)
    return this
  }
  setTextureWrapS(target: WebGLTextureTarget, wrap: WebGLTextureWrap): WebGLContext {
    native.textureParameter(target.value, 10242, wrap.value)
    return this
  }
  setTextureWrapT(target: WebGLTextureTarget, wrap: WebGLTextureWrap): WebGLContext {
    native.textureParameter(target.value, 10243, wrap.value)
    return this
  }
  generateMipmap(target: WebGLTextureTarget): WebGLContext { native.generateMipmap(target.value); return this }
  setUnpackFlipY(enabled: bool): WebGLContext { native.setUnpackFlipY(enabled); return this }
  setUnpackPremultiplyAlpha(enabled: bool): WebGLContext { native.setUnpackPremultiplyAlpha(enabled); return this }
  blendFunc(source: WebGLBlendFactor, destination: WebGLBlendFactor): WebGLContext {
    native.blendFunc(source.value, destination.value)
    return this
  }
  blendEquation(equation: WebGLBlendEquation): WebGLContext { native.blendEquation(equation.value); return this }
  depthFunc(function_: WebGLCompareFunction): WebGLContext { native.depthFunc(function_.value); return this }
  depthMask(enabled: bool): WebGLContext { native.depthMask(enabled); return this }
  colorMask(red: bool, green: bool, blue: bool, alpha: bool): WebGLContext {
    native.colorMask(red, green, blue, alpha)
    return this
  }
  cullFace(face: WebGLCullFace): WebGLContext { native.cullFace(face.value); return this }
  frontFace(winding: WebGLFrontFace): WebGLContext { native.frontFace(winding.value); return this }
  scissor(x: int, y: int, width: int, height: int): WebGLContext {
    native.scissor(x, y, width, height)
    return this
  }
  polygonOffset(factor: double, units: double): WebGLContext { native.polygonOffset(factor, units); return this }
  supportsInstancing(): bool => native.supportsInstancing()
  supportsUnsignedIntIndices(): bool => native.supportsUnsignedIntIndices()
  maxVertexAttributes(): int => native.maxVertexAttributes()
  maxTextureUnits(): int => native.maxTextureUnits()
  supportsDepthTextures(): bool => native.supportsDepthTextures()
  bindFramebuffer(target: WebGLFramebufferTarget, framebuffer: WebGLFramebuffer): WebGLContext {
    native.bindFramebuffer(target.value, framebuffer.native)
    return this
  }
  unbindFramebuffer(target: WebGLFramebufferTarget = .Framebuffer): WebGLContext {
    native.unbindFramebuffer(target.value)
    return this
  }
  framebufferTexture2d(
    target: WebGLFramebufferTarget, attachment: WebGLFramebufferAttachment,
    textureTarget: WebGLTextureTarget, texture: WebGLTexture,
  ): WebGLContext {
    native.framebufferTexture2d(target.value, attachment.value, textureTarget.value, texture.native)
    return this
  }
  framebufferStatus(target: WebGLFramebufferTarget = .Framebuffer): WebGLFramebufferStatus {
    value := native.framebufferStatus(target.value)
    // Temporary explicit narrowing until optional `?? panic(...)` emits `never` correctly.
    status := WebGLFramebufferStatus.fromValue(value) else {
      panic("Unknown WebGL framebuffer status " + string(value))
    }
    return status
  }
  bindRenderbuffer(target: WebGLRenderbufferTarget, renderbuffer: WebGLRenderbuffer): WebGLContext {
    native.bindRenderbuffer(target.value, renderbuffer.native)
    return this
  }
  unbindRenderbuffer(target: WebGLRenderbufferTarget = .Renderbuffer): WebGLContext {
    native.unbindRenderbuffer(target.value)
    return this
  }
  renderbufferStorage(
    target: WebGLRenderbufferTarget, format: WebGLRenderbufferFormat, width: int, height: int,
  ): WebGLContext {
    if width <= 0 || height <= 0 { panic("WebGL renderbuffer dimensions must be positive") }
    native.renderbufferStorage(target.value, format.value, width, height)
    return this
  }
  framebufferRenderbuffer(
    target: WebGLFramebufferTarget, attachment: WebGLFramebufferAttachment,
    renderbufferTarget: WebGLRenderbufferTarget, renderbuffer: WebGLRenderbuffer,
  ): WebGLContext {
    native.framebufferRenderbuffer(target.value, attachment.value, renderbufferTarget.value, renderbuffer.native)
    return this
  }
  attributeDivisor(location: int, divisor: int): bool {
    if divisor < 0 { panic("WebGL attribute divisor must be non-negative") }
    return native.attributeDivisor(location, divisor)
  }
  drawArraysInstanced(mode: WebGLPrimitive, first: int, count: int, instanceCount: int): bool {
    if instanceCount <= 0 { panic("WebGL instance count must be positive") }
    return native.drawArraysInstanced(mode.value, first, count, instanceCount)
  }
  drawElementsInstanced(
    mode: WebGLPrimitive, count: int, dataType: WebGLDataType,
    instanceCount: int, offset: int = 0,
  ): bool {
    if instanceCount <= 0 { panic("WebGL instance count must be positive") }
    return native.drawElementsInstanced(mode.value, count, dataType.value, offset, instanceCount)
  }
  flush(): WebGLContext { native.flush(); return this }
  finish(): WebGLContext { native.finish(); return this }
}

export class DomDocument {
  private native: NativeDocument

  head(): Element => Element { native: native.head() }
  body(): Element => Element { native: native.body() }
  window(): DomWindow => DomWindow { element: Element { native: native.window() } }
}

export function domDocument(): DomDocument {
  return DomDocument { native: NativeDocument.shared() }
}

export function div(
  id: string = "",
  className: string = "",
  role: string = "",
  title: string = "",
  ariaLabel: string = "",
  tabIndex: int | none = none,
  children: DomChild[] = [],
): Element {
  return createElement("div", id, className, role, title, ariaLabel, tabIndex, children)
}

export function button(
  id: string = "",
  className: string = "",
  name: string = "",
  value: string = "",
  buttonType: string = "button",
  disabled: bool = false,
  role: string = "",
  title: string = "",
  ariaLabel: string = "",
  tabIndex: int | none = none,
  onClick: DomEventHandler | none = none,
  children: DomChild[] = [],
): Element {
  element := createElement("button", id, className, role, title, ariaLabel, tabIndex, children)
  if name != "" { element.setAttribute("name", name) }
  if value != "" { element.setValue(value) }
  element.setAttribute("type", buttonType).setDisabled(disabled)
  if onClick != none { element.setOnClick(onClick!) }
  return element
}

export function span(
  id: string = "", className: string = "", role: string = "", title: string = "",
  ariaLabel: string = "", tabIndex: int | none = none, children: DomChild[] = [],
): Element => createElement("span", id, className, role, title, ariaLabel, tabIndex, children)

export function p(
  id: string = "", className: string = "", role: string = "", title: string = "",
  ariaLabel: string = "", tabIndex: int | none = none, children: DomChild[] = [],
): Element => createElement("p", id, className, role, title, ariaLabel, tabIndex, children)

export function section(
  id: string = "", className: string = "", role: string = "", title: string = "",
  ariaLabel: string = "", tabIndex: int | none = none, children: DomChild[] = [],
): Element => createElement("section", id, className, role, title, ariaLabel, tabIndex, children)

export function heading(
  level: int = 1, id: string = "", className: string = "", role: string = "",
  title: string = "", ariaLabel: string = "", tabIndex: int | none = none,
  children: DomChild[] = [],
): Element {
  if level < 1 || level > 6 { panic("DOM heading level must be between 1 and 6") }
  return createElement("h" + string(level), id, className, role, title, ariaLabel, tabIndex, children)
}

export function label(
  id: string = "", className: string = "", htmlFor: string = "", role: string = "",
  title: string = "", ariaLabel: string = "", tabIndex: int | none = none,
  children: DomChild[] = [],
): Element {
  element := createElement("label", id, className, role, title, ariaLabel, tabIndex, children)
  if htmlFor != "" { element.setAttribute("for", htmlFor) }
  return element
}

export function form(
  id: string = "", className: string = "", role: string = "", title: string = "",
  ariaLabel: string = "", tabIndex: int | none = none,
  onSubmit: DomEventHandler | none = none, children: DomChild[] = [],
): Element {
  element := createElement("form", id, className, role, title, ariaLabel, tabIndex, children)
  if onSubmit != none { element.setOnSubmit(onSubmit!) }
  return element
}

export function input(
  id: string = "", className: string = "", name: string = "", value: string = "",
  placeholder: string = "", inputType: string = "text", checked: bool = false,
  disabled: bool = false, role: string = "", title: string = "", ariaLabel: string = "",
  tabIndex: int | none = none, onInput: DomEventHandler | none = none,
  onChange: DomEventHandler | none = none,
): Element {
  element := createElement("input", id, className, role, title, ariaLabel, tabIndex, [])
  element.setAttribute("type", inputType).setValue(value).setChecked(checked).setDisabled(disabled)
  if name != "" { element.setAttribute("name", name) }
  if placeholder != "" { element.setAttribute("placeholder", placeholder) }
  if onInput != none { element.setOnInput(onInput!) }
  if onChange != none { element.setOnChange(onChange!) }
  return element
}

export function canvas(
  id: string = "", className: string = "", width: int = 300, height: int = 150,
  role: string = "", title: string = "", ariaLabel: string = "",
  tabIndex: int | none = none, children: DomChild[] = [],
): Canvas {
  element := createElement("canvas", id, className, role, title, ariaLabel, tabIndex, children)
  element.setAttribute("width", string(width)).setAttribute("height", string(height))
  return Canvas { element }
}

function createElement(
  tagName: string,
  id: string,
  className: string,
  role: string,
  title: string,
  ariaLabel: string,
  tabIndex: int | none,
  children: DomChild[],
): Element {
  native := NativeElement.create(tagName)
  if id != "" { native.setId(id) }
  if className != "" { native.setClassName(className) }
  if role != "" { native.setAttribute("role", role) }
  if title != "" { native.setAttribute("title", title) }
  if ariaLabel != "" { native.setAttribute("aria-label", ariaLabel) }
  if tabIndex != none { native.setAttribute("tabindex", string(tabIndex!)) }
  for child of children {
    case child {
      text: string -> native.appendText(text),
      element: Element -> native.appendChild(element.native),
      canvas: Canvas -> native.appendChild(canvas.element.native),
    }
  }
  return Element { native }
}

function eventFromNative(native: NativeDomEvent): DomEvent {
  return DomEvent {
    eventType: native.eventType(),
    timeStamp: native.timeStamp(),
    targetTagName: native.targetTagName(),
    targetId: native.targetId(),
    currentTargetTagName: native.currentTargetTagName(),
    currentTargetId: native.currentTargetId(),
    clientX: native.clientX(),
    clientY: native.clientY(),
    deltaX: native.deltaX(),
    deltaY: native.deltaY(),
    movementX: native.movementX(),
    movementY: native.movementY(),
    button: native.button(),
    buttons: native.buttons(),
    pointerId: native.pointerId(),
    value: native.value(),
    checked: native.checked(),
    key: native.key(),
    code: native.code(),
    altKey: native.altKey(),
    ctrlKey: native.ctrlKey(),
    metaKey: native.metaKey(),
    shiftKey: native.shiftKey(),
    repeat: native.repeat(),
    native,
  }
}

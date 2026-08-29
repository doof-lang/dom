import test from "node:test";
import assert from "node:assert/strict";
import { existsSync } from "node:fs";
import { readFile } from "node:fs/promises";

import { createDomBridge, loadDoofDom } from "../doof-dom.js";

class FakeCanvasContext {
  constructor() {
    this.calls = [];
    this.fillStyle = "#000";
    this.strokeStyle = "#000";
  }
  record(name, ...args) { this.calls.push([name, ...args]); }
  save() { this.record("save"); }
  restore() { this.record("restore"); }
  beginPath() { this.record("beginPath"); }
  closePath() { this.record("closePath"); }
  fill() { this.record("fill"); }
  stroke() { this.record("stroke"); }
  resetTransform() { this.record("resetTransform"); }
  clearRect(...args) { this.record("clearRect", ...args); }
  fillRect(...args) { this.record("fillRect", ...args); }
  strokeRect(...args) { this.record("strokeRect", ...args); }
  moveTo(...args) { this.record("moveTo", ...args); }
  lineTo(...args) { this.record("lineTo", ...args); }
  rect(...args) { this.record("rect", ...args); }
  arc(...args) { this.record("arc", ...args); }
  translate(...args) { this.record("translate", ...args); }
  scale(...args) { this.record("scale", ...args); }
  rotate(...args) { this.record("rotate", ...args); }
  setTransform(...args) { this.record("setTransform", ...args); }
  fillText(...args) { this.record("fillText", ...args); }
  strokeText(...args) { this.record("strokeText", ...args); }
  measureText(text) { this.record("measureText", text); return { width: text.length * 8 }; }
}

class FakeWebGLContext {
  constructor() {
    this.calls = [];
    this.COMPILE_STATUS = 35713;
    this.LINK_STATUS = 35714;
    this.TEXTURE0 = 33984;
    this.MAX_VERTEX_ATTRIBS = 34921;
    this.MAX_TEXTURE_IMAGE_UNITS = 34930;
  }
  record(name, ...args) { this.calls.push([name, ...args]); }
  createShader(type) { const value = { kind: "shader", type, source: "", compiled: false }; this.record("createShader", type); return value; }
  deleteShader(shader) { shader.deleted = true; this.record("deleteShader", shader); }
  shaderSource(shader, source) { shader.source = source; this.record("shaderSource", shader, source); }
  compileShader(shader) { shader.compiled = !shader.source.includes("invalid"); this.record("compileShader", shader); }
  getShaderParameter(shader) { return shader.compiled; }
  getShaderInfoLog(shader) { return shader.compiled ? "" : "shader failed"; }
  createProgram() { const value = { kind: "program", shaders: [], linked: false }; this.record("createProgram"); return value; }
  deleteProgram(program) { program.deleted = true; this.record("deleteProgram", program); }
  attachShader(program, shader) { program.shaders.push(shader); this.record("attachShader", program, shader); }
  linkProgram(program) { program.linked = program.shaders.length === 2 && program.shaders.every((shader) => shader.compiled); this.record("linkProgram", program); }
  getProgramParameter(program) { return program.linked; }
  getProgramInfoLog(program) { return program.linked ? "" : "program failed"; }
  createBuffer() { const value = { kind: "buffer" }; this.record("createBuffer"); return value; }
  deleteBuffer(buffer) { buffer.deleted = true; this.record("deleteBuffer", buffer); }
  useProgram(program) { this.record("useProgram", program); }
  bindBuffer(...args) { this.record("bindBuffer", ...args); }
  bufferData(target, values, usage) { this.record("bufferData", target, Array.from(values), usage, values.constructor.name); }
  getAttribLocation(_program, name) { return name === "position" ? 3 : -1; }
  enableVertexAttribArray(...args) { this.record("enableVertexAttribArray", ...args); }
  disableVertexAttribArray(...args) { this.record("disableVertexAttribArray", ...args); }
  vertexAttribPointer(...args) { this.record("vertexAttribPointer", ...args); }
  viewport(...args) { this.record("viewport", ...args); }
  clearColor(...args) { this.record("clearColor", ...args); }
  clearDepth(...args) { this.record("clearDepth", ...args); }
  clearStencil(...args) { this.record("clearStencil", ...args); }
  clear(...args) { this.record("clear", ...args); }
  enable(...args) { this.record("enable", ...args); }
  disable(...args) { this.record("disable", ...args); }
  drawArrays(...args) { this.record("drawArrays", ...args); }
  drawElements(...args) { this.record("drawElements", ...args); }
  flush() { this.record("flush"); }
  finish() { this.record("finish"); }
  vertexAttribDivisor(...args) { this.record("vertexAttribDivisor", ...args); }
  drawArraysInstanced(...args) { this.record("drawArraysInstanced", ...args); }
  drawElementsInstanced(...args) { this.record("drawElementsInstanced", ...args); }
  getParameter(name) {
    this.record("getParameter", name);
    if (name === this.MAX_VERTEX_ATTRIBS) return 16;
    if (name === this.MAX_TEXTURE_IMAGE_UNITS) return 8;
    return 0;
  }
  createTexture() { const value = { kind: "texture" }; this.record("createTexture"); return value; }
  deleteTexture(texture) { texture.deleted = true; this.record("deleteTexture", texture); }
  activeTexture(...args) { this.record("activeTexture", ...args); }
  bindTexture(...args) { this.record("bindTexture", ...args); }
  texImage2D(target, level, internalFormat, width, height, border, format, type, pixels) {
    if (arguments.length === 6) {
      this.record("texImage2D", ...arguments);
      return;
    }
    this.record("texImage2D", target, level, internalFormat, width, height, border, format, type, pixels == null ? null : Array.from(pixels));
  }
  texParameteri(...args) { this.record("texParameteri", ...args); }
  generateMipmap(...args) { this.record("generateMipmap", ...args); }
  pixelStorei(...args) { this.record("pixelStorei", ...args); }
  blendFunc(...args) { this.record("blendFunc", ...args); }
  blendEquation(...args) { this.record("blendEquation", ...args); }
  depthFunc(...args) { this.record("depthFunc", ...args); }
  depthMask(...args) { this.record("depthMask", ...args); }
  colorMask(...args) { this.record("colorMask", ...args); }
  cullFace(...args) { this.record("cullFace", ...args); }
  frontFace(...args) { this.record("frontFace", ...args); }
  scissor(...args) { this.record("scissor", ...args); }
  polygonOffset(...args) { this.record("polygonOffset", ...args); }
  createFramebuffer() { const value = { kind: "framebuffer" }; this.record("createFramebuffer"); return value; }
  deleteFramebuffer(value) { value.deleted = true; this.record("deleteFramebuffer", value); }
  bindFramebuffer(...args) { this.record("bindFramebuffer", ...args); }
  framebufferTexture2D(...args) { this.record("framebufferTexture2D", ...args); }
  checkFramebufferStatus(...args) { this.record("checkFramebufferStatus", ...args); return 36053; }
  createRenderbuffer() { const value = { kind: "renderbuffer" }; this.record("createRenderbuffer"); return value; }
  deleteRenderbuffer(value) { value.deleted = true; this.record("deleteRenderbuffer", value); }
  bindRenderbuffer(...args) { this.record("bindRenderbuffer", ...args); }
  renderbufferStorage(...args) { this.record("renderbufferStorage", ...args); }
  framebufferRenderbuffer(...args) { this.record("framebufferRenderbuffer", ...args); }
  getUniformLocation(_program, name) { return name === "missing" ? null : { name }; }
  uniform1f(...args) { this.record("uniform1f", ...args); }
  uniform2f(...args) { this.record("uniform2f", ...args); }
  uniform3f(...args) { this.record("uniform3f", ...args); }
  uniform4f(...args) { this.record("uniform4f", ...args); }
  uniform1i(...args) { this.record("uniform1i", ...args); }
  uniformMatrix4fv(location, transpose, values) { this.record("uniformMatrix4fv", location, transpose, Array.from(values)); }
}

class FakeNode {
  constructor(tagName = "", nodeType = 1, text = "") {
    this.tagName = tagName.toUpperCase();
    this.nodeType = nodeType;
    this.text = text;
    this.id = "";
    this.className = "";
    this.disabled = false;
    this.value = "";
    this.checked = false;
    this.attributes = new Map();
    this.focused = false;
    this.canvasContext = this.tagName === "CANVAS" ? new FakeCanvasContext() : null;
    this.webglContext = this.tagName === "CANVAS" ? new FakeWebGLContext() : null;
    this.parentNode = null;
    this.childNodes = [];
    this.listeners = new Map();
  }

  detach() {
    if (!this.parentNode) return;
    const index = this.parentNode.childNodes.indexOf(this);
    if (index >= 0) this.parentNode.childNodes.splice(index, 1);
    this.parentNode = null;
  }

  appendChild(child) {
    child.detach();
    this.childNodes.push(child);
    child.parentNode = this;
  }

  before(child) {
    const parent = this.parentNode;
    if (!parent) return;
    child.detach();
    const index = parent.childNodes.indexOf(this);
    parent.childNodes.splice(index, 0, child);
    child.parentNode = parent;
  }

  after(child) {
    const parent = this.parentNode;
    if (!parent) return;
    child.detach();
    const index = parent.childNodes.indexOf(this);
    parent.childNodes.splice(index + 1, 0, child);
    child.parentNode = parent;
  }

  replaceWith(child) {
    const parent = this.parentNode;
    if (!parent) return;
    child.detach();
    const index = parent.childNodes.indexOf(this);
    parent.childNodes[index] = child;
    child.parentNode = parent;
    this.parentNode = null;
  }

  remove() { this.detach(); }
  addEventListener(name, handler) { this.listeners.set(name, handler); }
  removeEventListener(name, handler) {
    if (this.listeners.get(name) === handler) this.listeners.delete(name);
  }
  dispatch(name, event) { this.listeners.get(name)?.({ ...event, currentTarget: this }); }
  setAttribute(name, value) {
    this.attributes.set(name, value);
    if (name === "width" || name === "height") {
      this[name] = Number(value);
      this[name === "width" ? "clientWidth" : "clientHeight"] = Number(value);
    }
  }
  removeAttribute(name) { this.attributes.delete(name); }
  focus() { this.focused = true; }
  blur() { this.focused = false; }
  getContext(kind, options) {
    if (kind === "2d") return this.canvasContext;
    if (kind === "webgl2") {
      this.webglContextKind = kind;
      this.webglContextOptions = options;
      return this.webglContext;
    }
    return null;
  }

  set textContent(value) {
    this.childNodes = [];
    this.text = value;
  }
}

class FakeWindow extends FakeNode {
  constructor() {
    super("window");
    this.devicePixelRatio = 2;
    this.navigator = {
      getGamepads: () => [{
        connected: true, id: "Test Pad",
        buttons: [{ pressed: true, value: 0.75 }], axes: [-0.5, 0.25],
      }],
    };
    this.nextFrame = 1;
    this.frames = new Map();
  }
  requestAnimationFrame(handler) { const id = this.nextFrame++; this.frames.set(id, handler); return id; }
  cancelAnimationFrame(id) { this.frames.delete(id); }
  flushAnimationFrame(timestamp) {
    const frames = Array.from(this.frames.values());
    this.frames.clear();
    for (const frame of frames) frame(timestamp);
  }
}

class FakeDocument {
  constructor() {
    this.defaultView = new FakeWindow();
    this.head = new FakeNode("head");
    this.body = new FakeNode("body");
    this.created = [];
  }
  createElement(tagName) {
    const node = new FakeNode(tagName);
    this.created.push(node);
    return node;
  }
  createTextNode(text) {
    const node = new FakeNode("", 3, text);
    this.created.push(node);
    return node;
  }
}

function harness(dispatch = () => 0) {
  const document = new FakeDocument();
  const errors = [];
  const bridge = createDomBridge(document, (error) => errors.push(error));
  const memory = new WebAssembly.Memory({ initial: 1 });
  bridge.attach({
    exports: {
      memory,
      __indirect_function_table: { get: () => dispatch },
    },
  });
  let next = 32;
  const write = (value) => {
    const bytes = new TextEncoder().encode(value);
    const pointer = next;
    next += bytes.length + 1;
    const memoryBytes = new Uint8Array(memory.buffer);
    memoryBytes.set(bytes, pointer);
    memoryBytes[pointer + bytes.length] = 0;
    return pointer;
  };
  return { document, errors, imports: bridge.imports, memory, write };
}

test("creates elements and text immediately and moves known handles", () => {
  const { document, imports, write } = harness();
  const div = imports.create_element(write("div"));
  const button = imports.create_element(write("button"));
  const text = imports.create_text(write("safe <b>text</b>"));

  assert.equal(document.created[0].tagName, "DIV");
  assert.equal(document.created[2].text, "safe <b>text</b>");
  imports.append_to(text, div);
  imports.append_to(div, 2);
  imports.insert_before(button, div);
  assert.deepEqual(document.body.childNodes, [document.created[1], document.created[0]]);

  imports.insert_after(button, div);
  assert.deepEqual(document.body.childNodes, [document.created[0], document.created[1]]);
  imports.unmount(button);
  assert.equal(document.created[1].parentNode, null);
  imports.replace(button, div);
  assert.deepEqual(document.body.childNodes, [document.created[1]]);
});

test("applies safe properties", () => {
  const { document, imports, write } = harness();
  const element = imports.create_element(write("button"));
  imports.set_string(element, 0, write("save"));
  imports.set_string(element, 1, write("primary"));
  imports.set_bool(element, 0, 1);
  imports.set_string(element, 2, write("publish"));
  imports.set_bool(element, 1, 1);
  imports.set_attribute(element, write("aria-label"), write("Save changes"));
  imports.focus(element);
  imports.set_text(element, write("<strong>Save</strong>"));

  assert.equal(document.created[0].id, "save");
  assert.equal(document.created[0].className, "primary");
  assert.equal(document.created[0].disabled, true);
  assert.equal(document.created[0].value, "publish");
  assert.equal(document.created[0].checked, true);
  assert.equal(document.created[0].attributes.get("aria-label"), "Save changes");
  assert.equal(document.created[0].focused, true);
  imports.blur(element);
  imports.remove_attribute(element, write("aria-label"));
  assert.equal(document.created[0].focused, false);
  assert.equal(document.created[0].attributes.has("aria-label"), false);
  assert.equal(document.created[0].text, "<strong>Save</strong>");
});

test("routes event snapshots and applies event control flags", () => {
  let received;
  const { document, imports, memory, write } = harness((callbackId, eventId) => {
    const output = 2048;
    const length = imports.event_string(eventId, 0, output, 64);
    received = {
      callbackId,
      type: new TextDecoder().decode(new Uint8Array(memory.buffer, output, length)),
      x: imports.event_number(eventId, 1),
      shift: imports.event_bool(eventId, 3),
      value: (() => {
        const valueOutput = 2112;
        const valueLength = imports.event_string(eventId, 7, valueOutput, 64);
        return new TextDecoder().decode(new Uint8Array(memory.buffer, valueOutput, valueLength));
      })(),
      checked: imports.event_int(eventId, 1),
    };
    return 7;
  });
  const element = imports.create_element(write("button"));
  document.created[0].value = "Ada";
  document.created[0].checked = true;
  imports.add_event(element, write("input"), 42, 9);
  const calls = [];
  document.created[0].dispatch("input", {
    type: "input",
    target: document.created[0],
    timeStamp: 12,
    clientX: 34,
    clientY: 56,
    button: 0,
    shiftKey: true,
    preventDefault: () => calls.push("prevent"),
    stopPropagation: () => calls.push("stop"),
    stopImmediatePropagation: () => calls.push("immediate"),
  });

  assert.deepEqual(received, { callbackId: 42, type: "input", x: 34, shift: 1, value: "Ada", checked: 1 });
  assert.deepEqual(calls, ["prevent", "stop", "immediate"]);
  imports.remove_event(element, write("input"), 42);
  assert.equal(document.created[0].listeners.size, 0);
});

test("routes compact 2D canvas operations", () => {
  const { document, imports, write } = harness();
  const canvas = imports.create_element(write("canvas"));
  const context = imports.canvas_context_2d(canvas);
  assert.notEqual(context, 0);

  imports.canvas_set_string(context, 0, write("#ff0000"));
  imports.canvas_set_number(context, 0, 3);
  imports.canvas_action(context, 2);
  imports.canvas_numbers(context, 3, 1, 2, 0, 0, 0, 0);
  imports.canvas_numbers(context, 4, 10, 20, 0, 0, 0, 0);
  imports.canvas_numbers(context, 6, 10, 10, 5, 0, Math.PI, 1);
  imports.canvas_action(context, 5);
  imports.canvas_text(context, 0, write("Doof"), 4, 8, NaN);
  assert.equal(imports.canvas_measure_text(context, write("Doof")), 32);

  const value = document.created[0].canvasContext;
  assert.equal(value.fillStyle, "#ff0000");
  assert.equal(value.lineWidth, 3);
  assert.deepEqual(value.calls, [
    ["beginPath"],
    ["moveTo", 1, 2],
    ["lineTo", 10, 20],
    ["arc", 10, 10, 5, 0, Math.PI, true],
    ["stroke"],
    ["fillText", "Doof", 4, 8],
    ["measureText", "Doof"],
  ]);
  imports.destroy_canvas_context(context);
  assert.throws(() => imports.canvas_action(context, 0), /Unknown Doof canvas context/);
});

test("routes browser sizing, window input, and animation frames", () => {
  const frameCalls = [];
  const { document, imports, write } = harness((callbackId, value) => {
    frameCalls.push([callbackId, value]);
    return 0;
  });
  const canvas = imports.create_element(write("canvas"));
  imports.set_attribute(canvas, write("width"), write("640"));
  imports.set_attribute(canvas, write("height"), write("360"));
  assert.equal(imports.element_number(canvas, 0), 640);
  assert.equal(imports.element_number(canvas, 1), 360);
  assert.equal(imports.element_number(canvas, 2), 640);
  assert.equal(imports.element_number(canvas, 3), 360);
  assert.equal(imports.element_number(canvas, 4), 2);
  assert.equal(imports.gamepad_int(0, 0, 0), 1);
  assert.equal(imports.gamepad_int(0, 1, 0), 1);
  assert.equal(imports.gamepad_int(0, 2, 0), 1);
  assert.equal(imports.gamepad_number(0, 0, 0), 0.75);
  assert.equal(imports.gamepad_number(0, 1, 0), -0.5);
  const gamepadId = 3000;
  assert.equal(imports.gamepad_string(0, 0, gamepadId, 32), 8);

  const request = imports.request_animation_frame(17, 9);
  document.defaultView.flushAnimationFrame(12.5);
  assert.deepEqual(frameCalls, [[17, 12.5]]);
  const cancelled = imports.request_animation_frame(18, 9);
  imports.cancel_animation_frame(cancelled);
  document.defaultView.flushAnimationFrame(20);
  assert.deepEqual(frameCalls, [[17, 12.5]]);

  imports.add_event(0, write("keydown"), 23, 9);
  document.defaultView.dispatch("keydown", {
    type: "keydown", target: document.body, key: "w", code: "KeyW", repeat: true,
    preventDefault() {}, stopPropagation() {}, stopImmediatePropagation() {},
  });
  assert.equal(frameCalls[1][0], 23);
  imports.remove_event(0, write("keydown"), 23);
});

test("loads, uploads, and releases browser images", () => {
  let dispatched;
  const { document, imports, write } = harness((...args) => { dispatched = args; });
  const imageId = imports.load_image(write("/card.png"), 1, 17, 23);
  const image = document.created[0];

  assert.equal(image.crossOrigin, "anonymous");
  assert.equal(image.decoding, "async");
  assert.equal(image.src, "/card.png");
  image.naturalWidth = 64;
  image.naturalHeight = 32;
  image.onload();
  assert.deepEqual(dispatched, [17, imageId, 64, 32, 1]);

  const canvas = imports.create_element(write("canvas"));
  const context = imports.canvas_context_webgl(canvas, 1, 1, 1, 0, 1, 0, 0);
  imports.webgl_texture_image(context, 3553, imageId);
  assert.equal(document.created[1].webglContext.calls.at(-1)[0], "texImage2D");
  assert.equal(document.created[1].webglContext.calls.at(-1).at(-1), image);

  imports.destroy_image(imageId);
  assert.equal(image.src, "");

  const cancelledId = imports.load_image(write("/cancel.png"), 0, 18, 23);
  const cancelled = document.created[2];
  imports.cancel_image(cancelledId);
  assert.equal(cancelled.src, "");
  assert.equal(cancelled.onload, null);

  const failedId = imports.load_image(write("/missing.png"), 2, 19, 23);
  const failed = document.created[3];
  failed.onerror();
  assert.deepEqual(dispatched, [19, 0, 0, 0, 0]);
  assert.equal(failed.crossOrigin, "use-credentials");
  imports.destroy_image(failedId);
});

test("owns WebGL resources and routes a foundational render pipeline", () => {
  const { document, imports, memory, write } = harness();
  const canvas = imports.create_element(write("canvas"));
  const context = imports.canvas_context_webgl(canvas, 1, 0, 1, 1, 0, 1, 2);
  assert.equal(document.created[0].webglContextKind, "webgl2");
  assert.deepEqual(document.created[0].webglContextOptions, {
    alpha: true,
    antialias: false,
    depth: true,
    stencil: true,
    premultipliedAlpha: false,
    preserveDrawingBuffer: true,
    powerPreference: "high-performance",
  });
  const vertex = imports.webgl_create_resource(context, 0, 35633);
  const fragment = imports.webgl_create_resource(context, 0, 35632);
  imports.webgl_string_operation(context, 0, vertex, write("#version 300 es\nin vec2 position;"), 0, 0, 0, 0);
  imports.webgl_string_operation(context, 0, fragment, write("#version 300 es\nout vec4 color; void main() { color = vec4(1.0); }"), 0, 0, 0, 0);
  imports.webgl_operation(context, 0, vertex, 0, 0, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 0, fragment, 0, 0, 0, 0, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 1, vertex, 0, 0, 0, 0, 0, 0, 0), 1);

  const program = imports.webgl_create_resource(context, 1, 0);
  imports.webgl_operation(context, 2, program, vertex, 0, 0, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 2, program, fragment, 0, 0, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 3, program, 0, 0, 0, 0, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 4, program, 0, 0, 0, 0, 0, 0, 0), 1);
  assert.equal(imports.webgl_string_operation(context, 1, program, write("position"), 0, 0, 0, 0), 3);

  const buffer = imports.webgl_create_resource(context, 2, 0);
  imports.webgl_operation(context, 6, buffer, 0, 34962, 0, 0, 0, 0, 0);
  const floatPointer = 4096;
  new Float64Array(memory.buffer, floatPointer, 6).set([-1, -1, 1, -1, 0, 1]);
  imports.webgl_buffer_data_f64(context, 34962, floatPointer, 6, 35044);
  imports.webgl_operation(context, 9, 3, 0, 2, 5126, 0, 0, 0, 0);
  imports.webgl_operation(context, 11, 0, 0, 0.1, 0.2, 0.3, 1, 0, 0);
  imports.webgl_operation(context, 14, 0, 0, 16384, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 17, 0, 0, 4, 0, 3, 0, 0, 0);
  assert.equal(imports.webgl_string_operation(context, 5, program, write("color"), 1, 0.5, 0.25, 1), 1);
  assert.equal(imports.webgl_string_operation(context, 2, program, write("missing"), 1, 0, 0, 0), 0);

  const indexPointer = 12288;
  new Uint16Array(memory.buffer, indexPointer, 3).set([0, 1, 2]);
  imports.webgl_buffer_data_u16(context, 34963, indexPointer, 3, 35048);
  const uintIndexPointer = 12304;
  new Uint32Array(memory.buffer, uintIndexPointer, 3).set([0, 70000, 2]);
  imports.webgl_buffer_data_u32(context, 34963, uintIndexPointer, 3, 35044);
  const bytePointer = 12320;
  new Uint8Array(memory.buffer, bytePointer, 4).set([0, 127, 200, 255]);
  imports.webgl_buffer_data_u8(context, 34962, bytePointer, 4, 35044);
  imports.webgl_operation(context, 18, 0, 0, 4, 3, 5123, 0, 0, 0);

  const matrixPointer = 8192;
  new Float64Array(memory.buffer, matrixPointer, 16).set([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);
  assert.equal(imports.webgl_uniform_matrix4(context, program, write("transform"), 0, matrixPointer, 16), 1);

  const texture = imports.webgl_create_resource(context, 3, 0);
  imports.webgl_operation(context, 21, 0, 0, 2, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 22, texture, 0, 3553, 0, 0, 0, 0, 0);
  const texturePointer = 20000;
  new Uint8Array(memory.buffer, texturePointer, 16).set([
    255, 0, 0, 255, 0, 255, 0, 255,
    0, 0, 255, 255, 255, 255, 255, 255,
  ]);
  imports.webgl_texture_rgba(context, 3553, 2, 2, texturePointer, 16);
  imports.webgl_operation(context, 23, 0, 0, 3553, 10241, 9729, 0, 0, 0);
  imports.webgl_operation(context, 24, 0, 0, 3553, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 25, 0, 0, 37440, 1, 0, 0, 0, 0);
  imports.webgl_operation(context, 26, 0, 0, 770, 771, 0, 0, 0, 0);
  imports.webgl_operation(context, 27, 0, 0, 32774, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 28, 0, 0, 515, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 29, 0, 0, 1, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 30, 0, 0, 1, 1, 1, 0, 0, 0);
  imports.webgl_operation(context, 31, 0, 0, 1029, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 32, 0, 0, 2305, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 33, 0, 0, 1, 2, 30, 40, 0, 0);
  imports.webgl_operation(context, 34, 0, 0, 1.5, 2, 0, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 35, 0, 0, 0, 0, 0, 0, 0, 0), 1);
  assert.equal(imports.webgl_operation(context, 39, 0, 0, 0, 0, 0, 0, 0, 0), 1);
  assert.equal(imports.webgl_operation(context, 40, 0, 0, 0, 0, 0, 0, 0, 0), 16);
  assert.equal(imports.webgl_operation(context, 41, 0, 0, 0, 0, 0, 0, 0, 0), 8);
  assert.equal(imports.webgl_operation(context, 42, 0, 0, 0, 0, 0, 0, 0, 0), 1);
  const depthTexture = imports.webgl_create_resource(context, 3, 0);
  imports.webgl_operation(context, 22, depthTexture, 0, 3553, 0, 0, 0, 0, 0);
  imports.webgl_texture_depth(context, 3553, 256, 128);
  const framebuffer = imports.webgl_create_resource(context, 4, 0);
  imports.webgl_operation(context, 43, framebuffer, 0, 36160, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 44, depthTexture, 0, 36160, 36096, 3553, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 45, 0, 0, 36160, 0, 0, 0, 0, 0), 36053);
  const renderbuffer = imports.webgl_create_resource(context, 5, 0);
  imports.webgl_operation(context, 46, renderbuffer, 0, 36161, 0, 0, 0, 0, 0);
  imports.webgl_operation(context, 47, 0, 0, 36161, 33189, 256, 128, 0, 0);
  imports.webgl_operation(context, 48, renderbuffer, 0, 36160, 36096, 36161, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 36, 3, 0, 1, 0, 0, 0, 0, 0), 1);
  assert.equal(imports.webgl_operation(context, 37, 0, 0, 4, 0, 3, 5, 0, 0), 1);
  assert.equal(imports.webgl_operation(context, 38, 0, 0, 4, 3, 5123, 0, 5, 0), 1);
  const calls = document.created[0].webglContext.calls;
  assert.ok(calls.some(([name, , values, usage, type]) => name === "bufferData" && values.length === 6 && usage === 35044 && type === "Float32Array"));
  assert.ok(calls.some(([name, , values, usage, type]) => name === "bufferData" && values.join() === "0,1,2" && usage === 35048 && type === "Uint16Array"));
  assert.ok(calls.some(([name, , values, , type]) => name === "bufferData" && values.join() === "0,70000,2" && type === "Uint32Array"));
  assert.ok(calls.some(([name, , values, , type]) => name === "bufferData" && values.join() === "0,127,200,255" && type === "Uint8Array"));
  assert.ok(calls.some(([name, mode, first, count]) => name === "drawArrays" && mode === 4 && first === 0 && count === 3));
  assert.ok(calls.some(([name, mode, count, type]) => name === "drawElements" && mode === 4 && count === 3 && type === 5123));
  assert.ok(calls.some(([name, unit]) => name === "activeTexture" && unit === 33986));
  assert.ok(calls.some(([name, , , , width, height]) => name === "texImage2D" && width === 2 && height === 2));
  assert.ok(calls.some(([name, , , internalFormat, width, height, , format, type, pixels]) =>
    name === "texImage2D" && internalFormat === 33189 && width === 256 && height === 128
      && format === 6402 && type === 5123 && pixels === null));
  assert.ok(calls.some(([name, target, attachment]) => name === "framebufferTexture2D" && target === 36160 && attachment === 36096));
  assert.ok(calls.some(([name, target, format, width, height]) =>
    name === "renderbufferStorage" && target === 36161 && format === 33189 && width === 256 && height === 128));
  assert.ok(calls.some(([name, mode, , count, instances]) => name === "drawArraysInstanced" && mode === 4 && count === 3 && instances === 5));

  const invalid = imports.webgl_create_resource(context, 0, 35633);
  imports.webgl_string_operation(context, 0, invalid, write("invalid shader"), 0, 0, 0, 0);
  imports.webgl_operation(context, 0, invalid, 0, 0, 0, 0, 0, 0, 0);
  assert.equal(imports.webgl_operation(context, 1, invalid, 0, 0, 0, 0, 0, 0, 0), 0);
  const logPointer = 16384;
  const logLength = imports.webgl_resource_log(context, 0, invalid, logPointer, 64);
  assert.equal(new TextDecoder().decode(new Uint8Array(memory.buffer, logPointer, logLength)), "shader failed");

  imports.webgl_delete_resource(context, 2, buffer);
  imports.webgl_delete_resource(context, 1, program);
  imports.webgl_delete_resource(context, 0, vertex);
  imports.webgl_delete_resource(context, 0, fragment);
  imports.webgl_delete_resource(context, 0, invalid);
  imports.webgl_delete_resource(context, 3, texture);
  imports.webgl_delete_resource(context, 3, depthTexture);
  imports.webgl_delete_resource(context, 4, framebuffer);
  imports.webgl_delete_resource(context, 5, renderbuffer);
  imports.destroy_webgl_context(context);
});

test("reports callback errors", () => {
  const { document, errors, imports, write } = harness(() => { throw new Error("boom"); });
  const element = imports.create_element(write("button"));
  imports.add_event(element, write("click"), 1, 1);
  document.created[0].dispatch("click", { type: "click", target: document.created[0] });
  assert.equal(errors.length, 1);
  assert.match(errors[0].message, /boom/);
});

const sampleWasm = new URL("../samples/counter/build/std-dom-counter-sample.wasm", import.meta.url);
test("runs the compiled counter through the real WASM bridge", {
  skip: !existsSync(sampleWasm),
}, async () => {
  const document = new FakeDocument();
  const app = await loadDoofDom(await readFile(sampleWasm), { document });
  app.call("start");

  const findById = (node, id) => {
    if (node.id === id) return node;
    for (const child of node.childNodes) {
      const found = findById(child, id);
      if (found) return found;
    }
    return null;
  };
  const count = findById(document.body, "count");
  const increment = findById(document.body, "increment");
  const name = findById(document.body, "name");
  const greeting = findById(document.body, "greeting");
  const profile = findById(document.body, "profile");
  const imageStatus = findById(document.body, "image-texture-status");
  const webgl = findById(document.body, "webgl-preview").webglContext;
  assert.ok(count);
  assert.ok(increment);
  assert.ok(name);
  assert.ok(greeting);
  assert.ok(imageStatus);
  assert.ok(webgl.calls.some(([operation, location, transpose, values]) =>
    operation === "uniformMatrix4fv"
      && location.name === "scene"
      && transpose === false
      && values.join() === "1,0,0,0,0,1,0,0,0,0,1,0,0.029999999329447746,-0.019999999552965164,0,1"
  ));
  increment.dispatch("click", {
    type: "click",
    target: increment,
    timeStamp: 1,
    preventDefault() {},
    stopPropagation() {},
    stopImmediatePropagation() {},
  });
  assert.equal(count.text, "Count: 1");
  name.value = "Ada";
  name.dispatch("input", {
    type: "input",
    target: name,
    timeStamp: 2,
    preventDefault() {},
    stopPropagation() {},
    stopImmediatePropagation() {},
  });
  assert.equal(greeting.text, "Hello, Ada");
  let prevented = false;
  profile.dispatch("submit", {
    type: "submit",
    target: profile,
    timeStamp: 3,
    preventDefault() { prevented = true; },
    stopPropagation() {},
    stopImmediatePropagation() {},
  });
  assert.equal(prevented, true);
  assert.equal(greeting.attributes.get("data-submitted"), "true");

  const loadedImage = document.created.find((node) => node.tagName === "IMG");
  assert.ok(loadedImage);
  loadedImage.naturalWidth = 2;
  loadedImage.naturalHeight = 2;
  loadedImage.onload();
  assert.equal(imageStatus.text, "Loaded image texture: 2x2");
  assert.ok(webgl.calls.some(([name, , , , , , source]) => name === "texImage2D" && source === loadedImage));
});

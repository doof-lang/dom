const encoder = new TextEncoder();
const decoder = new TextDecoder();

function defaultErrorHandler(error) {
  console.error(error);
}

function asError(value) {
  return value instanceof Error ? value : new Error(String(value));
}

function eventElement(value) {
  return value?.nodeType === 1 ? value : null;
}

function createDomBridge(document, onError) {
  let instance;
  let nextNodeId = 3;
  let nextEventId = 1;
  let nextContextId = 1;
  let nextWebGLResourceId = 1;
  const nodes = new Map();
  const events = new Map();
  const listeners = new Map();
  const imageLoads = new Map();
  const contexts = new Map();
  const webglResources = new Map();
  const browserWindow = document.defaultView ?? globalThis;

  nodes.set(0, browserWindow);
  nodes.set(1, document.head);
  nodes.set(2, document.body);

  const memoryBytes = () => new Uint8Array(instance.exports.memory.buffer);
  const readString = (pointer) => {
    const bytes = memoryBytes();
    let end = pointer;
    while (bytes[end] !== 0) end += 1;
    return decoder.decode(bytes.subarray(pointer, end));
  };
  const writeString = (value, output, capacity) => {
    if (value == null) return -1;
    const bytes = encoder.encode(String(value));
    if (output !== 0 && capacity > 0) {
      const length = Math.min(bytes.length, capacity - 1);
      memoryBytes().set(bytes.subarray(0, length), output);
      memoryBytes()[output + length] = 0;
    }
    return bytes.length;
  };
  const node = (id) => {
    const value = nodes.get(id);
    if (!value) throw new Error(`Unknown Doof DOM node handle ${id}`);
    return value;
  };
  const saveNode = (value) => {
    const id = nextNodeId++;
    nodes.set(id, value);
    return id;
  };
  const context = (id) => {
    const value = contexts.get(id)?.value;
    if (!value) throw new Error(`Unknown Doof canvas context handle ${id}`);
    return value;
  };
  const webglResource = (contextId, resourceId, kind) => {
    const registration = webglResources.get(resourceId);
    if (!registration || registration.contextId !== contextId || registration.kind !== kind) {
      throw new Error(`Unknown Doof WebGL ${kind} handle ${resourceId}`);
    }
    return registration.value;
  };
  const saveWebGLResource = (contextId, kind, value) => {
    if (!value) return 0;
    const resourceId = nextWebGLResourceId++;
    webglResources.set(resourceId, { contextId, kind, value });
    return resourceId;
  };

  const imports = {
    document_anchor(kind) {
      if (kind !== 0 && kind !== 1 && kind !== 2) throw new Error(`Unknown document anchor ${kind}`);
      return kind;
    },
    create_element(tagName) {
      return saveNode(document.createElement(readString(tagName)));
    },
    create_text(text) {
      return saveNode(document.createTextNode(readString(text)));
    },
    append_to(id, target) {
      node(target).appendChild(node(id));
    },
    insert_before(id, target) {
      node(target).before(node(id));
    },
    insert_after(id, target) {
      node(target).after(node(id));
    },
    replace(id, target) {
      node(target).replaceWith(node(id));
    },
    unmount(id) {
      node(id).remove();
    },
    destroy(id) {
      const value = nodes.get(id);
      if (!value) return;
      value.remove();
      nodes.delete(id);
      for (const [contextId, registration] of contexts) {
        if (registration.canvas === value) contexts.delete(contextId);
      }
      for (const [callbackId, registration] of listeners) {
        if (registration.node === value) {
          value.removeEventListener(registration.eventType, registration.listener);
          listeners.delete(callbackId);
        }
      }
    },
    set_text(id, text) {
      node(id).textContent = readString(text);
    },
    set_string(id, property, value) {
      const element = node(id);
      const text = readString(value);
      if (property === 0) element.id = text;
      else if (property === 1) element.className = text;
      else if (property === 2) element.value = text;
      else throw new Error(`Unknown DOM string property ${property}`);
    },
    set_bool(id, property, value) {
      const element = node(id);
      if (property === 0) element.disabled = value !== 0;
      else if (property === 1) element.checked = value !== 0;
      else throw new Error(`Unknown DOM boolean property ${property}`);
    },
    set_attribute(id, name, value) {
      node(id).setAttribute(readString(name), readString(value));
    },
    remove_attribute(id, name) {
      node(id).removeAttribute(readString(name));
    },
    focus(id) {
      node(id).focus();
    },
    blur(id) {
      node(id).blur();
    },
    element_number(id, property) {
      const value = node(id);
      const bounds = value.getBoundingClientRect?.() ?? { left: 0, top: 0 };
      const values = [value.width, value.height, value.clientWidth, value.clientHeight, browserWindow.devicePixelRatio, bounds.left, bounds.top];
      const result = values[property];
      return typeof result === "number" ? result : 0;
    },
    request_animation_frame(callbackId, dispatcher) {
      return browserWindow.requestAnimationFrame((timestamp) => {
        try {
          instance.exports.__indirect_function_table.get(dispatcher)(callbackId, timestamp);
        } catch (error) {
          onError(asError(error));
        }
      });
    },
    cancel_animation_frame(request) {
      browserWindow.cancelAnimationFrame(request);
    },
    load_image(urlPointer, crossOrigin, callbackId, dispatcher) {
      const image = document.createElement("img");
      const imageId = saveNode(image);
      if (crossOrigin === 1) image.crossOrigin = "anonymous";
      else if (crossOrigin === 2) image.crossOrigin = "use-credentials";
      image.decoding = "async";
      const finish = (succeeded) => {
        if (!imageLoads.has(imageId)) return;
        imageLoads.delete(imageId);
        image.onload = null;
        image.onerror = null;
        if (!succeeded) nodes.delete(imageId);
        try {
          const table = instance.exports.__indirect_function_table;
          if (!table || typeof table.get !== "function") {
            throw new Error("The Doof WASM function table was not exported");
          }
          table.get(dispatcher)(
            callbackId,
            succeeded ? imageId : 0,
            succeeded ? Number(image.naturalWidth || image.width || 0) : 0,
            succeeded ? Number(image.naturalHeight || image.height || 0) : 0,
            succeeded ? 1 : 0,
          );
        } catch (error) {
          onError(asError(error));
        }
      };
      image.onload = () => finish(true);
      image.onerror = () => finish(false);
      imageLoads.set(imageId, { image });
      image.src = readString(urlPointer);
      return imageId;
    },
    cancel_image(imageId) {
      const registration = imageLoads.get(imageId);
      if (!registration) return;
      imageLoads.delete(imageId);
      registration.image.onload = null;
      registration.image.onerror = null;
      registration.image.src = "";
      nodes.delete(imageId);
    },
    destroy_image(imageId) {
      const registration = imageLoads.get(imageId);
      if (registration) {
        imageLoads.delete(imageId);
        registration.image.onload = null;
        registration.image.onerror = null;
      }
      const image = nodes.get(imageId);
      if (image) image.src = "";
      nodes.delete(imageId);
    },
    gamepad_int(gamepad, field, item) {
      const pads = Array.from(browserWindow.navigator?.getGamepads?.() ?? []);
      if (field === 0) return pads.length;
      const pad = pads[gamepad] ?? null;
      if (field === 1) return pad?.connected ? 1 : 0;
      if (field === 2) return pad?.buttons?.[item]?.pressed ? 1 : 0;
      return 0;
    },
    gamepad_number(gamepad, field, item) {
      const pad = browserWindow.navigator?.getGamepads?.()?.[gamepad] ?? null;
      if (field === 0) return Number(pad?.buttons?.[item]?.value ?? 0);
      if (field === 1) return Number(pad?.axes?.[item] ?? 0);
      return 0;
    },
    gamepad_string(gamepad, field, output, capacity) {
      const pad = browserWindow.navigator?.getGamepads?.()?.[gamepad] ?? null;
      return writeString(field === 0 ? pad?.id ?? "" : "", output, capacity);
    },
    canvas_context_2d(id) {
      const canvas = node(id);
      const value = canvas.getContext?.("2d") ?? null;
      if (!value) return 0;
      const contextId = nextContextId++;
      contexts.set(contextId, { canvas, value });
      return contextId;
    },
    destroy_canvas_context(id) {
      contexts.delete(id);
    },
    canvas_action(id, action) {
      const value = context(id);
      const actions = ["save", "restore", "beginPath", "closePath", "fill", "stroke", "resetTransform"];
      const method = actions[action];
      if (!method) throw new Error(`Unknown canvas action ${action}`);
      value[method]();
    },
    canvas_numbers(id, operation, a, b, c, d, e, f) {
      const value = context(id);
      if (operation === 0) value.clearRect(a, b, c, d);
      else if (operation === 1) value.fillRect(a, b, c, d);
      else if (operation === 2) value.strokeRect(a, b, c, d);
      else if (operation === 3) value.moveTo(a, b);
      else if (operation === 4) value.lineTo(a, b);
      else if (operation === 5) value.rect(a, b, c, d);
      else if (operation === 6) value.arc(a, b, c, d, e, f !== 0);
      else if (operation === 7) value.translate(a, b);
      else if (operation === 8) value.scale(a, b);
      else if (operation === 9) value.rotate(a);
      else if (operation === 10) value.setTransform(a, b, c, d, e, f);
      else throw new Error(`Unknown canvas numeric operation ${operation}`);
    },
    canvas_set_string(id, property, text) {
      const value = context(id);
      const properties = [
        "fillStyle", "strokeStyle", "font", "textAlign", "textBaseline",
        "lineCap", "lineJoin", "globalCompositeOperation",
      ];
      const name = properties[property];
      if (!name) throw new Error(`Unknown canvas string property ${property}`);
      value[name] = readString(text);
    },
    canvas_set_number(id, property, number) {
      const value = context(id);
      const properties = ["lineWidth", "globalAlpha", "miterLimit", "lineDashOffset"];
      const name = properties[property];
      if (!name) throw new Error(`Unknown canvas numeric property ${property}`);
      value[name] = number;
    },
    canvas_text(id, operation, text, x, y, maxWidth) {
      const value = context(id);
      const method = operation === 0 ? "fillText" : operation === 1 ? "strokeText" : null;
      if (!method) throw new Error(`Unknown canvas text operation ${operation}`);
      const content = readString(text);
      if (Number.isNaN(maxWidth)) value[method](content, x, y);
      else value[method](content, x, y, maxWidth);
    },
    canvas_measure_text(id, text) {
      return context(id).measureText(readString(text)).width;
    },
    canvas_context_webgl(
      id, alpha, antialias, depth, stencil,
      premultipliedAlpha, preserveDrawingBuffer, powerPreference,
    ) {
      const canvas = node(id);
      const preferences = ["default", "low-power", "high-performance"];
      const value = canvas.getContext?.("webgl", {
        alpha: alpha !== 0,
        antialias: antialias !== 0,
        depth: depth !== 0,
        stencil: stencil !== 0,
        premultipliedAlpha: premultipliedAlpha !== 0,
        preserveDrawingBuffer: preserveDrawingBuffer !== 0,
        powerPreference: preferences[powerPreference] ?? "default",
      }) ?? null;
      if (!value) return 0;
      const contextId = nextContextId++;
      contexts.set(contextId, {
        canvas,
        value,
        instancing: value.getExtension?.("ANGLE_instanced_arrays") ?? null,
        unsignedIntIndices: value.getExtension?.("OES_element_index_uint") ?? null,
        depthTexture: value.getExtension?.("WEBGL_depth_texture") ?? null,
      });
      return contextId;
    },
    destroy_webgl_context(id) {
      const value = contexts.get(id)?.value;
      if (value) {
        for (const [resourceId, registration] of webglResources) {
          if (registration.contextId !== id) continue;
          if (registration.kind === "shader") value.deleteShader(registration.value);
          else if (registration.kind === "program") value.deleteProgram(registration.value);
          else if (registration.kind === "buffer") value.deleteBuffer(registration.value);
          else if (registration.kind === "texture") value.deleteTexture(registration.value);
          else if (registration.kind === "framebuffer") value.deleteFramebuffer(registration.value);
          else if (registration.kind === "renderbuffer") value.deleteRenderbuffer(registration.value);
          webglResources.delete(resourceId);
        }
      }
      contexts.delete(id);
    },
    webgl_create_resource(id, kind, option) {
      const value = context(id);
      if (kind === 0) return saveWebGLResource(id, "shader", value.createShader(option));
      if (kind === 1) return saveWebGLResource(id, "program", value.createProgram());
      if (kind === 2) return saveWebGLResource(id, "buffer", value.createBuffer());
      if (kind === 3) return saveWebGLResource(id, "texture", value.createTexture());
      if (kind === 4) return saveWebGLResource(id, "framebuffer", value.createFramebuffer());
      if (kind === 5) return saveWebGLResource(id, "renderbuffer", value.createRenderbuffer());
      throw new Error(`Unknown WebGL resource kind ${kind}`);
    },
    webgl_delete_resource(id, kind, resourceId) {
      const kinds = ["shader", "program", "buffer", "texture", "framebuffer", "renderbuffer"];
      const name = kinds[kind];
      const resource = webglResource(id, resourceId, name);
      const value = context(id);
      if (name === "shader") value.deleteShader(resource);
      else if (name === "program") value.deleteProgram(resource);
      else if (name === "buffer") value.deleteBuffer(resource);
      else if (name === "texture") value.deleteTexture(resource);
      else if (name === "framebuffer") value.deleteFramebuffer(resource);
      else value.deleteRenderbuffer(resource);
      webglResources.delete(resourceId);
    },
    webgl_operation(id, operation, primary, secondary, a, b, c, d, e, f) {
      const value = context(id);
      if (operation === 0) value.compileShader(webglResource(id, primary, "shader"));
      else if (operation === 1) return value.getShaderParameter(webglResource(id, primary, "shader"), value.COMPILE_STATUS) ? 1 : 0;
      else if (operation === 2) value.attachShader(webglResource(id, primary, "program"), webglResource(id, secondary, "shader"));
      else if (operation === 3) value.linkProgram(webglResource(id, primary, "program"));
      else if (operation === 4) return value.getProgramParameter(webglResource(id, primary, "program"), value.LINK_STATUS) ? 1 : 0;
      else if (operation === 5) value.useProgram(webglResource(id, primary, "program"));
      else if (operation === 6) value.bindBuffer(a, primary === 0 ? null : webglResource(id, primary, "buffer"));
      else if (operation === 7) value.enableVertexAttribArray(primary);
      else if (operation === 8) value.disableVertexAttribArray(primary);
      else if (operation === 9) value.vertexAttribPointer(primary, a, b, c !== 0, d, e);
      else if (operation === 10) value.viewport(a, b, c, d);
      else if (operation === 11) value.clearColor(a, b, c, d);
      else if (operation === 12) value.clearDepth(a);
      else if (operation === 13) value.clearStencil(a);
      else if (operation === 14) value.clear(a);
      else if (operation === 15) value.enable(a);
      else if (operation === 16) value.disable(a);
      else if (operation === 17) value.drawArrays(a, b, c);
      else if (operation === 18) value.drawElements(a, b, c, d);
      else if (operation === 19) value.flush();
      else if (operation === 20) value.finish();
      else if (operation === 21) value.activeTexture(value.TEXTURE0 + a);
      else if (operation === 22) value.bindTexture(a, primary === 0 ? null : webglResource(id, primary, "texture"));
      else if (operation === 23) value.texParameteri(a, b, c);
      else if (operation === 24) value.generateMipmap(a);
      else if (operation === 25) value.pixelStorei(a, b !== 0);
      else if (operation === 26) value.blendFunc(a, b);
      else if (operation === 27) value.blendEquation(a);
      else if (operation === 28) value.depthFunc(a);
      else if (operation === 29) value.depthMask(a !== 0);
      else if (operation === 30) value.colorMask(a !== 0, b !== 0, c !== 0, d !== 0);
      else if (operation === 31) value.cullFace(a);
      else if (operation === 32) value.frontFace(a);
      else if (operation === 33) value.scissor(a, b, c, d);
      else if (operation === 34) value.polygonOffset(a, b);
      else if (operation === 35) return contexts.get(id)?.instancing ? 1 : 0;
      else if (operation === 36) {
        const extension = contexts.get(id)?.instancing;
        if (!extension) return 0;
        extension.vertexAttribDivisorANGLE(primary, a);
        return 1;
      } else if (operation === 37) {
        const extension = contexts.get(id)?.instancing;
        if (!extension) return 0;
        extension.drawArraysInstancedANGLE(a, b, c, d);
        return 1;
      } else if (operation === 38) {
        const extension = contexts.get(id)?.instancing;
        if (!extension) return 0;
        extension.drawElementsInstancedANGLE(a, b, c, d, e);
        return 1;
      } else if (operation === 39) return contexts.get(id)?.unsignedIntIndices ? 1 : 0;
      else if (operation === 40) return value.getParameter(value.MAX_VERTEX_ATTRIBS);
      else if (operation === 41) return value.getParameter(value.MAX_TEXTURE_IMAGE_UNITS);
      else if (operation === 42) return contexts.get(id)?.depthTexture ? 1 : 0;
      else if (operation === 43) value.bindFramebuffer(a, primary === 0 ? null : webglResource(id, primary, "framebuffer"));
      else if (operation === 44) value.framebufferTexture2D(a, b, c, webglResource(id, primary, "texture"), 0);
      else if (operation === 45) return value.checkFramebufferStatus(a);
      else if (operation === 46) value.bindRenderbuffer(a, primary === 0 ? null : webglResource(id, primary, "renderbuffer"));
      else if (operation === 47) value.renderbufferStorage(a, b, c, d);
      else if (operation === 48) value.framebufferRenderbuffer(a, b, c, webglResource(id, primary, "renderbuffer"));
      else throw new Error(`Unknown WebGL operation ${operation}`);
      return 0;
    },
    webgl_string_operation(id, operation, primary, text, a, b, c, d) {
      const value = context(id);
      const content = readString(text);
      if (operation === 0) {
        value.shaderSource(webglResource(id, primary, "shader"), content);
        return 1;
      }
      const program = webglResource(id, primary, "program");
      if (operation === 1) return value.getAttribLocation(program, content);
      const location = value.getUniformLocation(program, content);
      if (location == null) return 0;
      if (operation === 2) value.uniform1f(location, a);
      else if (operation === 3) value.uniform2f(location, a, b);
      else if (operation === 4) value.uniform3f(location, a, b, c);
      else if (operation === 5) value.uniform4f(location, a, b, c, d);
      else if (operation === 6) value.uniform1i(location, a);
      else throw new Error(`Unknown WebGL string operation ${operation}`);
      return 1;
    },
    webgl_resource_log(id, kind, resourceId, output, capacity) {
      const value = context(id);
      const name = kind === 0 ? "shader" : kind === 1 ? "program" : null;
      if (!name) return -1;
      const resource = webglResource(id, resourceId, name);
      const log = name === "shader" ? value.getShaderInfoLog(resource) : value.getProgramInfoLog(resource);
      return writeString(log ?? "", output, capacity);
    },
    webgl_buffer_data_f64(id, target, pointer, count, usage) {
      const source = new Float64Array(instance.exports.memory.buffer, pointer, count);
      context(id).bufferData(target, Float32Array.from(source), usage);
    },
    webgl_buffer_data_u16(id, target, pointer, count, usage) {
      const source = new Uint16Array(instance.exports.memory.buffer, pointer, count);
      context(id).bufferData(target, Uint16Array.from(source), usage);
    },
    webgl_buffer_data_u32(id, target, pointer, count, usage) {
      const source = new Uint32Array(instance.exports.memory.buffer, pointer, count);
      context(id).bufferData(target, Uint32Array.from(source), usage);
    },
    webgl_buffer_data_u8(id, target, pointer, count, usage) {
      const source = new Uint8Array(instance.exports.memory.buffer, pointer, count);
      context(id).bufferData(target, Uint8Array.from(source), usage);
    },
    webgl_uniform_matrix4(id, programId, name, transpose, pointer, count) {
      const value = context(id);
      const program = webglResource(id, programId, "program");
      const location = value.getUniformLocation(program, readString(name));
      if (location == null) return 0;
      const source = new Float64Array(instance.exports.memory.buffer, pointer, count);
      value.uniformMatrix4fv(location, transpose !== 0, Float32Array.from(source));
      return 1;
    },
    webgl_texture_rgba(id, target, width, height, pointer, count) {
      const pixels = new Uint8Array(instance.exports.memory.buffer, pointer, count);
      context(id).texImage2D(target, 0, 6408, width, height, 0, 6408, 5121, pixels);
    },
    webgl_texture_depth(id, target, width, height) {
      context(id).texImage2D(target, 0, 6402, width, height, 0, 6402, 5123, null);
    },
    webgl_texture_image(id, target, imageId) {
      context(id).texImage2D(target, 0, 6408, 6408, 5121, node(imageId));
    },
    add_event(id, eventTypePointer, callbackId, dispatcher) {
      const element = node(id);
      const eventType = readString(eventTypePointer);
      const listener = (event) => {
        const eventId = nextEventId++;
        events.set(eventId, event);
        try {
          const table = instance.exports.__indirect_function_table;
          if (!table || typeof table.get !== "function") {
            throw new Error("The Doof WASM function table was not exported");
          }
          const flags = table.get(dispatcher)(callbackId, eventId);
          if ((flags & 1) !== 0) event.preventDefault();
          if ((flags & 2) !== 0) event.stopPropagation();
          if ((flags & 4) !== 0) event.stopImmediatePropagation();
        } catch (error) {
          onError(asError(error));
        } finally {
          events.delete(eventId);
        }
      };
      element.addEventListener(eventType, listener);
      listeners.set(callbackId, { node: element, eventType, listener });
    },
    remove_event(id, eventTypePointer, callbackId) {
      const registration = listeners.get(callbackId);
      if (!registration) return;
      const eventType = readString(eventTypePointer);
      node(id).removeEventListener(eventType, registration.listener);
      listeners.delete(callbackId);
    },
    event_string(id, field, output, capacity) {
      const event = events.get(id);
      if (!event) return -1;
      const target = eventElement(event.target);
      const currentTarget = eventElement(event.currentTarget);
      const value = [
        event.type,
        target?.tagName.toLowerCase(),
        target?.id || null,
        currentTarget?.tagName.toLowerCase(),
        currentTarget?.id || null,
        typeof event.key === "string" ? event.key : null,
        typeof event.code === "string" ? event.code : null,
        typeof currentTarget?.value === "string" ? currentTarget.value : null,
      ][field];
      return writeString(value, output, capacity);
    },
    event_number(id, field) {
      const event = events.get(id);
      if (!event) return NaN;
      const value = [
        event.timeStamp, event.clientX, event.clientY,
        event.deltaX, event.deltaY, event.movementX, event.movementY,
      ][field];
      return typeof value === "number" ? value : NaN;
    },
    event_int(id, field) {
      const event = events.get(id);
      if (!event) return -2147483648;
      if (field === 0 && typeof event.button === "number") return event.button;
      const currentTarget = eventElement(event.currentTarget);
      if (field === 1 && typeof currentTarget?.checked === "boolean") return currentTarget.checked ? 1 : 0;
      if (field === 2 && typeof event.buttons === "number") return event.buttons;
      if (field === 3 && typeof event.pointerId === "number") return event.pointerId;
      return -2147483648;
    },
    event_bool(id, field) {
      const event = events.get(id);
      if (!event) return 0;
      return [event.altKey, event.ctrlKey, event.metaKey, event.shiftKey, event.repeat][field] ? 1 : 0;
    },
    report_error(message) {
      onError(new Error(readString(message)));
    },
  };

  const wasi = {
    fd_close() { return 0; },
    environ_sizes_get(countPointer, sizePointer) {
      const view = new DataView(instance.exports.memory.buffer);
      view.setUint32(countPointer, 0, true);
      view.setUint32(sizePointer, 0, true);
      return 0;
    },
    environ_get() { return 0; },
  };

  return {
    imports,
    wasi,
    attach(value) { instance = value; },
  };
}

async function instantiate(source, imports) {
  if (source instanceof WebAssembly.Module) {
    return { instance: await WebAssembly.instantiate(source, imports) };
  }
  if (source instanceof ArrayBuffer || ArrayBuffer.isView(source)) {
    return WebAssembly.instantiate(source, imports);
  }
  const response = source instanceof Response ? source : await fetch(source);
  if (!response.ok) throw new Error(`Could not load WASM: ${response.status} ${response.statusText}`);
  try {
    return await WebAssembly.instantiateStreaming(response.clone(), imports);
  } catch {
    return WebAssembly.instantiate(await response.arrayBuffer(), imports);
  }
}

export async function loadDoofDom(source, options = {}) {
  const onError = options.onError ?? defaultErrorHandler;
  const document = options.document ?? globalThis.document;
  if (!document?.head || !document?.body) throw new Error("loadDoofDom requires a browser document");

  const bridge = createDomBridge(document, onError);
  const supplied = options.imports ?? {};
  const imports = {
    ...supplied,
    doof_dom: { ...(supplied.doof_dom ?? {}), ...bridge.imports },
    wasi_snapshot_preview1: {
      ...(supplied.wasi_snapshot_preview1 ?? {}),
      ...bridge.wasi,
    },
  };
  const result = await instantiate(source, imports);
  const instance = result.instance ?? result;
  bridge.attach(instance);

  const exports = instance.exports;
  const readCString = (pointer) => {
    const bytes = new Uint8Array(exports.memory.buffer);
    let end = pointer;
    while (bytes[end] !== 0) end += 1;
    return decoder.decode(bytes.subarray(pointer, end));
  };
  const readEnvelope = (pointer) => {
    if (!pointer) throw new Error("Doof WASM returned a null response pointer");
    try {
      const envelope = JSON.parse(readCString(pointer));
      if (!envelope.ok) throw new Error(typeof envelope.error === "string" ? envelope.error : JSON.stringify(envelope.error));
      return envelope.value;
    } finally {
      exports.doof_free(pointer);
    }
  };

  if (typeof exports._initialize === "function") exports._initialize();
  readEnvelope(exports.doof_initialize());

  return {
    instance,
    call(name, params = {}) {
      const callable = exports[`doof_export_${name}`];
      if (typeof callable !== "function") throw new Error(`Doof WASM does not export '${name}'`);
      const bytes = encoder.encode(JSON.stringify(params));
      const pointer = exports.malloc(bytes.length + 1);
      const memory = new Uint8Array(exports.memory.buffer);
      memory.set(bytes, pointer);
      memory[pointer + bytes.length] = 0;
      try {
        return readEnvelope(callable(pointer));
      } finally {
        exports.free(pointer);
      }
    },
  };
}

export { createDomBridge };

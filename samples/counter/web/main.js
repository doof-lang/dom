import { loadDoofDom } from "../std/dom/doof-dom.js";

const app = await loadDoofDom("../std-dom-counter-sample.wasm");
app.call("start");

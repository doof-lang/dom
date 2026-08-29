#pragma once

#include "doof_runtime.hpp"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <limits>
#include <memory>
#include <optional>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#if defined(__EMSCRIPTEN__)
extern "C" {
__attribute__((import_module("doof_dom"), import_name("document_anchor")))
int32_t doof_dom_document_anchor(int32_t kind);
__attribute__((import_module("doof_dom"), import_name("create_element")))
int32_t doof_dom_create_element(const char* tag_name);
__attribute__((import_module("doof_dom"), import_name("create_text")))
int32_t doof_dom_create_text(const char* text);
__attribute__((import_module("doof_dom"), import_name("append_to")))
void doof_dom_append_to(int32_t node, int32_t target);
__attribute__((import_module("doof_dom"), import_name("insert_before")))
void doof_dom_insert_before(int32_t node, int32_t target);
__attribute__((import_module("doof_dom"), import_name("insert_after")))
void doof_dom_insert_after(int32_t node, int32_t target);
__attribute__((import_module("doof_dom"), import_name("replace")))
void doof_dom_replace(int32_t node, int32_t target);
__attribute__((import_module("doof_dom"), import_name("unmount")))
void doof_dom_unmount(int32_t node);
__attribute__((import_module("doof_dom"), import_name("destroy")))
void doof_dom_destroy(int32_t node);
__attribute__((import_module("doof_dom"), import_name("set_text")))
void doof_dom_set_text(int32_t node, const char* text);
__attribute__((import_module("doof_dom"), import_name("set_string")))
void doof_dom_set_string(int32_t node, int32_t property, const char* value);
__attribute__((import_module("doof_dom"), import_name("set_bool")))
void doof_dom_set_bool(int32_t node, int32_t property, int32_t value);
__attribute__((import_module("doof_dom"), import_name("set_attribute")))
void doof_dom_set_attribute(int32_t node, const char* name, const char* value);
__attribute__((import_module("doof_dom"), import_name("remove_attribute")))
void doof_dom_remove_attribute(int32_t node, const char* name);
__attribute__((import_module("doof_dom"), import_name("focus")))
void doof_dom_focus(int32_t node);
__attribute__((import_module("doof_dom"), import_name("blur")))
void doof_dom_blur(int32_t node);
__attribute__((import_module("doof_dom"), import_name("element_number")))
double doof_dom_element_number(int32_t node, int32_t property);
__attribute__((import_module("doof_dom"), import_name("request_animation_frame")))
int32_t doof_dom_request_animation_frame(int32_t callback_id, int32_t dispatcher);
__attribute__((import_module("doof_dom"), import_name("cancel_animation_frame")))
void doof_dom_cancel_animation_frame(int32_t request);
__attribute__((import_module("doof_dom"), import_name("load_image")))
int32_t doof_dom_load_image(const char* url, int32_t cross_origin, int32_t callback_id, int32_t dispatcher);
__attribute__((import_module("doof_dom"), import_name("cancel_image")))
void doof_dom_cancel_image(int32_t image);
__attribute__((import_module("doof_dom"), import_name("destroy_image")))
void doof_dom_destroy_image(int32_t image);
__attribute__((import_module("doof_dom"), import_name("gamepad_int")))
int32_t doof_dom_gamepad_int(int32_t gamepad, int32_t field, int32_t item);
__attribute__((import_module("doof_dom"), import_name("gamepad_number")))
double doof_dom_gamepad_number(int32_t gamepad, int32_t field, int32_t item);
__attribute__((import_module("doof_dom"), import_name("gamepad_string")))
int32_t doof_dom_gamepad_string(int32_t gamepad, int32_t field, char* output, int32_t capacity);
__attribute__((import_module("doof_dom"), import_name("canvas_context_2d")))
int32_t doof_dom_canvas_context_2d(int32_t node);
__attribute__((import_module("doof_dom"), import_name("destroy_canvas_context")))
void doof_dom_destroy_canvas_context(int32_t context);
__attribute__((import_module("doof_dom"), import_name("canvas_action")))
void doof_dom_canvas_action(int32_t context, int32_t action);
__attribute__((import_module("doof_dom"), import_name("canvas_numbers")))
void doof_dom_canvas_numbers(int32_t context, int32_t operation, double a, double b, double c, double d, double e, double f);
__attribute__((import_module("doof_dom"), import_name("canvas_set_string")))
void doof_dom_canvas_set_string(int32_t context, int32_t property, const char* value);
__attribute__((import_module("doof_dom"), import_name("canvas_set_number")))
void doof_dom_canvas_set_number(int32_t context, int32_t property, double value);
__attribute__((import_module("doof_dom"), import_name("canvas_text")))
void doof_dom_canvas_text(int32_t context, int32_t operation, const char* text, double x, double y, double max_width);
__attribute__((import_module("doof_dom"), import_name("canvas_measure_text")))
double doof_dom_canvas_measure_text(int32_t context, const char* text);
__attribute__((import_module("doof_dom"), import_name("canvas_context_webgl")))
int32_t doof_dom_canvas_context_webgl(
    int32_t node, int32_t alpha, int32_t antialias, int32_t depth, int32_t stencil,
    int32_t premultiplied_alpha, int32_t preserve_drawing_buffer, int32_t power_preference
);
__attribute__((import_module("doof_dom"), import_name("destroy_webgl_context")))
void doof_dom_destroy_webgl_context(int32_t context);
__attribute__((import_module("doof_dom"), import_name("webgl_create_resource")))
int32_t doof_dom_webgl_create_resource(int32_t context, int32_t kind, int32_t option);
__attribute__((import_module("doof_dom"), import_name("webgl_delete_resource")))
void doof_dom_webgl_delete_resource(int32_t context, int32_t kind, int32_t resource);
__attribute__((import_module("doof_dom"), import_name("webgl_operation")))
int32_t doof_dom_webgl_operation(
    int32_t context, int32_t operation, int32_t primary, int32_t secondary,
    double a, double b, double c, double d, double e, double f
);
__attribute__((import_module("doof_dom"), import_name("webgl_string_operation")))
int32_t doof_dom_webgl_string_operation(
    int32_t context, int32_t operation, int32_t primary, const char* text,
    double a, double b, double c, double d
);
__attribute__((import_module("doof_dom"), import_name("webgl_resource_log")))
int32_t doof_dom_webgl_resource_log(
    int32_t context, int32_t kind, int32_t resource, char* output, int32_t capacity
);
__attribute__((import_module("doof_dom"), import_name("webgl_buffer_data_f64")))
void doof_dom_webgl_buffer_data_f64(
    int32_t context, int32_t target, const double* values, int32_t count, int32_t usage
);
__attribute__((import_module("doof_dom"), import_name("webgl_buffer_data_u16")))
void doof_dom_webgl_buffer_data_u16(
    int32_t context, int32_t target, const uint16_t* values, int32_t count, int32_t usage
);
__attribute__((import_module("doof_dom"), import_name("webgl_buffer_data_u32")))
void doof_dom_webgl_buffer_data_u32(
    int32_t context, int32_t target, const uint32_t* values, int32_t count, int32_t usage
);
__attribute__((import_module("doof_dom"), import_name("webgl_buffer_data_u8")))
void doof_dom_webgl_buffer_data_u8(
    int32_t context, int32_t target, const uint8_t* values, int32_t count, int32_t usage
);
__attribute__((import_module("doof_dom"), import_name("webgl_uniform_matrix4")))
int32_t doof_dom_webgl_uniform_matrix4(
    int32_t context, int32_t program, const char* name, int32_t transpose,
    const double* values, int32_t count
);
__attribute__((import_module("doof_dom"), import_name("webgl_texture_rgba")))
void doof_dom_webgl_texture_rgba(
    int32_t context, int32_t target, int32_t width, int32_t height,
    const uint8_t* pixels, int32_t count
);
__attribute__((import_module("doof_dom"), import_name("webgl_texture_depth")))
void doof_dom_webgl_texture_depth(
    int32_t context, int32_t target, int32_t width, int32_t height
);
__attribute__((import_module("doof_dom"), import_name("webgl_texture_image")))
void doof_dom_webgl_texture_image(int32_t context, int32_t target, int32_t image);
__attribute__((import_module("doof_dom"), import_name("add_event")))
void doof_dom_add_event(int32_t node, const char* event_type, int32_t callback_id, int32_t dispatcher);
__attribute__((import_module("doof_dom"), import_name("remove_event")))
void doof_dom_remove_event(int32_t node, const char* event_type, int32_t callback_id);
__attribute__((import_module("doof_dom"), import_name("event_string")))
int32_t doof_dom_event_string(int32_t event, int32_t field, char* output, int32_t capacity);
__attribute__((import_module("doof_dom"), import_name("event_number")))
double doof_dom_event_number(int32_t event, int32_t field);
__attribute__((import_module("doof_dom"), import_name("event_int")))
int32_t doof_dom_event_int(int32_t event, int32_t field);
__attribute__((import_module("doof_dom"), import_name("event_bool")))
int32_t doof_dom_event_bool(int32_t event, int32_t field);
__attribute__((import_module("doof_dom"), import_name("report_error")))
void doof_dom_report_error(const char* message);
}
#endif

namespace doof_dom {

namespace detail {

inline int32_t nextNativeHandle() {
    static int32_t next = 3;
    return next++;
}

inline int32_t documentAnchor(int32_t kind) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_document_anchor(kind);
#else
    return kind;
#endif
}

inline int32_t createElement(const std::string& tagName) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_create_element(tagName.c_str());
#else
    (void)tagName;
    return nextNativeHandle();
#endif
}

inline int32_t createText(const std::string& text) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_create_text(text.c_str());
#else
    (void)text;
    return nextNativeHandle();
#endif
}

inline void appendTo(int32_t node, int32_t target) {
#if defined(__EMSCRIPTEN__)
    doof_dom_append_to(node, target);
#else
    (void)node; (void)target;
#endif
}

inline void insertBefore(int32_t node, int32_t target) {
#if defined(__EMSCRIPTEN__)
    doof_dom_insert_before(node, target);
#else
    (void)node; (void)target;
#endif
}

inline void insertAfter(int32_t node, int32_t target) {
#if defined(__EMSCRIPTEN__)
    doof_dom_insert_after(node, target);
#else
    (void)node; (void)target;
#endif
}

inline void replace(int32_t node, int32_t target) {
#if defined(__EMSCRIPTEN__)
    doof_dom_replace(node, target);
#else
    (void)node; (void)target;
#endif
}

inline void unmount(int32_t node) {
#if defined(__EMSCRIPTEN__)
    doof_dom_unmount(node);
#else
    (void)node;
#endif
}

inline void destroy(int32_t node, bool borrowed) {
#if defined(__EMSCRIPTEN__)
    if (!borrowed) doof_dom_destroy(node);
#else
    (void)node; (void)borrowed;
#endif
}

inline void setText(int32_t node, const std::string& text) {
#if defined(__EMSCRIPTEN__)
    doof_dom_set_text(node, text.c_str());
#else
    (void)node; (void)text;
#endif
}

inline void setString(int32_t node, int32_t property, const std::string& value) {
#if defined(__EMSCRIPTEN__)
    doof_dom_set_string(node, property, value.c_str());
#else
    (void)node; (void)property; (void)value;
#endif
}

inline void setBool(int32_t node, int32_t property, bool value) {
#if defined(__EMSCRIPTEN__)
    doof_dom_set_bool(node, property, value ? 1 : 0);
#else
    (void)node; (void)property; (void)value;
#endif
}

inline void setAttribute(int32_t node, const std::string& name, const std::string& value) {
#if defined(__EMSCRIPTEN__)
    doof_dom_set_attribute(node, name.c_str(), value.c_str());
#else
    (void)node; (void)name; (void)value;
#endif
}

inline void removeAttribute(int32_t node, const std::string& name) {
#if defined(__EMSCRIPTEN__)
    doof_dom_remove_attribute(node, name.c_str());
#else
    (void)node; (void)name;
#endif
}

inline void focus(int32_t node) {
#if defined(__EMSCRIPTEN__)
    doof_dom_focus(node);
#else
    (void)node;
#endif
}

inline void blur(int32_t node) {
#if defined(__EMSCRIPTEN__)
    doof_dom_blur(node);
#else
    (void)node;
#endif
}

inline int32_t canvasContext2d(int32_t node) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_canvas_context_2d(node);
#else
    (void)node;
    return nextNativeHandle();
#endif
}

inline void destroyCanvasContext(int32_t context) {
#if defined(__EMSCRIPTEN__)
    doof_dom_destroy_canvas_context(context);
#else
    (void)context;
#endif
}

inline void canvasAction(int32_t context, int32_t action) {
#if defined(__EMSCRIPTEN__)
    doof_dom_canvas_action(context, action);
#else
    (void)context; (void)action;
#endif
}

inline void canvasNumbers(
    int32_t context, int32_t operation,
    double a = 0.0, double b = 0.0, double c = 0.0,
    double d = 0.0, double e = 0.0, double f = 0.0
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_canvas_numbers(context, operation, a, b, c, d, e, f);
#else
    (void)context; (void)operation; (void)a; (void)b; (void)c; (void)d; (void)e; (void)f;
#endif
}

inline void canvasSetString(int32_t context, int32_t property, const std::string& value) {
#if defined(__EMSCRIPTEN__)
    doof_dom_canvas_set_string(context, property, value.c_str());
#else
    (void)context; (void)property; (void)value;
#endif
}

inline void canvasSetNumber(int32_t context, int32_t property, double value) {
#if defined(__EMSCRIPTEN__)
    doof_dom_canvas_set_number(context, property, value);
#else
    (void)context; (void)property; (void)value;
#endif
}

inline void canvasText(
    int32_t context, int32_t operation, const std::string& text,
    double x, double y, const std::optional<double>& maxWidth
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_canvas_text(
        context, operation, text.c_str(), x, y,
        maxWidth.value_or(std::numeric_limits<double>::quiet_NaN())
    );
#else
    (void)context; (void)operation; (void)text; (void)x; (void)y; (void)maxWidth;
#endif
}

inline double canvasMeasureText(int32_t context, const std::string& text) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_canvas_measure_text(context, text.c_str());
#else
    (void)context;
    return static_cast<double>(text.size());
#endif
}

inline int32_t webglContext(
    int32_t node, bool alpha, bool antialias, bool depth, bool stencil,
    bool premultipliedAlpha, bool preserveDrawingBuffer, int32_t powerPreference
) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_canvas_context_webgl(
        node, alpha ? 1 : 0, antialias ? 1 : 0, depth ? 1 : 0, stencil ? 1 : 0,
        premultipliedAlpha ? 1 : 0, preserveDrawingBuffer ? 1 : 0, powerPreference
    );
#else
    (void)node; (void)alpha; (void)antialias; (void)depth; (void)stencil;
    (void)premultipliedAlpha; (void)preserveDrawingBuffer; (void)powerPreference;
    return nextNativeHandle();
#endif
}

inline void destroyWebglContext(int32_t context) {
#if defined(__EMSCRIPTEN__)
    doof_dom_destroy_webgl_context(context);
#else
    (void)context;
#endif
}

inline int32_t webglCreateResource(int32_t context, int32_t kind, int32_t option = 0) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_webgl_create_resource(context, kind, option);
#else
    (void)context; (void)kind; (void)option;
    return nextNativeHandle();
#endif
}

inline void webglDeleteResource(int32_t context, int32_t kind, int32_t resource) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_delete_resource(context, kind, resource);
#else
    (void)context; (void)kind; (void)resource;
#endif
}

inline int32_t webglOperation(
    int32_t context, int32_t operation, int32_t primary = 0, int32_t secondary = 0,
    double a = 0.0, double b = 0.0, double c = 0.0,
    double d = 0.0, double e = 0.0, double f = 0.0
) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_webgl_operation(context, operation, primary, secondary, a, b, c, d, e, f);
#else
    (void)context; (void)primary; (void)secondary;
    (void)a; (void)b; (void)c; (void)d; (void)e; (void)f;
    if (operation == 40 || operation == 41) return 16;
    if (operation == 45) return 36053;
    return operation == 1 || operation == 4 || operation == 42 || (operation >= 35 && operation <= 39) ? 1 : 0;
#endif
}

inline int32_t webglStringOperation(
    int32_t context, int32_t operation, int32_t primary, const std::string& text,
    double a = 0.0, double b = 0.0, double c = 0.0, double d = 0.0
) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_webgl_string_operation(
        context, operation, primary, text.c_str(), a, b, c, d
    );
#else
    (void)context; (void)primary; (void)text; (void)a; (void)b; (void)c; (void)d;
    return operation == 1 ? 0 : 1;
#endif
}

inline std::string webglResourceLog(int32_t context, int32_t kind, int32_t resource) {
#if defined(__EMSCRIPTEN__)
    const int32_t length = doof_dom_webgl_resource_log(context, kind, resource, nullptr, 0);
    if (length <= 0) return "";
    std::vector<char> value(static_cast<std::size_t>(length) + 1, '\0');
    const int32_t written = doof_dom_webgl_resource_log(
        context, kind, resource, value.data(), length + 1
    );
    return written < 0 ? "" : std::string(value.data(), static_cast<std::size_t>(written));
#else
    (void)context; (void)kind; (void)resource;
    return "";
#endif
}

inline void webglBufferData(
    int32_t context, int32_t target,
    const std::shared_ptr<std::vector<double>>& values, int32_t usage
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_buffer_data_f64(
        context, target, values->data(), static_cast<int32_t>(values->size()), usage
    );
#else
    (void)context; (void)target; (void)values; (void)usage;
#endif
}

inline void webglBufferDataUnsignedShort(
    int32_t context, int32_t target,
    const std::shared_ptr<std::vector<int32_t>>& values, int32_t usage
) {
    std::vector<uint16_t> narrowed;
    narrowed.reserve(values->size());
    for (const auto value : *values) {
        if (value < 0 || value > 65535) doof::panic("WebGL unsigned-short buffer values must be between 0 and 65535");
        narrowed.push_back(static_cast<uint16_t>(value));
    }
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_buffer_data_u16(
        context, target, narrowed.data(), static_cast<int32_t>(narrowed.size()), usage
    );
#else
    (void)context; (void)target; (void)usage;
#endif
}

inline void webglBufferDataUnsignedInt(
    int32_t context, int32_t target,
    const std::shared_ptr<std::vector<int32_t>>& values, int32_t usage
) {
    std::vector<uint32_t> widened;
    widened.reserve(values->size());
    for (const auto value : *values) {
        if (value < 0) doof::panic("WebGL unsigned-int buffer values must be non-negative");
        widened.push_back(static_cast<uint32_t>(value));
    }
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_buffer_data_u32(
        context, target, widened.data(), static_cast<int32_t>(widened.size()), usage
    );
#else
    (void)context; (void)target; (void)usage;
#endif
}

inline void webglBufferDataBytes(
    int32_t context, int32_t target,
    const std::shared_ptr<std::vector<uint8_t>>& values, int32_t usage
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_buffer_data_u8(
        context, target, values->data(), static_cast<int32_t>(values->size()), usage
    );
#else
    (void)context; (void)target; (void)values; (void)usage;
#endif
}

inline bool webglUniformMatrix4(
    int32_t context, int32_t program, const std::string& name, bool transpose,
    const std::shared_ptr<std::vector<double>>& values
) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_webgl_uniform_matrix4(
        context, program, name.c_str(), transpose ? 1 : 0,
        values->data(), static_cast<int32_t>(values->size())
    ) != 0;
#else
    (void)context; (void)program; (void)name; (void)transpose; (void)values;
    return true;
#endif
}

inline void webglTextureRgba(
    int32_t context, int32_t target, int32_t width, int32_t height,
    const std::shared_ptr<std::vector<uint8_t>>& pixels
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_texture_rgba(
        context, target, width, height, pixels->data(), static_cast<int32_t>(pixels->size())
    );
#else
    (void)context; (void)target; (void)width; (void)height; (void)pixels;
#endif
}

inline void webglTextureDepth(
    int32_t context, int32_t target, int32_t width, int32_t height
) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_texture_depth(context, target, width, height);
#else
    (void)context; (void)target; (void)width; (void)height;
#endif
}

inline void webglTextureImage(int32_t context, int32_t target, int32_t image) {
#if defined(__EMSCRIPTEN__)
    doof_dom_webgl_texture_image(context, target, image);
#else
    (void)context; (void)target; (void)image;
#endif
}

inline std::optional<std::string> eventString(int32_t event, int32_t field) {
#if defined(__EMSCRIPTEN__)
    const int32_t length = doof_dom_event_string(event, field, nullptr, 0);
    if (length < 0) return std::nullopt;
    std::vector<char> value(static_cast<std::size_t>(length) + 1, '\0');
    const int32_t written = doof_dom_event_string(event, field, value.data(), length + 1);
    if (written < 0) return std::nullopt;
    return std::string(value.data(), static_cast<std::size_t>(written));
#else
    (void)event; (void)field;
    return std::nullopt;
#endif
}

inline std::optional<double> eventNumber(int32_t event, int32_t field) {
#if defined(__EMSCRIPTEN__)
    const double value = doof_dom_event_number(event, field);
    return std::isnan(value) ? std::nullopt : std::optional<double>(value);
#else
    (void)event; (void)field;
    return std::nullopt;
#endif
}

inline std::optional<int32_t> eventInt(int32_t event, int32_t field) {
#if defined(__EMSCRIPTEN__)
    const int32_t value = doof_dom_event_int(event, field);
    return value == std::numeric_limits<int32_t>::min() ? std::nullopt : std::optional<int32_t>(value);
#else
    (void)event; (void)field;
    return std::nullopt;
#endif
}

inline bool eventBool(int32_t event, int32_t field) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_event_bool(event, field) != 0;
#else
    (void)event; (void)field;
    return false;
#endif
}

inline void reportError(const std::string& message) {
#if defined(__EMSCRIPTEN__)
    doof_dom_report_error(message.c_str());
#else
    (void)message;
#endif
}

inline double elementNumber(int32_t node, int32_t property) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_element_number(node, property);
#else
    (void)node; (void)property;
    return property == 4 ? 1.0 : 0.0;
#endif
}

inline void destroyImage(int32_t image) {
#if defined(__EMSCRIPTEN__)
    doof_dom_destroy_image(image);
#else
    (void)image;
#endif
}

}  // namespace detail

class NativeDomEvent {
public:
    explicit NativeDomEvent(int32_t event)
        : type_(detail::eventString(event, 0).value_or("click")),
          timeStamp_(detail::eventNumber(event, 0).value_or(0.0)),
          targetTagName_(detail::eventString(event, 1).value_or("")),
          targetId_(detail::eventString(event, 2)),
          currentTargetTagName_(detail::eventString(event, 3).value_or("")),
          currentTargetId_(detail::eventString(event, 4)),
          clientX_(detail::eventNumber(event, 1)),
          clientY_(detail::eventNumber(event, 2)),
          deltaX_(detail::eventNumber(event, 3)),
          deltaY_(detail::eventNumber(event, 4)),
          movementX_(detail::eventNumber(event, 5)),
          movementY_(detail::eventNumber(event, 6)),
          button_(detail::eventInt(event, 0)),
          buttons_(detail::eventInt(event, 2)),
          pointerId_(detail::eventInt(event, 3)),
          value_(detail::eventString(event, 7)),
          checked_([event]() -> std::optional<bool> {
              const auto value = detail::eventInt(event, 1);
              return value.has_value() ? std::optional<bool>(*value != 0) : std::nullopt;
          }()),
          key_(detail::eventString(event, 5)),
          code_(detail::eventString(event, 6)),
          altKey_(detail::eventBool(event, 0)),
          ctrlKey_(detail::eventBool(event, 1)),
          metaKey_(detail::eventBool(event, 2)),
          shiftKey_(detail::eventBool(event, 3)),
          repeat_(detail::eventBool(event, 4)) {}

    std::string eventType() const { return type_; }
    double timeStamp() const { return timeStamp_; }
    std::string targetTagName() const { return targetTagName_; }
    std::optional<std::string> targetId() const { return targetId_; }
    std::string currentTargetTagName() const { return currentTargetTagName_; }
    std::optional<std::string> currentTargetId() const { return currentTargetId_; }
    std::optional<double> clientX() const { return clientX_; }
    std::optional<double> clientY() const { return clientY_; }
    std::optional<double> deltaX() const { return deltaX_; }
    std::optional<double> deltaY() const { return deltaY_; }
    std::optional<double> movementX() const { return movementX_; }
    std::optional<double> movementY() const { return movementY_; }
    std::optional<int32_t> button() const { return button_; }
    std::optional<int32_t> buttons() const { return buttons_; }
    std::optional<int32_t> pointerId() const { return pointerId_; }
    std::optional<std::string> value() const { return value_; }
    std::optional<bool> checked() const { return checked_; }
    std::optional<std::string> key() const { return key_; }
    std::optional<std::string> code() const { return code_; }
    bool altKey() const { return altKey_; }
    bool ctrlKey() const { return ctrlKey_; }
    bool metaKey() const { return metaKey_; }
    bool shiftKey() const { return shiftKey_; }
    bool repeat() const { return repeat_; }
    void preventDefault() { flags_ |= 1; }
    void stopPropagation() { flags_ |= 2; }
    void stopImmediatePropagation() { flags_ |= 4; }
    int32_t flags() const { return flags_; }

private:
    std::string type_;
    double timeStamp_;
    std::string targetTagName_;
    std::optional<std::string> targetId_;
    std::string currentTargetTagName_;
    std::optional<std::string> currentTargetId_;
    std::optional<double> clientX_;
    std::optional<double> clientY_;
    std::optional<double> deltaX_;
    std::optional<double> deltaY_;
    std::optional<double> movementX_;
    std::optional<double> movementY_;
    std::optional<int32_t> button_;
    std::optional<int32_t> buttons_;
    std::optional<int32_t> pointerId_;
    std::optional<std::string> value_;
    std::optional<bool> checked_;
    std::optional<std::string> key_;
    std::optional<std::string> code_;
    bool altKey_ = false;
    bool ctrlKey_ = false;
    bool metaKey_ = false;
    bool shiftKey_ = false;
    bool repeat_ = false;
    int32_t flags_ = 0;
};

class NativeImage {
public:
    NativeImage(int32_t handle, int32_t width, int32_t height)
        : handle_(handle), width_(width), height_(height) {}
    ~NativeImage() { detail::destroyImage(handle_); }

    int32_t width() const { return width_; }
    int32_t height() const { return height_; }
    int32_t handle() const { return handle_; }

private:
    int32_t handle_;
    int32_t width_;
    int32_t height_;
};

namespace detail {

inline std::unordered_map<int32_t, doof::callback<void(std::shared_ptr<NativeDomEvent>)>>& callbacks() {
    // Node states owned by the process-wide document can outlive ordinary
    // function-local statics during shutdown. Keep the callback registry alive
    // until process teardown so their destructors can unregister safely.
    static auto* values = new std::unordered_map<int32_t, doof::callback<void(std::shared_ptr<NativeDomEvent>)>>();
    return *values;
}

inline std::unordered_map<int32_t, doof::callback<void(double)>>& frameCallbacks() {
    static auto* values = new std::unordered_map<int32_t, doof::callback<void(double)>>();
    return *values;
}

inline std::unordered_map<int32_t, doof::callback<void(std::shared_ptr<NativeImage>, std::string)>>& imageCallbacks() {
    static auto* values = new std::unordered_map<
        int32_t, doof::callback<void(std::shared_ptr<NativeImage>, std::string)>>();
    return *values;
}

inline int32_t nextCallbackId() {
    static int32_t next = 1;
    return next++;
}

}  // namespace detail

extern "C" inline __attribute__((used)) int32_t doof_dom_dispatch_event(
    int32_t callbackId,
    int32_t eventId
) {
    const auto found = detail::callbacks().find(callbackId);
    if (found == detail::callbacks().end()) return 0;
    // A handler may clear or replace itself. Copy it before invoking so a
    // registry mutation during the call cannot invalidate our iterator.
    const auto callback = found->second;
    auto event = std::make_shared<NativeDomEvent>(eventId);
    try {
        auto& domain = doof::detail::ApplicationDomain::shared();
        doof::detail::ActiveActorScope scope(&domain);
        callback.call(event);
    } catch (const doof::Panic& error) {
        detail::reportError(std::string("panic: ") + error.what());
    } catch (const std::exception& error) {
        detail::reportError(error.what());
    }
    return event->flags();
}

extern "C" inline __attribute__((used)) void doof_dom_dispatch_frame(
    int32_t callbackId, double timestamp
) {
    const auto found = detail::frameCallbacks().find(callbackId);
    if (found == detail::frameCallbacks().end()) return;
    const auto callback = found->second;
    detail::frameCallbacks().erase(found);
    try {
        auto& domain = doof::detail::ApplicationDomain::shared();
        doof::detail::ActiveActorScope scope(&domain);
        callback.call(timestamp);
    } catch (const doof::Panic& error) {
        detail::reportError(std::string("panic: ") + error.what());
    } catch (const std::exception& error) {
        detail::reportError(error.what());
    }
}

extern "C" inline __attribute__((used)) void doof_dom_dispatch_image(
    int32_t callbackId, int32_t image, int32_t width, int32_t height, int32_t succeeded
) {
    const auto found = detail::imageCallbacks().find(callbackId);
    if (found == detail::imageCallbacks().end()) return;
    const auto callback = found->second;
    detail::imageCallbacks().erase(found);
    std::shared_ptr<NativeImage> loaded;
    std::string error;
    if (succeeded != 0) loaded = std::make_shared<NativeImage>(image, width, height);
    else error = "The browser could not load or decode the image";
    try {
        auto& domain = doof::detail::ApplicationDomain::shared();
        doof::detail::ActiveActorScope scope(&domain);
        callback.call(loaded, error);
    } catch (const doof::Panic& panic) {
        detail::reportError(std::string("panic: ") + panic.what());
    } catch (const std::exception& exception) {
        detail::reportError(exception.what());
    }
}

namespace detail {

inline int32_t dispatcherPointer() {
#if defined(__EMSCRIPTEN__)
    return static_cast<int32_t>(reinterpret_cast<std::uintptr_t>(&doof_dom_dispatch_event));
#else
    return 0;
#endif
}

inline int32_t frameDispatcherPointer() {
#if defined(__EMSCRIPTEN__)
    return static_cast<int32_t>(reinterpret_cast<std::uintptr_t>(&doof_dom_dispatch_frame));
#else
    return 0;
#endif
}

inline int32_t imageDispatcherPointer() {
#if defined(__EMSCRIPTEN__)
    return static_cast<int32_t>(reinterpret_cast<std::uintptr_t>(&doof_dom_dispatch_image));
#else
    return 0;
#endif
}

inline int32_t requestAnimationFrame(int32_t callbackId) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_request_animation_frame(callbackId, frameDispatcherPointer());
#else
    (void)callbackId;
    return nextNativeHandle();
#endif
}

inline void cancelAnimationFrame(int32_t request) {
#if defined(__EMSCRIPTEN__)
    doof_dom_cancel_animation_frame(request);
#else
    (void)request;
#endif
}

inline int32_t loadImage(
    const std::string& url, int32_t crossOrigin, int32_t callbackId
) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_load_image(url.c_str(), crossOrigin, callbackId, imageDispatcherPointer());
#else
    (void)url; (void)crossOrigin; (void)callbackId;
    return nextNativeHandle();
#endif
}

inline void cancelImage(int32_t image) {
#if defined(__EMSCRIPTEN__)
    doof_dom_cancel_image(image);
#else
    (void)image;
#endif
}

inline int32_t gamepadInt(int32_t gamepad, int32_t field, int32_t item = 0) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_gamepad_int(gamepad, field, item);
#else
    (void)gamepad; (void)field; (void)item;
    return 0;
#endif
}

inline double gamepadNumber(int32_t gamepad, int32_t field, int32_t item) {
#if defined(__EMSCRIPTEN__)
    return doof_dom_gamepad_number(gamepad, field, item);
#else
    (void)gamepad; (void)field; (void)item;
    return 0.0;
#endif
}

inline std::string gamepadString(int32_t gamepad, int32_t field) {
#if defined(__EMSCRIPTEN__)
    const int32_t length = doof_dom_gamepad_string(gamepad, field, nullptr, 0);
    if (length <= 0) return "";
    std::vector<char> value(static_cast<std::size_t>(length) + 1, '\0');
    const int32_t written = doof_dom_gamepad_string(gamepad, field, value.data(), length + 1);
    return written < 0 ? "" : std::string(value.data(), static_cast<std::size_t>(written));
#else
    (void)gamepad; (void)field;
    return "";
#endif
}

inline void addEvent(int32_t node, const std::string& eventType, int32_t callbackId) {
#if defined(__EMSCRIPTEN__)
    doof_dom_add_event(node, eventType.c_str(), callbackId, dispatcherPointer());
#else
    (void)node; (void)eventType; (void)callbackId;
#endif
}

inline void removeEvent(int32_t node, const std::string& eventType, int32_t callbackId) {
#if defined(__EMSCRIPTEN__)
    doof_dom_remove_event(node, eventType.c_str(), callbackId);
#else
    (void)node; (void)eventType; (void)callbackId;
#endif
}

struct NodeState {
    int32_t handle;
    bool borrowed;
    std::weak_ptr<NodeState> parent;
    std::vector<std::shared_ptr<NodeState>> children;
    std::unordered_map<std::string, int32_t> eventCallbacks;

    NodeState(int32_t handle, bool borrowed) : handle(handle), borrowed(borrowed) {}

    ~NodeState() {
        for (const auto& [eventType, callbackId] : eventCallbacks) {
            removeEvent(handle, eventType, callbackId);
            callbacks().erase(callbackId);
        }
        for (const auto& child : children) child->parent.reset();
        destroy(handle, borrowed);
    }
};

inline void detach(const std::shared_ptr<NodeState>& node) {
    auto parent = node->parent.lock();
    if (!parent) return;
    parent->children.erase(
        std::remove(parent->children.begin(), parent->children.end(), node),
        parent->children.end()
    );
    node->parent.reset();
}

inline void ensureCanContain(
    const std::shared_ptr<NodeState>& node,
    const std::shared_ptr<NodeState>& target
) {
    for (auto current = target; current; current = current->parent.lock()) {
        if (current == node) doof::panic("A DOM element cannot be placed inside itself or its descendants");
    }
}

inline std::size_t childIndex(
    const std::shared_ptr<NodeState>& parent,
    const std::shared_ptr<NodeState>& child
) {
    const auto found = std::find(parent->children.begin(), parent->children.end(), child);
    if (found == parent->children.end()) doof::panic("DOM placement target is detached");
    return static_cast<std::size_t>(found - parent->children.begin());
}

}  // namespace detail

class NativeElement : public std::enable_shared_from_this<NativeElement> {
public:
    static std::shared_ptr<NativeElement> create(const std::string& tagName) {
        return std::shared_ptr<NativeElement>(
            new NativeElement(std::make_shared<detail::NodeState>(detail::createElement(tagName), false))
        );
    }

    void appendChild(const std::shared_ptr<NativeElement>& child) {
        appendState(child->state_);
    }

    void appendText(const std::string& text) {
        auto child = std::make_shared<detail::NodeState>(detail::createText(text), false);
        appendState(child);
    }

    void appendTo(const std::shared_ptr<NativeElement>& target) {
        target->appendState(state_);
    }

    void insertBefore(const std::shared_ptr<NativeElement>& target) {
        if (state_ == target->state_) return;
        auto parent = target->state_->parent.lock();
        if (!parent) doof::panic("Cannot insert before a detached DOM element");
        detail::ensureCanContain(state_, parent);
        detail::detach(state_);
        const auto index = detail::childIndex(parent, target->state_);
        parent->children.insert(parent->children.begin() + static_cast<std::ptrdiff_t>(index), state_);
        state_->parent = parent;
        detail::insertBefore(state_->handle, target->state_->handle);
    }

    void insertAfter(const std::shared_ptr<NativeElement>& target) {
        if (state_ == target->state_) return;
        auto parent = target->state_->parent.lock();
        if (!parent) doof::panic("Cannot insert after a detached DOM element");
        detail::ensureCanContain(state_, parent);
        detail::detach(state_);
        const auto index = detail::childIndex(parent, target->state_);
        parent->children.insert(parent->children.begin() + static_cast<std::ptrdiff_t>(index + 1), state_);
        state_->parent = parent;
        detail::insertAfter(state_->handle, target->state_->handle);
    }

    void replace(const std::shared_ptr<NativeElement>& target) {
        if (state_ == target->state_) return;
        auto parent = target->state_->parent.lock();
        if (!parent) doof::panic("Cannot replace a detached DOM element");
        detail::ensureCanContain(state_, parent);
        detail::detach(state_);
        const auto index = detail::childIndex(parent, target->state_);
        parent->children[index] = state_;
        state_->parent = parent;
        target->state_->parent.reset();
        detail::replace(state_->handle, target->state_->handle);
    }

    void unmount() {
        if (state_->borrowed) doof::panic("Document head and body cannot be unmounted");
        detail::detach(state_);
        detail::unmount(state_->handle);
    }

    void setText(const std::string& text) {
        for (const auto& child : state_->children) child->parent.reset();
        state_->children.clear();
        detail::setText(state_->handle, text);
    }

    void setId(const std::string& id) { detail::setString(state_->handle, 0, id); }
    void setClassName(const std::string& className) { detail::setString(state_->handle, 1, className); }
    void setDisabled(bool disabled) { detail::setBool(state_->handle, 0, disabled); }
    void setValue(const std::string& value) { detail::setString(state_->handle, 2, value); }
    void setChecked(bool checked) { detail::setBool(state_->handle, 1, checked); }
    void setAttribute(const std::string& name, const std::string& value) {
        detail::setAttribute(state_->handle, name, value);
    }
    void removeAttribute(const std::string& name) { detail::removeAttribute(state_->handle, name); }
    void focus() { detail::focus(state_->handle); }
    void blur() { detail::blur(state_->handle); }
    double numberProperty(int32_t property) { return detail::elementNumber(state_->handle, property); }

    void setEventHandler(
        const std::string& eventType,
        doof::callback<void(std::shared_ptr<NativeDomEvent>)> handler
    ) {
        const auto existing = state_->eventCallbacks.find(eventType);
        if (existing != state_->eventCallbacks.end()) {
            detail::removeEvent(state_->handle, eventType, existing->second);
            detail::callbacks().erase(existing->second);
        }
        const int32_t callbackId = detail::nextCallbackId();
        detail::callbacks().emplace(callbackId, std::move(handler));
        state_->eventCallbacks[eventType] = callbackId;
        detail::addEvent(state_->handle, eventType, callbackId);
    }

    void clearEventHandler(const std::string& eventType) {
        const auto existing = state_->eventCallbacks.find(eventType);
        if (existing == state_->eventCallbacks.end()) return;
        detail::removeEvent(state_->handle, eventType, existing->second);
        detail::callbacks().erase(existing->second);
        state_->eventCallbacks.erase(existing);
    }

private:
    explicit NativeElement(std::shared_ptr<detail::NodeState> state) : state_(std::move(state)) {}

    void appendState(const std::shared_ptr<detail::NodeState>& child) {
        detail::ensureCanContain(child, state_);
        detail::detach(child);
        state_->children.push_back(child);
        child->parent = state_;
        detail::appendTo(child->handle, state_->handle);
    }

    std::shared_ptr<detail::NodeState> state_;

    friend class NativeDocument;
    friend class NativeCanvasContext;
    friend class NativeWebGLContext;
};

class NativeAnimationFrameRequest {
public:
    static std::shared_ptr<NativeAnimationFrameRequest> create(doof::callback<void(double)> handler) {
        const int32_t callbackId = detail::nextCallbackId();
        detail::frameCallbacks().emplace(callbackId, std::move(handler));
        const int32_t request = detail::requestAnimationFrame(callbackId);
        return std::shared_ptr<NativeAnimationFrameRequest>(new NativeAnimationFrameRequest(request, callbackId));
    }

    ~NativeAnimationFrameRequest() { cancel(); }

    void cancel() {
        if (request_ == 0) return;
        detail::cancelAnimationFrame(request_);
        detail::frameCallbacks().erase(callbackId_);
        request_ = 0;
    }

private:
    NativeAnimationFrameRequest(int32_t request, int32_t callbackId)
        : request_(request), callbackId_(callbackId) {}
    int32_t request_;
    int32_t callbackId_;
};

class NativeImageLoadRequest {
public:
    static std::shared_ptr<NativeImageLoadRequest> create(
        const std::string& url,
        int32_t crossOrigin,
        doof::callback<void(std::shared_ptr<NativeImage>, std::string)> handler
    ) {
        const int32_t callbackId = detail::nextCallbackId();
        detail::imageCallbacks().emplace(callbackId, std::move(handler));
        const int32_t image = detail::loadImage(url, crossOrigin, callbackId);
        return std::shared_ptr<NativeImageLoadRequest>(
            new NativeImageLoadRequest(image, callbackId));
    }

    ~NativeImageLoadRequest() { cancel(); }

    void cancel() {
        if (image_ == 0) return;
        detail::cancelImage(image_);
        detail::imageCallbacks().erase(callbackId_);
        image_ = 0;
    }

private:
    NativeImageLoadRequest(int32_t image, int32_t callbackId)
        : image_(image), callbackId_(callbackId) {}
    int32_t image_;
    int32_t callbackId_;
};

class NativeGamepads {
public:
    static int32_t count() { return detail::gamepadInt(0, 0); }
    static bool connected(int32_t index) { return detail::gamepadInt(index, 1) != 0; }
    static std::string id(int32_t index) { return detail::gamepadString(index, 0); }
    static bool buttonPressed(int32_t index, int32_t button) { return detail::gamepadInt(index, 2, button) != 0; }
    static double buttonValue(int32_t index, int32_t button) { return detail::gamepadNumber(index, 0, button); }
    static double axis(int32_t index, int32_t axis) { return detail::gamepadNumber(index, 1, axis); }
};

class NativeCanvasContext {
public:
    static std::shared_ptr<NativeCanvasContext> create(const std::shared_ptr<NativeElement>& element) {
        const int32_t handle = detail::canvasContext2d(element->state_->handle);
        if (handle == 0) doof::panic("The DOM element does not provide a 2D canvas context");
        return std::shared_ptr<NativeCanvasContext>(new NativeCanvasContext(handle, element));
    }

    ~NativeCanvasContext() { detail::destroyCanvasContext(handle_); }

    void save() { detail::canvasAction(handle_, 0); }
    void restore() { detail::canvasAction(handle_, 1); }
    void beginPath() { detail::canvasAction(handle_, 2); }
    void closePath() { detail::canvasAction(handle_, 3); }
    void fill() { detail::canvasAction(handle_, 4); }
    void stroke() { detail::canvasAction(handle_, 5); }
    void resetTransform() { detail::canvasAction(handle_, 6); }

    void clearRect(double x, double y, double width, double height) {
        detail::canvasNumbers(handle_, 0, x, y, width, height);
    }
    void fillRect(double x, double y, double width, double height) {
        detail::canvasNumbers(handle_, 1, x, y, width, height);
    }
    void strokeRect(double x, double y, double width, double height) {
        detail::canvasNumbers(handle_, 2, x, y, width, height);
    }
    void moveTo(double x, double y) { detail::canvasNumbers(handle_, 3, x, y); }
    void lineTo(double x, double y) { detail::canvasNumbers(handle_, 4, x, y); }
    void rect(double x, double y, double width, double height) {
        detail::canvasNumbers(handle_, 5, x, y, width, height);
    }
    void arc(
        double x, double y, double radius, double startAngle, double endAngle, bool anticlockwise
    ) {
        detail::canvasNumbers(handle_, 6, x, y, radius, startAngle, endAngle, anticlockwise ? 1.0 : 0.0);
    }
    void translate(double x, double y) { detail::canvasNumbers(handle_, 7, x, y); }
    void scale(double x, double y) { detail::canvasNumbers(handle_, 8, x, y); }
    void rotate(double angle) { detail::canvasNumbers(handle_, 9, angle); }
    void setTransform(double a, double b, double c, double d, double e, double f) {
        detail::canvasNumbers(handle_, 10, a, b, c, d, e, f);
    }

    void setFillStyle(const std::string& value) { detail::canvasSetString(handle_, 0, value); }
    void setStrokeStyle(const std::string& value) { detail::canvasSetString(handle_, 1, value); }
    void setFont(const std::string& value) { detail::canvasSetString(handle_, 2, value); }
    void setTextAlign(const std::string& value) { detail::canvasSetString(handle_, 3, value); }
    void setTextBaseline(const std::string& value) { detail::canvasSetString(handle_, 4, value); }
    void setLineCap(const std::string& value) { detail::canvasSetString(handle_, 5, value); }
    void setLineJoin(const std::string& value) { detail::canvasSetString(handle_, 6, value); }
    void setGlobalCompositeOperation(const std::string& value) { detail::canvasSetString(handle_, 7, value); }
    void setLineWidth(double value) { detail::canvasSetNumber(handle_, 0, value); }
    void setGlobalAlpha(double value) { detail::canvasSetNumber(handle_, 1, value); }
    void setMiterLimit(double value) { detail::canvasSetNumber(handle_, 2, value); }
    void setLineDashOffset(double value) { detail::canvasSetNumber(handle_, 3, value); }

    void fillText(
        const std::string& text, double x, double y, const std::optional<double>& maxWidth
    ) {
        detail::canvasText(handle_, 0, text, x, y, maxWidth);
    }
    void strokeText(
        const std::string& text, double x, double y, const std::optional<double>& maxWidth
    ) {
        detail::canvasText(handle_, 1, text, x, y, maxWidth);
    }
    double measureTextWidth(const std::string& text) {
        return detail::canvasMeasureText(handle_, text);
    }

private:
    NativeCanvasContext(int32_t handle, std::shared_ptr<NativeElement> element)
        : handle_(handle), element_(std::move(element)) {}

    int32_t handle_;
    // Retain the canvas element for as long as this context can draw into it.
    std::shared_ptr<NativeElement> element_;
};

class NativeWebGLContext;

class NativeWebGLShader {
public:
    ~NativeWebGLShader();
    void setSource(const std::string& source);
    void compile();
    bool compiled() const;
    std::string infoLog() const;

private:
    NativeWebGLShader(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
    friend class NativeWebGLProgram;
};

class NativeWebGLProgram {
public:
    ~NativeWebGLProgram();
    void attach(const std::shared_ptr<NativeWebGLShader>& shader);
    void link();
    bool linked() const;
    std::string infoLog() const;

private:
    NativeWebGLProgram(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
};

class NativeWebGLBuffer {
public:
    ~NativeWebGLBuffer();

private:
    NativeWebGLBuffer(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
};

class NativeWebGLTexture {
public:
    ~NativeWebGLTexture();

private:
    NativeWebGLTexture(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
};

class NativeWebGLFramebuffer {
public:
    ~NativeWebGLFramebuffer();
private:
    NativeWebGLFramebuffer(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
};

class NativeWebGLRenderbuffer {
public:
    ~NativeWebGLRenderbuffer();
private:
    NativeWebGLRenderbuffer(int32_t resource, std::shared_ptr<NativeWebGLContext> context)
        : resource_(resource), context_(std::move(context)) {}
    int32_t resource_;
    std::shared_ptr<NativeWebGLContext> context_;
    friend class NativeWebGLContext;
};

class NativeWebGLContext : public std::enable_shared_from_this<NativeWebGLContext> {
public:
    static std::shared_ptr<NativeWebGLContext> create(
        const std::shared_ptr<NativeElement>& element,
        bool alpha, bool antialias, bool depth, bool stencil,
        bool premultipliedAlpha, bool preserveDrawingBuffer, int32_t powerPreference
    ) {
        const int32_t handle = detail::webglContext(
            element->state_->handle, alpha, antialias, depth, stencil,
            premultipliedAlpha, preserveDrawingBuffer, powerPreference
        );
        if (handle == 0) doof::panic("The browser or GPU does not support WebGL 2");
        return std::shared_ptr<NativeWebGLContext>(new NativeWebGLContext(handle, element));
    }

    ~NativeWebGLContext() { detail::destroyWebglContext(handle_); }

    std::shared_ptr<NativeWebGLShader> createShader(int32_t type) {
        const int32_t resource = detail::webglCreateResource(handle_, 0, type);
        if (resource == 0) doof::panic("WebGL could not create a shader");
        return std::shared_ptr<NativeWebGLShader>(new NativeWebGLShader(resource, shared_from_this()));
    }
    std::shared_ptr<NativeWebGLProgram> createProgram() {
        const int32_t resource = detail::webglCreateResource(handle_, 1);
        if (resource == 0) doof::panic("WebGL could not create a program");
        return std::shared_ptr<NativeWebGLProgram>(new NativeWebGLProgram(resource, shared_from_this()));
    }
    std::shared_ptr<NativeWebGLBuffer> createBuffer() {
        const int32_t resource = detail::webglCreateResource(handle_, 2);
        if (resource == 0) doof::panic("WebGL could not create a buffer");
        return std::shared_ptr<NativeWebGLBuffer>(new NativeWebGLBuffer(resource, shared_from_this()));
    }
    std::shared_ptr<NativeWebGLTexture> createTexture() {
        const int32_t resource = detail::webglCreateResource(handle_, 3);
        if (resource == 0) doof::panic("WebGL could not create a texture");
        return std::shared_ptr<NativeWebGLTexture>(new NativeWebGLTexture(resource, shared_from_this()));
    }
    std::shared_ptr<NativeWebGLFramebuffer> createFramebuffer() {
        const int32_t resource = detail::webglCreateResource(handle_, 4);
        if (resource == 0) doof::panic("WebGL could not create a framebuffer");
        return std::shared_ptr<NativeWebGLFramebuffer>(new NativeWebGLFramebuffer(resource, shared_from_this()));
    }
    std::shared_ptr<NativeWebGLRenderbuffer> createRenderbuffer() {
        const int32_t resource = detail::webglCreateResource(handle_, 5);
        if (resource == 0) doof::panic("WebGL could not create a renderbuffer");
        return std::shared_ptr<NativeWebGLRenderbuffer>(new NativeWebGLRenderbuffer(resource, shared_from_this()));
    }

    void useProgram(const std::shared_ptr<NativeWebGLProgram>& program) {
        detail::webglOperation(handle_, 5, program->resource_);
    }
    void bindBuffer(int32_t target, const std::shared_ptr<NativeWebGLBuffer>& buffer) {
        detail::webglOperation(handle_, 6, buffer->resource_, 0, target);
    }
    void unbindBuffer(int32_t target) { detail::webglOperation(handle_, 6, 0, 0, target); }
    void bufferData(
        int32_t target, const std::shared_ptr<std::vector<double>>& values, int32_t usage
    ) {
        detail::webglBufferData(handle_, target, values, usage);
    }
    void bufferDataBytes(
        int32_t target, const std::shared_ptr<std::vector<uint8_t>>& values, int32_t usage
    ) {
        detail::webglBufferDataBytes(handle_, target, values, usage);
    }
    void bufferDataUnsignedShort(
        int32_t target, const std::shared_ptr<std::vector<int32_t>>& values, int32_t usage
    ) {
        detail::webglBufferDataUnsignedShort(handle_, target, values, usage);
    }
    void bufferDataUnsignedInt(
        int32_t target, const std::shared_ptr<std::vector<int32_t>>& values, int32_t usage
    ) {
        detail::webglBufferDataUnsignedInt(handle_, target, values, usage);
    }
    int32_t attributeLocation(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name
    ) {
        return detail::webglStringOperation(handle_, 1, program->resource_, name);
    }
    void enableAttribute(int32_t location) { detail::webglOperation(handle_, 7, location); }
    void disableAttribute(int32_t location) { detail::webglOperation(handle_, 8, location); }
    void attributePointer(
        int32_t location, int32_t size, int32_t type,
        bool normalized, int32_t stride, int32_t offset
    ) {
        detail::webglOperation(
            handle_, 9, location, 0, size, type, normalized ? 1.0 : 0.0, stride, offset
        );
    }
    void viewport(int32_t x, int32_t y, int32_t width, int32_t height) {
        detail::webglOperation(handle_, 10, 0, 0, x, y, width, height);
    }
    void clearColor(double red, double green, double blue, double alpha) {
        detail::webglOperation(handle_, 11, 0, 0, red, green, blue, alpha);
    }
    void clearDepth(double depth) { detail::webglOperation(handle_, 12, 0, 0, depth); }
    void clearStencil(int32_t value) { detail::webglOperation(handle_, 13, 0, 0, value); }
    void clear(bool color, bool depth, bool stencil) {
        int32_t mask = 0;
        if (color) mask |= 0x4000;
        if (depth) mask |= 0x0100;
        if (stencil) mask |= 0x0400;
        detail::webglOperation(handle_, 14, 0, 0, mask);
    }
    void enable(int32_t capability) { detail::webglOperation(handle_, 15, 0, 0, capability); }
    void disable(int32_t capability) { detail::webglOperation(handle_, 16, 0, 0, capability); }
    void drawArrays(int32_t mode, int32_t first, int32_t count) {
        detail::webglOperation(handle_, 17, 0, 0, mode, first, count);
    }
    void drawElements(int32_t mode, int32_t count, int32_t type, int32_t offset) {
        detail::webglOperation(handle_, 18, 0, 0, mode, count, type, offset);
    }
    bool uniform1f(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name, double x
    ) {
        return detail::webglStringOperation(handle_, 2, program->resource_, name, x) != 0;
    }
    bool uniform2f(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name,
        double x, double y
    ) {
        return detail::webglStringOperation(handle_, 3, program->resource_, name, x, y) != 0;
    }
    bool uniform3f(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name,
        double x, double y, double z
    ) {
        return detail::webglStringOperation(handle_, 4, program->resource_, name, x, y, z) != 0;
    }
    bool uniform4f(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name,
        double x, double y, double z, double w
    ) {
        return detail::webglStringOperation(handle_, 5, program->resource_, name, x, y, z, w) != 0;
    }
    bool uniform1i(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name, int32_t value
    ) {
        return detail::webglStringOperation(handle_, 6, program->resource_, name, value) != 0;
    }
    bool uniformMatrix4(
        const std::shared_ptr<NativeWebGLProgram>& program, const std::string& name,
        bool transpose, const std::shared_ptr<std::vector<double>>& values
    ) {
        return detail::webglUniformMatrix4(
            handle_, program->resource_, name, transpose, values
        );
    }
    void activeTexture(int32_t unit) { detail::webglOperation(handle_, 21, 0, 0, unit); }
    void bindTexture(int32_t target, const std::shared_ptr<NativeWebGLTexture>& texture) {
        detail::webglOperation(handle_, 22, texture->resource_, 0, target);
    }
    void unbindTexture(int32_t target) { detail::webglOperation(handle_, 22, 0, 0, target); }
    void textureImageRgba(
        int32_t target, int32_t width, int32_t height,
        const std::shared_ptr<std::vector<uint8_t>>& pixels
    ) {
        detail::webglTextureRgba(handle_, target, width, height, pixels);
    }
    void textureImageDepth(int32_t target, int32_t width, int32_t height) {
        detail::webglTextureDepth(handle_, target, width, height);
    }
    void textureImage(int32_t target, const std::shared_ptr<NativeImage>& image) {
        detail::webglTextureImage(handle_, target, image->handle());
    }
    void textureParameter(int32_t target, int32_t parameter, int32_t value) {
        detail::webglOperation(handle_, 23, 0, 0, target, parameter, value);
    }
    void generateMipmap(int32_t target) { detail::webglOperation(handle_, 24, 0, 0, target); }
    void setUnpackFlipY(bool enabled) {
        detail::webglOperation(handle_, 25, 0, 0, 0x9240, enabled ? 1.0 : 0.0);
    }
    void setUnpackPremultiplyAlpha(bool enabled) {
        detail::webglOperation(handle_, 25, 0, 0, 0x9241, enabled ? 1.0 : 0.0);
    }
    void blendFunc(int32_t source, int32_t destination) {
        detail::webglOperation(handle_, 26, 0, 0, source, destination);
    }
    void blendEquation(int32_t equation) { detail::webglOperation(handle_, 27, 0, 0, equation); }
    void depthFunc(int32_t function) { detail::webglOperation(handle_, 28, 0, 0, function); }
    void depthMask(bool enabled) { detail::webglOperation(handle_, 29, 0, 0, enabled ? 1.0 : 0.0); }
    void colorMask(bool red, bool green, bool blue, bool alpha) {
        detail::webglOperation(
            handle_, 30, 0, 0,
            red ? 1.0 : 0.0, green ? 1.0 : 0.0,
            blue ? 1.0 : 0.0, alpha ? 1.0 : 0.0
        );
    }
    void cullFace(int32_t face) { detail::webglOperation(handle_, 31, 0, 0, face); }
    void frontFace(int32_t winding) { detail::webglOperation(handle_, 32, 0, 0, winding); }
    void scissor(int32_t x, int32_t y, int32_t width, int32_t height) {
        detail::webglOperation(handle_, 33, 0, 0, x, y, width, height);
    }
    void polygonOffset(double factor, double units) {
        detail::webglOperation(handle_, 34, 0, 0, factor, units);
    }
    bool supportsInstancing() { return detail::webglOperation(handle_, 35) != 0; }
    bool supportsUnsignedIntIndices() { return detail::webglOperation(handle_, 39) != 0; }
    int32_t maxVertexAttributes() { return detail::webglOperation(handle_, 40); }
    int32_t maxTextureUnits() { return detail::webglOperation(handle_, 41); }
    bool supportsDepthTextures() { return detail::webglOperation(handle_, 42) != 0; }
    void bindFramebuffer(int32_t target, const std::shared_ptr<NativeWebGLFramebuffer>& framebuffer) {
        detail::webglOperation(handle_, 43, framebuffer->resource_, 0, target);
    }
    void unbindFramebuffer(int32_t target) { detail::webglOperation(handle_, 43, 0, 0, target); }
    void framebufferTexture2d(
        int32_t target, int32_t attachment, int32_t textureTarget,
        const std::shared_ptr<NativeWebGLTexture>& texture
    ) {
        detail::webglOperation(handle_, 44, texture->resource_, 0, target, attachment, textureTarget);
    }
    int32_t framebufferStatus(int32_t target) { return detail::webglOperation(handle_, 45, 0, 0, target); }
    void bindRenderbuffer(int32_t target, const std::shared_ptr<NativeWebGLRenderbuffer>& renderbuffer) {
        detail::webglOperation(handle_, 46, renderbuffer->resource_, 0, target);
    }
    void unbindRenderbuffer(int32_t target) { detail::webglOperation(handle_, 46, 0, 0, target); }
    void renderbufferStorage(int32_t target, int32_t format, int32_t width, int32_t height) {
        detail::webglOperation(handle_, 47, 0, 0, target, format, width, height);
    }
    void framebufferRenderbuffer(
        int32_t target, int32_t attachment, int32_t renderbufferTarget,
        const std::shared_ptr<NativeWebGLRenderbuffer>& renderbuffer
    ) {
        detail::webglOperation(handle_, 48, renderbuffer->resource_, 0, target, attachment, renderbufferTarget);
    }
    bool attributeDivisor(int32_t location, int32_t divisor) {
        return detail::webglOperation(handle_, 36, location, 0, divisor) != 0;
    }
    bool drawArraysInstanced(int32_t mode, int32_t first, int32_t count, int32_t instanceCount) {
        return detail::webglOperation(handle_, 37, 0, 0, mode, first, count, instanceCount) != 0;
    }
    bool drawElementsInstanced(
        int32_t mode, int32_t count, int32_t type, int32_t offset, int32_t instanceCount
    ) {
        return detail::webglOperation(handle_, 38, 0, 0, mode, count, type, offset, instanceCount) != 0;
    }
    void flush() { detail::webglOperation(handle_, 19); }
    void finish() { detail::webglOperation(handle_, 20); }

    int32_t handle() const { return handle_; }

private:
    NativeWebGLContext(int32_t handle, std::shared_ptr<NativeElement> element)
        : handle_(handle), element_(std::move(element)) {}
    int32_t handle_;
    std::shared_ptr<NativeElement> element_;
};

inline NativeWebGLShader::~NativeWebGLShader() {
    detail::webglDeleteResource(context_->handle(), 0, resource_);
}
inline void NativeWebGLShader::setSource(const std::string& source) {
    detail::webglStringOperation(context_->handle(), 0, resource_, source);
}
inline void NativeWebGLShader::compile() {
    detail::webglOperation(context_->handle(), 0, resource_);
}
inline bool NativeWebGLShader::compiled() const {
    return detail::webglOperation(context_->handle(), 1, resource_) != 0;
}
inline std::string NativeWebGLShader::infoLog() const {
    return detail::webglResourceLog(context_->handle(), 0, resource_);
}

inline NativeWebGLProgram::~NativeWebGLProgram() {
    detail::webglDeleteResource(context_->handle(), 1, resource_);
}
inline void NativeWebGLProgram::attach(const std::shared_ptr<NativeWebGLShader>& shader) {
    detail::webglOperation(context_->handle(), 2, resource_, shader->resource_);
}
inline void NativeWebGLProgram::link() {
    detail::webglOperation(context_->handle(), 3, resource_);
}
inline bool NativeWebGLProgram::linked() const {
    return detail::webglOperation(context_->handle(), 4, resource_) != 0;
}
inline std::string NativeWebGLProgram::infoLog() const {
    return detail::webglResourceLog(context_->handle(), 1, resource_);
}

inline NativeWebGLBuffer::~NativeWebGLBuffer() {
    detail::webglDeleteResource(context_->handle(), 2, resource_);
}

inline NativeWebGLTexture::~NativeWebGLTexture() {
    detail::webglDeleteResource(context_->handle(), 3, resource_);
}
inline NativeWebGLFramebuffer::~NativeWebGLFramebuffer() {
    detail::webglDeleteResource(context_->handle(), 4, resource_);
}
inline NativeWebGLRenderbuffer::~NativeWebGLRenderbuffer() {
    detail::webglDeleteResource(context_->handle(), 5, resource_);
}

class NativeDocument {
public:
    static std::shared_ptr<NativeDocument> shared() {
        static auto document = std::shared_ptr<NativeDocument>(new NativeDocument());
        return document;
    }

    std::shared_ptr<NativeElement> head() { return head_; }
    std::shared_ptr<NativeElement> body() { return body_; }
    std::shared_ptr<NativeElement> window() { return window_; }

private:
    NativeDocument()
        : window_(std::shared_ptr<NativeElement>(new NativeElement(
              std::make_shared<detail::NodeState>(detail::documentAnchor(0), true)))),
          head_(std::shared_ptr<NativeElement>(new NativeElement(
              std::make_shared<detail::NodeState>(detail::documentAnchor(1), true)))),
          body_(std::shared_ptr<NativeElement>(new NativeElement(
              std::make_shared<detail::NodeState>(detail::documentAnchor(2), true)))) {}

    std::shared_ptr<NativeElement> window_;
    std::shared_ptr<NativeElement> head_;
    std::shared_ptr<NativeElement> body_;
};

}  // namespace doof_dom

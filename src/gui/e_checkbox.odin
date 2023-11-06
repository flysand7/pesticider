
package gui

Checkbox :: struct {
    using element: Element,
    checked: bool,
}

checkbox_create :: proc(parent: ^Element, flags: Element_Flags, checked := false) -> ^Checkbox {
    checkbox := element_create(parent, Checkbox, flags)
    checkbox.checked = checked
    checkbox.msg_class = checkbox_message
    return checkbox
}

checkbox_message :: proc(element: ^Element, message: Message, di: int, dp: rawptr) -> int {
    checkbox := cast(^Checkbox) element
    #partial switch message {
        case .Layout_Get_Width, .Layout_Get_Height:
            return 25
        case .Update:
            element_repaint(checkbox)
        case .Mouse_Clicked:
            checkbox.checked = !checkbox.checked
        case .Paint:
            hovered := checkbox.window.hovered == checkbox
            pressed := checkbox.window.pressed == checkbox && checkbox.window.hovered == checkbox
            color_border := hovered? u32(0xffffff) : u32(0x777777)
            if pressed {
                color_border = u32(0x333333)
            }
            color_checked := u32(0x42c8f5)
            color_back := u32(0x000000)
            painter := cast(^Painter) dp
            paint_rect(painter, element.bounds, color_back, color_border)
            if checkbox.checked {
                indent := 5
                rect := rect_make(
                    element.bounds.l + indent,
                    element.bounds.t + indent,
                    element.bounds.r - indent,
                    element.bounds.b - indent)
                paint_box(painter, rect, color_checked)
            }
    }
    return 0
}

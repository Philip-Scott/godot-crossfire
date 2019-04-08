# Displays a background texture which loops infinitely in all directions.
# It should be put on a Node2D under the root of your scene.
# Differences from ParallaxBackground node:
# - Just drop a texture on it, done
# - No need to have a large enough image, tiling fills all visible area
# - Works on the same layer, adjust Z as you see fit
# - Focused on camera center, so zooming won't trouble the parallax. (TODO zoom parallax?)

extends Node2D

# Background texture to repeat
export(Texture) var texture = null
# Parallax motion speed.
# The closer to zero, the slower the background will move.
# (1,1) is in sync, above is faster.
export var parallax = Vector2(0.5, 0.5)

var _tiles_x = 0
var _tiles_y = 0


func _ready():
    update_tiles()
    _update_position()
    set_process(true)

# If zoom changes too much in your game,
# you should call this, then update() to redraw tiles to the right range.
func update_tiles():
    _calculate_required_tiles()
    var ntiles = _calculate_required_tiles()
    _tiles_x = ntiles.x
    _tiles_y = ntiles.y
    #update()


func _process(delta):
    _update_position()


func _update_position():
    var cam_pos = _get_camera_center()
    #print("cam_zoom = " + str(Vector2(1,1)/get_canvas_transform().get_scale()))

    var parallax_pos = -cam_pos * parallax

    var tsize = texture.get_size()
    var tiled_pos = parallax_pos / tsize
    var floored_parallax_pos = tsize * Vector2(floor(tiled_pos.x), floor(tiled_pos.y))

    var new_pos = cam_pos + (parallax_pos - floored_parallax_pos)

    position = (new_pos)


func _get_camera_center():
    var ctrans = get_canvas_transform()
    var top_left = -ctrans.get_origin()
    var vsize = get_viewport_rect().size
    var center = (top_left + 0.5*vsize) / ctrans.get_scale()
    return center


func _calculate_required_tiles():
    var tile_size = texture.get_size() * get_scale()
    var view_size = get_viewport_rect().size / get_canvas_transform().get_scale()
    var fn = view_size / tile_size
    return Vector2(ceil(fn.x), ceil(fn.y))


func _draw():
    var tsize = texture.get_size()
    var nx = _tiles_x / 2 + 1
    var ny = _tiles_y / 2 + 1

    # Draw tiles around the center
    for y in range(-ny, ny):
        for x in range(-nx, nx):
            draw_texture(texture, Vector2(x,y) * tsize)

    #draw_rect(Rect2(Vector2(0,0), Vector2(8,8)), Color(1,0,0))
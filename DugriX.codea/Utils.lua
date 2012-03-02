
function getGradientColor(width, position, color1, color2)
    r = color1.r
    g = color1.g
    b = color1.b
    a = color1.a
        
    dr = (color2.r - r) / width
    dg = (color2.g - g) / width
    db = (color2.b - b) / width
    da = (color2.a - a) / width

    r = (r + (dr * position))
    g = (g + (dg * position))
    b = (b + (db * position))
    a = (a + (da * position))
    
    return color(r, g, b, a)
end

function getBounds(points)
    maxX = 0 - math.huge
    maxY = 0 - math.huge
    minX = math.huge
    minY = math.huge

    for i, pt in ipairs(points) do
        if pt.x > maxX then
            maxX = pt.x
        end
        if pt.x < minX then
            minX = pt.x
        end
        if pt.y > maxY then
            maxY = pt.y
        end
        if pt.y < minY then
            minY = pt.y
        end
    end

    bounds = Rect( minX, minY, maxX-minX, maxY-minY )
    return bounds
end

function centerPolyInRect(poly, rect_)
    local bounds = getBounds(poly)
    local x = rect_.x + ((rect_.w - bounds.w) / 2)
    local y = rect_.y + ((rect_.h - bounds.h) / 2)
    
    local newPoly = {}
    for i, pt in ipairs(poly) do
        pt.x = x + pt.x
        pt.y = y + pt.y
        table.insert(newPoly, pt)
    end
    return newPoly
end

function drawPoly(poly)
    for i = 1, #poly - 1 do
        local a = poly[i]
        local b = poly[i + 1]
        line(a.x, a.y, b.x, b.y)
    end
end

function pointIsInRect(pt_, rect_)
    if rect_.x < pt_.x and rect_.x + rect_.w > pt_.x
    and rect_.y < pt_.y and rect_.y + rect_.h > pt_.y then
        return true
    else
        return false
    end
end

function easeInOutQuart(time, begin, change, duration)
    local res = nil
    
    time = time/(duration/2)
    
    if time < 1 then
        res = change/2 * math.pow(time, 4) + begin
    else
        res = -change/2 * (math.pow(time-2, 4) - 2) + begin
    end
    return res
end

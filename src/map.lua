-- map related methods

--  Set maps/ as the base directory for map loading
ATL.Loader.path = '/res/'

-- Use the loader to load the map
map = ATL.Loader.load("platform.tmx")

function map_draw()
    map:draw()
end

function map_find_solid_tiles()

    local collidable_tiles = {}

    local layer = map.tl["blocks"]

    for tileX=1,map.width do
        for tileY=1,map.height do

            local tile
            tile = layer.tileData(tileX-1,tileY-1)

            if tile and tile.properties.solid then
                local ctile = Collider:addRectangle((tileX-1)*32,(tileY-1)*32,32,32)
                ctile.type = "tile"
                Collider:addToGroup("tiles", ctile)
                Collider:setPassive(ctile)
                table.insert(collidable_tiles, ctile)
            end

        end
    end

    return collidable_tiles
end

function map_create_sides()
    
    borderLeft  = Collider:addRectangle( -100, 0, 99, 650)
    borderRight = Collider:addRectangle(  961, 0, 99, 650)
    borderLeft.type  = "border"
    borderRight.type = "border"
    
    dumpLeft  = Collider:addRectangle( -100, 651, 99, 199)
    dumpRight = Collider:addRectangle(  961, 651, 99, 199)
    dumpLeft.type  = "dump"
    dumpRight.type = "dump"
    
end

function map_pixwidth()
    return map.width*32
end

function map_pixheight()
    return map.height*32
end

function map_random_pos()
   
    x = math.random(0, map_pixwidth())
    y = math.random(0, map_pixheight()-100)
    
    return x, y
   
end
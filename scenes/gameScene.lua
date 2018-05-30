-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: Sebastian N
-- Created on: May 28
--
-- This program gathers the knowledge gained in the previous classes. 
-- (Composer, physics, collisions)
-----------------------------------------------------------------------------------------

-- Variables for requirements
local composer = require( "composer" )
local physics = require('physics')
local json = require('json')
local tiled = require('com.ponywolf.ponytiled')
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Important Variables for the scene
local map = nil
local ninja = nil
local rightArrow = nil
local shootButton = nil
local jumpButton = nil
local playerKunais = {}
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- Function to make the character move 
local moveNinja = function(event)
    if (ninja.sequence == 'run') then
        transition.moveBy(ninja, {
            x = 10,
            y = 0,
            time = 0
            })
    end

    -- Statement to set back to idle after jump
    if (ninja.sequence == 'jump') then
        local ninjaVelocityX, ninjaVelocityY = ninja:getLinearVelocity()

        if ninjaVelocityY == 0 then
            ninja.sequence = 'idle'
            ninja:setSequence('idle')
            ninja:play()
        end
    end

end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    physics.start()
    physics.setGravity(0, 10)
    --physics.setDrawMode('hybrid')

    -- Load map to the game
    local filename = './assets/maps/level0.json'
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, 'assets/maps')
    --map.xScale, map.yScale = 0.85, 0.85

    -- Loading right arrow
    rightArrow = display.newImage('./assets/sprites/rightButton.png')
    rightArrow.x = display.contentCenterX / 3
    rightArrow.y = display.contentHeight - 200
    rightArrow.id = 'rightArrow'

    -- Loading shoot button
    shootButton = display.newImage('./assets/sprites/jumpButton.png')
    shootButton.x = display.contentCenterX * 1.5
    shootButton.y = display.contentHeight - 200
    shootButton.id = 'shoot button'

    -- Loading jump button
    jumpButton = display.newImage('./assets/sprites/jumpButton.png')
    jumpButton.x = display.contentCenterX * 1.7
    jumpButton.y = display.contentHeight - 200
    jumpButton.id = 'jump button'

    -- Loading element for our character
    -- Idle
    local sheetOptionIdle = require('assets.spritesheets.ninjaBoy.ninjaBoyIdle')
    local sheetIdleNinja = graphics.newImageSheet('./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png', sheetOptionIdle:getSheet())

    -- Run
    local sheetOptionRun = require('assets.spritesheets.ninjaBoy.ninjaBoyRun')
    local sheetRunNinja = graphics.newImageSheet('./assets/spritesheets/ninjaBoy/ninjaBoyRun.png', sheetOptionRun:getSheet())

    -- Jump
    local sheetOptionJump = require('assets.spritesheets.ninjaBoy.ninjaBoyJump')
    local sheetJumpNinja = graphics.newImageSheet('./assets/spritesheets/ninjaBoy/ninjaBoyJump.png', sheetOptionJump:getSheet())


    -- Sequence data ninja
    local sequence_data_ninja = {
        { 
            name = 'idle',
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetIdleNinja
        },
        {
            name = 'run',
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 0,
            sheet = sheetRunNinja
        },
        {
            name = 'jump',
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 1,
            sheet = sheetJumpNinja
        }
    }

    -- Initiation of ninja's movement
    ninja = display.newSprite(sheetIdleNinja, sequence_data_ninja)
    ninja.x = display.contentCenterX * 0.5
    ninja.y = display.contentCentery
    ninja.id = 'ninja'
    physics.addBody(ninja, 'dynamic', {
        friction = 0.5,
        bounce = 0.1
        })
    ninja.isFixedRotation = true
    ninja.sequence = 'idle'
    ninja:setSequence('idle')
    ninja:play()

    -- Insert elements
    sceneGroup:insert(map)
    sceneGroup:insert(ninja)
    sceneGroup:insert(rightArrow)
    sceneGroup:insert(shootButton)
    sceneGroup:insert(jumpButton)

    -- Function to make the character change image sheet
    function rightArrow:touch(event)
        if (event.phase == 'began') then
            if (ninja.sequence ~= 'run') then 
                ninja.sequence = 'run'
                ninja:setSequence('run')
                ninja:play()
            end
        elseif (event.phase == 'ended') then
            if (ninja.sequence ~= 'idle') then
                ninja.sequence = 'idle'
                ninja:setSequence('idle')
                ninja:play()
            end
        end
        return true 
    end

    -- function to make the character jump
    function jumpButton:touch(event)
        if (event.phase == 'began') then 
            if (ninja.sequence ~= 'jump') then 
                ninja.sequence = 'jump'
                ninja:setSequence('jump')
                ninja:play()
                ninja:setLinearVelocity(0, 2000)
            end
        end
    end

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        rightArrow:addEventListener('touch', rightArrow)
        jumpButton:addEventListener('touch', jumpButton)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("enterFrame", moveNinja)
    
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        rightArrow:addEventListener('touch', rightArrow)
        Runtime:addEventListener('enterFrame', moveNinja)
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
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

-- Important Variables for the scene
local map = nil
local ninja = nil
local rightArrow = nil
local shootButton = nil
local jumpButton = nil
local playerKunais = {}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
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

    -- Load Nija

    -- Insert elements
    sceneGroup:insert(map)
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
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
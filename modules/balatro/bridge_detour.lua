-- This script acts as a drop-in replacement for the native love.platform module,
-- providing a Lua-based implementation for a standard Linux environment.
-- It should be required once at the start of the game.

love.platform = love.platform or {}

-- The game is hardcoded to use these enum values
local FileOperationStatus = {
  SUCCESS = 0,
  FETCH_ERROR = 1,
  CLOUD_SAVE_ERROR = 2,
  CONFLICT = 3,
  OFFLINE = 4,
  LOAD_ERROR = 5,
  NOT_FOUND = 6
}

local load_game_callback
local save_game_callback
local platform_status_callback
local save_initialized_callback

----------------------------------------------------------------------
-- Lifecycle Management
----------------------------------------------------------------------
function love.platform.earlyInit()
  -- No-op in this implementation.
end

function love.platform.init(onInitSuccess, onInitFailure)
  love.filesystem.setIdentity('balatro')
  print("Bridge: Filesystem identity set to 'balatro'.")

  if onInitSuccess then
    onInitSuccess(love.system.getOS(), love.platform.getLocalPlayerName())
  end
  return true
end

function love.platform.update(dt)
  -- No-op for platform-specific updates.
end

function love.platform.shutdown()
  print("Bridge: Shutdown.")
end

----------------------------------------------------------------------
-- Platform & Player Information
----------------------------------------------------------------------
function love.platform.getPlatformId()
  return love.system.getOS()
end

function love.platform.getLocalPlayerName()
  return os.getenv("USER") or os.getenv("LOGNAME") or "Player"
end

function love.platform.getLocalPlayerAvatar()
  return nil
end

function love.platform.isPremium()
  return true
end

function love.platform.isArcade()
  return false
end

function love.platform.isFirstTimePlaying()
  return not love.platform.saveGameExists('1', 'profile.jkr')
end

function love.platform.isOffline()
  return true
end

function love.platform.getNotchPosition()
  return nil
end

----------------------------------------------------------------------
-- Filesystem Operations
----------------------------------------------------------------------

-- Different builds use different file APIs; therefore, we implement both the
-- thin wrapper around the framework's filesystem module and the more complex
-- signatures with individual save slots.
love.platform.localGetInfo = love.filesystem.getInfo
love.platform.localRead = love.filesystem.read
love.platform.localWrite = love.filesystem.write
love.platform.localRemove = love.filesystem.remove
love.platform.localCreateDirectory = love.filesystem.createDirectory

-- some versions store their settings files in `common/`
love.filesystem.getInfo = function (filename, ...)
  local info = love.platform.localGetInfo(filename, ...)

  if not info then
    info = love.platform.localGetInfo("common/" .. filename, ...)
  end

  return info
end

love.filesystem.read = function (filename, ...)
  local content, size = love.platform.localRead(filename, ...)

  if not content then
    content, size = love.platform.localRead("common/" .. filename, ...)
  end

  return content, size
end

function love.platform.writeSaveGame(profile, filename, data)
  local dir = tostring(profile)
  if not love.platform.localGetInfo(dir) then
    love.platform.localCreateDirectory(dir)
  end
  local path = table.concat({dir, filename}, "/")
  return love.platform.localWrite(path, data)
end

function love.platform.loadSaveGame(profile, filename)
  local path = table.concat({tostring(profile), filename}, "/")
  return love.platform.localRead(path)
end

function love.platform.saveGameExists(profile, filename)
  local path = table.concat({tostring(profile), filename}, "/")
  return love.platform.localGetInfo(path) ~= nil
end

function love.platform.deleteSaveGameFile(profile, filename)
  local path = table.concat({tostring(profile), filename}, "/")
  return love.platform.localRemove(path)
end

function love.platform.deleteSaveGame(profile)
  return love.platform.localRemove(tostring(profile))
end

----------------------------------------------------------------------
-- Asynchronous Callbacks & Handlers
----------------------------------------------------------------------

function love.platform.setOnPlatformStatusChangedCallback(callback)
  -- Assume always offline, as we don't implement cloud features.
  if callback then
    callback(false, "offline")
  end
end

function love.platform.setOnSaveInitializedCallback(callback)
  if callback then
    callback()
  end
end

function love.platform.setLoadGameCallback(callback)
  load_game_callback = callback
end

function love.platform.loadGameFile(filename)
  local content, size = love.filesystem.read(filename)

  if load_game_callback then
    if content then
      load_game_callback(filename, FileOperationStatus.SUCCESS, "", content, nil, nil)
    else
      load_game_callback(filename, FileOperationStatus.NOT_FOUND, "File not found", nil, nil, nil)
    end
  end
end

function love.platform.setSaveGameCallback(callback)
  save_game_callback = callback
end

function love.platform.saveGameFile(filename, data)
  local success, msg = love.filesystem.write(filename, data)
  if save_game_callback then
    if success then
      save_game_callback(filename, FileOperationStatus.SUCCESS, "", data, nil, nil)
    else
      save_game_callback(filename, FileOperationStatus.CLOUD_SAVE_ERROR, msg, nil, nil, nil)
    end
  end
end

-- These are no-ops because we call the callbacks immediately (synchronously).
function love.platform.runLoadGameCallbacks() end
function love.platform.runSaveGameCallbacks() end

function love.platform.resolveConflict(file, content, conflictId)
  -- No-op for Linux, assume local is authoritative.
  print("Bridge: resolveConflict called, but this is a no-op on Linux.")
end

----------------------------------------------------------------------
-- Achievements & Awards
----------------------------------------------------------------------
function love.platform.unlockAchievement(achievementId)
  love.filesystem.append(
    "unlock_awards.lua",
    string.format("love.platform.unlockAchievement(%q)\n", achievementId)
  )

  print(
    string.format(
      "[%s] Achievement Unlocked: %s",
      os.date("%Y-%m-%d %H:%M:%S"),
      tostring(achievementId)
    )
  )
end

function love.platform.unlockAward(awardName)
  love.filesystem.append(
    "unlock_awards.lua",
    string.format("love.platform.unlockAward(%q)\n", awardName)
  )

  print(
    string.format(
      "[%s] Award Unlocked: %s",
      os.date("%Y-%m-%d %H:%M:%S"),
      tostring(awardName)
    )
  )
end

----------------------------------------------------------------------
-- Miscellaneous & Stubbed Functions
----------------------------------------------------------------------

function love.platform.event(name, ...)
  print("Analytics Event: " .. name)
end

function love.platform.authenticateLocalPlayer() end
function love.platform.requestReview() end
function love.platform.hideSplashScreen() end
function love.platform.anyButtonPressed() return false end
function love.platform.requestTrackingPermission() end
function love.platform.setProfileButtonActive(active) end

print("Linux bridge loaded.")

----------------------------------------------------------------------
-- Module Registration
-- Make this bridge available to any subsequent `require "love.platform"` calls.
----------------------------------------------------------------------
package.loaded["love.platform"] = love.platform

if love.graphics then
  if love.graphics.isActive and not love.graphics.checkActive then
    love.graphics.checkActive = love.graphics.isActive
  end

  love.graphics.beginFrame = love.graphics.beginFrame or function() end
end

UIEditableMap = extends(UIMap)

function UIEditableMap:doRender(thing, pos)
  -- TODO: Return false if there's already that item on top stackpos
  if not thing then
    return false
  end

  if g_keyboard.isCtrlPressed() then
    g_map.removeThing(thing)
  end

  g_map.addThing(thing, pos, thing:isItem() and -1 or 4)
  return true
end

function UIEditableMap:resolve(pos)
  -- if not _G["currentWidget"] then return false end

  local thing = _G["currentThing"]
  if type(thing) == 'string' then -- Creatures
    local spawn = g_creatures.getSpawn(pos)
    if spawn then
      spawn:addCreature(pos, g_creatures.getCreatureByName(thing))
    else
      local spawn = g_creatures.addSpawn(pos, 5)
      spawn:addCreature(pos, g_creatures.getCreatureByName(thing))
    end
    return true
  elseif type(thing) == 'number' then -- Items
    local actualTool = _G["currentTool"].id
    local itemType = g_things.findItemTypeByClientId(thing)
    if not itemType then return false end
    
    if actualTool == ToolMouse then return false
    elseif actualTool == ToolPencil then
      return self:doRender(Item.createOtb(itemType:getServerId()), pos)
    end
  end
  return false
end

function handlerMousePress(self, mousePos, button)
  local pos = self:getPosition(mousePos)
  if not pos then
    return false
  end
  
  if g_keyboard.isCtrlPressed() then
    return g_map.removeThingByPos(pos)
  end
  
  if button == MouseRightButton or button == MouseLeftButton then
    return self:resolve(pos)
  end
end

--[[function UIEditableMap:onMousePress(mousePos, button)
    handlerMousePress(self, mousePos, button)
end]]

-- Mesen 2 probe: replace system-font tile 5 with a solid 2bpp tile.
-- The game uploads the system font at VRAM $4000 (word address $2000).

local function write_vram_word_address(address)
  emu.write(0x2116, address & 0xFF, emu.memType.snesMemory)
  emu.write(0x2117, (address >> 8) & 0xFF, emu.memType.snesMemory)
end

local function patch_font_tile()
  -- Tile 5 starts at byte offset $50, or VRAM word address $2028.
  write_vram_word_address(0x2028)
  for _ = 1, 8 do
    emu.write(0x2118, 0xFF, emu.memType.snesMemory)
    emu.write(0x2119, 0xFF, emu.memType.snesMemory)
  end
end

emu.addEventCallback(patch_font_tile, emu.eventType.endFrame)

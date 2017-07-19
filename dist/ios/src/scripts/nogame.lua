--[[
Copyright (c) 2006-2016 LOVE Development Team

This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
--]]

-- Make sure love exists.
local love = require("love")

function love.nogame()
	local math = math

	-- 30log.lua begins
	local function require_30log()
	local assert, pairs, type, tostring, setmetatable = assert, pairs, type, tostring, setmetatable
	local baseMt, _instances, _classes, _class = {}, setmetatable({},{__mode='k'}), setmetatable({},{__mode='k'})
	local function assert_class(class, method) assert(_classes[class], ('Wrong method call. Expected class:%s.'):format(method)) end
	local function deep_copy(t, dest, aType) t = t or {}; local r = dest or {}
	  for k,v in pairs(t) do
	    if aType and type(v)==aType then r[k] = v elseif not aType then
	      if type(v) == 'table' and k ~= "__index" then r[k] = deep_copy(v) else r[k] = v end
	    end
	  end; return r
	end
	local function instantiate(self,...)
	  assert_class(self, 'new(...) or class(...)'); local instance = {class = self}; _instances[instance] = tostring(instance); setmetatable(instance,self)
	  if self.init then if type(self.init) == 'table' then deep_copy(self.init, instance) else self.init(instance, ...) end; end; return instance
	end
	local function extend(self, name, extra_params)
	  assert_class(self, 'extend(...)'); local heir = {}; _classes[heir] = tostring(heir); deep_copy(extra_params, deep_copy(self, heir));
	  heir.name, heir.__index, heir.super = extra_params and extra_params.name or name, heir, self; return setmetatable(heir,self)
	end
	baseMt = { __call = function (self,...) return self:new(...) end, __tostring = function(self,...)
	  if _instances[self] then return ("instance of '%s' (%s)"):format(rawget(self.class,'name') or '?', _instances[self]) end
	  return _classes[self] and ("class '%s' (%s)"):format(rawget(self,'name') or '?',_classes[self]) or self
	end}; _classes[baseMt] = tostring(baseMt); setmetatable(baseMt, {__tostring = baseMt.__tostring})
	local class = {isClass = function(class, ofsuper) local isclass = not not _classes[class]; if ofsuper then return isclass and (class.super == ofsuper) end; return isclass end, isInstance = function(instance, ofclass) 
	    local isinstance = not not _instances[instance]; if ofclass then return isinstance and (instance.class == ofclass) end; return isinstance end}; _class = function(name, attr)
	  local c = deep_copy(attr); c.mixins=setmetatable({},{__mode='k'}); _classes[c] = tostring(c); c.name, c.__tostring, c.__call = name or c.name, baseMt.__tostring, baseMt.__call
	  c.include = function(self,mixin) assert_class(self, 'include(mixin)'); self.mixins[mixin] = true; return deep_copy(mixin, self, 'function') end
	  c.new, c.extend, c.__index, c.includes = instantiate, extend, c, function(self,mixin) assert_class(self,'includes(mixin)') return not not (self.mixins[mixin] or (self.super and self.super:includes(mixin))) end
	  c.extends = function(self, class) assert_class(self, 'extends(class)') local super = self; repeat super = super.super until (super == class or super == nil); return class and (super == class) end
	    return setmetatable(c, baseMt) end; class._DESCRIPTION = '30 lines library for object orientation in Lua'; class._VERSION = '30log v1.0.0'; class._URL = 'http://github.com/Yonaba/30log'; class._LICENSE = 'MIT LICENSE <http://www.opensource.org/licenses/mit-license.php>'
	return setmetatable(class,{__call = function(_,...) return _class(...) end })
	end
	-- 30log.lua ends

	local mosaic_png =
	"iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAGXRFWHRTb2Z0d2FyZQBBZG9i\
	ZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tl\
	dCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1l\
	dGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUu\
	My1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpS\
	REYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgt\
	bnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6\
	Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRv\
	YmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9u\
	cy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRp\
	ZDo2NDY3ODU2OTk0NkJFNTExQTg3RkQ3MTNCOTc2N0UzNyIgeG1wTU06RG9jdW1lbnRJRD0i\
	eG1wLmRpZDo5ODkwN0RFRTg3RUExMUU1QTRBMTk2NDJEQUYyRkUwNyIgeG1wTU06SW5zdGFu\
	Y2VJRD0ieG1wLmlpZDo5ODkwN0RFRDg3RUExMUU1QTRBMTk2NDJEQUYyRkUwNyIgeG1wOkNy\
	ZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJp\
	dmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjBGQTIzQUI1RTc4N0U1MTFBNDUy\
	ODc2NjFDRjM3OTIwIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjY0Njc4NTY5OTQ2QkU1\
	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\
	"

	local mosaic_2x_png =
	"iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAAGXRFWHRTb2Z0d2FyZQBBZG9i\
	ZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tl\
	dCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1l\
	dGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUu\
	My1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpS\
	REYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgt\
	bnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6\
	Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRv\
	YmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9u\
	cy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRp\
	ZDo2NDY3ODU2OTk0NkJFNTExQTg3RkQ3MTNCOTc2N0UzNyIgeG1wTU06RG9jdW1lbnRJRD0i\
	eG1wLmRpZDo2MUE5QkRBODg3RkMxMUU1OTRCREE0MUFFRjY2QUZCQyIgeG1wTU06SW5zdGFu\
	Y2VJRD0ieG1wLmlpZDo2MUE5QkRBNzg3RkMxMUU1OTRCREE0MUFFRjY2QUZCQyIgeG1wOkNy\
	ZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJp\
	dmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkIyQjY0ODJDRkM4N0U1MTFBNDUy\
	ODc2NjFDRjM3OTIwIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjY0Njc4NTY5OTQ2QkU1\
	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\
	"

	local toast_back_png =
	"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\
	RU5ErkJggg==\
	"
	local toast_eyes_closed_png =
	"iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAB3UlEQVR4nO3cMU4VURhA4X/A\
	2oIFyILA1sZlsABwAWyEVihYjpaWtiY8mqfEECnnmpzvSyaZ5Db/zD2ZyTSzHQ6Hoetk9QCs\
	JYA4AcQJIE4AcQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA\
	4gQQJ4A4AcQJIE4AcQKIE0CcAOIEECeAOAHECSBOAHECiHu3eoCSm8vzt9fvv+00yYvdA9i2\
	7c/59cWHv9a+PHzfe5xdHa/348xczczPmXk/M79m5sfMfF4x064B3Fyev9r0mTmdmcPMPO05\
	y0Jfj8d/YcUr4G5mzo7nvzf9dmYeF8yyq7eecKv+2LoigE//WvDb2v1tbnqbz8A4AcQJIE4A\
	cQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA4gQQJ4A4AcQJ\
	IE4AcQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA4gQQJ4A4\
	AcQJIE4AcQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA4gQQ\
	J4A4AcQJIE4AcQKIE0CcAOIEECeAOAHECSDuGds2Io/iw+DXAAAAAElFTkSuQmCC\
	"
	local toast_eyes_open_png =
	"iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAACHUlEQVR4nO3cMU5UYRhG4TPG\
	DegGVCq3YFgACSHU9nYuAkJs6AyFBS0FHTRQuBCtjImbIHQMBSROCMZuPsI5TzU3U8xbnPvP\
	zRSzWC6XxOvF9IDMKgC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsA\
	uQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuZfTA0z2d97+\
	872Dyz9r27GqE2D9XgHfgRvgN/BhcsxaT4CneAcM2AO27l9vAKfAu6kxEyfAa+ArcAF8BhYD\
	GyZtPLh+M7Li3sQzwCl/74Ad7gL4NrBjyhmwu3J9PjUEZgLYeuTaFMAJcAVsA7+Ao8kxE18B\
	P/9z/WytPOecAZ+AQ+B6ag/MnAAfgWPgPXAJfBnYMOapPexOBPAD2Bz43Dxi0b+Fu/VDkFwB\
	yBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBc\
	AcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWA\
	XAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgV\
	gFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWA3C2ytyc6Pw+oOAAAAABJRU5E\
	rkJggg==\
	"
	local toast_front_png =
	"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\
	JEBwJEBw/gUUgiKM2bt1ygAAAABJRU5ErkJggg==\
	"
	local toast_mouth_png =
	"iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAACO0lEQVR4nO3cP2oVURhA8RNJ\
	o+ICAiJWVoqFm7BIkTaF4DYsRNyKYGUrpBBSZweChYSkTBqx8w/PIgmYKnmPebzhnvMrh7nw\
	DXNmGG4xW4vFgnjd2fQA2awCkCsAuQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuQKQ\
	KwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkCkCsAuQKQKwC5ApArALkC\
	kCsAuQKQKwC57U0PsC7vdh+vvPb95+PJ5pi7rRF/FfvfzX8APAEeAveBu5fHriyAH8AZcAJ8\
	Bf6AJ4Jh3wDAPvCB5a7xBHgBnK9lohka+RvgDcsH/gh4Pf0o8zVyAM9WXPd00ilmbuQAfq64\
	7tekU8zcyAEcrLjucNIpZm7kAN6y/FvgCPi0hllma+QAvgEvgdNbnv8F2AX+rm2iGRpyHwCu\
	7QXcA14Be8BzYOfy+G/gOxdP/UcuAgA8ewAwcACw/G6g6cZfGTqA3Gzkb4DcQgHIFYBcAcgV\
	gFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHI\
	FYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwB\
	yBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBcAcgVgFwByBWAXAHIFYBc\
	AcgVgFwByBWAXAHI/QPwhzWTvXo9agAAAABJRU5ErkJggg==\
	"

	local class = require_30log()

	local Toast = class("Toast")

	function Toast:init()
		self:center()

		self.eyes = {}
		self.eyes.closed_t = 0
		self.eyes.blink_t = 2

		self.look = {}
		self.look.target = { x = 0.2,  y = 0.2 }
		self.look.current = { x = 0.2,  y = 0.2 }
		self.look.DURATION = 0.5
		self.look.POINTS = {
			{ x = 0.8, y = 0.8 },
			{ x = 0.1, y = 0.1 },
			{ x = 0.8, y = 0.1 },
			{ x = 0.1, y = 0.8 },
		}
		self.look.point = 0
		self.look.point_t = 1
		self.look.t = 0
	end

	local function easeOut(t, b, c, d)
		t = t / d - 1
		return c * (math.pow(t, 3) + 1) + b
	end

	function Toast:center()
		local ww, wh = love.window.fromPixels(love.graphics.getDimensions())
		self.x = math.floor(ww / 2 / 32) * 32 + 16
		self.y = math.floor(wh / 2 / 32) * 32 + 16
	end

	function Toast:get_look_coordinates()
		local t = self.look.t

		local src = self.look.current
		local dst = self.look.target

		local look_x = easeOut(t, src.x, dst.x - src.x, self.look.DURATION)
		local look_y = easeOut(t, src.y, dst.y - src.y, self.look.DURATION)

		return look_x, look_y
	end

	function Toast:update(dt)
		self.look.t = math.min(self.look.t + dt, self.look.DURATION)
		self.eyes.closed_t = math.max(self.eyes.closed_t - dt, 0)
		self.eyes.blink_t = math.max(self.eyes.blink_t - dt, 0)
		self.look.point_t = math.max(self.look.point_t - dt, 0)

		if self.eyes.blink_t == 0 then
			self:blink()
		end

		if self.look.point_t == 0 then
			self:look_at_next_point()
		end

		local look_x, look_y = self:get_look_coordinates()

		self.offset_x = look_x * 4
		self.offset_y = (1 - look_y) * -4
	end

	function Toast:draw()
		local x = self.x
		local y = self.y

		local look_x, look_y = self:get_look_coordinates()

		love.graphics.draw(g_images.toast.back, x, y, self.r, 1, 1, 64, 64)
		love.graphics.draw(g_images.toast.front, x + self.offset_x, y + self.offset_y, self.r, 1, 1, 64, 64)
		love.graphics.draw(self:get_eyes_image(), x + self.offset_x * 2.5, y + self.offset_y * 2.5, self.r, 1, 1, 64, 64)
		love.graphics.draw(g_images.toast.mouth, x + self.offset_x * 2, y + self.offset_y * 2, self.r, 1, 1, 64, 64)
	end

	function Toast:get_eyes_image()
		if self.eyes.closed_t > 0 then
			return g_images.toast.eyes.closed
		end
		return g_images.toast.eyes.open
	end

	function Toast:blink()
		if self.eyes.closed_t > 0 then
			return
		end
		self.eyes.closed_t = 0.1
		self.eyes.blink_t = self.next_blink()
	end

	function Toast:next_blink()
		return 5 + love.math.random(0, 3)
	end

	function Toast:look_at(tx, ty)
		local look_x, look_y = self:get_look_coordinates()
		self.look.current.x = look_x
		self.look.current.y = look_y

		self.look.t = 0
		self.look.point_t = 3 + love.math.random(0, 1)

		self.look.target.x = tx
		self.look.target.y = ty
	end

	function Toast:look_at_next_point()
		self.look.point = self.look.point + 1
		if self.look.point > #self.look.POINTS then
			self.look.point = 1
		end
		local point = self.look.POINTS[self.look.point]
		self:look_at(point.x, point.y)
	end

	local Mosaic = class("Mosaic")

	function Mosaic:init()
		local mosaic_image = g_images.mosaic[1]

		local sw, sh = mosaic_image:getDimensions()
		local ww, wh = love.window.fromPixels(love.graphics.getDimensions())

		if love.window.getPixelScale() > 1 then
			mosaic_image = g_images.mosaic[2]
		end

		local SIZE_X = math.floor(ww / 32 + 2)
		local SIZE_Y = math.floor(wh / 32 + 2)
		local SIZE = SIZE_X * SIZE_Y

		self.batch = love.graphics.newSpriteBatch(mosaic_image, SIZE, "stream")
		self.pieces = {}
		self.color_t = 1
		self.generation = 1

		local COLORS = {}

		for _,color in ipairs({
			{ 240, 240, 240 }, -- WHITE (ish)
			{ 232, 104, 162}, -- PINK
			{ 69, 155, 168 }, -- BLUE
			{ 67, 93, 119 }, -- DARK BLUE
		}) do
			table.insert(COLORS, color)
			table.insert(COLORS, color)
		end

		-- Insert only once. This way it appears half as often.
		table.insert(COLORS, { 220, 239, 113 }) -- LIME

		-- When using the higher-res mosaic sprite sheet, we want to draw its
		-- sprites at the same scale as the regular-resolution one, because
		-- we'll globally love.graphics.scale *everything* by the screen's
		-- pixel density ratio.
		-- We can avoid a lot of Quad scaling by taking advantage of the fact
		-- that Quads use normalized texture coordinates internally - if we use 
		-- the 'source image size' and quad size of the @1x image for the Quads
		-- even when rendering them using the @2x image, it will automatically
		-- scale as expected.
		local QUADS = {
			love.graphics.newQuad(0,  0,  32, 32, sw, sh),
			love.graphics.newQuad(0,  32, 32, 32, sw, sh),
			love.graphics.newQuad(32, 32, 32, 32, sw, sh),
			love.graphics.newQuad(32, 0,  32, 32, sw, sh),
		}

		local exclude_left = math.floor(ww / 2 / 32)
		local exclude_right = exclude_left + 3
		local exclude_top = math.floor(wh / 2 / 32)
		local exclude_bottom = exclude_top + 3
		local exclude_width = exclude_right - exclude_left + 1
		local exclude_height = exclude_bottom - exclude_top + 1
		local exclude_area = exclude_width * exclude_height

		local exclude_center_x = exclude_left + 1.5
		local exclude_center_y = exclude_top + 1.5

		self.generators = {
			function(piece, generation)
				return COLORS[love.math.random(1, #COLORS)]
			end,
			function(piece, generation)
				return COLORS[1 + (generation + piece.grid_x - piece.grid_y) % #COLORS]
			end,
			function(piece, generation)
				return COLORS[1 + (piece.grid_x + generation) % #COLORS]
			end,
			function(piece, generation)
				local len = generation + math.sqrt(piece.grid_x ^ 2 + piece.grid_y ^ 2)
				return COLORS[1 + math.floor(len) % #COLORS]
			end,
			function(piece, generation)
				local dx = piece.grid_x - exclude_center_x
				local dy = piece.grid_y - exclude_center_y
				local len = generation - math.sqrt(dx ^ 2 + dy ^ 2)
				return COLORS[1 + math.floor(len) % #COLORS]
			end,
			function(piece, generation)
				local dx = math.abs(piece.grid_x - exclude_center_x) - generation
				local dy = math.abs(piece.grid_y - exclude_center_y) - generation
				return COLORS[1 + math.floor(math.max(dx, dy)) % #COLORS]
			end,
		}

		self.generator = self.generators[1]

		local EXCLUDE = {}
		for y = exclude_top,exclude_bottom do
			EXCLUDE[y]  = {}
			for x = exclude_left,exclude_right do
				EXCLUDE[y][x] = true
			end
		end

		for y = 1,SIZE_Y do
			for x = 1,SIZE_X do
				if not EXCLUDE[y] or not EXCLUDE[y][x] then
					local piece = {
						grid_x = x,
						grid_y = y,
						x = (x - 1) * 32,
						y = (y - 1) * 32,
						r = love.math.random(0, 100) / 100 * math.pi,
						rv = 1,
						color = {},
						quad = QUADS[(x + y) % 4 + 1]
					}

					piece.color.prev = self.generator(piece, self.generation)
					piece.color.next = piece.color.prev
					table.insert(self.pieces, piece)
				end
			end
		end

		local GLYPHS = {
			N = love.graphics.newQuad(0,  64, 32, 32, sw, sh),
			O = love.graphics.newQuad(32, 64, 32, 32, sw, sh),
			G = love.graphics.newQuad(0,  96, 32, 32, sw, sh),
			A = love.graphics.newQuad(32, 96, 32, 32, sw, sh),
			M = love.graphics.newQuad(64, 96, 32, 32, sw, sh),
			E = love.graphics.newQuad(96, 96, 32, 32, sw, sh),

			U = love.graphics.newQuad(64, 0,  32, 32, sw, sh),
			P = love.graphics.newQuad(96, 0,  32, 32, sw, sh),
			o = love.graphics.newQuad(64, 32, 32, 32, sw, sh),
			S = love.graphics.newQuad(96, 32, 32, 32, sw, sh),
			R = love.graphics.newQuad(64, 64, 32, 32, sw, sh),
			T = love.graphics.newQuad(96, 64, 32, 32, sw, sh),
		}

		local INITIAL_TEXT_COLOR = { 240, 240, 240 }

		local put_text = function(str, offset, x, y)
			local idx = offset + SIZE_X * y + x
			for i = 1, #str do
				local c = str:sub(i, i)
				if c ~= " " then
					local piece = self.pieces[idx + i]
					if piece then
						piece.quad = GLYPHS[c]
						piece.r = 0
						piece.rv = 0
						piece.color.prev = INITIAL_TEXT_COLOR
						piece.color.next = INITIAL_TEXT_COLOR
					end
				end
			end
		end

		local text_center_x = math.floor(ww / 2 / 32)

		local no_game_text_offset = SIZE_X * exclude_bottom - exclude_area
		put_text("No GAME", no_game_text_offset, text_center_x - 2, 1)

		put_text("SUPER TOAST", 0, text_center_x - 4, exclude_top - 3)
	end

	function Mosaic:addGeneration()
		self.generation = self.generation + 1
		if self.generation % 5 == 0 then
			if love.math.random(0, 100) < 60 then
				self.generator = self.generators[love.math.random(2, #self.generators)]
			else
				self.generator = self.generators[1]
			end
		end
	end

	function Mosaic:update(dt)
		self.color_t = math.max(self.color_t - dt, 0)
		local change_color = self.color_t == 0
		if change_color then
			self.color_t = 1
			self:addGeneration()
		end
		local gen = self.generator
		for idx,piece in ipairs(self.pieces) do
			piece.r = piece.r + piece.rv * dt
			if change_color then
				piece.color.prev = piece.color.next
				piece.color.next = gen(piece, self.generation)
			end
		end
	end

	function Mosaic:draw()
		self.batch:clear()
		love.graphics.setColor(255, 255, 255, 64)
		for idx,piece in ipairs(self.pieces) do
			local ct = 1 - self.color_t
			local c0 = piece.color.prev
			local c1 = piece.color.next
			local r = easeOut(ct, c0[1], c1[1] - c0[1], 1)
			local g = easeOut(ct, c0[2], c1[2] - c0[2], 1)
			local b = easeOut(ct, c0[3], c1[3] - c0[3], 1)

			self.batch:setColor(r, g, b)
			self.batch:add(piece.quad, piece.x, piece.y, piece.r, 1, 1, 16, 16)
		end
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.batch, 0, 0)
	end

	function love.load()
		love.graphics.setBackgroundColor(136, 193, 206)

		local function load_image(file, name)
			return love.graphics.newImage(love.filesystem.newFileData(file, name:gsub("_", "."), "base64"))
		end

		g_images = {}
		g_images.toast = {}
		g_images.toast.back = load_image(toast_back_png, "toast_back.png")
		g_images.toast.front = load_image(toast_front_png, "toast_front.png")
		g_images.toast.eyes = {}
		g_images.toast.eyes.open = load_image(toast_eyes_open_png, "toast_eyes_open.png")
		g_images.toast.eyes.closed = load_image(toast_eyes_closed_png, "toast_eyes_closed.png")
		g_images.toast.mouth = load_image(toast_mouth_png, "toast_mouth.png")

		g_images.mosaic = {}
		g_images.mosaic[1] = load_image(mosaic_png, "mosaic.png")
		g_images.mosaic[2] = load_image(mosaic_2x_png, "mosaic@2x.png")

		g_entities = {}
		g_entities.toast = Toast()
		g_entities.mosaic = Mosaic()
	end

	function love.update(dt)
		dt = math.min(dt, 1/10)
		g_entities.toast:update(dt)
		g_entities.mosaic:update(dt)
	end

	function love.draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.push()
		love.graphics.scale(love.window.getPixelScale())
		g_entities.mosaic:draw()
		g_entities.toast:draw()
		love.graphics.pop()
	end

	function love.resize(w, h)
		g_entities.mosaic = Mosaic()
		g_entities.toast:center()
	end

	function love.keypressed(key)
		if key == "escape" then
			love.event.quit()
		end
	end

	function love.keyreleased(key)
		if key == "f" then
			local is_fs = love.window.getFullscreen()
			love.window.setFullscreen(not is_fs)
		end
	end

	function love.mousepressed(x, y, b)
		local tx = x / love.graphics.getWidth()
		local ty = y / love.graphics.getHeight()
		g_entities.toast:look_at(tx, ty)
	end

	function love.mousemoved(x, y)
		if love.mouse.isDown(1) then
			local tx = x / love.graphics.getWidth()
			local ty = y / love.graphics.getHeight()
			g_entities.toast:look_at(tx, ty)
		end
	end

	local last_touch = {time=0, x=0, y=0}

	function love.touchpressed(id, x, y, pressure)
		-- Double-tap the screen (when using a touch screen) to exit.
		if #love.touch.getTouches() == 1 then
			local dist = math.sqrt((x-last_touch.x)^2 + (y-last_touch.y)^2)
			local difftime = love.timer.getTime() - last_touch.time
			if difftime < 0.3 and dist < 50 then
				if love.window.showMessageBox("Exit No-Game Screen", "", {"OK", "Cancel"}) == 1 then
					love.event.quit()
				end
			end

			last_touch.time = love.timer.getTime()
			last_touch.x = x
			last_touch.y = y
		end
	end

	function love.conf(t)
		t.title = "L\195\150VE " .. love._version .. " (" .. love._version_codename .. ")"
		t.gammacorrect = true
		t.modules.audio = false
		t.modules.sound = false
		t.modules.physics = false
		t.modules.joystick = false
		t.window.resizable = true
		t.window.highdpi = true

		if love._os == "iOS" then
			t.window.borderless = true
		end
	end
end

return love.nogame

-----------------------------------------------
-- @Desc  : 茗伊插件集UI库
-- @Author: 翟一鸣 @tinymins
-- @Date  : 2014-11-24 08:40:30
-- @Email : admin@derzh.com
-- @Last Modified by:   Webster
-- @Last Modified time: 2015-09-14 18:55:48
-----------------------------------------------
MY = MY or {}
local _MY = {
	szIniFileEditBox   = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndEditBox.ini",
	szIniFileButton    = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndButton.ini",
	szIniFileCheckBox  = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndCheckBox.ini",
	szIniFileMainPanel = MY.GetAddonInfo().szFrameworkRoot .. "ui\\MainPanel.ini",
}
local _L = MY.LoadLangPack()
---------------------------------------------------------------------
-- 本地的 UI 组件对象
---------------------------------------------------------------------
local function ApplyUIArgument(ui, tArg)
	if tArg and ui then
		if tArg.x or tArg.y       then ui:pos        (tArg.x, tArg.y  ) end
		if tArg.w or tArg.h       then ui:size       (tArg.w, tArg.h  ) end
		if tArg.anchor            then ui:anchor     (tArg.anchor     ) end
		if tArg.alpha             then ui:alpha      (tArg.alpha      ) end
		if tArg.font              then ui:font       (tArg.font       ) end -- must before color
		if tArg.color             then ui:color      (tArg.color      ) end
		if tArg.multiline         then ui:multiLine  (tArg.multiline  ) end -- must before :text()
		if tArg.text              then ui:text       (tArg.text       ) end
		if tArg.placeholder       then ui:placeholder(tArg.placeholder) end
		if tArg.group             then ui:group      (tArg.group      ) end
		if tArg.tip               then if type(tArg.tip) == 'table' then ui:tip(unpack(tArg.tip)) else ui:tip(tArg.tip) end end
		if tArg.menu              then ui:menu       (tArg.menu       ) end
		if tArg.limit             then ui:limit      (tArg.limit      ) end
		if tArg.scroll            then ui:scroll     (tArg.scroll     ) end
		if tArg.handlestyle       then ui:handleStyle(tArg.handlestyle) end
		if tArg.edittype          then ui:edittype   (tArg.edittype   ) end
		if tArg.enable ~= nil     then ui:enable     (tArg.enable     ) end
		if tArg.visible ~= nil    then ui:visible    (tArg.visible    ) end
		if tArg.image             then if type(tArg.image) == 'table' then ui:image (unpack(tArg.image)) else ui:image(tArg.image) end end
		if tArg.onscroll          then ui:scroll     (tArg.onscroll   ) end
		if tArg.onhover           then ui:hover      (tArg.onhover    ) end
		if tArg.onclick           then ui:click      (tArg.onclick    ) end
		if tArg.onlclick          then ui:lclick     (tArg.onlclick   ) end
		if tArg.onrclick          then ui:rclick     (tArg.onrclick   ) end
		if tArg.checked           then ui:check      (tArg.checked    ) end
		if tArg.oncheck           then ui:check      (tArg.oncheck    ) end
		if tArg.onchange          then ui:change     (tArg.onchange   ) end
		if tArg.autocomplete      then for _, v in ipairs(tArg.autocomplete) do ui:autocomplete(unpack(v)) end end
	end
end

-- conv raw to eles array
local function raw2ele(raw)
	-- format tab
	local _tab = { raw = raw }
	if type(tab)=="table" then for k, v in pairs(tab) do _tab[k]=v end end
	_tab.type = raw.szMyuiType or raw:GetType()
	if not _tab.txt and _tab.type == "Text"        then _tab.txt = raw end
	if not _tab.img and _tab.type == "Image"       then _tab.img = raw end
	if not _tab.chk and _tab.type == "WndCheckBox" then _tab.chk = raw end
	if not _tab.chk and _tab.type == "WndRadioBox" then _tab.chk = raw end
	if not _tab.edt and _tab.type == "WndEdit"     then _tab.edt = raw end
	if not _tab.sdw and _tab.type == "Shadow"      then _tab.sdw = raw end
	if not _tab.hdl and _tab.type == "Handle"      then _tab.hdl = raw end
	if _tab.type=="WndEditBox" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','')
		_tab.edt = _tab.edt or raw:Lookup('WndEdit_Default')
		_tab.img = _tab.img or raw:Lookup('','Image_Default')
		_tab.phd = _tab.phd or raw:Lookup('','Text_PlaceHolder')
	elseif _tab.type=="WndComboBox" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','')
		_tab.cmb = _tab.cmb or raw:Lookup('Btn_ComboBox')
		_tab.txt = _tab.txt or raw:Lookup('','Text_Default')
		_tab.img = _tab.img or raw:Lookup('','Image_Default')
	elseif _tab.type=="WndEditComboBox" or _tab.type=="WndAutocomplete" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','')
		_tab.cmb = _tab.cmb or raw:Lookup('Btn_ComboBox')
		_tab.edt = _tab.edt or raw:Lookup('WndEdit_Default')
		_tab.img = _tab.img or raw:Lookup('','Image_Default')
		_tab.phd = _tab.phd or raw:Lookup('','Text_PlaceHolder')
	elseif _tab.type=="WndScrollBox" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','Handle_Padding/Handle_Scroll')
		_tab.txt = _tab.txt or raw:Lookup('','Handle_Padding/Handle_Scroll/Text_Default')
		_tab.img = _tab.img or raw:Lookup('','Image_Default')
	elseif _tab.type=="WndFrame" then
		_tab.frm = _tab.frm or raw
		_tab.wnd = _tab.wnd or raw:Lookup("Window_Main")
		_tab.hdl = _tab.hdl or (_tab.wnd or _tab.frm):Lookup("", "")
		_tab.txt = _tab.txt or raw:Lookup("", "Text_Title")
	elseif _tab.type=="WndSliderBox" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','')
		_tab.sld = _tab.sld or raw:Lookup("WndNewScrollBar_Default")
		_tab.txt = _tab.txt or raw:Lookup('','Text_Default')
	elseif string.sub(_tab.type, 1, 3) == "Wnd" then
		_tab.wnd = _tab.wnd or raw
		_tab.hdl = _tab.hdl or raw:Lookup('','')
		_tab.txt = _tab.txt or raw:Lookup('','Text_Default')
	else _tab.itm = raw end
	return _tab
end
-------------------------------------
-- UI object class
-------------------------------------
local XGUI = class()

-- 不会玩元表 (╯‵□′)╯︵┻━┻
-- -- 设置元表，这样可以当作table调用，其效果相当于 .eles[i].raw
-- setmetatable(XGUI, {  __call = function(me, ...) return me:ctor(...) end, __index = function(t, k)
	-- if type(k) == "number" then
		-- return t.eles[k].raw
	-- elseif k=="new" then
		-- return t['ctor']
	-- end
-- end
-- , __metatable = true
-- })

-----------------------------------------------------------
-- my ui common functions
-----------------------------------------------------------
-- 获取一个窗体的所有子元素
local GetChildren = function(root)
	if not root then return {} end
	local stack = { root }  -- 初始栈
	local children = {}     -- 保存所有子元素 szTreePath => element 键值对
	while #stack > 0 do     -- 循环直到栈空
		--### 弹栈: 弹出栈顶元素
		local raw = stack[#stack]
		table.remove(stack, #stack)
		if raw:GetType()=="Handle" then
			-- 将当前弹出的Handle加入子元素表
			children[table.concat({ raw:GetTreePath(), '/Handle' })] = raw
			for i = 0, raw:GetItemCount() - 1, 1 do
				-- 如果子元素是Handle/将他压栈
				if raw:Lookup(i):GetType()=='Handle' then table.insert(stack, raw:Lookup(i))
				-- 否则压入结果队列
				else children[table.concat({table.concat({ raw:Lookup(i):GetTreePath() }), i})] = raw:Lookup(i) end
			end
		else
			-- 如果有Handle则将所有Handle压栈待处理
			local status, handle = pcall(function() return raw:Lookup('','') end) -- raw可能没有Lookup方法 用pcall包裹
			if status and handle then table.insert(stack, handle) end
			-- 将当前弹出的元素加入子元素表
			children[table.concat({ raw:GetTreePath() })] = raw
			--### 压栈: 将刚刚弹栈的元素的所有子窗体压栈
			local status, sub_raw = pcall(function() return raw:GetFirstChild() end) -- raw可能没有GetFirstChild方法 用pcall包裹
			while status and sub_raw do
				table.insert(stack, sub_raw)
				sub_raw = sub_raw:GetNext()
			end
		end
	end
	-- 因为是求子元素 所以移除第一个压栈的元素（父元素）
	children[table.concat({ root:GetTreePath() })] = nil
	return children
end

-----------------------------------------------------------
-- my ui selectors -- same as jQuery -- by tinymins --
-----------------------------------------------------------
--
-- self.ele       : ui elements table
-- selt.ele[].raw : ui element itself    -- common functions will do with this
-- self.ele[].txt : ui element text box  -- functions like Text() will do with this
-- self.ele[].img : ui element image box -- functions like LoadImage() will do with this
--
-- ui object creator
-- same as jQuery.$()
function XGUI:ctor(raw, tab)
	self.eles = self.eles or {} -- setmetatable({}, { __mode = "v" })
	if type(raw)=="table" and type(raw.eles)=="table" then
		for i = 1, #raw.eles, 1 do
			table.insert(self.eles, raw.eles[i])
		end
		self.eles = raw.eles
	else
		-- farmat raw
		if type(raw)=="string" then
			raw = Station.Lookup(raw)
		end
		if raw then
			table.insert( self.eles, raw2ele(raw) )
		end
	end
	return self
end

-- clone
-- clone and return a new class
function XGUI:clone(eles)
	self:_checksum()
	eles = eles or self.eles
	local _eles = {}
	for i = 1, #eles, 1 do
		if eles[i].raw then table.insert(_eles, raw2ele(eles[i].raw)) end
	end
	return XGUI.new({eles = _eles})
end

--  del bad eles
-- (self) _checksum()
function XGUI:_checksum()
	for i = #self.eles, 1, -1 do
		local ele = self.eles[i]
		local status, err = true, 'szType'
		if (not ele.raw) or (not ele.raw.___id) then
			status, err = false, ''
		else
			status, err = pcall(function() return ele.raw:GetType() end)
		end
		if (not status) or (err=='') then table.remove(self.eles, i) end
	end
	return self
end

-- add a ele to object
-- same as jQuery.add()
function XGUI:add(raw, tab)
	self:_checksum()
	local eles = {}
	for i = 1, #self.eles, 1 do
		table.insert(eles, self.eles[i])
	end
	-- farmat raw
	if type(raw)=="string" then
		raw = Station.Lookup(raw)
	end
	-- insert into eles
	if raw then
		table.insert(eles, raw2ele(raw, tab))
	end
	return self:clone(eles)
end

-- delete elements from object
-- same as jQuery.not()
function XGUI:del(raw)
	self:_checksum()
	local eles = {}
	for i = 1, #self.eles, 1 do
		table.insert(eles, self.eles[i])
	end
	if type(raw) == "string" then
		-- delete ele those id/class fits filter:raw
		if string.sub(raw, 1, 1) == "#" then
			raw = string.sub(raw, 2)
			if string.sub(raw, 1, 1) == "^" then
				-- regexp
				for i = #eles, 1, -1 do
					if string.find(eles[i].raw:GetName(), raw) then
						table.remove(eles, i)
					end
				end
			else
				-- normal
				for i = #eles, 1, -1 do
					if eles[i].raw:GetName() == raw then
						table.remove(eles, i)
					end
				end
			end
		elseif string.sub(raw, 1, 1) == "." then
			raw = string.sub(raw, 2)
			if string.sub(raw, 1, 1) == "^" then
				-- regexp
				for i = #eles, 1, -1 do
					if string.find((eles[i].raw.szMyuiType or eles[i].raw:GetType()), raw) then
						table.remove(eles, i)
					end
				end
			else
				-- normal
				for i = #eles, 1, -1 do
					if (eles[i].raw.szMyuiType or eles[i].raw:GetType()) == raw then
						table.remove(eles, i)
					end
				end
			end
		end
	else
		-- delete ele those treepath is the same as raw
		raw = table.concat({ raw:GetTreePath() })
		for i = #eles, 1, -1 do
			if table.concat({ eles[i].raw:GetTreePath() }) == raw then
				table.remove(eles, i)
			end
		end
	end
	return self:clone(eles)
end

-- filter elements from object
-- same as jQuery.filter()
function XGUI:filter(raw)
	self:_checksum()
	local eles = {}
	for i = 1, #self.eles, 1 do
		table.insert(eles, self.eles[i])
	end
	if type(raw) == "string" then
		-- delete ele those id/class not fits filter:raw
		if string.sub(raw, 1, 1) == "#" then
			raw = string.sub(raw, 2)
			if string.sub(raw, 1, 1) == "^" then
				-- regexp
				for i = #eles, 1, -1 do
					if not string.find(eles[i].raw:GetName(), raw) then
						table.remove(eles, i)
					end
				end
			else
				-- normal
				for i = #eles, 1, -1 do
					if eles[i].raw:GetName() ~= raw then
						table.remove(eles, i)
					end
				end
			end
		elseif string.sub(raw, 1, 1) == "." then
			raw = string.sub(raw, 2)
			if string.sub(raw, 1, 1) == "^" then
				-- regexp
				for i = #eles, 1, -1 do
					if not string.find((eles[i].raw.szMyuiType or eles[i].raw:GetType()), raw) then
						table.remove(eles, i)
					end
				end
			else
				-- normal
				for i = #eles, 1, -1 do
					if (eles[i].raw.szMyuiType or eles[i].raw:GetType()) ~= raw then
						table.remove(eles, i)
					end
				end
			end
		end
	elseif type(raw)=="nil" then
		return self
	else
		-- delete ele those treepath is not the same as raw
		raw = table.concat({ raw:GetTreePath() })
		for i = #eles, 1, -1 do
			if table.concat({ eles[i].raw:GetTreePath() }) ~= raw then
				table.remove(eles, i)
			end
		end
	end
	return self:clone(eles)
end

-- get parent
-- same as jQuery.parent()
function XGUI:parent()
	self:_checksum()
	local parent = {}
	for _, ele in pairs(self.eles) do
		parent[table.concat{ele.raw:GetParent():GetTreePath()}] = ele.raw:GetParent()
	end
	local eles = {}
	for _, raw in pairs(parent) do
		-- insert into eles
		table.insert(eles, raw2ele(raw))
	end
	return self:clone(eles)
end

-- get children
-- same as jQuery.children()
function XGUI:children(filter)
	self:_checksum()
	local child = {}
	local childHash = {}
	if type(filter)=="string" and string.sub(filter, 1, 1)=="#" and string.sub(filter, 2, 2)~="^" then
		filter = string.sub(filter, 2)
		for _, ele in pairs(self.eles) do
			local c = (ele.wnd or ele.raw):Lookup(filter)
			if c then
				table.insert(child, c)
				childHash[table.concat({ table.concat({ c:GetTreePath() }), filter })] = true
			end
		end
		local eles = {}
		for _, raw in ipairs(child) do
			-- insert into eles
			table.insert(eles, raw2ele(raw))
		end
		return self:clone(eles)
	else
		for _, ele in pairs(self.eles) do
			local raw = (ele.wnd or ele.raw)
			if raw:GetType() == "Handle" then
				for i = 0, raw:GetItemCount() - 1, 1 do
					if not childHash[table.concat({ raw:Lookup(i):GetTreePath(), i })] then
						table.insert(child, raw:Lookup(i))
						childHash[table.concat({ table.concat({ raw:Lookup(i):GetTreePath() }), i })] = true
					end
				end
			else
				-- 子handle
				local status, handle = pcall(function() return raw:Lookup('','') end) -- raw可能没有Lookup方法 用pcall包裹
				if status and handle and not childHash[table.concat{handle:GetTreePath(),'/Handle'}] then
					table.insert(child, handle)
					childHash[table.concat({handle:GetTreePath(),'/Handle'})] = true
				end
				-- 子窗体
				local status, sub_raw = pcall(function() return raw:GetFirstChild() end) -- raw可能没有GetFirstChild方法 用pcall包裹
				while status and sub_raw do
					if not childHash[table.concat{sub_raw:GetTreePath()}] then
						table.insert( child, sub_raw )
						childHash[table.concat({sub_raw:GetTreePath()})] = true
					end
					sub_raw = sub_raw:GetNext()
				end
			end
		end
		local eles = {}
		for _, raw in ipairs(child) do
			-- insert into eles
			table.insert(eles, raw2ele(raw))
		end
		return self:clone(eles):filter(filter)
	end
end

-- get child-item
function XGUI:item(filter)
	return self:hdl():children(filter)
end

-- find ele
-- same as jQuery.find()
function XGUI:find(filter)
	self:_checksum()
	local children = {}
	for _, ele in pairs(self.eles) do
		if ele.raw then for szTreePath, raw in pairs(GetChildren(ele.raw)) do
			children[szTreePath] = raw
		end end
	end
	local eles = {}
	for _, raw in pairs(children) do
		-- insert into eles
		table.insert(eles, raw2ele(raw))
	end
	return self:clone(eles):filter(filter)
end

-- filter mouse in ele
function XGUI:ptIn()
	self:_checksum()
	local eles = {}
	local xC, yC = Cursor.GetPos()
	for _, ele in pairs(self.eles) do
		if (ele.itm and ele.itm:PtInItem(xC, yC))
		or (ele.wnd and ele.wnd:PtInWindow(xC, yC)) then
			table.insert(eles, raw2ele(ele.raw))
		end
	end
	return self:clone(eles)
end

-- each
-- same as jQuery.each(function(){})
-- :each(XGUI each_self)  -- you can use 'this' to visit raw element likes jQuery
function XGUI:each(fn)
	self:_checksum()
	local eles = {}
	-- get a copy of ele list
	for _, ele in pairs(self.eles) do
		table.insert(eles, ele)
	end
	-- for each in the list call function
	for _, ele in pairs(eles) do
		local _this = this
		this = ele.raw
		local res, err = pcall(fn, self:clone({{raw = ele.raw}}))
		this = _this
		if res and err == 0 then
			break
		end
	end
	return self
end

-- eq
-- same as jQuery.eq(pos)
function XGUI:eq(pos)
	if pos then
		return self:slice(pos,pos)
	end
	return self
end

-- first
-- same as jQuery.first()
function XGUI:first()
	return self:slice(1,1)
end

-- last
-- same as jQuery.last()
function XGUI:last()
	return self:slice(-1,-1)
end

-- slice -- index starts from 1
-- same as jQuery.slice(selector, pos)
function XGUI:slice(startpos, endpos)
	self:_checksum()
	local eles = {}
	for i = 1, #self.eles, 1 do
		table.insert(eles, self.eles[i])
	end
	endpos = endpos or #eles
	if endpos < 0 then endpos = #eles + endpos + 1 end
	for i = #eles, endpos + 1, -1 do
		table.remove(eles)
	end
	if startpos < 0 then startpos = #eles + startpos + 1 end
	for i = startpos, 2, -1 do
		table.remove(eles, 1)
	end
	return self:clone(eles)
end

-- get raw
-- same as jQuery[index]
function XGUI:raw(index, key)
	self:_checksum()
	key = key or 'raw'
	local eles = self.eles
	if index < 0 then index = #eles + index + 1 end
	if index > 0 and index <= #eles then return eles[index][key] end
end

-- get ele
function XGUI:ele(index)
	self:_checksum()
	local eles, ele = self.eles, {}
	if index < 0 then index = #eles + index + 1 end
	if index > 0 and index <= #eles then
		for k, v in pairs(eles[index]) do
			ele[k] = v
		end
	end
	return ele
end

-- get frm
function XGUI:frm(index)
	self:_checksum()
	local eles = {}
	if index < 0 then index = #self.eles + index + 1 end
	if index > 0 and index <= #self.eles and self.eles[index].frm then
		table.insert(eles, { raw = self.eles[index].frm })
	end
	return self:clone(eles)
end

-- get wnd
function XGUI:wnd(index)
	self:_checksum()
	local eles = {}
	if index < 0 then index = #self.eles + index + 1 end
	if index > 0 and index <= #self.eles and self.eles[index].wnd then
		table.insert(eles, { raw = self.eles[index].wnd })
	end
	return self:clone(eles)
end

-- get item
function XGUI:itm(index)
	self:_checksum()
	local eles = {}
	if index < 0 then index = #eles + index + 1 end
	if index > 0 and index <= #self.eles and self.eles[index].itm then
		table.insert(eles, { raw = self.eles[index].itm })
	end
	return self:clone(eles)
end

-- get handle
function XGUI:hdl(index)
	self:_checksum()
	local eles = {}
	if index then
		if index < 0 then index = #eles + index + 1 end
		if index > 0 and index <= #self.eles and self.eles[index].hdl then
			table.insert(eles, { raw = self.eles[index].hdl })
		end
	else
		for _, ele in ipairs(self.eles) do
			table.insert(eles, { raw = ele.hdl })
		end
	end
	return self:clone(eles)
end

-- get count
function XGUI:count()
	self:_checksum()
	return #self.eles
end

-----------------------------------------------------------
-- my ui opreation -- same as jQuery -- by tinymins --
-----------------------------------------------------------

-- remove
-- same as jQuery.remove()
function XGUI:remove()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		if ele.fnOnDestroy then
			local status, err = pcall(function() ele.fnOnDestroy(ele.raw) end)
			if not status then
				MY.Debug({err}, "UI:remove#fnOnDestroy", MY_DEBUG.ERROR)
			end
		end
		if ele.raw:GetType() == "WndFrame" then
			Wnd.CloseWindow(ele.raw)
		elseif string.sub(ele.raw:GetType(), 1, 3) == "Wnd" then
			ele.raw:Destroy()
		else
			local h = ele.raw:GetParent()
			if h:GetType() == "Handle" then
				h:RemoveItem(ele.raw)
				h:FormatAllItemPos()
			end
		end
	end
	self.eles = {}
	return self
end

-- xml string
_MY.tItemXML = {
	["Text"] = "<text>w=150 h=30 valign=1 font=162 eventid=371 </text>",
	["Image"] = "<image>w=100 h=100 eventid=371 </image>",
	["Box"] = "<box>w=48 h=48 eventid=525311 </box>",
	["Shadow"] = "<shadow>w=15 h=15 eventid=277 </shadow>",
	["Handle"] = "<handle>firstpostype=0 w=10 h=10</handle>",
}
-- append
-- similar as jQuery.append()
-- Instance:append(szType,[ szName,] tArg)
-- Instance:append(szItemString)
function XGUI:append(szType, szName, tArg, bReturnNewItem)
	self:_checksum()
	local szXml
	assert(type(szType) == 'string')
	if type(szName) == 'table' then
		szName, tArg, bReturnNewItem = nil, szName, tArg
	elseif szType:find("%<") then
		szType, szXml, bReturnNewItem = nil, szType, szName
	elseif #szType == 0 then
		return
	end
	local ret
	if bReturnNewItem then
		ret = MY.UI()
	else
		ret = self
	end
	if szType then
		for _, ele in pairs(self.eles) do
			local ui
			if ( (ele.wnd or ele.frm) and ( string.sub(szType, 1, 3) == "Wnd" or string.sub(szType, -4) == ".ini" ) ) then
				-- append from ini file
				local szFile = szType
				if string.sub(szType, -4) == ".ini" then
					szType = string.gsub(szType,".*[/\\]","")
					szType = string.sub(szType,0,-5)
				else
					szFile = MY.GetAddonInfo().szFrameworkRoot .. "ui\\" .. szFile .. ".ini"
				end
				local frame = Wnd.OpenWindow(szFile, "MY_TempWnd")
				if not frame then
					return MY.Debug({_L("unable to open ini file [%s]", szFile)}, 'MY#UI#append', MY_DEBUG.ERROR)
				end
				local wnd = frame:Lookup(szType)
				if not wnd then
					MY.Debug({_L("can not find wnd component [%s]", szType)}, 'MY#UI#append', MY_DEBUG.ERROR)
				else
					wnd.szMyuiType = szType
					if szName then
						wnd:SetName(szName)
					end
					wnd:ChangeRelation((ele.wnd or ele.frm), true, true)
					if szType == 'WndSliderBox' then
						wnd.bShowPercentage = true
						wnd.nOffset = 0
						wnd.tMyOnChange = {}
						wnd:Lookup("WndNewScrollBar_Default").FormatText = function(value, bPercentage)
							if bPercentage then
								return string.format("%.2f%%", value)
							else
								return value
							end
						end
						wnd:Lookup("WndNewScrollBar_Default").OnScrollBarPosChanged = function()
							local fnFormat = wnd:Lookup("WndNewScrollBar_Default").FormatText
							if wnd.bShowPercentage then
								local nCurrentPercentage = this:GetScrollPos() * 100 / this:GetStepCount()
								wnd:Lookup("", "Text_Default"):SetText(fnFormat(nCurrentPercentage, true))
								for _, fn in ipairs(wnd.tMyOnChange) do
									pcall(fn, nCurrentPercentage)
								end
							else
								local nCurrentValue = this:GetScrollPos() + wnd.nOffset
								wnd:Lookup("", "Text_Default"):SetText(fnFormat(nCurrentValue, false))
								for _, fn in ipairs(wnd.tMyOnChange) do
									pcall(fn, nCurrentValue)
								end
							end
						end
						wnd:Lookup("WndNewScrollBar_Default").OnMouseWheel = function()                                   -- listening Mouse Wheel
							local nDistance = Station.GetMessageWheelDelta()            -- get distance
							wnd:Lookup("WndNewScrollBar_Default"):ScrollNext(-nDistance*2)            -- wheel scroll position
							return 1
						end
						wnd:Lookup("WndNewScrollBar_Default"):Lookup('Btn_Track').OnMouseWheel = function()               -- listening Mouse Wheel
							local nDistance = Station.GetMessageWheelDelta()            -- get distance
							wnd:Lookup("WndNewScrollBar_Default"):ScrollNext(-nDistance)            -- wheel scroll position
							return 1
						end
					elseif szType=='WndEditBox' then
						local edt = wnd:Lookup("WndEdit_Default")
						edt.OnSetFocus = function()
							wnd:Lookup("", "Text_PlaceHolder"):Hide()
						end
						edt.OnKillFocus = function()
							if wnd:Lookup("WndEdit_Default"):GetText() == "" then
								wnd:Lookup("", "Text_PlaceHolder"):Show()
							end
						end
						edt.OnEditSpecialKeyDown = function()
							local szKey = GetKeyName(Station.GetMessageKey())
							if szKey == "Esc" or (
								szKey == "Enter" and not edt:IsMultiLine()
							) then
								Station.SetFocusWindow(edt:GetRoot())
								return 1
							end
						end
					elseif szType=='WndAutocomplete' then
						local edt = wnd:Lookup("WndEdit_Default")
						edt.OnSetFocus = function()
							wnd:Lookup("", "Text_PlaceHolder"):Hide()
							-- check disabled
							if wnd.tMyAcOption.disabled or wnd.tMyAcOption.disabledTmp then
								return
							end
							MY.UI(wnd):autocomplete('search')
						end
						edt.OnEditChanged = function()
							-- disabled
							if wnd.tMyAcOption.disabled or wnd.tMyAcOption.disabledTmp or Station.GetFocusWindow() ~= this then
								return
							end
							-- placeholder
							local len = this:GetText():len()
							if len == 0 then
								wnd:Lookup("", "Text_PlaceHolder"):Show()
							else
								wnd:Lookup("", "Text_PlaceHolder"):Hide()
							end
							-- min search length
							if len >= wnd.tMyAcOption.minLength then
								-- delay search
								MY.DelayCall(function()
									MY.UI(wnd):autocomplete('search')
									-- for compatible
									Station.SetFocusWindow(edt)
								end, wnd.tMyAcOption.delay)
							else
								MY.UI(wnd):autocomplete('close')
							end
						end
						edt.OnKillFocus = function()
							if edt:GetText() == "" then
								wnd:Lookup("", "Text_PlaceHolder"):Show()
							end

							MY.DelayCall(function()
								if not Station.GetFocusWindow() or Station.GetFocusWindow():GetName() ~= 'PopupMenuPanel' then
									Wnd.CloseWindow("PopupMenuPanel")
								end
							end)
						end
						edt.OnEditSpecialKeyDown = function()
							local szKey = GetKeyName(Station.GetMessageKey())
							if IsPopupMenuOpened() and PopupMenu_ProcessHotkey then
								if szKey == "Enter"
								or szKey == "Up"
								or szKey == "Down"
								or szKey == "Left"
								or szKey == "Right" then
									return PopupMenu_ProcessHotkey(szKey)
								end
							elseif szKey == "Esc" or (
								szKey == "Enter" and not edt:IsMultiLine()
							) then
								Station.SetFocusWindow(edt:GetRoot())
								return 1
							end
						end
						wnd.tMyAcOption = {
							beforeSearch = nil  , -- @param: wnd, option
							beforePopup  = nil  , -- @param: menu, wnd, option
							beforeDelete = nil  , -- @param: szOption, fnDoDelete, option
							afterDelete  = nil  , -- @param: szOption, option

							ignoreCase   = true ,  -- ignore case while matching
							anyMatch     = true ,  -- match any part of option list
							autoFill     = false,  -- auto fill edit with first match (conflict withanyMatch)
							delay        = 0    ,  -- delay time when edit changed
							disabled     = false,  -- disable autocomplete
							minLength    = 0    ,  -- the min length of the searching string
							maxOption    = 0    ,  -- the max number of displayed options (0 means no limitation)
							source       = {}   ,  -- option list
						}
					elseif szType == 'WndRadioBox' then
						MY.UI.RegisterUIEvent(wnd, 'OnLButtonUp', function()
							local p = wnd:GetParent():GetFirstChild()
							while p do
								if p ~= wnd and
								p.group == wnd.group and
								p:GetType() == 'WndCheckBox' and
								p:IsCheckBoxChecked() then
									p:Check(false)
								end
								p = p:GetNext()
							end
						end)
					elseif szType == 'WndListBox' then
						local hScroll = wnd:Lookup('', 'Handle_Scroll')
						hScroll.OnListItemHandleMouseEnter = function()
							MY.UI(this:Lookup('Image_Bg')):fadeIn(100)
						end
						hScroll.OnListItemHandleMouseLeave = function()
							MY.UI(this:Lookup('Image_Bg')):fadeTo(500,0)
						end
						hScroll.OnListItemHandleLButtonClick = function()
							if this:GetParent().OnListItemHandleCustomLButtonClick then
								local status, err = pcall(
									this:GetParent().OnListItemHandleCustomLButtonClick,
									this.text, this.id, this.data, not this.selected
								)
								if not status then
									MY.Debug({err}, 'WndListBox#CustomLButtonClick', MY_DEBUG.ERROR)
								elseif err == false then
									return
								end
							end
							if not this.selected then
								if not hScroll.tMyLbOption.multiSelect then
									for i = hScroll:GetItemCount() - 1, 0, -1 do
										local hItem = hScroll:Lookup(i)
										if hItem.selected then
											hItem.selected = false
											hItem:Lookup('Image_Sel'):Hide()
										end
									end
								end
								this:Lookup('Image_Sel'):Show()
							else
								this:Lookup('Image_Sel'):Hide()
							end
							this.selected = not this.selected
						end
						hScroll.OnListItemHandleRButtonClick = function()
							if not this.selected then
								if not hScroll.tMyLbOption.multiSelect then
									for i = hScroll:GetItemCount() - 1, 0, -1 do
										local hItem = hScroll:Lookup(i)
										if hItem.selected then
											hItem.selected = false
											hItem:Lookup('Image_Sel'):Hide()
										end
									end
								end
								this.selected = true
								this:Lookup('Image_Sel'):Show()
							end
							if hScroll.GetListItemHandleMenu then
								PopupMenu(hScroll.GetListItemHandleMenu(this.text, this.id, this.data, this.selected))
							end
						end
						hScroll.tMyLbOption = {
							multiSelect = false,
						}
					end
					if bReturnNewItem then
						ret = ret:add(wnd)
					end
					ui = MY.UI(wnd)
				end
				Wnd.CloseWindow(frame)
			elseif ( string.sub(szType, 1, 3) ~= "Wnd" and ele.hdl ) then
				local szXml = _MY.tItemXML[szType]
				local hnd
				if szXml then
					-- append from xml
					local nCount = ele.hdl:GetItemCount()
					ele.hdl:AppendItemFromString(szXml)
					hnd = ele.hdl:Lookup(nCount)
					if hnd and szName then
						hnd:SetName(szName)
					end
				else
					-- append from ini
					hnd = ele.hdl:AppendItemFromIni("interface\\MY\\.Framework\\ui\\HandleItems.ini","Handle_" .. szType, szName)
				end
				ele.hdl:FormatAllItemPos()
				if not hnd then
					return MY.Debug({_L("unable to append handle item [%s]", szType)},'MY#UI:append', MY_DEBUG.ERROR)
				else
					if bReturnNewItem then
						ret = ret:add(hnd)
					end
					ui = MY.UI(hnd)
				end
			end
			ApplyUIArgument(ui, tArg)
		end
	elseif szXml then
		for _, ele in pairs(self.eles) do
			if ele.hdl then
				-- append from xml
				local nCount = ele.hdl:GetItemCount()
				ele.hdl:AppendItemFromString(szXml)
				ele.hdl:FormatAllItemPos()
				if bReturnNewItem then
					for i = nCount - 1, ele.hdl:GetItemCount() - 1 do
						ret = ret:add(ele.hdl:GetItem(i))
					end
				end
			end
		end
	end
	return ret
end

-- clear
-- clear handle
-- (self) Instance:clear()
function XGUI:clear()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		if ele.hdl then
			ele.hdl:Clear()
			ele.hdl:FormatAllItemPos()
		end
	end
	return self
end

-----------------------------------------------------------
-- my ui property visitors
-----------------------------------------------------------

-- data set/get
function XGUI:data(key, value)
	self:_checksum()
	if key and value then -- set name
		for _, ele in pairs(self.eles) do
			ele.raw[key] = value
		end
		return self
	elseif key then -- get
		local ele = self.eles[1]
		if ele and ele.raw then
			return ele.raw[key]
		end
	else
		return self
	end
end

-- show
function XGUI:show()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		pcall(function() ele.raw:Show() end)
		pcall(function() ele.hdl:Show() end)
	end
	return self
end

-- hide
function XGUI:hide()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		ele.raw:Hide()
		if ele.hdl then
			ele.hdl:Hide()
		end
	end
	return self
end

-- visible
function XGUI:visible(bVisiable)
	self:_checksum()
	if type(bVisiable)=='boolean' then
		return self:toggle(bVisiable)
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.IsVisible then
			return ele.raw:IsVisible()
		end
	end
end

-- enable or disable elements
function XGUI:enable(bEnable)
	self:_checksum()
	if type(bEnable)=='boolean' then
		for _, ele in pairs(self.eles) do
			local x = ele.chk or ele.wnd or ele.raw
			if x and x.Enable then
				x:Enable(bEnable)
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.IsEnabled then
			return ele.raw:IsEnabled()
		end
	end
end

-- show/hide eles
function XGUI:toggle(bShow)
	self:_checksum()
	for _, ele in pairs(self.eles) do
		if bShow == false or (bShow == nil and ele.raw:IsVisible()) then
			ele.raw:Hide()
			if ele.hdl then
				ele.hdl:Hide()
			end
		else
			ele.raw:Show()
			if ele.hdl then
				ele.hdl:Show()
			end
		end
	end
	return self
end

-- drag area
-- (self) drag(boolean bEnableDrag) -- enable/disable drag
-- (self) drag(number nX, number y, number w, number h) -- set drag positon and area
-- (self) drag(function fnOnDrag, function fnOnDragEnd)-- bind frame/item frag event handle
function XGUI:drag(nX, nY, nW, nH)
	self:_checksum()
	if type(nX) == 'boolean' then
		for _, ele in pairs(self.eles) do
			local x = ele.frm or ele.raw
			if x and x.EnableDrag then
				x:EnableDrag(nX)
			end
		end
		return self
	elseif type(nX) == 'number' or
	type(nY) == 'number' or
	type(nW) == 'number' or
	type(nH) == 'number' then
		for i = 1, #self.eles, 1 do
			local s, err =pcall(function()
				local _w, _h = self:eq(i):size()
				nX, nY, nW, nH = nX or 0, nY or 0, nW or _w, nH or _h
				self:frm(i):raw(1):SetDragArea(nX, nY, nW, nH)
			end)
		end
		return self
	elseif type(nX) == 'function' or
	type(nY) == 'function' or
	type(nW) == 'function' then
		for _, ele in pairs(self.eles) do
			if ele.frm then
				if nX then
					MY.UI.RegisterUIEvent(ele.frm, 'OnFrameDragSetPosEnd', nX)
				end
				if nY then
					MY.UI.RegisterUIEvent(ele.frm, 'OnFrameDragEnd', nY)
				end
			elseif ele.itm then
				if nX then
					MY.UI.RegisterUIEvent(ele.itm, 'OnItemLButtonDrag', nX)
				end
				if nY then
					MY.UI.RegisterUIEvent(ele.itm, 'OnItemLButtonDragEnd', nY)
				end
			end
		end
		return self
	else
		local ele = self.eles[1]
		if ele then
			local x = ele.frm or ele.raw
			if x and x.IsDragable then
				return x:IsDragable()
			end
		end
	end
end

-- get/set ui object text
function XGUI:text(szText)
	self:_checksum()
	if szText then
		for _, ele in pairs(self.eles) do
			if ele.type == "WndScrollBox" then
				ele.hdl:Clear()
				ele.hdl:AppendItemFromString(GetFormatText(szText))
				ele.hdl:FormatAllItemPos()
			elseif ele.type == "WndSliderBox" and type(szText)=="function" then
				ele.sld.FormatText = szText
			elseif ele.type == "WndEditBox" or ele.type == "WndAutocomplete" then
				ele.edt:SetText(szText)
				if szText == "" then
					ele.phd:Show()
				else
					ele.phd:Hide()
				end
			elseif ele.type == "Text" then
				ele.txt:SetText(szText)
				ele.txt:GetParent():FormatAllItemPos()
				if ele.raw.bAutoSize then
					ele.raw:AutoSize()
				end
			elseif type(szText) ~= "function" then
				local x = ele.txt or ele.edt or ele.raw
				if x and x.SetText then
					x:SetText(szText)
					local x = x:GetParent()
					if x and x.FormatAllItemPos then
						x:FormatAllItemPos()
					end
				end
			end
		end
		return self
	else
		local ele = self.eles[1]
		if ele then
			local x = ele.txt or ele.edt or ele.raw
			if x and x.GetText then
				return x:GetText()
			end
		end
	end
end

-- get/set ui object text
function XGUI:placeholder(szText)
	self:_checksum()
	if szText then
		for _, ele in pairs(self.eles) do
			if ele.phd then ele.phd:SetText(szText) end
		end
		return self
	else
		local ele = self.eles[1]
		if ele and ele.phd and ele.phd.GetText then
			return ele.phd:GetText()
		end
	end
end

-- ui autocomplete interface
function XGUI:autocomplete(method, arg1, arg2)
	self:_checksum()
	if method == 'option' and (type(arg1) == 'nil' or (type(arg1) == 'string' and type(arg2) == nil)) then -- get
		-- select the first item
		local ele = self.eles[1]
		-- try to get its option
		if ele then
			return clone(ele.raw.tMyAcOption)
		end
	else -- set
		if method == 'option' then
			if type(arg1) == 'string' then
				arg1 = {
					[arg1] = arg2
				}
			end
			if type(arg1) == 'table' then
				for _, ele in pairs(self.eles) do
					ele.raw.tMyAcOption = ele.raw.tMyAcOption or {}
					for k, v in pairs(arg1) do
						ele.raw.tMyAcOption[k] = v
					end
				end
			end
		elseif method == 'close' then
			Wnd.CloseWindow('PopupMenuPanel')
		elseif method == 'destroy' then
			for _, ele in pairs(self.eles) do
				ele.raw:Lookup("WndEdit_Default").OnSetFocus = nil
				ele.raw:Lookup("WndEdit_Default").OnKillFocus = nil
				ele.raw:Lookup("", "Text_PlaceHolder"):Hide()
			end
		elseif method == 'disable' then
			self:autocomplete('option', 'disable', true)
		elseif method == 'enable' then
			self:autocomplete('option', 'disable', false)
		elseif method == 'search' then
			for _, ele in pairs(self.eles) do
				if ele.raw.tMyAcOption then
					local option = ele.raw.tMyAcOption
					if type(option.beforeSearch) == 'function' then
						option.beforeSearch(ele.raw, option)
					end
					local keyword = arg1 or ele.raw:Lookup("WndEdit_Default"):GetText()
					keyword = MY.String.PatternEscape(keyword)
					if not option.anyMatch then
						keyword = '^' .. keyword
					end
					if option.ignoreCase then
						keyword = StringLowerW(keyword)
					end
					local tOption = {}
					-- get matched list
					for _, src in ipairs(option.source) do
						local s = src
						if option.ignoreCase then
							s = StringLowerW(src)
						end
						if string.find(s, keyword) then
							table.insert(tOption, src)
						end
					end

					-- create menu
					local menu = {}
					for _, szOption in ipairs(tOption) do
						-- max option limit
						if option.maxOption > 0 and #menu >= option.maxOption then
							break
						end
						-- create new option
						local t = {
							szOption = szOption,
							fnAction = function()
								option.disabledTmp = true
								MY.UI(ele.raw):text(szOption)
								option.disabledTmp = nil
								Wnd.CloseWindow('PopupMenuPanel')
							end,
						}
						if option.beforeDelete or option.afterDelete then
							t.szIcon = "ui/Image/UICommon/CommonPanel2.UITex"
							t.nFrame = 49
							t.nMouseOverFrame = 51
							t.nIconWidth = 17
							t.nIconHeight = 17
							t.szLayer = "ICON_RIGHTMOST"
							t.fnClickIcon = function()
								local bSure = true
								local fnDoDelete = function()
									for i=#option.source, 1, -1 do
										if option.source[i] == szOption then
											table.remove(option.source, i)
										end
									end
									MY.UI(ele.raw):autocomplete('search')
								end
								if option.beforeDelete then
									bSure = option.beforeDelete(szOption, fnDoDelete, option)
								end
								if bSure ~= false then
									fnDoDelete()
								end
								if option.afterDelete then
									option.afterDelete(szOption, option)
								end
							end
						end
						table.insert(menu, t)
					end
					local nX, nY = ele.raw:GetAbsPos()
					local nW, nH = ele.raw:GetSize()
					menu.nMiniWidth = nW
					menu.x, menu.y = nX, nY + nH
					menu.bDisableSound = true
					menu.bShowKillFocus = true

					if type(option.beforePopup) == 'function' then
						option.beforePopup(menu, ele.raw, option)
					end
					-- popup menu
					if #menu > 0 then
						option.disabledTmp = true
						PopupMenu(menu)
						Station.SetFocusWindow(ele.raw:Lookup("WndEdit_Default"))
						option.disabledTmp = nil
					else
						Wnd.CloseWindow('PopupMenuPanel')
					end
				end
			end
		elseif method == 'insert' then
			if type(arg1) == 'string' then
				arg1 = { arg1 }
			end
			if type(arg1) == 'table' then
				for _, src in ipairs(arg1) do
					if type(src) == 'string' then
						for _, ele in pairs(self.eles) do
							for i=#ele.raw.tMyAcOption.source, 1, -1 do
								 if ele.raw.tMyAcOption.source[i] == src then
									table.remove(ele.raw.tMyAcOption.source, i)
								 end
							 end
							table.insert(ele.raw.tMyAcOption.source, src)
						end
					end
				end
			end
		elseif method == 'delete' then
			if type(arg1) == 'string' then
				arg1 = { arg1 }
			end
			if type(arg1) == 'table' then
				for _, src in ipairs(arg1) do
					if type(src) == 'string' then
						for _, ele in pairs(self.eles) do
							for i=#ele.raw.tMyAcOption.source, 1, -1 do
								 if ele.raw.tMyAcOption.source[i] == arg1 then
									table.remove(ele.raw.tMyAcOption.source, i)
								 end
							 end
						end
					end
				end
			end
		end
		return self
	end
end

-- ui listbox interface
function XGUI:listbox(method, arg1, arg2, arg3, arg4)
	self:_checksum()
	if method == 'option' and (type(arg1) == 'nil' or (type(arg1) == 'string' and type(arg2) == nil)) then -- get
		-- select the first item
		local ele = self.eles[1]
		-- try to get its option
		if ele then
			return clone(ele.raw.tMyLbOption)
		end
	else -- set
		if method == 'option' then
			if type(arg1) == 'string' then
				arg1 = {
					[arg1] = arg2
				}
			end
			if type(arg1) == 'table' then
				for _, ele in pairs(self.eles) do
					ele.raw.tMyLbOption = ele.raw.tMyLbOption or {}
					for k, v in pairs(arg1) do
						ele.raw.tMyLbOption[k] = v
					end
				end
			end
		elseif method == 'select' then
			local tData = {}
			if arg1 == 'all' then
				for _, ele in pairs(self.eles) do
					if ele.type == 'WndListBox' then
						local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
						for i = 0, hScroll:GetItemCount() - 1, 1 do
							local hItem = hScroll:Lookup(i)
							table.insert(tData, { text = hItem.text, id = hItem.id, data = hItem.data, selected = hItem.selected })
						end
					end
				end
			elseif arg1 == 'unselected' then
				for _, ele in pairs(self.eles) do
					if ele.type == 'WndListBox' then
						local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
						for i = 0, hScroll:GetItemCount() - 1, 1 do
							local hItem = hScroll:Lookup(i)
							if not hItem.selected then
								table.insert(tData, { text = hItem.text, id = hItem.id, data = hItem.data, selected = hItem.selected })
							end
						end
					end
				end
			else--if arg1 == 'selected' then
				for _, ele in pairs(self.eles) do
					if ele.type == 'WndListBox' then
						local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
						for i = 0, hScroll:GetItemCount() - 1, 1 do
							local hItem = hScroll:Lookup(i)
							if hItem.selected then
								table.insert(tData, { text = hItem.text, id = hItem.id, data = hItem.data, selected = hItem.selected })
							end
						end
					end
				end
			end
			return tData
		elseif method == 'insert' then
			local text, id, data, pos = arg1, arg2, arg3, tonumber(arg4)
			for _, ele in pairs(self.eles) do
				if ele.type == 'WndListBox' then
					local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
					local bExist
					if id then
						for i = hScroll:GetItemCount() - 1, 0, -1 do
							if hScroll:Lookup(i).id == id then
								bExist = true
							end
						end
					end
					if not bExist then
						local w, h = hScroll:GetSize()
						local xml = '<handle>eventid=371 <image>w='..w..' h=25 path="UI/Image/Common/TextShadow.UITex" frame=5 alpha=0 name="Image_Bg" </image><image>w='..w..' h=25 path="UI/Image/Common/TextShadow.UITex" lockshowhide=1 frame=2 name="Image_Sel" </image><text>w='..w..' h=25 valign=1 name="Text_Default" </text></handle>'
						local hItem
						if pos then
							pos = pos - 1 -- C++ count from zero but lua count from one.
							hScroll:InsertItemFromString(pos, false, xml)
							hItem = hScroll:Lookup(pos)
						else
							hScroll:AppendItemFromString(xml)
							hItem = hScroll:Lookup(hScroll:GetItemCount() - 1)
						end
						hItem.id = id
						hItem.text = text
						hItem.data = data
						hItem:Lookup('Text_Default'):SetText(text)
						hItem.OnItemMouseEnter = hScroll.OnListItemHandleMouseEnter
						hItem.OnItemMouseLeave = hScroll.OnListItemHandleMouseLeave
						hItem.OnItemLButtonClick = hScroll.OnListItemHandleLButtonClick
						hItem.OnItemRButtonClick = hScroll.OnListItemHandleRButtonClick
						hScroll:FormatAllItemPos()
					end
				end
			end
		elseif method == 'update' then
			local text, id, data = arg1, arg2, arg3
			for _, ele in pairs(self.eles) do
				if ele.type == 'WndListBox' then
					local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
					for i = hScroll:GetItemCount() - 1, 0, -1 do
						if id and hScroll:Lookup(i).id == id then
							hScroll:Lookup(i).data = data
							hScroll:Lookup(i):Lookup('Text_Default'):SetText(text)
						end
					end
				end
			end
		elseif method == 'delete' then
			local text, id = arg1, arg2
			for _, ele in pairs(self.eles) do
				if ele.type == 'WndListBox' then
					local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
					for i = hScroll:GetItemCount() - 1, 0, -1 do
						if (id and hScroll:Lookup(i).id == id) or
						(not id and text and hScroll:Lookup(i).text == text) then
							hScroll:RemoveItem(i)
						end
					end
					hScroll:FormatAllItemPos()
				end
			end
		elseif method == 'clear' then
			for _, ele in pairs(self.eles) do
				if ele.type == 'WndListBox' then
					ele.raw:Lookup('', 'Handle_Scroll'):Clear()
				end
			end
		elseif method == 'multiSelect' then
			self:listbox('option', 'multiSelect', arg1)
		elseif method == 'onmenu' then
			if type(arg1) == 'function' then
				for _, ele in pairs(self.eles) do
					if ele.type == 'WndListBox' then
						ele.raw:Lookup('', 'Handle_Scroll').GetListItemHandleMenu = arg1
					end
				end
			end
		elseif method == 'onlclick' then
			if type(arg1) == 'function' then
				for _, ele in pairs(self.eles) do
					if ele.type == 'WndListBox' then
						ele.raw:Lookup('', 'Handle_Scroll').OnListItemHandleCustomLButtonClick = arg1
					end
				end
			end
		end
		return self
	end
end

-- get/set ui object name
function XGUI:name(szText)
	self:_checksum()
	if szText then -- set name
		for _, ele in pairs(self.eles) do
			ele.raw:SetName(szText)
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.GetName then
			return ele.raw:GetName()
		end
	end
end

-- get/set ui object group
function XGUI:group(szText)
	self:_checksum()
	if szText then -- set group
		for _, ele in pairs(self.eles) do
			ele.raw.group = szText
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw then
			return ele.raw.group
		end
	end
end

-- set ui penetrable
function XGUI:penetrable(bPenetrable)
	self:_checksum()
	if type(bPenetrable) == 'boolean' then -- set penetrable
		for _, ele in pairs(self.eles) do
			ele.raw.bPenetrable = bPenetrable
			if ele.raw.SetMousePenetrable then
				ele.raw:SetMousePenetrable(bPenetrable)
			end
			if ele.wnd and ele.wnd.SetMousePenetrable then
				ele.wnd:SetMousePenetrable(bPenetrable)
			end
		end
	end
	return self
end

-- get/set ui alpha
function XGUI:alpha(nAlpha)
	self:_checksum()
	if nAlpha then -- set name
		for _, ele in pairs(self.eles) do
			ele.raw:SetAlpha(nAlpha)
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.GetAlpha then
			return ele.raw:GetAlpha()
		end
	end
end

-- (self) Instance:fadeTo(nTime, nOpacity, callback)
function XGUI:fadeTo(nTime, nOpacity, callback)
	self:_checksum()
	if nTime and nOpacity then
		for i = 1, #self.eles, 1 do
			local ele = self:eq(i)
			local nStartAlpha = ele:alpha()
			local nStartTime = GetTime()
			local fnCurrent = function(nStart, nEnd, nTotalTime, nDuringTime)
				return ( nEnd - nStart ) * nDuringTime / nTotalTime + nStart -- 线性模型
			end
			if not ele:visible() then ele:alpha(0):toggle(true) end
			MY.BreatheCall("MY_FADE_" .. MY.UI.GetTreePath(ele:raw(1)), function()
				ele:show()
				local nCurrentAlpha = fnCurrent(nStartAlpha, nOpacity, nTime, GetTime()-nStartTime)
				ele:alpha(nCurrentAlpha)
				-- MY.Debug(string.format('%d %d %d %d\n', nStartAlpha, nOpacity, nCurrentAlpha, (nStartAlpha - nCurrentAlpha)*(nCurrentAlpha - nOpacity)), 'fade', MY_DEBUG.LOG)
				if (nStartAlpha - nCurrentAlpha)*(nCurrentAlpha - nOpacity) <= 0 then
					ele:alpha(nOpacity)
					pcall(callback, ele)
					return 0
				end
			end)
		end
	end
	return self
end

-- (self) Instance:fadeIn(nTime, callback)
function XGUI:fadeIn(nTime, callback)
	self:_checksum()
	nTime = nTime or 300
	for i = 1, #self.eles, 1 do
		self:eq(i):fadeTo(nTime, self:eq(i):data('nOpacity') or 255, callback)
	end
	return self
end

-- (self) Instance:fadeOut(nTime, callback)
function XGUI:fadeOut(nTime, callback)
	self:_checksum()
	nTime = nTime or 300
	for i = 1, #self.eles, 1 do
		local ele = self:eq(i)
		if ele:alpha() > 0 then ele:data('nOpacity', ele:alpha()) end
	end
	self:fadeTo(nTime, 0, function(ele)
		ele:toggle(false)
		pcall(callback, ele)
	end)
	return self
end

-- (self) Instance:slideTo(nTime, nHeight, callback)
function XGUI:slideTo(nTime, nHeight, callback)
	self:_checksum()
	if nTime and nHeight then
		for i = 1, #self.eles, 1 do
			local ele = self:eq(i)
			local nStartValue = ele:height()
			local nStartTime = GetTime()
			local fnCurrent = function(nStart, nEnd, nTotalTime, nDuringTime)
				return ( nEnd - nStart ) * nDuringTime / nTotalTime + nStart -- 线性模型
			end
			if not ele:visible() then ele:height(0):toggle(true) end
			MY.BreatheCall(function()
				ele:show()
				local nCurrentValue = fnCurrent(nStartValue, nHeight, nTime, GetTime()-nStartTime)
				ele:height(nCurrentValue)
				-- MY.Debug(string.format('%d %d %d %d\n', nStartValue, nHeight, nCurrentValue, (nStartValue - nCurrentValue)*(nCurrentValue - nHeight)), 'slide', MY_DEBUG.LOG)
				if (nStartValue - nCurrentValue)*(nCurrentValue - nHeight) <= 0 then
					ele:height(nHeight):toggle( nHeight ~= 0 )
					pcall(callback)
					return 0
				end
			end)
		end
	end
	return self
end

-- (self) Instance:slideUp(nTime, callback)
function XGUI:slideUp(nTime, callback)
	self:_checksum()
	nTime = nTime or 300
	for i = 1, #self.eles, 1 do
		local ele = self:eq(i)
		if ele:height() > 0 then ele:data('nSlideTo', ele:height()) end
	end
	self:slideTo(nTime, 0, callback)
	return self
end

-- (self) Instance:slideDown(nTime, callback)
function XGUI:slideDown(nTime, callback)
	self:_checksum()
	nTime = nTime or 300
	for i = 1, #self.eles, 1 do
		self:eq(i):slideTo(nTime, self:eq(i):data('nSlideTo'), callback)
	end
	return self
end

-- (number) Instance:font()
-- (self) Instance:font(number nFont)
function XGUI:font(nFont)
	self:_checksum()
	if nFont then-- set name
		for _, ele in pairs(self.eles) do
			local x = ele.txt or ele.edt or ele.raw
			if x then
				if x.SetFontScheme then
					x:SetFontScheme(nFont)
				end
				if x.SetSelectFontScheme then
					x:SetSelectFontScheme(nFont)
				end
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.GetFontScheme then
			return ele.raw:GetFontScheme()
		end
	end
end

-- (number, number, number) Instance:color()
-- (self) Instance:color(number r, number g, number b)
function XGUI:color(r, g, b)
	self:_checksum()
	if type(r) == "table" then
		r, g, b = unpack(r)
	end
	if b then
		for _, ele in pairs(self.eles) do
			local x = ele.sdw
			if x and x.SetColorRGB then
				x:SetColorRGB(r, g, b)
			end
			local x = ele.edt or ele.txt
			if x and x.SetFontColor then
				x:SetFontColor(r, g, b)
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele then
			if ele.sdw then
				return ele.sdw:GetColorRGB()
			elseif ele.edt or ele.txt then
				return (ele.edt or ele.txt):GetFontColor()
			end
		end
	end
end

-- (number) Instance:left()
-- (self) Instance:left(number)
function XGUI:left(nLeft)
	if nLeft then
		return self:pos(nLeft, nil)
	else
		local l, t = self:pos()
		return l
	end
end

-- (number) Instance:top()
-- (self) Instance:top(number)
function XGUI:top(nTop)
	if nTop then
		return self:pos(nil, nTop)
	else
		local l, t = self:pos()
		return t
	end
end

-- (number, number) Instance:pos()
-- (self) Instance:pos(nLeft, nTop)
function XGUI:pos(nLeft, nTop)
	self:_checksum()
	if nLeft or nTop then
		for _, ele in pairs(self.eles) do
			local _nLeft, _nTop = ele.raw:GetRelPos()
			nLeft, nTop = nLeft or _nLeft, nTop or _nTop
			if ele.frm then
				ele.frm:SetRelPos(nLeft, nTop)
			elseif ele.wnd then
				ele.wnd:SetRelPos(nLeft, nTop)
			elseif ele.itm then
				ele.itm:SetRelPos(nLeft, nTop)
				ele.itm:GetParent():FormatAllItemPos()
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.GetRelPos then
			return ele.raw:GetRelPos()
		end
	end
end

-- (anchor) Instance:anchor()
-- (self) Instance:anchor(anchor)
function XGUI:anchor(anchor)
	self:_checksum()
	if type(anchor) == 'table' then
		for _, ele in pairs(self.eles) do
			if ele.frm then
				ele.frm:SetPoint(anchor.s, 0, 0, anchor.r, anchor.x, anchor.y)
				ele.frm:CorrectPos()
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.frm then
			return GetFrameAnchor(ele.frm, anchor)
		end
	end
end

-- (number) Instance:width()
-- (self) Instance:width(number)
function XGUI:width(nWidth)
	if nWidth then
		return self:size(nWidth, nil)
	else
		local w, h = self:size()
		return w
	end
end

-- (number) Instance:height()
-- (self) Instance:height(number)
function XGUI:height(nHeight)
	if nHeight then
		return self:size(nil, nHeight)
	else
		local w, h = self:size()
		return h
	end
end

-- (number, number) Instance:size()
-- (self) Instance:size(nLeft, nTop)
-- (self) Instance:size(OnSizeChanged)
function XGUI:size(nWidth, nHeight)
	self:_checksum()
	if type(nWidth) == 'function' then
		for _, ele in pairs(self.eles) do
			MY.UI.RegisterUIEvent(ele.raw, "OnSizeChanged", nWidth)
		end
	elseif nWidth or nHeight then
		for _, ele in pairs(self.eles) do
			local _nWidth, _nHeight = ele.raw:GetSize()
			nWidth, nHeight = nWidth or _nWidth, nHeight or _nHeight
			if ele.type == 'WndFrame' then
				local frm = ele.frm
				local hnd = frm:Lookup("", "")
				if frm.simple then
					local nWidthTitleBtnR = 0
					local p = frm:Lookup('WndContainer_TitleBtnR'):GetFirstChild()
					while p do
						nWidthTitleBtnR = nWidthTitleBtnR + (p:GetSize())
						p = p:GetNext()
					end
					frm:Lookup('', 'Text_Title'):SetSize(nWidth - nWidthTitleBtnR, 30)
					frm:Lookup('', 'Image_Title'):SetSize(nWidth, 30)
					frm:Lookup('', 'Shadow_Bg'):SetSize(nWidth, nHeight)
					frm:Lookup('WndContainer_TitleBtnR'):SetSize(nWidth, 30)
					frm:Lookup('WndContainer_TitleBtnR'):FormatAllContentPos()
					frm:Lookup('Btn_Drag'):SetRelPos(nWidth - 16, nHeight - 16)
					frm:SetSize(nWidth, nHeight)
					frm:SetDragArea(0, 0, nWidth, 30)
					hnd:SetSize(nWidth, nHeight)
					ele.wnd:SetSize(nWidth, nHeight - 30)
				elseif frm.intact then
					-- fix size
					if nWidth  < 132 then nWidth  = 132 end
					if nHeight < 150 then nHeight = 150 end
					-- set size
					frm:SetSize(nWidth, nHeight)
					frm:SetDragArea(0, 0, nWidth, 55)
					hnd:SetSize(nWidth, nHeight)
					hnd:Lookup("Image_BgT" ):SetSize(nWidth, 64)
					hnd:Lookup("Image_BgCT"):SetSize(nWidth - 32, 64)
					hnd:Lookup("Image_BgLC"):SetSize(8, nHeight - 149)
					hnd:Lookup("Image_BgCC"):SetSize(nWidth - 16, nHeight - 149)
					hnd:Lookup("Image_BgRC"):SetSize(8, nHeight - 149)
					hnd:Lookup("Image_BgCB"):SetSize(nWidth - 132, 85)
					hnd:Lookup("Text_Title"):SetSize(nWidth - 90, 30)
					hnd:FormatAllItemPos()
					local hClose = frm:Lookup("Btn_Close")
					if hClose then
						hClose:SetRelPos(nWidth - 35, 15)
					end
					local hMax = frm:Lookup("CheckBox_Maximize")
					if hMax then
						hMax:SetRelPos(nWidth - 63, 15)
					end
					if ele.wnd then
						ele.wnd:SetSize(nWidth - 40, nHeight - 90)
						ele.wnd:Lookup("", ""):SetSize(nWidth - 40, nHeight - 90)
					end
					-- reset position
					local an = GetFrameAnchor(frm)
					frm:SetPoint(an.s, 0, 0, an.r, an.x, an.y)
				else
					ele.frm:SetSize(nWidth, nHeight)
					ele.hdl:SetSize(nWidth, nHeight)
				end
			elseif ele.type == "WndCheckBox" then
				ele.wnd:SetSize(nHeight, nHeight)
				ele.txt:SetSize(nWidth - nHeight - 1, nHeight)
				ele.txt:SetRelPos(nHeight + 1, 0)
				ele.hdl:SetSize(nWidth, nHeight)
				ele.hdl:FormatAllItemPos()
			elseif ele.type == "WndComboBox" then
				local w, h= ele.cmb:GetSize()
				ele.cmb:SetRelPos(nWidth-w-5, math.ceil((nHeight - h)/2))
				ele.cmb:Lookup("", ""):SetAbsPos(ele.hdl:GetAbsPos())
				ele.cmb:Lookup("", ""):SetSize(nWidth, nHeight)
				ele.wnd:SetSize(nWidth, nHeight)
				ele.hdl:SetSize(nWidth, nHeight)
				ele.img:SetSize(nWidth, nHeight)
				ele.txt:SetSize(nWidth - 10, nHeight)
				ele.hdl:FormatAllItemPos()
			elseif ele.type == "WndEditComboBox" or ele.type == "WndAutocomplete" then
				ele.wnd:SetSize(nWidth, nHeight)
				ele.hdl:SetSize(nWidth, nHeight)
				ele.phd:SetSize(nWidth, nHeight)
				ele.img:SetSize(nWidth, nHeight)
				ele.hdl:FormatAllItemPos()
				local w, h= ele.cmb:GetSize()
				ele.edt:SetSize(nWidth-10-w, nHeight-4)
				ele.cmb:SetRelPos(nWidth-w-5, (nHeight-h-1)/2+1)
			elseif ele.type == "WndRadioBox" then
				ele.wnd:SetSize(nHeight, nHeight)
				ele.txt:SetSize(nWidth - nHeight - 1, nHeight)
				ele.txt:SetRelPos(nHeight + 1, 0)
				ele.hdl:SetSize(nWidth, nHeight)
				ele.hdl:FormatAllItemPos()
			elseif ele.type == "WndEditBox" then
				ele.wnd:SetSize(nWidth, nHeight)
				ele.hdl:SetSize(nWidth, nHeight)
				ele.phd:SetSize(nWidth, nHeight)
				ele.img:SetSize(nWidth, nHeight)
				ele.edt:SetSize(nWidth-8, nHeight-4)
				ele.hdl:FormatAllItemPos()
			elseif ele.type == "Text" then
				ele.txt:SetSize(nWidth, nHeight)
				ele.txt:GetParent():FormatAllItemPos()
				ele.raw.bAutoSize = false
			elseif ele.type == "WndListBox" then
				ele.raw:SetSize(nWidth, nHeight)
				ele.raw:Lookup('Scroll_Default'):SetRelPos(nWidth - 15, 10)
				ele.raw:Lookup('Scroll_Default'):SetSize(15, nHeight - 20)
				ele.raw:Lookup('', ''):SetSize(nWidth, nHeight)
				ele.raw:Lookup('', 'Image_Default'):SetSize(nWidth, nHeight)
				local hScroll = ele.raw:Lookup('', 'Handle_Scroll')
				hScroll:SetSize(nWidth - 20, nHeight - 20)
				for i = hScroll:GetItemCount() - 1, 0, -1 do
					local hItem = hScroll:Lookup(i)
					hItem:Lookup('Image_Bg'):SetSize(nWidth - 20, 25)
					hItem:Lookup('Image_Sel'):SetSize(nWidth - 20, 25)
					hItem:Lookup('Text_Default'):SetSize(nWidth - 20, 25)
					hItem:FormatAllItemPos()
				end
				hScroll:FormatAllItemPos()
			elseif ele.type == "WndScrollBox" then
				ele.raw:SetSize(nWidth, nHeight)
				ele.raw:Lookup("", ""):SetSize(nWidth, nHeight)
				ele.raw:Lookup("", "Image_Default"):SetSize(nWidth, nHeight)
				ele.raw:Lookup("", "Handle_Padding"):SetSize(nWidth - 30, nHeight - 20)
				ele.raw:Lookup("", "Handle_Padding/Handle_Scroll"):SetSize(nWidth - 30, nHeight - 20)
				ele.raw:Lookup("", "Handle_Padding/Handle_Scroll"):FormatAllItemPos()
				ele.raw:Lookup("WndScrollBar"):SetRelX(nWidth - 20)
				ele.raw:Lookup("WndScrollBar"):SetH(nHeight - 20)
			elseif ele.wnd then
				pcall(function() ele.wnd:SetSize(nWidth, nHeight) end)
				pcall(function() ele.hdl:SetSize(nWidth, nHeight) end)
				pcall(function() ele.txt:SetSize(nWidth, nHeight) end)
				pcall(function() ele.img:SetSize(nWidth, nHeight) end)
				pcall(function() ele.edt:SetSize(nWidth-8, nHeight-4) end)
				pcall(function() ele.hdl:FormatAllItemPos() end)
			elseif ele.itm then
				pcall(function() (ele.itm or ele.raw):SetSize(nWidth, nHeight) end)
				pcall(function() (ele.itm or ele.raw):GetParent():FormatAllItemPos() end)
				pcall(function() ele.hdl:FormatAllItemPos() end)
			end
			if ele.raw.OnSizeChanged then
				local _this = this
				this = ele.raw
				local status, err = pcall(ele.raw.OnSizeChanged)
				if not status then
					MY.Debug({err}, 'ERROR XGUI:OnSizeChanged', MY_DEBUG.ERROR)
				end
				this = _this
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw and ele.raw.GetSize then
			return ele.raw:GetSize()
		end
	end
end

-- (self) Instance:autosize() -- resize Text element by autosize
-- (self) Instance:autosize(bool bAutoSize) -- set if Text ele autosize
function XGUI:autosize(bAutoSize)
	self:_checksum()
	if bAutoSize == nil then
		for _, ele in pairs(self.eles) do
			if ele.type == 'Text' then
				ele.raw:AutoSize()
			end
		end
	elseif type(bAutoSize) == 'boolean' then
		for _, ele in pairs(self.eles) do
			if ele.type == 'Text' then
				ele.raw.bAutoSize = true
			end
		end
	end
	return self
end

-- (number) Instance:scroll() -- get current scroll percentage (none scroll will return -1)
-- (self) Instance:scroll(number nPercentage) -- set scroll percentage
-- (self) Instance:scroll(function OnScrollBarPosChanged) -- bind scroll event handle
function XGUI:scroll(nPercentage)
	self:_checksum()
	if nPercentage then -- set
		if type(nPercentage) == "number" then
			for _, ele in pairs(self.eles) do
				local x = ele.raw:Lookup("WndScrollBar")
				if x and x.GetStepCount and x.SetScrollPos then
					x:SetScrollPos(x:GetStepCount() * nPercentage / 100)
				end
			end
		elseif type(nPercentage) == "function" then
			local fnOnChange = nPercentage
			for _, ele in pairs(self.eles) do
				local x = ele.raw:Lookup("WndScrollBar")
				if x then
					MY.UI.RegisterUIEvent(x, 'OnScrollBarPosChanged', function()
						if not this.nLastScrollPos then
							this.nLastScrollPos = 0
						end
						local nDistance = Station.GetMessageWheelDelta()
						local nScrollPos = x:GetScrollPos()
						local nStepCount = x:GetStepCount()
						if this.nLastScrollPos == nScrollPos and nDistance == 0 then
							return
						end
						this.nLastScrollPos = nScrollPos
						if nStepCount == 0 then
							fnOnChange(-1, nDistance)
						else
							fnOnChange(nScrollPos * 100 / nStepCount, nDistance)
						end
					end)
				end
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.raw then
			local x = ele.raw:Lookup("WndScrollBar")
			if x and x.GetStepCount and x.GetScrollPos then
				if x:GetStepCount() == 0 then
					return -1
				else
					return x:GetScrollPos() * 100 / x:GetStepCount()
				end
			end
		end
	end
end

-- (number, number) Instance:range()
-- (self) Instance:range(nMin, nMax)
function XGUI:range(nMin, nMax)
	self:_checksum()
	if type(nMin)=='number' and type(nMax)=='number' and nMax>nMin then
		for _, ele in pairs(self.eles) do
			if ele.type == "WndSliderBox" then
				ele.wnd.nOffset = nMin
				ele.sld:SetStepCount(nMax - nMin)
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.type == "WndSliderBox" then
			return ele.wnd.nOffset, ele.sld:GetStepCount()
		end
	end
end

-- (number, number) Instance:value()
-- (self) Instance:value(nValue)
function XGUI:value(nValue)
	self:_checksum()
	if nValue then
		for _, ele in pairs(self.eles) do
			if ele.type=="WndSliderBox" then
				ele.sld:SetScrollPos(nValue - ele.wnd.nOffset)
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele and ele.type == "WndSliderBox" then
			return ele.wnd.nOffset + ele.sld:GetScrollPos()
		end
	end
end


-- (boolean) Instance:multiLine()
-- (self) Instance:multiLine(bMultiLine)
function XGUI:multiLine(bMultiLine)
	self:_checksum()
	if type(bMultiLine)=='boolean' then
		for _, ele in pairs(self.eles) do
			local x = ele.edt
			if x and x.SetMultiLine then
				x:SetMultiLine(bMultiLine)
			end
			local x = ele.txt
			if x and x.SetMultiLine then
				x:SetMultiLine(bMultiLine)
				x:GetParent():FormatAllItemPos()
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele then
			local x = ele.edt or ele.txt
			if x and x.IsMultiLine then
				return x:IsMultiLine()
			end
		end
	end
end

-- (self) Instance:image(szImageAndFrame)
-- (self) Instance:image(szImage, nFrame)
function XGUI:image(szImage, nFrame)
	self:_checksum()
	if szImage then
		nFrame = nFrame or string.gsub(szImage, '.*%|(%d+)', '%1')
		szImage = string.gsub(szImage, '%|.*', '')
		if nFrame then
			nFrame = tonumber(nFrame)
			for _, ele in pairs(self.eles) do
				local x = ele.img
				if x and x.FromUITex then
					x:FromUITex(szImage, nFrame)
					x:GetParent():FormatAllItemPos()
				end
			end
		else
			for _, ele in pairs(self.eles) do
				local x = ele.img
				if x and x.FromTextureFile then
					x:FromTextureFile(szImage)
					x:GetParent():FormatAllItemPos()
				end
			end
		end
	end
	return self
end

-- (self) Instance:frame(nFrame)
-- (number) Instance:frame()
function XGUI:frame(nFrame)
	self:_checksum()
	if nFrame then
		nFrame = tonumber(nFrame)
		for _, ele in pairs(self.eles) do
			local x = ele.img
			if x and x.SetFrame then
				x:SetFrame(nFrame)
				x:GetParent():FormatAllItemPos()
			end
		end
	else
		local ele = self.eles[1]
		if ele and ele.type == 'Image' then
			return ele.raw:GetFrame()
		end
	end
	return self
end

-- (self) Instance:handleStyle(dwStyle)
function XGUI:handleStyle(dwStyle)
	self:_checksum()
	if dwStyle then
		for _, ele in pairs(self.eles) do
			local x = ele.hdl
			if x and x.SetHandleStyle then
				x:SetHandleStyle(dwStyle)
			end
		end
	end
	return self
end

-- (self) Instance:edittype(dwType)
function XGUI:edittype(dwType)
	self:_checksum()
	if dwType then
		for _, ele in pairs(self.eles) do
			local x = ele.edt
			if x and x.SetType then
				x:SetType(dwType)
			end
		end
	end
	return self
end

-- (self) XGUI:limit(nLimit)
function XGUI:limit(nLimit)
	self:_checksum()
	if nLimit then
		for _, ele in pairs(self.eles) do
			local x = ele.edt
			if x and x.SetLimit then
				x:SetLimit(nLimit)
			end
		end
		return self
	else -- get
		local ele = self.eles[1]
		if ele then
			local x = ele.edt
			if x and x.GetLimit then
				return x:GetLimit()
			end
		end
	end
end

-- (self) XGUI:sliderStyle(bShowPercentage)
function XGUI:sliderStyle(bShowPercentage)
	self:_checksum()
	for _, ele in pairs(self.eles) do
		if ele.type=="WndSliderBox" then
			ele.wnd.bShowPercentage = bShowPercentage
		end
	end
	return self
end

-- (self) Instance:bringToTop()
function XGUI:bringToTop()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		local x = ele.frm
		if x and x.BringToTop then
			x:BringToTop()
		end
	end
	return self
end

-- (self) Instance:refresh()
function XGUI:refresh()
	self:_checksum()
	for _, ele in pairs(self.eles) do
		if ele.hdl then
			ele.hdl:FormatAllItemPos()
		end
	end
	return self
end

-----------------------------------------------------------
-- my ui events handle
-----------------------------------------------------------

-- 绑定Frame的事件
function XGUI:onevent(szEvent, fnEvent)
	self:_checksum()
	if type(szEvent) == "string" then
		local nPos, szKey = (StringFindW(szEvent, "."))
		if nPos then
			szKey = string.sub(szEvent, nPos + 1)
			szEvent = string.sub(szEvent, 1, nPos - 1)
		end
		if type(fnEvent)=="function" then
			for _, ele in pairs(self.eles) do
				if ele.frm then
					if not ele.frm.tMyOnEvent then
						ele.frm.tMyOnEvent = {}
						ele.frm.OnEvent = function(event)
							for _, p in ipairs(ele.frm.tMyOnEvent[event] or {}) do pcall(p.fn) end
						end
					end
					if not ele.frm.tMyOnEvent[szEvent] then
						ele.frm:RegisterEvent(szEvent)
						ele.frm.tMyOnEvent[szEvent] = {}
					end
					if szKey then
						for i = #ele.frm.tMyOnEvent[szEvent], 1, -1 do
							if ele.frm.tMyOnEvent[szEvent][i].id == szKey then
								table.remove(ele.frm.tMyOnEvent[szEvent], i)
							end
						end
					end
					table.insert(ele.frm.tMyOnEvent[szEvent], { id = szKey, fn = fnEvent })
				end
			end
		else
			for _, ele in pairs(self.eles) do
				if ele.frm and ele.frm.tMyOnEvent and ele.frm.tMyOnEvent[szEvent] then
					if szKey then
						for i = #ele.frm.tMyOnEvent[szEvent], 1, -1 do
							if ele.frm.tMyOnEvent[szEvent][i].id == szKey then
								table.remove(ele.frm.tMyOnEvent[szEvent], i)
							end
						end
					else
						ele.frm.tMyOnEvent[szEvent] = {}
					end
				end
			end
		end
	end
	return self
end

-- 绑定ele的UI事件
function XGUI:onuievent(szEvent, fnEvent)
	self:_checksum()
	if type(szEvent)~="string" then
		return self
	end
	if type(fnEvent)=="function" then
		for _, ele in pairs(self.eles) do
			MY.UI.RegisterUIEvent(ele.raw, szEvent, fnEvent)
		end
	else
		for _, ele in pairs(self.eles) do
			if ele.raw then
				if ele.raw['tMy' .. szEvent] then
					ele.raw['tMy' .. szEvent] = {}
				end
			end
		end
	end
	return self
end

-- customMode 设置Frame的CustomMode
-- (self) Instance:customMode(string szTip, function fnOnEnterCustomMode, function fnOnLeaveCustomMode)
function XGUI:customMode(szTip, fnOnEnterCustomMode, fnOnLeaveCustomMode, szPoint)
	self:_checksum()
	if type(szTip)=="string" then
		self:onevent("ON_ENTER_CUSTOM_UI_MODE", function()
			UpdateCustomModeWindow(this, szTip, this.bPenetrable)
		end):onevent("ON_LEAVE_CUSTOM_UI_MODE", function()
			UpdateCustomModeWindow(this, szTip, this.bPenetrable)
		end)
		if type(fnOnEnterCustomMode) == "function" then
			self:onevent("ON_ENTER_CUSTOM_UI_MODE", function()
				fnOnEnterCustomMode(GetFrameAnchor(this, szPoint))
			end)
		end
		if type(fnOnLeaveCustomMode) == "function" then
			self:onevent("ON_LEAVE_CUSTOM_UI_MODE", function()
				fnOnLeaveCustomMode(GetFrameAnchor(this, szPoint))
			end)
		end
	end
	return self
end

-- breathe 设置Frame的breathe
-- (self) Instance:breathe(function fnOnFrameBreathe)
function XGUI:breathe(fnOnFrameBreathe)
	self:_checksum()
	if type(fnOnFrameBreathe)=="function" then
		for _, ele in pairs(self.eles) do
			if ele.frm then
				MY.UI.RegisterUIEvent(ele.frm, "OnFrameBreathe", fnOnFrameBreathe)
			end
		end
	end
	return self
end

-- menu 弹出菜单
-- :menu(table menu)  弹出菜单menu
-- :menu(functin fn)  弹出菜单function返回值table
function XGUI:menu(lmenu, rmenu, bNoAutoBind)
	self:_checksum()
	if not bNoAutoBind then
		rmenu = rmenu or lmenu
	end
	-- pop menu function
	local fnPopMenu = function(raw, menu)
		raw = raw:Lookup("", "") or raw
		local _menu = nil
		local nX, nY = raw:GetAbsPos()
		local nW, nH = raw:GetSize()
		if type(menu) == "function" then
			_menu = menu()
		else
			_menu = menu
		end
		_menu.nMiniWidth = nW
		_menu.x = nX
		_menu.y = nY + nH
		PopupMenu(_menu)
	end
	-- bind left click
	if lmenu then
		self:each(function(eself)
			eself:lclick(function() fnPopMenu(eself:raw(1), lmenu) end)
		end)
	end
	-- bind right click
	if rmenu then
		self:each(function(eself)
			eself:rclick(function() fnPopMenu(eself:raw(1), rmenu) end)
		end)
	end
	return self
end

-- lmenu 弹出左键菜单
-- :lmenu(table menu)  弹出菜单menu
-- :lmenu(functin fn)  弹出菜单function返回值table
function XGUI:lmenu(menu)
	return self:menu(menu, nil, true)
end

-- rmenu 弹出右键菜单
-- :lmenu(table menu)  弹出菜单menu
-- :lmenu(functin fn)  弹出菜单function返回值table
function XGUI:rmenu(menu)
	return self:menu(nil, menu, true)
end

-- click 鼠标单击事件
-- same as jQuery.click()
-- :click(fnAction) 绑定
-- :click()         触发
-- :click(number n) 触发
-- n: 1    左键
--    0    中键
--   -1    右键
function XGUI:click(fnLClick, fnRClick, fnMClick, bNoAutoBind)
	self:_checksum()
	if type(fnLClick)=="function" or type(fnMClick)=="function" or type(fnRClick)=="function" then
		if not bNoAutoBind then
			fnMClick = fnMClick or fnLClick
			fnRClick = fnRClick or fnLClick
		end
		for _, ele in pairs(self.eles) do
			if type(fnLClick)=="function" then
				local fnAction = function() fnLClick(MY.Const.Event.Mouse.LBUTTON, ele.raw) end
				if ele.type == "WndScrollBox" then
					MY.UI.RegisterUIEvent(ele.hdl ,'OnItemLButtonClick' , fnAction)
				elseif ele.cmb then
					MY.UI.RegisterUIEvent(ele.cmb ,'OnLButtonClick'     , fnAction)
				elseif ele.wnd then
					MY.UI.RegisterUIEvent(ele.wnd ,'OnLButtonClick'     , fnAction)
				elseif ele.itm then
					ele.itm:RegisterEvent(16)
					MY.UI.RegisterUIEvent(ele.itm ,'OnItemLButtonClick' , fnAction)
				elseif ele.hdl then
					ele.hdl:RegisterEvent(16)
					MY.UI.RegisterUIEvent(ele.hdl ,'OnItemLButtonClick' , fnAction)
				end
			end
			if type(fnMClick)=="function" then

			end
			if type(fnRClick)=="function" then
				local fnAction = function() fnRClick(MY.Const.Event.Mouse.RBUTTON, ele.raw) end
				if ele.type == "WndScrollBox" then
					MY.UI.RegisterUIEvent(ele.hdl ,'OnItemRButtonClick' , fnAction)
				elseif ele.cmb then
					MY.UI.RegisterUIEvent(ele.cmb ,'OnRButtonClick'     , fnAction)
				elseif ele.wnd then
					MY.UI.RegisterUIEvent(ele.wnd ,'OnRButtonClick'     , fnAction)
				elseif ele.itm then
					ele.itm:RegisterEvent(32)
					MY.UI.RegisterUIEvent(ele.itm ,'OnItemRButtonClick' , fnAction)
				elseif ele.hdl then
					ele.hdl:RegisterEvent(32)
					MY.UI.RegisterUIEvent(ele.hdl ,'OnItemRButtonClick' , fnAction)
				end
			end
		end
	else
		local nFlag = fnLClick or fnMClick or fnRClick or MY.Const.Event.Mouse.LBUTTON
		if nFlag==MY.Const.Event.Mouse.LBUTTON then
			for _, ele in pairs(self.eles) do
				if ele.wnd then local _this = this this = ele.wnd pcall(ele.wnd.OnLButtonClick) this = _this end
				if ele.itm then local _this = this this = ele.itm pcall(ele.itm.OnItemLButtonClick) this = _this end
			end
		elseif nFlag==MY.Const.Event.Mouse.MBUTTON then

		elseif nFlag==MY.Const.Event.Mouse.RBUTTON then
			for _, ele in pairs(self.eles) do
				if ele.wnd then local _this = this this = ele.wnd pcall(ele.wnd.OnRButtonClick) this = _this end
				if ele.itm then local _this = this this = ele.itm pcall(ele.itm.OnItemRButtonClick) this = _this end
			end
		end
	end
	return self
end

-- lclick 鼠标左键单击事件
-- same as jQuery.lclick()
-- :lclick(fnAction) 绑定
-- :lclick()         触发
function XGUI:lclick(fnLClick)
	return self:click(fnLClick or MY.Const.Event.Mouse.LBUTTON, nil, nil, true)
end

-- rclick 鼠标右键单击事件
-- same as jQuery.rclick()
-- :rclick(fnAction) 绑定
-- :rclick()         触发
function XGUI:rclick(fnRClick)
	return self:click(nil, fnRClick or MY.Const.Event.Mouse.RBUTTON, nil, true)
end

-- hover 鼠标悬停事件
-- same as jQuery.hover()
-- :hover(fnHover[, fnLeave]) 绑定
function XGUI:hover(fnHover, fnLeave, bNoAutoBind)
	self:_checksum()
	if not bNoAutoBind then fnLeave = fnLeave or fnHover end
	if fnHover then
		for _, ele in pairs(self.eles) do
			local wnd = ele.edt or ele.wnd
			local itm = ele.itm or ele.itm
			if wnd then
				MY.UI.RegisterUIEvent(wnd, 'OnMouseEnter'    , function() fnHover(true, this:PtInWindow(Cursor.GetPos())) end)
			elseif itm then
				itm:RegisterEvent(256)
				MY.UI.RegisterUIEvent(itm, 'OnItemMouseEnter', function() fnHover(true, this:PtInItem(Cursor.GetPos())) end)
			end
		end
	end
	if fnLeave then
		for _, ele in pairs(self.eles) do
			local wnd = ele.edt or ele.wnd
			local itm = ele.itm or ele.itm
			if wnd then
				MY.UI.RegisterUIEvent(wnd, 'OnMouseLeave'    , function() fnLeave(false, this:PtInWindow(Cursor.GetPos())) end)
			elseif itm then
				itm:RegisterEvent(256)
				MY.UI.RegisterUIEvent(itm, 'OnItemMouseLeave', function() fnLeave(false, this:PtInItem(Cursor.GetPos())) end)
			end
		end
	end
	return self
end

-- tip 鼠标悬停提示
-- (self) Instance:tip( tip[, nPosType[, tOffset[, bNoEncode] ] ] ) 绑定tip事件
-- string|function tip:要提示的文字文本或序列化的DOM文本或返回前述文本的函数
-- number nPosType:    提示位置 有效值为MY.Const.UI.Tip.枚举
-- table tOffset:      提示框偏移量等附加信息{ x = x, y = y, hide = MY.Const.UI.Tip.Hide枚举, nFont = 字体, r, g, b = 字颜色 }
-- boolean bNoEncode:  当szTip为纯文本时保持这个参数为false 当szTip为格式化的DOM字符串时设置该参数为true
function XGUI:tip(tip, nPosType, tOffset, bNoEncode)
	tOffset = tOffset or {}
	tOffset.x = tOffset.x or 0
	tOffset.y = tOffset.y or 0
	tOffset.w = tOffset.w or 450
	tOffset.hide = tOffset.hide or MY.Const.UI.Tip.HIDE
	tOffset.nFont = tOffset.nFont or 136
	nPosType = nPosType or MY.Const.UI.Tip.POS_FOLLOW_MOUSE
	return self:hover(function()
		local x, y = this:GetAbsPos()
		local w, h = this:GetSize()
		if nPosType == MY.Const.UI.Tip.POS_FOLLOW_MOUSE then
			x, y = Cursor.GetPos()
			x, y = x - 0, y - 40
		end
		x, y = x + tOffset.x, y + tOffset.y
		local szTip = tip
		if type(szTip) == 'function' then
			szTip = szTip()
		end
		if not bNoEncode then
			szTip = GetFormatText(szTip, tOffset.nFont, tOffset.r, tOffset.g, tOffset.b)
		end
		OutputTip(szTip, tOffset.w, {x, y, w, h}, nPosType)
	end, function()
		if tOffset.hide == MY.Const.UI.Tip.HIDE then
			HideTip(false)
		elseif tOffset.hide == MY.Const.UI.Tip.ANIMATE_HIDE then
			HideTip(true)
		end
	end, true)
end

-- check 复选框状态变化
-- :check(fnOnCheckBoxCheck[, fnOnCheckBoxUncheck]) 绑定
-- :check()                返回是否已勾选
-- :check(bool bChecked)   勾选/取消勾选
function XGUI:check(fnCheck, fnUncheck, bNoAutoBind)
	self:_checksum()
	if not bNoAutoBind then
		fnUncheck = fnUncheck or fnCheck
	end
	if type(fnCheck)=="function" or type(fnUncheck)=="function" then
		for _, ele in pairs(self.eles) do
			if ele.chk then
				if type(fnCheck)=="function" then MY.UI.RegisterUIEvent(ele.chk, 'OnCheckBoxCheck' , function() fnCheck(true) end) end
				if type(fnUncheck)=="function" then MY.UI.RegisterUIEvent(ele.chk, 'OnCheckBoxUncheck' , function() fnUncheck(false) end) end
			end
		end
		return self
	elseif type(fnCheck) == "boolean" then
		for _, ele in pairs(self.eles) do
			if ele.chk then ele.chk:Check(fnCheck) end
		end
		return self
	elseif not fnCheck then
		local ele = self.eles[1]
		if ele and ele.chk then
			return ele.chk:IsCheckBoxChecked()
		end
	else
		MY.Debug({'fnCheck:'..type(fnCheck)..' fnUncheck:'..type(fnUncheck)}, 'ERROR XGUI:check', MY_DEBUG.ERROR)
	end
end

-- change 输入框文字变化
-- :change(fnOnChange) 绑定
-- :change()   调用处理函数
function XGUI:change(fnOnChange)
	self:_checksum()
	if fnOnChange then
		for _, ele in pairs(self.eles) do
			if ele.edt then
				MY.UI.RegisterUIEvent(ele.edt, 'OnEditChanged', function() pcall(fnOnChange,ele.edt:GetText()) end)
			end
			if ele.type=="WndSliderBox" then
				table.insert(ele.wnd.tMyOnChange, fnOnChange)
			end
		end
		return self
	else
		for _, ele in pairs(self.eles) do
			if ele.edt then local _this = this this = ele.edt pcall(ele.edt.OnEditChanged) this = _this  end
			if ele.type=="WndSliderBox" then
				local _this = this this = ele.sld pcall(ele.sld.OnScrollBarPosChanged) this = _this
			end
		end
		return self
	end
end

-- focus （输入框）获得焦点 -- 好像只有输入框能获得焦点
-- :focus(fnOnSetFocus, fnOnKillFocus) 绑定
-- :focus()   使获得焦点
function XGUI:focus(fnOnSetFocus, fnOnKillFocus)
	self:_checksum()
	if fnOnSetFocus then
		fnOnKillFocus = fnOnKillFocus or fnOnSetFocus
		for _, ele in pairs(self.eles) do
			if ele.edt then
				MY.UI.RegisterUIEvent(ele.edt, 'OnSetFocus' , function() pcall(fnOnSetFocus , ele.raw, true ) end)
				MY.UI.RegisterUIEvent(ele.edt, 'OnKillFocus', function() pcall(fnOnKillFocus, ele.raw, false) end)
			end
		end
		return self
	else
		for _, ele in pairs(self.eles) do
			if ele.edt then
				Station.SetFocusWindow(ele.edt)
				break
			end
		end
		return self
	end
end

-- OnGetFocus 获取焦点

-----------------------------------------------------------
-- MY.UI
-----------------------------------------------------------

MY.UI = MY.UI or {}
MY.Const = MY.Const or {}
MY.Const.Event = MY.Const.Event or {}
MY.Const.Event.Mouse = MY.Const.Event.Mouse or {}
MY.Const.Event.Mouse.LBUTTON = 1
MY.Const.Event.Mouse.MBUTTON = 0
MY.Const.Event.Mouse.RBUTTON = -1
MY.Const.UI = MY.Const.UI or {}
MY.Const.UI.Tip = MY.Const.UI.Tip or {}
MY.Const.UI.Tip.POS_FOLLOW_MOUSE = 0
MY.Const.UI.Tip.POS_LEFT         = 1
MY.Const.UI.Tip.POS_RIGHT        = 2
MY.Const.UI.Tip.POS_TOP          = 3
MY.Const.UI.Tip.POS_BOTTOM       = 4
MY.Const.UI.Tip.POS_RIGHT_BOTTOM = 5
MY.Const.UI.Slider = MY.Const.UI.Slider or {}
MY.Const.UI.Slider.SHOW_VALUE    = false
MY.Const.UI.Slider.SHOW_PERCENT  = true

MY.Const.UI.Tip.NO_HIDE      = 100
MY.Const.UI.Tip.HIDE         = 101
MY.Const.UI.Tip.ANIMATE_HIDE = 102

MUI = MY.UI
-- 设置元表，这样可以当作函数调用，其效果相当于 MY.UI.Fetch
setmetatable(MY.UI, { __call = function(me, ...) return me.Fetch(...) end, __metatable = true })


-- 构造函数 类似jQuery: $(selector)
MY.UI.Fetch = function(selector, tab)
	return XGUI.new(selector, tab)
end
-- 绑定UI事件
MY.UI.RegisterUIEvent = function(raw, szEvent, fnEvent)
	if not raw['tMy'..szEvent] then
		-- init onXXX table
		raw['tMy'..szEvent] = { raw[szEvent] }
		-- init onXXX function
		raw[szEvent] = function(...)
			for _, fn in ipairs(raw['tMy'..szEvent]) do
				local tReturn
				for _, fn in ipairs(raw['tMy' .. szEvent] or {}) do
					local t = { pcall(fn, ...) }
					if not t[1] then
						MY.Debug({t[2]}, MY.UI.GetTreePath(raw) .. '#' .. szEvent, MY_DEBUG.ERROR)
					elseif not tReturn then
						table.remove(t, 1)
						tReturn = t
					end
				end
				if tReturn then
					return unpack(tReturn)
				end
			 end
		end
	end
	if fnEvent then
		table.insert(raw['tMy'..szEvent], fnEvent)
	end
end

---------------------------------------------------
-- create new frame
-- (ui) MY.UI.CreateFrame(string szName, table opt)
-- @param string szName: the ID of frame
-- @param table  opt   : options
---------------------------------------------------
MY.UI.CreateFrame = function(szName, opt)
	if type(opt) ~= 'table' then
		opt = {}
	end
	if not (
		opt.level == 'Normal'  or opt.level == 'Lowest'  or opt.level == 'Topmost'  or
		opt.level == 'Normal1' or opt.level == 'Lowest1' or opt.level == 'Topmost1' or
		opt.level == 'Normal2' or opt.level == 'Lowest2' or opt.level == 'Topmost2'
	) then
		opt.level = "Normal"
	end
	-- calc ini file path
	local szIniFile = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndFrame.ini"
	if opt.simple then
		szIniFile = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndFrameSimple.ini"
	elseif opt.empty then
		szIniFile = MY.GetAddonInfo().szFrameworkRoot .. "ui\\WndFrameEmpty.ini"
	end

	-- close and reopen exist frame
	local frm = Station.Lookup(opt.level .. '/' .. szName)
	if frm then
		Wnd.CloseWindow(frm)
	end
	frm = Wnd.OpenWindow(szIniFile, szName)
	frm:ChangeRelation(opt.level)
	frm:Show()
	local ui = MY.UI(frm)
	-- init frame
	if opt.esc then
		MY.RegisterEsc('Frame_Close_' .. szName, function()
			return true
		end, function()
			if frm.OnCloseButtonClick then
				local status, res = pcall(frm.OnCloseButtonClick)
				if status and res then
					return
				end
			end
			Wnd.CloseWindow(frm)
			PlaySound(SOUND.UI_SOUND, g_sound.CloseFrame)
			MY.RegisterEsc('Frame_Close_' .. szName)
		end)
	end
	if opt.simple then
		frm.simple = true
		frm:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
		-- top right buttons
		if not opt.close then
			frm:Lookup('WndContainer_TitleBtnR/Wnd_Close'):Destroy()
		else
			frm:Lookup("WndContainer_TitleBtnR/Wnd_Close/Btn_Close").OnLButtonClick = function()
				if frm.OnCloseButtonClick then
					local status, res = pcall(frm.OnCloseButtonClick)
					if status and res then
						return
					end
				end
				Wnd.CloseWindow(frm)
				PlaySound(SOUND.UI_SOUND, g_sound.CloseFrame)
			end
		end
		if opt.onrestore then
			MY.UI.RegisterUIEvent(frm, 'OnRestore', opt.onrestore)
		end
		if not opt.minimize then
			frm:Lookup('WndContainer_TitleBtnR/Wnd_Minimize'):Destroy()
		else
			if opt.onminimize then
				MY.UI.RegisterUIEvent(frm, 'OnMinimize', opt.onminimize)
			end
			frm:Lookup("WndContainer_TitleBtnR/Wnd_Minimize/CheckBox_Minimize").OnCheckBoxCheck = function()
				if frm.bMaximize then
					frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize"):Check(false)
				else
					frm.w, frm.h = frm:GetSize()
				end
				frm:Lookup('Window_Main'):Hide()
				frm:Lookup('', 'Shadow_Bg'):Hide()
				frm:SetSize(frm.w, 30)
				local hMax = frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize")
				if hMax then
					hMax:Enable(false)
				end
				if frm.OnMinimize then
					local status, res = pcall(frm.OnMinimize, frm:Lookup('Window_Main'))
					if status and res then
						return
					end
				end
				if opt.dragresize then
					frm:Lookup('Btn_Drag'):Hide()
				end
				frm.bMinimize = true
			end
			frm:Lookup("WndContainer_TitleBtnR/Wnd_Minimize/CheckBox_Minimize").OnCheckBoxUncheck = function()
				frm:Lookup('Window_Main'):Show()
				frm:Lookup('', 'Shadow_Bg'):Show()
				frm:SetSize(frm.w, frm.h)
				local hMax = frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize")
				if hMax then
					hMax:Enable(true)
				end
				if frm.OnRestore then
					local status, res = pcall(frm.OnRestore, frm:Lookup('Window_Main'))
					if status and res then
						return
					end
				end
				if opt.dragresize then
					frm:Lookup('Btn_Drag'):Show()
				end
				frm.bMinimize = false
			end
		end
		if not opt.maximize then
			frm:Lookup('WndContainer_TitleBtnR/Wnd_Maximize'):Destroy()
		else
			if opt.onmaximize then
				MY.UI.RegisterUIEvent(frm, 'OnMaximize', opt.onmaximize)
			end
			frm:Lookup('WndContainer_TitleBtnR').OnLButtonDBClick = function()
				frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize"):ToggleCheck()
			end
			frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize").OnCheckBoxCheck = function()
				if frm.bMinimize then
					frm:Lookup("WndContainer_TitleBtnR/Wnd_Minimize/CheckBox_Minimize"):Check(false)
				else
					frm.anchor = GetFrameAnchor(frm)
					frm.w, frm.h = frm:GetSize()
				end
				local w, h = Station.GetClientSize()
				MY.UI(frm):pos(0, 0):drag(false):size(w, h):onevent('UI_SCALED.FRAME_MAXIMIZE_RESIZE', function()
					local w, h = Station.GetClientSize()
					MY.UI(frm):pos(0, 0):size(w, h)
				end)
				if frm.OnMaximize then
					local status, res = pcall(frm.OnMaximize, frm:Lookup('Window_Main'))
					if status and res then
						return
					end
				end
				if opt.dragresize then
					frm:Lookup('Btn_Drag'):Hide()
				end
				frm.bMaximize = true
			end
			frm:Lookup("WndContainer_TitleBtnR/Wnd_Maximize/CheckBox_Maximize").OnCheckBoxUncheck = function()
				MY.UI(frm)
				  :onevent('UI_SCALED.FRAME_MAXIMIZE_RESIZE')
				  :size(frm.w, frm.h)
				  :anchor(frm.anchor)
				  :drag(true)
				if frm.OnRestore then
					local status, res = pcall(frm.OnRestore, frm:Lookup('Window_Main'))
					if status and res then
						return
					end
				end
				if opt.dragresize then
					frm:Lookup('Btn_Drag'):Show()
				end
				frm.bMaximize = false
			end
		end
		-- drag resize button
		opt.minwidth  = opt.minwidth or 100
		opt.minheight = opt.minheight or 50
		if not opt.dragresize then
			frm:Lookup('Btn_Drag'):Hide()
		else
			if opt.ondragresize then
				MY.UI.RegisterUIEvent(frm, 'OnDragResize', opt.ondragresize)
			end
			frm:Lookup('Btn_Drag').OnDragButton = function()
				local x, y = Station.GetMessagePos()
				local W, H = Station.GetClientSize()
				local X, Y = frm:GetRelPos()
				local w, h = x - X, y - Y
				w = math.min(w, W - X) -- frame size should not larger than client size
				h = math.min(h, H - Y)
				w = math.max(w, opt.minwidth) -- frame size must larger than setted min size
				h = math.max(h, opt.minheight)
				frm:Lookup('Btn_Drag'):SetRelPos(w - 16, h - 16)
				frm:Lookup('', 'Shadow_Bg'):SetSize(w, h)
			end
			frm:Lookup('Btn_Drag').OnDragButtonBegin = function()
				frm:Lookup('Window_Main'):Hide()
			end
			frm:Lookup('Btn_Drag').OnDragButtonEnd = function()
				frm:Lookup('Window_Main'):Show()
				local w, h = this:GetRelPos()
				w = math.max(w + 16, opt.minwidth)
				h = math.max(h + 16, opt.minheight)
				MY.UI(frm):size(w, h)
				if frm.OnDragResize then
					local status, res = pcall(frm.OnDragResize, frm:Lookup('Window_Main'))
					if status and res then
						return
					end
				end
			end
			frm:Lookup('Btn_Drag'):RegisterLButtonDrag()
		end
		-- frame properties
		if opt.alpha then
			frm:Lookup('', 'Image_Title'):SetAlpha(opt.alpha * 1.4)
			frm:Lookup('', 'Shadow_Bg'):SetAlpha(opt.alpha /255 * 200)
		end
	elseif not opt.empty then
		frm.intact = true
		frm:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
		frm:Lookup("Btn_Close").OnLButtonClick = function()
			if frm.OnCloseButtonClick then
				local status, res = pcall(frm.OnCloseButtonClick)
				if status and res then
					return
				end
			end
			Wnd.CloseWindow(frm)
		end
		-- load bg uitex
		local szUITexCommon = MY.GetAddonInfo().szUITexCommon
		for k, v in pairs({
			['Image_BgLT'] = 9,
			['Image_BgCT'] = 8,
			['Image_BgRT'] = 7,
			['Image_BgT' ] = 6,
		}) do
			local h = frm:Lookup('', k)
			h:FromUITex(szUITexCommon, v)
		end
	end
	ApplyUIArgument(ui, opt)
	return ui
end

-- 打开取色板
MY.UI.OpenColorPicker = function(callback, t)
	if t then
		return OpenColorTablePanel(callback,nil,nil,t)
	end
	local ui = MY.UI.CreateFrame("_MY_ColorTable", { simple = true, close = true, esc = true })
	  :size(900, 500):text(_L["color picker"]):anchor({s='CENTER', r='CENTER', x=0, y=0})
	local fnHover = function(bHover, r, g, b)
		if bHover then
			this:SetAlpha(255)
			ui:item("#Select"):color(r, g, b)
			ui:item("#Select_Text"):text(string.format("r=%d, g=%d, b=%d", r, g, b))
		else
			this:SetAlpha(200)
			ui:item("#Select"):color(255, 255, 255)
			ui:item("#Select_Text"):text(g_tStrings.STR_NONE)
		end
	end
	local fnClick = function( ... )
		if callback then callback( ... ) end
		if not IsCtrlKeyDown() then
			ui:remove()
		end
	end
	for nRed = 1, 8 do
		for nGreen = 1, 8 do
			for nBlue = 1, 8 do
				local x = 20 + ((nRed - 1) % 4) * 220 + (nGreen - 1) * 25
				local y = 10 + math.modf((nRed - 1) / 4) * 220 + (nBlue - 1) * 25
				local r, g, b  = nRed * 32 - 1, nGreen * 32 - 1, nBlue * 32 - 1
				ui:append("Shadow", {
					w = 23, h = 23, x = x, y = y, color = { r, g, b }, alpha = 200,
					onhover = function(bHover)
						fnHover(bHover, r, g, b)
					end,
					onclick = function()
						fnClick(r, g, b)
					end,
				})
			end
		end
	end

	for i = 1, 16 do
		local x = 480 + (i - 1) * 25
		local y = 435
		local r, g, b  = i * 16 - 1, i * 16 - 1, i * 16 - 1
		ui:append("Shadow", {
			w = 23, h = 23, x = x, y = y, color = { r, g, b }, alpha = 200,
			onhover = function(bHover)
				fnHover(bHover, r, g, b)
			end,
			onclick = function()
				fnClick(r, g, b)
			end,
		})
	end
	ui:append("Shadow", "Select", { w = 25, h = 25, x = 20, y = 435 })
	ui:append("Text", "Select_Text", { x = 65, y = 435 })
	local GetRGBValue = function()
		local r, g, b  = tonumber(ui:children("#R"):text()), tonumber(ui:children("#G"):text()), tonumber(ui:children("#B"):text())
		if r and g and b and r <= 255 and g <= 255 and b <= 255 then
			return r, g, b
		end
	end
	local onChange = function()
		if GetRGBValue() then
			local r, g, b = GetRGBValue()
			fnHover(true, r, g, b)
		end
	end
	local x, y = 240, 435
	ui:append("Text", { text = "R", x = x, y = y })
	ui:append("WndEditBox", "R", { x = x + 14, y = y + 4, w = 38, h = 25, limit = 3, edittype = 0, onchange = onChange })
	x = x + 14 + 38
	ui:append("Text", { text = "G", x = x, y = y })
	ui:append("WndEditBox", "G", { x = x + 14, y = y + 4, w = 38, h = 25, limit = 3, edittype = 0, onchange = onChange })
	x = x + 14 + 38
ui:append("Text", { text = "B", x = x, y = y })
	ui:append("WndEditBox", "B", { x = x + 14, y = y + 4, w = 38, h = 25, limit = 3, edittype = 0, onchange = onChange })
	x = x + 14 + 38
	ui:append("WndButton", { text = g_tStrings.STR_HOTKEY_SURE, x = x + 5, y = y + 5, w = 60, h = 25, onclick = function()
		if GetRGBValue() then
			fnClick(GetRGBValue())
		else
			MY.Sysmsg({_L["RGB value error"]})
		end
	end})
	Station.SetFocusWindow(ui:raw(1))
	-- OpenColorTablePanel(callback,nil,nil,t)
	--  or {
	--     { r = 0,   g = 255, b = 0  },
	--     { r = 0,   g = 255, b = 255},
	--     { r = 255, g = 0  , b = 0  },
	--     { r = 40,  g = 140, b = 218},
	--     { r = 211, g = 229, b = 37 },
	--     { r = 65,  g = 50 , b = 160},
	--     { r = 170, g = 65 , b = 180},
	-- }
end

-- 打开字体选择
MY.UI.OpenFontPicker = function(callback, t)
	local w, h = 820, 640
	local ui = MY.UI.CreateFrame("_MY_Color_Picker", { simple = true, close = true, esc = true })
	  :size(w, h):text(_L["color picker"]):anchor({s='CENTER', r='CENTER', x=0, y=0})

	for i = 0, 255 do
		local txt = ui:append("Text", "Text_"..i, {
			w = 70, x = i % 10 * 80 + 20, y = math.floor(i / 10) * 25,
			font = i, alpha = 200, text = _L("Font %d", i)
		}):item("#Text_"..i)
		  :click(function()
		  	if callback then callback(i) end
		  	ui:remove()
		  end)
		  :hover(function()
		  	MY.UI(this):alpha(255)
		  end,function()
		  	MY.UI(this):alpha(200)
		  end)
		-- remove unexist font
		if txt:font() ~= i then
			txt:remove()
		end
	end
	Station.SetFocusWindow(ui:raw(1))
end

-- 打开文本编辑器
MY.UI.OpenTextEditor = function(szText, szFrameName)
	if not szFrameName then
		szFrameName = "MY_DefaultTextEditor"
	end
	local w, h, ui = 400, 300
	local function OnResize()
		ui:children('.WndEditBox'):size(ui:wnd(1):size())
	end
	ui = MY.UI.CreateFrame(szFrameName, {
		w = w, h = h, text = _L["text editor"], alpha = 180,
		anchor = { s='CENTER', r='CENTER', x=0, y=0 },
		simple = true, close = true, esc = true,
		dragresize = true, minimize = true, ondragresize = OnResize,
	}):append("WndEditBox", { x = 0, y = 0, multiline = true, text = szText })
	OnResize()
	return ui
end

-- 打开文本列表编辑器
MY.UI.OpenListEditor = function(szFrameName, tTextList, OnAdd, OnDel)
	local muDel
	local AddListItem = function(muList, szText)
		local i = muList:hdl(1):children():count()
		local muItem = muList:append('<handle><image>w=300 h=25 eventid=371 name="Image_Bg" </image><text>name="Text_Default" </text></handle>'):hdl(1):children():last()
		local hHandle = muItem:raw(1)
		hHandle.Value = szText
		local hText = muItem:children("#Text_Default"):pos(10, 2):text(szText or ""):raw(1)
		muItem:children("#Image_Bg"):image("UI/Image/Common/TextShadow.UITex",5):alpha(0):hover(function(bIn)
			if hHandle.Selected then return nil end
			if bIn then
				MY.UI(this):fadeIn(100)
			else
				MY.UI(this):fadeTo(500,0)
			end
		end):click(function(nButton)
			if nButton == MY.Const.Event.Mouse.RBUTTON then
				hHandle.Selected = true
				PopupMenu({{
					szOption = _L["delete"],
					fnAction = function()
						muDel:click()
					end,
				}})
			else
				hHandle.Selected = not hHandle.Selected
			end
			if hHandle.Selected then
				MY.UI(this):image("UI/Image/Common/TextShadow.UITex",2)
			else
				MY.UI(this):image("UI/Image/Common/TextShadow.UITex",5)
			end
		end)
	end
	local ui = MY.UI.CreateFrame(szFrameName)
	ui:append("Image", "Image_Spliter"):find("#Image_Spliter"):pos(-10,25):size(360, 10):image("UI/Image/UICommon/Commonpanel.UITex",42)
	local muEditBox = ui:append("WndEditBox", "WndEditBox_Keyword"):find("#WndEditBox_Keyword"):pos(0,0):size(170, 25)
	local muList = ui:append("WndScrollBox", "WndScrollBox_KeywordList"):find("#WndScrollBox_KeywordList"):handleStyle(3):pos(0,30):size(340, 380)
	-- add
	ui:append("WndButton", "WndButton_Add"):find("#WndButton_Add"):pos(180,0):width(80):text(_L["add"]):click(function()
		local szText = muEditBox:text()
		-- 加入表
		if OnAdd then
			if OnAdd(szText) ~= false then
				AddListItem(muList, szText)
			end
		else
			AddListItem(muList, szText)
		end
	end)
	-- del
	muDel = ui:append("WndButton", "WndButton_Del"):find("#WndButton_Del"):pos(260,0):width(80):text(_L["delete"]):click(function()
		muList:hdl(1):children():each(function(ui)
			if this.Selected then
				if OnDel then
					OnDel(this.Value)
				end
				ui:remove()
			end
		end)
	end)
	-- insert data to ui
	for i, v in ipairs(tTextList) do
		AddListItem(muList, v)
	end
	return ui
end
-- 打开浏览器
MY.UI.OpenInternetExplorer = function(szAddr, bDisableSound)
	local nIndex, nLast = nil, nil
	for i = 1, 10, 1 do
		if not _MY.IsInternetExplorerOpened(i) then
			nIndex = i
			break
		elseif not nLast then
			nLast = i
		end
	end
	if not nIndex then
		OutputMessage("MSG_ANNOUNCE_RED", g_tStrings.MSG_OPEN_TOO_MANY)
		return nil
	end
	local x, y = _MY.IE_GetNewIEFramePos()
	local frame = Wnd.OpenWindow("InternetExplorer", "IE"..nIndex)
	frame.bIE = true
	frame.nIndex = nIndex

	frame:BringToTop()
	if nLast then
		frame:SetAbsPos(x, y)
		frame:CorrectPos()
		frame.x = x
		frame.y = y
	else
		frame:SetPoint("CENTER", 0, 0, "CENTER", 0, 0)
		frame.x, frame.y = frame:GetAbsPos()
	end
	local webPage = frame:Lookup("WebPage_Page")
	if szAddr then
		webPage:Navigate(szAddr)
	end
	Station.SetFocusWindow(webPage)
	if not bDisableSound then
		PlaySound(SOUND.UI_SOUND,g_sound.OpenFrame)
	end
	return webPage
end
-- 判断浏览器是否已开启
_MY.IsInternetExplorerOpened = function(nIndex)
	local frame = Station.Lookup("Topmost/IE"..nIndex)
	if frame and frame:IsVisible() then
		return true
	end
	return false
end
-- 获取浏览器绝对位置
_MY.IE_GetNewIEFramePos = function()
	local nLastTime = 0
	local nLastIndex = nil
	for i = 1, 10, 1 do
		local frame = Station.Lookup("Topmost/IE"..i)
		if frame and frame:IsVisible() then
			if frame.nOpenTime > nLastTime then
				nLastTime = frame.nOpenTime
				nLastIndex = i
			end
		end
	end
	if nLastIndex then
		local frame = Station.Lookup("Topmost/IE"..nLastIndex)
		x, y = frame:GetAbsPos()
		local wC, hC = Station.GetClientSize()
		if x + 890 <= wC and y + 630 <= hC then
			return x + 30, y + 30
		end
	end
	return 40, 40
end

-- append an item to parent
-- MY.UI.Append(hParent, szType,[ szName,] tArg)
-- hParent     -- an Window, Handle or MY.UI object
-- szName      -- name of the object inserted
-- tArg        -- param like width, height, left, right, etc.
MY.UI.Append = function(hParent, szType, szName, tArg)
	return MY.UI(hParent):append(szType, szName, tArg)
end

MY.UI.GetTreePath = function(raw)
	local tTreePath = {}
	if type(raw) == "table" and raw.GetTreePath then
		table.insert(tTreePath, (raw:GetTreePath()):sub(1, -2))
		while(raw and raw:GetType():sub(1, 3) ~= 'Wnd') do
			local szName = raw:GetName()
			if not szName or szName == '' then
				table.insert(tTreePath, 2, raw:GetIndex())
			else
				table.insert(tTreePath, 2, szName)
			end
			raw = raw:GetParent()
		end
	else
		table.insert(tTreePath, tostring(raw))
	end
	return table.concat(tTreePath, '/')
end

CP = {}
CP.Categories = {}

AttachTable = {}

if SERVER then
	if ConVarExists("ttt_fas2_ttt_wep_enabled") then
		local enabled = GetConVar("ttt_fas2_ttt_wep_enabled")
		hook.Add("TTTPrepareRound", "Remove default TTT weapons.", function()
			if !enabled:GetBool() then
				local TTTWeps = {
					"weapon_ttt_glock",
					"weapon_ttt_m16",
					"weapon_zm_mac10",
					"weapon_zm_pistol",
					"weapon_zm_revolver",
					"weapon_zm_rifle",
					"weapon_zm_shotgun",
					"weapon_zm_sledge"
				}
				for _,class in pairs(TTTWeps) do
					for _, wep in pairs( ents.FindByClass( class ) ) do
						wep:Remove()
					end
				end
			end
		end)
	end
end

if CLIENT then
	surface.CreateFont( "CP_LargeTitle", { font = "Roboto", size = 32, weight = 500, antialias = true } )
	surface.CreateFont( "CP_SmallTitle", { font = "Roboto", size = 16, weight = 1500, antialias = true } )
	
	local BGColor = Color( 64, 62, 46, 255 )
	local CPANEL = {}
	CP.ControlPanel = nil
	FASisMounted = nil
	
	hook.Add( "InitPostEntity", "Check if parent addon is mounted", function()
		for k, addon in pairs( engine.GetAddons() ) do
			if ( addon.wsid == "180507408" ) and addon.mounted then
				FASisMounted = true
			end
		end
	end)

	function CPANEL:Init()
		local cats = {}
		local items = {}
		local itms = {}
		local precat = {}
		local preitms = {}
		local hash = {}
		local categories = {}
		
		local firstCat = true
		local firstItem = true
		
		self:SetSize( math.Clamp( 1024, 0, ScrW() ), math.Clamp( 768, 0, ScrH() ) )
		self:SetPos( ( ScrW() / 2 ) - ( self:GetWide() / 2 ), ( ScrH() / 2 ) - ( self:GetTall() / 2 ) )
		
		local closeButton = vgui.Create("DButton", self)
		closeButton:SetFont("marlett")
		closeButton:SetText("r")
		closeButton.Paint = function() end
		closeButton:SetColor( Color( 255, 255, 255) )
		closeButton:SetSize( 32, 32 )
		closeButton:SetPos(self:GetWide() - 40, 8 )
		closeButton.DoClick = function()
			RunConsoleCommand("tttfas2_cp")
		end
		
		local catContainer = vgui.Create("DPanel", self)
		catContainer:SetTall(28)
		catContainer:Dock(TOP)
		catContainer:DockMargin( 0, 48, 0, 0 )
		
		local Container = vgui.Create("DPanel", self )
		Container:Dock(FILL)
		Container:DockMargin( 0, 0, 0, 0 )
		Container:SetSize( self:GetWide() - 60, self:GetTall() - 150 )
		Container:SetPos( ( self:GetWide() / 2 ) - ( Container:GetWide() / 2 ), 120 )
		
		local itmContainer = vgui.Create("DPanel", Container)
		itmContainer:Dock(FILL)
		itmContainer:DockMargin( 20, 20, 20, 20 )
		
		local function createSetting( n, ln, panel, itmcat )
			panel:Dock( FILL )
			panel:DockMargin( 20, 20, 20, 20 )
			
			local itm = vgui.Create("DPanel", panel )
			itm:Dock(FILL)
			itm:DockMargin(0, 0, 0, 0)
			itm:SetName(n)
			
			itm.Paint = function(pnl, w, h)
				surface.SetDrawColor( BGColor )
				surface.DrawRect( 0, 0, w, 48 )
		
				draw.SimpleText( ln, "CP_LargeTitle", 16, 8, color_white )
			end
			
			itm.UpdateColours = function(pnl)
				if pnl:GetActive() then return pnl:SetTextColor(Color(105, 105, 105, 255)) end
				if pnl.Hovered then return pnl:SetTextColor(Color(120, 120, 120, 255)) end
				pnl:SetTextColor(Color(140, 140, 140, 255))
			end
			
			itm.GetActive = function(pnl) return pnl.Active or false end
			itm.SetActive = function(pnl, state) pnl.Active = state end
	
			if firstItem then firstItem = false; itm:SetActive(true) end
	
			itm.OnDeactivate = function()
				panel:SetVisible(false)
				panel:SetZPos(-1)
			end
			itm.OnActivate = function()
				panel:SetVisible(true)
				panel:SetZPos(100)
			end
			itm.SelectedItem = function(pnl)
				for k, v in pairs(items) do v:SetActive(false) v:OnDeactivate() end
				itm:SetActive(true) itm:OnActivate()
			end
			
			if itmcat == "Weapon" then
				local itmEnabledLbl = vgui.Create( "DLabel", itm )
				itmEnabledLbl:Dock( TOP )
				itmEnabledLbl:DockMargin( 10, 75, 20, 10)
				itmEnabledLbl:SetText( "Enabled" )
				itmEnabledLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmEnabledLbl:SetFont( "CP_SmallTitle" )
				local itmEnabled = vgui.Create( "DCheckBoxLabel", itm )
				itmEnabled:Dock( TOP )
				itmEnabled:DockMargin( 20, 0, 20, 0 )
				itmEnabled:SetConVar( "ttt_fas2_wep_" .. n .."_enabled" )
				itmEnabled:SetDark( true )
				itmEnabled:SetText( "" )
				
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 10, 25, 20, 10)
				itmAquireLbl:SetText( "Availability" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquire = vgui.Create( "DCheckBoxLabel", itm )
				itmAquire:Dock( TOP )
				itmAquire:DockMargin( 20, 0, 20, 5 )
				itmAquire:SetText( "Available to everyone?" )
				itmAquire:SetConVar( "ttt_fas2_wep_" .. n .."_aquire" )
				itmAquire:SetDark( true )
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 20, 0, 20, 5)
				itmAquireLbl:SetText( "Available to:" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquireAvail = vgui.Create( "DComboBox", itm )
				itmAquireAvail:Dock( TOP )
				itmAquireAvail:DockMargin( 20, 0, 20, 0 )
				itmAquireAvail:AddChoice( "Traitors", 0 )
				itmAquireAvail:AddChoice( "Detectives", 1 )
				itmAquireAvail:AddChoice( "Both", 2 )
				if ConVarExists( "ttt_fas2_wep_" .. n .."_available" ) then
					local wepEnabled = GetConVar("ttt_fas2_wep_" .. n .."_available")
					if type(itmAquireAvail:GetOptionText( wepEnabled:GetInt() + 1)) != "string" then Dev( 2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: wep_available for ".. n .."is not a string.\n" ) return end
					itmAquireAvail:SetText( itmAquireAvail:GetOptionText( wepEnabled:GetInt() + 1))
				end
				function itmAquireAvail:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_wep_" .. n .."_available", data )
				end
				
				local itmDefaultLbl = vgui.Create( "DLabel", itm )
				itmDefaultLbl:Dock( TOP )
				itmDefaultLbl:DockMargin( 10, 25, 20, 10 )
				itmDefaultLbl:SetText( "Default equipment for:" )
				itmDefaultLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmDefaultLbl:SetFont( "CP_SmallTitle" )
				local itmDefault = vgui.Create( "DComboBox", itm )
				itmDefault:Dock( TOP )
				itmDefault:DockMargin( 20, 0, 20, 0 )
				itmDefault:AddChoice( "Neither", 0 )
				itmDefault:AddChoice( "Traitors", 1 )
				itmDefault:AddChoice( "Detectives", 2 )
				if ConVarExists( "ttt_fas2_wep_" .. n .."_defaultfor" ) then
					local wepDefaultFor = GetConVar("ttt_fas2_wep_" .. n .."_defaultfor")
					if type(itmDefault:GetOptionText( wepDefaultFor:GetInt() + 1)) != "string" then Dev( 2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: wep_defaultfor for ".. n .."is not a string.\n") return end
					itmDefault:SetText( itmDefault:GetOptionText( wepDefaultFor:GetInt() + 1 ))
				end
				function itmDefault:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_wep_" .. n .."_defaultfor", data )
				end
			end
			
			if itmcat == "Attachment" then
				local itmEnabledLbl = vgui.Create( "DLabel", itm )
				itmEnabledLbl:Dock( TOP )
				itmEnabledLbl:DockMargin( 10, 75, 20, 10)
				itmEnabledLbl:SetText( "Enabled" )
				itmEnabledLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmEnabledLbl:SetFont( "CP_SmallTitle" )
				local itmEnabled = vgui.Create( "DCheckBoxLabel", itm )
				itmEnabled:Dock( TOP )
				itmEnabled:DockMargin( 20, 0, 20, 0 )
				itmEnabled:SetConVar( "ttt_fas2_att_" .. n .."_enabled" )
				itmEnabled:SetDark( true )
				itmEnabled:SetText( "" )
				
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 10, 25, 20, 10)
				itmAquireLbl:SetText( "Availability" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquire = vgui.Create( "DCheckBoxLabel", itm )
				itmAquire:Dock( TOP )
				itmAquire:DockMargin( 20, 0, 20, 5 )
				itmAquire:SetText( "Available to everyone?" )
				itmAquire:SetConVar( "ttt_fas2_att_" .. n .."_aquire" )
				itmAquire:SetDark( true )
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 20, 0, 20, 5)
				itmAquireLbl:SetText( "Available to:" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquireAvail = vgui.Create( "DComboBox", itm )
				itmAquireAvail:Dock( TOP )
				itmAquireAvail:DockMargin( 20, 0, 20, 0 )
				itmAquireAvail:AddChoice( "Traitors", 0 )
				itmAquireAvail:AddChoice( "Detectives", 1 )
				itmAquireAvail:AddChoice( "Both", 2 )
				if ConVarExists( "ttt_fas2_att_" .. n .."_available" ) then
					local attAvailable = GetConVar("ttt_fas2_att_" .. n .."_available")
					if type(itmAquireAvail:GetOptionText( attAvailable:GetInt() + 1)) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: att_available for ".. n .."is not a string.\n") return end
					itmAquireAvail:SetText( itmAquireAvail:GetOptionText( attAvailable:GetInt() + 1 ))
				end
				function itmAquireAvail:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_att_" .. n .."_available", data )
				end
				
				local itmDefaultLbl = vgui.Create( "DLabel", itm )
				itmDefaultLbl:Dock( TOP )
				itmDefaultLbl:DockMargin( 10, 25, 20, 10 )
				itmDefaultLbl:SetText( "Default equipment for:" )
				itmDefaultLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmDefaultLbl:SetFont( "CP_SmallTitle" )
				local itmDefault = vgui.Create( "DComboBox", itm )
				itmDefault:Dock( TOP )
				itmDefault:DockMargin( 20, 0, 20, 0 )
				itmDefault:AddChoice( "Neither", 0 )
				itmDefault:AddChoice( "Traitors", 1 )
				itmDefault:AddChoice( "Detectives", 2 )
				if ConVarExists( "ttt_fas2_att_" .. n .."_defaultfor" ) then
					local attDefaultFor = GetConVar("ttt_fas2_att_" .. n .."_defaultfor")
					if type(itmDefault:GetOptionText( attDefaultFor:GetInt() + 1)) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: att_defaultfor for ".. n .."is not a string.\n") return end
					itmDefault:SetText( itmDefault:GetOptionText(attDefaultFor:GetInt() + 1 ))
				end
				function itmDefault:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_att_" .. n .."_defaultfor", data )
				end
			end
			
			if itmcat == "Support" then
				local itmEnabledLbl = vgui.Create( "DLabel", itm )
				itmEnabledLbl:Dock( TOP )
				itmEnabledLbl:DockMargin( 10, 75, 20, 10)
				itmEnabledLbl:SetText( "Enabled" )
				itmEnabledLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmEnabledLbl:SetFont( "CP_SmallTitle" )
				local itmEnabled = vgui.Create( "DCheckBoxLabel", itm )
				itmEnabled:Dock( TOP )
				itmEnabled:DockMargin( 20, 0, 20, 0 )
				itmEnabled:SetConVar( "ttt_fas2_sup_" .. n .."_enabled" )
				itmEnabled:SetDark( true )
				itmEnabled:SetText( "" )
				
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 10, 25, 20, 10)
				itmAquireLbl:SetText( "Availability" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquire = vgui.Create( "DCheckBoxLabel", itm )
				itmAquire:Dock( TOP )
				itmAquire:DockMargin( 20, 0, 20, 5 )
				itmAquire:SetText( "Available to everyone?" )
				itmAquire:SetConVar( "ttt_fas2_sup_" .. n .."_aquire" )
				itmAquire:SetDark( true )
				local itmAquireLbl = vgui.Create( "DLabel", itm )
				itmAquireLbl:Dock( TOP )
				itmAquireLbl:DockMargin( 20, 0, 20, 5)
				itmAquireLbl:SetText( "Available to:" )
				itmAquireLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmAquireLbl:SetFont( "CP_SmallTitle" )
				local itmAquireAvail = vgui.Create( "DComboBox", itm )
				itmAquireAvail:Dock( TOP )
				itmAquireAvail:DockMargin( 20, 0, 20, 0 )
				itmAquireAvail:AddChoice( "Traitors", 0 )
				itmAquireAvail:AddChoice( "Detectives", 1 )
				itmAquireAvail:AddChoice( "Both", 2 )
				if ConVarExists( "ttt_fas2_sup_" .. n .."_available" ) then
					local supAvailable = GetConVar("ttt_fas2_sup_" .. n .."_available")
					if type(itmAquireAvail:GetOptionText( supAvailable:GetInt() + 1)) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: sup_available for ".. n .."is not a string.\n") return end
					itmAquireAvail:SetText( itmAquireAvail:GetOptionText(supAvailable:GetInt() + 1 ))
				end
				function itmAquireAvail:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_sup_" .. n .."_available", data )
				end
				
				local itmDefaultLbl = vgui.Create( "DLabel", itm )
				itmDefaultLbl:Dock( TOP )
				itmDefaultLbl:DockMargin( 10, 25, 20, 10 )
				itmDefaultLbl:SetText( "Default equipment for:" )
				itmDefaultLbl:SetTextColor( Color( 0, 0, 0, 255 ) )
				itmDefaultLbl:SetFont( "CP_SmallTitle" )
				local itmDefault = vgui.Create( "DComboBox", itm )
				itmDefault:Dock( TOP )
				itmDefault:DockMargin( 20, 0, 20, 0 )
				itmDefault:AddChoice( "Neither", 0 )
				itmDefault:AddChoice( "Traitors", 1 )
				itmDefault:AddChoice( "Detectives", 2 )
				if ConVarExists( "ttt_fas2_sup_" .. n .."_defaultfor" ) then
					local supDefaultFor = GetConVar("ttt_fas2_sup_" .. n .."_defaultfor")
					if type(itmDefault:GetOptionText( supDefaultFor:GetInt() + 1)) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: sup_defaultfor for ".. n .."is not a string.\n") return end
					itmDefault:SetText( itmDefault:GetOptionText(supDefaultFor:GetInt() + 1 ))
				end
				function itmDefault:OnSelect( index, value, data )
					RunConsoleCommand( "ttt_fas2_sup_" .. n .."_defaultfor", data )
				end
				
				if ConVarExists("ttt_fas2_sup_" .. n .."_store") then
					local supStore = GetConVar("ttt_fas2_sup_" .. n .."_store")
					if supStore:GetInt() > 0 then
						local itmStoreSize = vgui.Create( "DNumSlider", itm )
						itmStoreSize:Dock( TOP )
						itmStoreSize:DockMargin( 20, 20, 20, 20 )
						itmStoreSize:SetSize( 150, 100 )
						itmStoreSize:SetText( "Cache Size" )
						itmStoreSize:SetDark( true )
						itmStoreSize:SetMin( 500 )
						itmStoreSize:SetMax( 5000 )
						itmStoreSize:SetDecimals( 0 )
						itmStoreSize:SetConVar(  "ttt_fas2_sup_" .. n .."_store" )
					end
				end
			end
			
			local warning = vgui.Create( "DLabel", itm )
			warning:Dock( BOTTOM )
			warning:DockMargin( 20, 20, 20, 20 )
			warning:SetText( "NOTICE: Changes will only take effect after map change or server restart." )
			warning:SetTextColor( Color( 255, 0, 0, 255 ) )
			warning:SetFont( "CP_SmallTitle" )
		
			table.insert(items, itm)
			
			return itm
		end
		
		local function createCat( text, panel, description )
			panel:SetParent( Container )
			panel:Dock( FILL )
			panel.Paint = function( pnl, w, h )
				surface.SetDrawColor ( 232, 232, 232, 255 )
				surface.DrawRect( 0, 0, w, h )
			end
			
			if firstCat then
				panel:SetZPos( 100 )
				panel:SetVisible( true )
			else 
				panel:SetZPos( 1 )
				panel:SetVisible( false )
			end
			
			local cat = vgui.Create( "DButton", catContainer )
			cat:Dock( LEFT )
			cat:SetText( "  ".. text .. "  " )
			cat:SetFont( "DermaDefault" )
			if description and description ~= "" then
				cat:SetToolTip( description )
			end
			
			cat.Paint = function( pnl, w, h )
				surface.SetDrawColor( 218, 218, 218, 255 )
				surface.DrawRect( 0, 0, w, h )
				
				if pnl:GetActive() then
					surface.SetDrawColor( BGColor )
					surface.DrawRect( 0, h - 3, w, 3 )
				end
			end
			
			cat.UpdateColors = function( pnl )
				if pnl:GetActive() then return pnl:SetTextColor( Color( 105, 105, 105, 255 ) ) end
				if pnl.Hovered then return pnl:SetTextColor( Color( 120, 120, 120, 255 ) ) end
				pnl:SetTextColor( Color( 140, 140, 140, 255 ) )
			end
			
			cat.PerformLayout = function( pnl )
				pnl:SizeToContents()
				pnl:SetWide( pnl:GetWide() + 12 )
				pnl:SetTall( pnl:GetParent():GetTall() )
				DLabel.PerformLayout( pnl )
				pnl:SetContentAlignment( 4 )
			end
			
			cat.GetActive = function( pnl ) 
				return 
				pnl.Active or false 
			end
			
			cat.SetActive = function( pnl, state ) 
				pnl.Active = state 
			end
			
			if firstCat then 
				firstCat = false
				cat:SetActive( true )
			end
			
			cat.OnDeactivate = function()
				panel:SetVisible( false )
				panel:SetZPos( 1 )
			end
			
			cat.OnActivate = function()
				panel:SetVisible( true )
				panel:SetZPos( 100 )
			end
			
			cat.DoClick = function( pnl )
				for k, v in pairs( cats ) do
					v:SetActive( false )
					v:OnDeactivate()
				end
				
				cat:SetActive( true )
				cat:OnActivate()
			end
			
			if LocalPlayer():IsAdmin() then
				local weaponList = vgui.Create( "DListView", panel )
				weaponList:Dock( LEFT )
				weaponList:DockMargin( 20, 20, 0, 20 )
				weaponList:SetSize( Container:GetWide() / 4, Container:GetTall() )
				weaponList:SetMultiSelect( false )
				weaponList:AddColumn( text )
				weaponList.OnClickLine = function( parent, line, inselected )
					local selected = line:GetValue( 2 )
					for k, v in pairs( items ) do	
						if v:GetName() == selected then
							v:SelectedItem()
						end
					end
				end
				
				for _, itemtbl in pairs(itms) do
					if itemtbl.cat == text then
						local settingsPanel = vgui.Create( "DPanel", panel, itemtbl.namelong )
						weaponList:AddLine(itemtbl.namelong, itemtbl.name)
						createSetting( itemtbl.name, itemtbl.namelong, settingsPanel, itemtbl.cat )
					end
				end
			end
			
			table.insert( cats, cat )
			
			return cat
		end
		local function createClientCont( text, panel, description )
			panel:SetParent( Container )
			panel:Dock( FILL )
			panel.Paint = function( pnl, w, h )
				surface.SetDrawColor ( 232, 232, 232, 255 )
				surface.DrawRect( 0, 0, w, h )
			end
			
			if firstCat then
				panel:SetZPos( 100 )
				panel:SetVisible( true )
			else 
				panel:SetZPos( 1 )
				panel:SetVisible( false )
			end
			
			local cat = vgui.Create( "DButton", catContainer )
			cat:Dock( RIGHT )
			cat:SetText( "  ".. text .. "  " )
			cat:SetFont( "DermaDefault" )
			if description and description ~= "" then
				cat:SetToolTip( description )
			end
			
			cat.Paint = function( pnl, w, h )
				surface.SetDrawColor( 218, 218, 218, 255 )
				surface.DrawRect( 0, 0, w, h )
				
				if pnl:GetActive() then
					surface.SetDrawColor( BGColor )
					surface.DrawRect( 0, h - 3, w, 3 )
				end
			end
			
			cat.UpdateColors = function( pnl )
				if pnl:GetActive() then return pnl:SetTextColor( Color( 105, 105, 105, 255 ) ) end
				if pnl.Hovered then return pnl:SetTextColor( Color( 120, 120, 120, 255 ) ) end
				pnl:SetTextColor( Color( 140, 140, 140, 255 ) )
			end
			
			cat.PerformLayout = function( pnl )
				pnl:SizeToContents()
				pnl:SetWide( pnl:GetWide() + 12 )
				pnl:SetTall( pnl:GetParent():GetTall() )
				DLabel.PerformLayout( pnl )
				pnl:SetContentAlignment( 4 )
			end
			
			cat.GetActive = function( pnl ) 
				return 
				pnl.Active or false 
			end
			
			cat.SetActive = function( pnl, state ) 
				pnl.Active = state 
			end
			
			if firstCat then 
				firstCat = false
				cat:SetActive( true )
			end
			
			cat.OnDeactivate = function()
				panel:SetVisible( false )
				panel:SetZPos( 1 )
			end
			
			cat.OnActivate = function()
				panel:SetVisible( true )
				panel:SetZPos( 100 )
			end
			
			cat.DoClick = function( pnl )
				for k, v in pairs( cats ) do
					v:SetActive( false )
					v:OnDeactivate()
				end
				
				cat:SetActive( true )
				cat:OnActivate()
			end
			
			local cliset = vgui.Create( "DPanel", panel )
			cliset:Dock( LEFT )
			cliset:DockMargin( 20, 20, 0, 20 )
			cliset:SetSize( Container:GetWide() / 3, Container:GetTall() )
			
			
			local lblHUD = vgui.Create( "DLabel", cliset )
			lblHUD:Dock( TOP )
			lblHUD:DockMargin( 10, 25, 20, 10)
			lblHUD:SetText( "HUD Control" )
			lblHUD:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblHUD:SetFont( "CP_SmallTitle" )
			local cbHUDDisable = vgui.Create( "DCheckBoxLabel", cliset )
			cbHUDDisable:Dock( TOP )
			cbHUDDisable:DockMargin( 20, 0, 20, 5 )
			cbHUDDisable:SetText( "Disable HUD elements?" )
			cbHUDDisable:SetConVar( "fas2_nohud" )
			cbHUDDisable:SetDark( true )
			local cbCustomHUD = vgui.Create( "DCheckBoxLabel", cliset )
			cbCustomHUD:Dock( TOP )
			cbCustomHUD:DockMargin( 20, 0, 20, 5 )
			cbCustomHUD:SetText( "Enable custom HUD elements?" )
			cbCustomHUD:SetConVar( "fas2_customhud" )
			cbCustomHUD:SetDark( true )
			local cbHoldToAim = vgui.Create( "DCheckBoxLabel", cliset )
			cbHoldToAim:Dock( TOP )
			cbHoldToAim:DockMargin( 20, 0, 20, 5 )
			cbHoldToAim:SetText( "Enable hold-to-aim?" )
			cbHoldToAim:SetConVar( "fas2_holdtoaim" )
			cbHoldToAim:SetDark( true )
			local cbRealBipod = vgui.Create( "DCheckBoxLabel", cliset )
			cbRealBipod:Dock( TOP )
			cbRealBipod:DockMargin( 20, 0, 20, 5 )
			cbRealBipod:SetText( "Enable realistic bi-pod behaviour?" )
			cbRealBipod:SetConVar( "fas2_alternatebipod" )
			cbRealBipod:SetDark( true )
			local cbBlur = vgui.Create( "DCheckBoxLabel", cliset )
			cbBlur:Dock( TOP )
			cbBlur:DockMargin( 20, 0, 20, 5 )
			cbBlur:SetText( "Enable blur effects?" )
			cbBlur:SetConVar( "fas2_blureffects" )
			cbBlur:SetDark( true )
			local cbBlurDepth = vgui.Create( "DCheckBoxLabel", cliset )
			cbBlurDepth:Dock( TOP )
			cbBlurDepth:DockMargin( 20, 0, 20, 5 )
			cbBlurDepth:SetText( "Enable blur depth?" )
			cbBlurDepth:SetConVar( "fas2_blureffects_depth" )
			cbBlurDepth:SetDark( true )
			local cbHitMark = vgui.Create( "DCheckBoxLabel", cliset )
			cbHitMark:Dock( TOP )
			cbHitMark:DockMargin( 20, 0, 20, 5 )
			cbHitMark:SetText( "Enable hit marker?" )
			cbHitMark:SetConVar( "fas2_hitmarker" )
			cbHitMark:SetDark( true )
			
			local lblHandRig = vgui.Create( "DLabel", cliset )
			lblHandRig:Dock( TOP )
			lblHandRig:DockMargin( 10, 25, 20, 10)
			lblHandRig:SetText( "Hand Rig Control" )
			lblHandRig:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblHandRig:SetFont( "CP_SmallTitle" )
			local lblSleeves = vgui.Create( "DLabel", cliset )
			lblSleeves:Dock( TOP )
			lblSleeves:DockMargin( 20, 0, 20, 2)
			lblSleeves:SetText( "Sleeves" )
			lblSleeves:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblSleeves:SetFont( "CP_SmallTitle" )
			local cmbHandRig = vgui.Create( "DComboBox", cliset )
			cmbHandRig:Dock( TOP )
			cmbHandRig:DockMargin( 20, 0, 20, 5 )
			cmbHandRig:AddChoice( "Short", 0 )
			cmbHandRig:AddChoice( "Long", 1 )
			if ConVarExists( "fas2_handrig" ) then
				local handrig = GetConVar( "fas2_handrig" )
				if type(cmbHandRig:GetOptionText( handrig:GetInt() + 1)) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: fas2_handrig option is not valid.\n") return end
				cmbHandRig:SetText( cmbHandRig:GetOptionText( handrig:GetInt() + 1 ) )
			else
				ErrorNoHalt( "[Firearms:Source 2.0 Weapons for TTT] ConVar 'fas2_handrig' does not exist.\n" )
			end
			function cmbHandRig:OnSelect( index, value, data )
				RunConsoleCommand( "fas2_handrig", data )
				RunConsoleCommand( "fas2_handrig_applynow" )
			end
			local lblSkin = vgui.Create( "DLabel", cliset )
			lblSkin:Dock( TOP )
			lblSkin:DockMargin( 20, 0, 20, 2)
			lblSkin:SetText( "Skin Color" )
			lblSkin:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblSkin:SetFont( "CP_SmallTitle" )
			local cmbSkin = vgui.Create( "DComboBox", cliset )
			cmbSkin:Dock( TOP )
			cmbSkin:DockMargin( 20, 0, 20, 2 )
			cmbSkin:AddChoice( "White", 1 )
			cmbSkin:AddChoice( "Tan", 2 )
			cmbSkin:AddChoice( "Black", 3 )
			cmbSkin:AddChoice( "Camouflage", 4 )
			if ConVarExists( "fas2_handskin" ) then
				local handskin = GetConVar( "fas2_handskin" )
				if type(cmbSkin:GetOptionText( handskin:GetInt())) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: fas2_handskin option is not valid.\n") return end
				cmbSkin:SetText( cmbSkin:GetOptionText( handskin:GetInt() ) )
			else
				ErrorNoHalt("[Firearms:Source 2.0 Weapons for TTT] ConVar 'fas2_handskin' does not exist.\n")
			end
			function cmbSkin:OnSelect( index, value, data )
				RunConsoleCommand( "fas2_handskin", data )
				RunConsoleCommand( "fas2_handrig_applynow" )
			end
			local lblSleevePat = vgui.Create( "DLabel", cliset )
			lblSleevePat:Dock( TOP )
			lblSleevePat:DockMargin( 20, 0, 20, 2)
			lblSleevePat:SetText( "Sleeve Pattern" )
			lblSleevePat:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblSleevePat:SetFont( "CP_SmallTitle" )
			local cmdSleevePat = vgui.Create( "DComboBox", cliset )
			cmdSleevePat:Dock( TOP )
			cmdSleevePat:DockMargin( 20, 0, 20, 2 )
			cmdSleevePat:AddChoice( "Woodland", 1 )
			cmdSleevePat:AddChoice( "ACU", 2 )
			if ConVarExists( "fas2_sleeveskin" ) then
				local sleeveskin = GetConVar( "fas2_sleeveskin" )
				if type(cmdSleevePat:GetOptionText( sleeveskin:GetInt())) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: fas2_sleeveskin option is not valid.\n") return end
				cmdSleevePat:SetText( cmdSleevePat:GetOptionText( sleeveskin:GetInt() ) )
			else
				ErrorNoHalt("[Firearms:Source 2.0 Weapons for TTT] ConVar 'fas2_sleeveskin' does not exist.\n")
			end
			function cmdSleevePat:OnSelect( index, value, data )
				RunConsoleCommand( "fas2_sleeveskin", data )
				RunConsoleCommand( "fas2_handrig_applynow" )
			end
			local lblGlovePat = vgui.Create( "DLabel", cliset )
			lblGlovePat:Dock( TOP )
			lblGlovePat:DockMargin( 20, 0, 20, 2)
			lblGlovePat:SetText( "Glove Pattern" )
			lblGlovePat:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblGlovePat:SetFont( "CP_SmallTitle" )
			local cmdGlovePat = vgui.Create( "DComboBox", cliset )
			cmdGlovePat:Dock( TOP )
			cmdGlovePat:DockMargin( 20, 0, 20, 2 )
			cmdGlovePat:AddChoice( "Nomex", 1 )
			cmdGlovePat:AddChoice( "Black", 2 )
			cmdGlovePat:AddChoice( "Desert Khaki", 3 )
			cmdGlovePat:AddChoice( "Multicam", 4 )
			if ConVarExists( "fas2_gloveskin" ) then
				local gloveskin = GetConVar( "fas2_gloveskin" )
				if type(cmdGlovePat:GetOptionText( gloveskin:GetInt())) != "string" then Dev(2, "[Firearms:Source 2.0 Weapons for TTT] ERROR: fas2_gloveskin option is not valid.\n") return end
				cmdGlovePat:SetText( cmdGlovePat:GetOptionText( gloveskin:GetInt() ) )
			else
				ErrorNoHalt("[Firearms:Source 2.0 Weapons for TTT] ConVar 'fas2_gloveskin' does not exist.\n")
			end
			function cmdGlovePat:OnSelect( index, value, data )
				RunConsoleCommand( "fas2_gloveskin", data )
				RunConsoleCommand( "fas2_handrig_applynow" )
			end
			local lblTextSize = vgui.Create( "DLabel", cliset )
			lblTextSize:Dock( TOP )
			lblTextSize:DockMargin( 10, 25, 20, 10)
			lblTextSize:SetText( "HUD Text Size" )
			lblTextSize:SetTextColor( Color( 0, 0, 0, 255 ) )
			lblTextSize:SetFont( "CP_SmallTitle" )
			local nsTextSize = vgui.Create( "DNumSlider", cliset )
			nsTextSize:Dock( TOP )
			nsTextSize:DockMargin( 20, 0, 20, 2)
			nsTextSize:SetDecimals( 2 )
			nsTextSize:SetMin( 0.2 )
			nsTextSize:SetMax( 2 )
			nsTextSize:SetConVar("fas2_textsize")
			nsTextSize:SetValue( GetConVarNumber( "fas2_textsize" ) )
			
			local credits = vgui.Create( "DPanel", panel )
			credits:Dock( FILL )
			credits:DockMargin( 20, 20, 20, 20 )
			credits:SetSize( ( Container:GetWide() / 3 ) * 2, Container:GetTall() )
			local fas2logo = vgui.Create( "Material", credits )
			fas2logo.AutoSize = false
			fas2logo:SetSize( credits:GetWide() / 3, credits:GetTall() / 3 )
			fas2logo:SetPos( ( credits:GetWide() / 2 ) - ( fas2logo:GetWide() / 2 ), 10 )
			fas2logo:SetMaterial( "vgui/fas2_logo" )
			local creditstxt = vgui.Create( "DLabel", credits )
			creditstxt:SetText( "Firearms:Source is the property of the Firearms: Source Development Team." )
			creditstxt:SetFont( "CP_SmallTitle" )
			creditstxt:SizeToContents()
			creditstxt:SetPos( ( ( credits:GetWide() / 2 ) - ( creditstxt:GetWide() / 2 ) ), fas2logo:GetTall() + 20 )
			creditstxt:SetTextColor( Color( 0, 0, 0, 255 ) )
			local creditstxt2 = vgui.Create( "DLabel", credits )
			creditstxt2:SetText( "'Firearms:Source 2.0 SWEPs' are the property of Spy." )
			creditstxt2:SetFont( "CP_SmallTitle" )
			creditstxt2:SetSize( credits:GetWide() - 300, 40 )
			creditstxt2:SetWrap( true )
			creditstxt2:SetPos( ( ( credits:GetWide() / 2 ) - ( creditstxt2:GetWide() / 2 ) ) + 10, creditstxt:GetTall() + fas2logo:GetTall() + 30 )
			creditstxt2:SetTextColor( Color( 0, 0, 0, 255 ) )
			local creditstxt3 = vgui.Create( "DLabel", credits )
			creditstxt3:SetText( "The adaptation of the 'Firearms:Source 2.0 SWEPs' for 'Trouble in Terrorist Town' is the property of doUbleU." )
			creditstxt3:SetFont( "CP_SmallTitle" )
			creditstxt3:SetSize( credits:GetWide() - 255, 40 )
			creditstxt3:SetWrap( true )
			creditstxt3:SetPos( ( ( credits:GetWide() / 2 ) - ( creditstxt3:GetWide() / 2 ) ) + 20, creditstxt:GetTall() + creditstxt2:GetTall() + fas2logo:GetTall() + 40 )
			creditstxt3:SetTextColor( Color( 0, 0, 0, 255 ) )
			
			table.insert( cats, cat )
			
			return cat
		end
		local function createServerCont( text, panel, description )
			panel:SetParent( Container )
			panel:Dock( FILL )
			panel.Paint = function( pnl, w, h )
				surface.SetDrawColor ( 232, 232, 232, 255 )
				surface.DrawRect( 0, 0, w, h )
			end
			
			if firstCat then
				panel:SetZPos( 100 )
				panel:SetVisible( true )
			else 
				panel:SetZPos( 1 )
				panel:SetVisible( false )
			end
			
			local cat = vgui.Create( "DButton", catContainer )
			cat:Dock( LEFT )
			cat:SetText( "  ".. text .. "  " )
			cat:SetFont( "DermaDefault" )
			if description and description ~= "" then
				cat:SetToolTip( description )
			end
			
			cat.Paint = function( pnl, w, h )
				surface.SetDrawColor( 218, 218, 218, 255 )
				surface.DrawRect( 0, 0, w, h )
				
				if pnl:GetActive() then
					surface.SetDrawColor( BGColor )
					surface.DrawRect( 0, h - 3, w, 3 )
				end
			end
			
			cat.UpdateColors = function( pnl )
				if pnl:GetActive() then return pnl:SetTextColor( Color( 105, 105, 105, 255 ) ) end
				if pnl.Hovered then return pnl:SetTextColor( Color( 120, 120, 120, 255 ) ) end
				pnl:SetTextColor( Color( 140, 140, 140, 255 ) )
			end
			
			cat.PerformLayout = function( pnl )
				pnl:SizeToContents()
				pnl:SetWide( pnl:GetWide() + 12 )
				pnl:SetTall( pnl:GetParent():GetTall() )
				DLabel.PerformLayout( pnl )
				pnl:SetContentAlignment( 4 )
			end
			
			cat.GetActive = function( pnl ) 
				return 
				pnl.Active or false 
			end
			
			cat.SetActive = function( pnl, state ) 
				pnl.Active = state 
			end
			
			if firstCat then 
				firstCat = false
				cat:SetActive( true )
			end
			
			cat.OnDeactivate = function()
				panel:SetVisible( false )
				panel:SetZPos( 1 )
			end
			
			cat.OnActivate = function()
				panel:SetVisible( true )
				panel:SetZPos( 100 )
			end
			
			cat.DoClick = function( pnl )
				for k, v in pairs( cats ) do
					v:SetActive( false )
					v:OnDeactivate()
				end
				
				cat:SetActive( true )
				cat:OnActivate()
			end
			
			local svset = vgui.Create( "DPanel", panel )
			svset:Dock( FILL )
			svset:DockMargin( 20, 20, 20, 20 )
			svset:SetSize( Container:GetWide() / 3, Container:GetTall() )
			
			local defaultTTTWeps = vgui.Create( "DCheckBoxLabel", svset )
			defaultTTTWeps:Dock( TOP )
			defaultTTTWeps:DockMargin( 20, 20, 20, 0 )
			defaultTTTWeps:SetText( "Enable default CS:S weapons?" )
			defaultTTTWeps:SetConVar( "ttt_fas2_ttt_wep_enabled" )
			defaultTTTWeps:SetDark( 1 )
			if ConVarExists( "ttt_fas2_ttt_wep_enabled" ) then
				local defaultWeps = GetConVar( "ttt_fas2_ttt_wep_enabled" )
				defaultTTTWeps:SetValue( defaultWeps:GetBool() )
			end		
			
			local explainOne = vgui.Create( "DLabel", svset )
			explainOne:Dock( TOP )
			explainOne:DockMargin( 44, 0, 20, 0 )
			explainOne:SetText( "If you're having issues switching weapons, disable the default CS:S weapons." )
			explainOne:SetDark( 1 )
			explainOne:SetFont( "CP_SmallTitle" )
			local explainTwo = vgui.Create( "DLabel", svset )
			explainTwo:Dock( TOP )
			explainTwo:DockMargin( 44, 0, 20, 0 )
			explainTwo:SetText( "This setting will take effect next round." )
			explainTwo:SetTextColor( Color( 255, 0, 0, 255 ) )
			explainTwo:SetFont( "CP_SmallTitle" )
			
			table.insert( cats, cat )
			
			return cat
		end
		
		local function populateCatsAndItems()
			table.Empty( categories )
			table.Empty( precat )
			table.Empty( itms )
			table.Empty( preitms )
			
			for _, wep in pairs( weapons.GetList() ) do
				if wep.Category == "TTT FA:S 2.0 Weapons" then
					table.insert( precat, wep.EquipMenuData[ "type" ] )
					table.insert( preitms, { cat = wep.EquipMenuData[ "type" ], name = wep.TableName, namelong = wep.EquipMenuData[ "desc" ] } )
				end
			end
			
			for _, item in pairs( AttachTable ) do
					if item.category == "TTT FA:S 2.0 Attachment" then
						table.insert( precat, item.type)
						table.insert( preitms, { cat = item.type, name = item.tablename, namelong = item.name } )
					end
			end
		end
		
		populateCatsAndItems()
		
		for _, v in ipairs( precat ) do
			if ( not hash[v] ) then	
				categories[#categories+1] = v
				hash[v] = true
			end
		end
		
		for _, v in ipairs( preitms ) do
			if ( not hash[v.name] ) then
				itms[#itms+1] = v
				hash[v.name] = true
			end
		end
		
		CPClientControl = vgui.Create( "DPanel")
		createClientCont( "Client Settings", CPClientControl, "HUD and hand model settings." )
		
		if LocalPlayer():IsAdmin() then
			CPServerTab = vgui.Create("DPanel")
			createServerCont( "Optional Settings", CPServerTab, "Optional settings for TTT FA:S2 Weapons." )
			for _, CATEGORY in pairs(categories) do
				CPCategoryTab = vgui.Create("DPanel")
				createCat(CATEGORY, CPCategoryTab, nil ) 
			end
		end
	end

	function CPANEL:Paint( w, h )
		Derma_DrawBackgroundBlur( self )
		
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, w, h )
		
		surface.SetDrawColor( BGColor )
		surface.DrawRect( 0, 0, w, 48 )
		
		draw.SimpleText( "TTT Firearms:Source Weapons - Control Panel", "CP_LargeTitle", 16, 8, color_white )
		hook.Call( "RefreshVM" )
	end

	vgui.Register( "DTTTFAS2CP", CPANEL )
	
	concommand.Add( "tttfas2_cp", function( ply, cmd, args )
		if GAMEMODE_NAME == "terrortown" then
			if FASisMounted then
				if not CP.ControlPanel then
					CP.ControlPanel = vgui.Create('DTTTFAS2CP')
					CP.ControlPanel:SetVisible(false)
				end
		
				if CP.ControlPanel:IsVisible() then
					CP.ControlPanel:Hide()
					gui.EnableScreenClicker(false)
				else
					CP.ControlPanel:Show()
					gui.EnableScreenClicker(true)
				end
			else
				MsgC( Color( 255, 255, 100 ), "[Firearms:Source 2.0 Weapons for TTT] 'FA:S 2.0 Alpha SWEPs' addon not installed or mounted.\n" )
			end
		else
			MsgC( Color( 255, 255, 100 ), "Firearms:Source 2 weapons for TTT are only available in the 'Trouble in Terrorist Town' gamemode.\n" )
		end
	end)
end
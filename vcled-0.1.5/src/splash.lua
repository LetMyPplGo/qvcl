require "vcl"

local VCL,_VCLED_VERSION = VCL,_VCLED_VERSION

module "Splash"

local mainAbout=VCL.Form()
mainAbout._={position="poDesktopCenter",borderstyle="bsNone",bordericons="[]",color=VCL.clWhite,width=400,height=200,formstyle="fsStayOnTop",} -- formstyle="fsSplash",
VCL.Shape(mainAbout)._ = { borderspacing={around=5, bottom=30},align="alCLient" }
VCL.Label(mainAbout)._ = { caption="VCLed v".._VCLED_VERSION,top=30,left=110,font={size=20,style="fsBold"} }
VCL.Memo(mainAbout)._  = { borderstyle="bsNone",top=80,left=40,width=330,height=80,alignment="taCenter", readonly=true, tabstop=false,
					     font={name="Courier New", size=8,color=VCL.clGreen},
						 lines="Scriptable text editor with syntax highlighting\n\nProgrammed in LUA\n\nRequires VCLua v0.3.5 library" }

function onCloseSplash(t)
	mainAbout:Close()
	t:Free()
end

function Show()
	local t=VCL.Timer()
	t._={ontimer="Splash.onCloseSplash",interval=1000}
	mainAbout:ShowModal()	
	-- adds close button to AboutBox
	VCL.SpeedButton(mainAbout,"aboutButton")._={top=175,left=335,width=60,caption="Close",flat=true,transparent=true, onClick="Splash.onClickAbout"}
	mainAbout._={position="poMainformCenter"}
end

function ShowAboutBox()
	mainAbout:ShowModal()
end

function onClickAbout()
	mainAbout:Close()
end


require "vcl"
require "lxp"
require "xfm"

testform = [[
<?xml version="1.0" encoding="ISO-8859-1"?>
<Form name="myForm">
	<property name="caption" value="My Form" />
	<property name="width" value="400" />
	<property name="height" value="400" />
	<StatusBar name="myStatusBar">
	</StatusBar>	
	<Panel name="myPanel">
	    <property name="align" value="alClient" />
	    <property name="caption" value="" />
		<event name="onclick" value="onPanelClick">
				onPanelClick = function(Sender)
					print("CLICK1",Sender.name)
				end
		</event>	    
		<Button name="myButton1">
			<property name="caption" value="My Button 1" />
			<property name="top" value="20" />
			<property name="left" value="20" />	
			<event name="onclick" value="onClick">
				onClick = function(Sender)
					print("CLICK2",Sender.name)
				end
			</event>
		</Button>
		<Button name="myButton2">
			<property name="caption" value="My Button 2" />	
			<property name="top" value="50" />
			<property name="left" value="20" />
			<event name="onclick" value="onButton2Click">
				onButton2Click = function(Sender)
					print("CLICK3",Sender.name)
				end
			</event>
		</Button>
		<Memo name="myMemo">
			<property name="top" value="80" />
			<property name="left" value="20" />
			<property name="color" value="clInfoBk" />
			<event name="onchange" value="onMemoChange">
				onMemoChange = function(Sender)
					print("MEMOLINES",table.getn(Sender:GetText()),Sender:Count())
				end
			</event>			
		</Memo>
	</Panel>
</Form>
]]

xfm.parse(testform):ShowModal()

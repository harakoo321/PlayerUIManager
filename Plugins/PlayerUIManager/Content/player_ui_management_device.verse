using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
player_ui_management_device<public> := class(creative_device):
    var PlayerWidgetMap : [player]widget_holder = map{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        for:
            Player : GetPlayspace().GetPlayers()
            set PlayerWidgetMap[Player] = widget_holder{ Player := Player }
        do:

    AddWidget<public>(Player : player, Widget : widget) : void =
        if (WidgetHolder := PlayerWidgetMap[Player]):
            WidgetHolder.AddWidget(Widget)
    
    RemoveWidget<public>(Player : player, Widget : widget) : void =
        if (WidgetHolder := PlayerWidgetMap[Player]):
            WidgetHolder.RemoveWidget(Widget)

    RemoveAllWidget<public>(Player : player) : void =
        if (WidgetHolder := PlayerWidgetMap[Player]):
            WidgetHolder.RemoveAllWidget()

widget_holder := class:
    Player : player
    var Widgets<private> : []widget = array{}

    AddWidget(Widget : widget):void=
        if (PlayerUI := GetPlayerUI[Player], set Widgets += array{ Widget }):
            PlayerUI.AddWidget(Widget)

    RemoveWidget(Widget : widget) : void =
        if (PlayerUI := GetPlayerUI[Player], set Widgets = Widgets.RemoveAllElements(Widget)):
            PlayerUI.RemoveWidget(Widget)

    RemoveAllWidget() : void =
        if (PlayerUI := GetPlayerUI[Player]):
            for (Widget : Widgets):
                PlayerUI.RemoveWidget(Widget)
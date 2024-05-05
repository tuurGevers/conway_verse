using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Verse.org/Random }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/UI }

Main := class(creative_device):
    @editable TestCube:creative_prop_asset = DefaultCreativePropAsset

    OnBegin<override>()<suspends>:void=
        C := Conway{Cube:=TestCube}
        C.StartConway()
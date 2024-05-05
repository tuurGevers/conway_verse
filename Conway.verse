using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Verse.org/Random }
using { /Fortnite.com/Game }
using { /UnrealEngine.com/Temporary/UI }

Cell := class:
    var State: int
    var Prop: creative_prop = creative_prop{}
    var PreviousState: int = 0

Conway := class():
    var Grid: [][]Cell = array{}
    Cube: creative_prop_asset
    var ChunkSize: int = 10
    var CurrentChunkX: int = 0
    var CurrentChunkY: int = 0

    StartConway() <suspends>: void =
        InitGrid(40)
        DrawInitial()
        loop:
            UpdateGrid()
            Sleep(0.1)

    DrawInitial(): void =
        for (I := 0 .. Grid.Length - 1):
            for (J := 0 .. Grid[I].Length - 1):
                if (Grid[I][J].State = 1):
                    Prop := SpawnTarget(vector3{X := I * 100.0, Y := J * 100.0, Z := 50.0}, Cube)
                    if (set Grid[I][J].Prop = Prop){}
                    if (set Grid[I][J].PreviousState = 1){}

    InitGrid(Size: int): void =
        for (I := 0 .. Size - 1):
            set Grid += array{array{}}
            for (J := 0 .. Size - 1):
                State := GetRandomInt(0, 1)
                if (set Grid[I] += array{Cell{State := State}}){}

    GetNeighbours(X: int, Y: int): int =
        var Neighbours: int = 0
        for (I := X - 1 .. X + 1):
            for (J := Y - 1 .. Y + 1):
                if (I >= 0 and I < Grid.Length and J >= 0 and J < Grid[I].Length and (not I = X or not J = Y)):
                    if (set Neighbours += Grid[I][J].PreviousState){}
        return Neighbours

    UpdateGrid()<suspends>:void=
        for(I:=0..3):
            spawn. UpdateGridChunk()
            IncrementChunkCoordinates()
            spawn. DrawGridChunk()

    UpdateGridChunk()<suspends>: void =
        for (I := CurrentChunkX .. Min(CurrentChunkX + ChunkSize - 1, Grid.Length - 1)):
            for (J := CurrentChunkY .. Min(CurrentChunkY + ChunkSize - 1, Grid[I].Length - 1)):
                if (set Grid[I][J].PreviousState = Grid[I][J].State){}
        for (I := CurrentChunkX .. Min(CurrentChunkX + ChunkSize - 1, Grid.Length - 1)):
            for (J := CurrentChunkY .. Min(CurrentChunkY + ChunkSize - 1, Grid[I].Length - 1)):
                Neighbours := GetNeighbours(I, J)
                if (Grid[I][J].State = 1 and (Neighbours < 2 or Neighbours > 3)):
                    if (set Grid[I][J].State = 0){}
                else if (Grid[I][J].State = 0 and Neighbours = 3):
                    if (set Grid[I][J].State = 1){}


    DrawGridChunk()<suspends>: void =
        for (I := CurrentChunkX .. Min(CurrentChunkX + ChunkSize - 1, Grid.Length - 1)):
            for (J := CurrentChunkY .. Min(CurrentChunkY + ChunkSize - 1, Grid[I].Length - 1)):
                if (Grid[I][J].PreviousState = 0 and Grid[I][J].State = 1):
                    Prop := SpawnTarget(vector3{X := I * 100.0, Y := J * 100.0, Z := 50.0}, Cube)
                    if (set Grid[I][J].Prop = Prop){}
                else if (Grid[I][J].PreviousState = 1 and Grid[I][J].State = 0):
                    if (Prop := Grid[I][J].Prop):
                        Prop.Dispose()
                        if (set Grid[I][J].Prop = creative_prop{}){}

    IncrementChunkCoordinates(): void =
        if (CurrentChunkY + ChunkSize >= Grid[0].Length):
            if (CurrentChunkX + ChunkSize >= Grid.Length):
                set CurrentChunkX = 0
                set CurrentChunkY = 0
            else:
                set CurrentChunkX += ChunkSize
                set CurrentChunkY = 0
        else:
            set CurrentChunkY += ChunkSize

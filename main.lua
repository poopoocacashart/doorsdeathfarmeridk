local PathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local targetPositions = {
    Vector3.new(250, -0, -10),
    Vector3.new(268, -0, -41),
    Vector3.new(235, -0, -52),
    Vector3.new(265, -0, -51)
}
local proxprompt = workspace.CurrentRooms["0"].Door.Lock.UnlockPrompt
local crouchthing = workspace.CurrentRooms["0"].Assets.Luggage_Cart_Crouch
crouchthing:Destroy()

local path = PathfindingService:CreatePath({
    AgentRadius = 2,
    AgentHeight = 5,
    AgentCanJump = false,
    AgentMaxSlope = 45,
})
local function walkToTarget(targetPosition)
    path:ComputeAsync(character.PrimaryPart.Position, targetPosition)

    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()

        for _, waypoint in ipairs(waypoints) do
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait()

            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
        end
    else
        warn("Pathfinding failed to " .. tostring(targetPosition))
    end
end

local function walkThroughAllPoints()
    for index, targetPosition in ipairs(targetPositions) do
        walkToTarget(targetPosition)

        -- Fire the ProximityPrompt if this is the last target position
        if index == #targetPositions then
            fireproximityprompt(proxprompt)
        end
    end
end

walkThroughAllPoints()



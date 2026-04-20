local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:FindFirstChild("remotes")
local fishCaughtRemote = remote and remote:FindFirstChild("fishCaught")

if fishCaughtRemote then
    while true do
        fishCaughtRemote:FireServer(
            Vector3.new(-1, -1, -1),
            -1
        )
        task.wait(0.01)
    end
end
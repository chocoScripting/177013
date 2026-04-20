-- Panel Script Loader dengan Luna UI Library
-- Fetch dan execute script dari GitHub

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Luna Library Link (dari GitHub raw content)
local LUNA_LIBRARY_URL = "https://raw.githubusercontent.com/Floating-Tunas/FloatingTunas-Windows-v2-Updated/main/Dependencies/Luna.lua"

-- Script Registry - Daftar script yang bisa diload
local SCRIPTS = {
    {
        name = "Pixel Blade Fishing",
        url = "https://raw.githubusercontent.com/chocoScripting/177013/refs/heads/main/pixelBladeFishing.lua",
        description = "Script fishing untuk Pixel Blade"
    },
    {
        name = "Pixel Blade Main",
        url = "https://raw.githubusercontent.com/chocoScripting/177013/refs/heads/main/pixelBladeMain.lua",
        description = "Script utama untuk Pixel Blade"
    }
}

-- Variabel global
local Luna = nil
local isLoading = false

-- ============================================
-- FUNCTION: Load Luna Library
-- ============================================
local function loadLunaLibrary()
    print("[Panel] Loading Luna Library...")
    local success, result = pcall(function()
        local lunaCode = HttpService:GetAsync(LUNA_LIBRARY_URL)
        return load(lunaCode)()
    end)
    
    if success then
        print("[Panel] Luna Library loaded successfully!")
        return result
    else
        print("[Panel] Error loading Luna: " .. tostring(result))
        return nil
    end
end

-- ============================================
-- FUNCTION: Load Script dari GitHub
-- ============================================
local function loadScriptFromGitHub(url, scriptName)
    if isLoading then
        print("[Panel] Sudah ada script yang sedang diload, tunggu dulu...")
        return false
    end
    
    isLoading = true
    print("[Panel] Loading: " .. scriptName .. "...")
    
    local success, result = pcall(function()
        local scriptCode = HttpService:GetAsync(url)
        local scriptFunc = load(scriptCode)
        
        if scriptFunc then
            print("[Panel] Executing: " .. scriptName)
            scriptFunc()
            return true
        else
            print("[Panel] Gagal load script: " .. scriptName)
            return false
        end
    end)
    
    if success and result then
        print("[Panel] " .. scriptName .. " berhasil dijalankan!")
    else
        print("[Panel] Error: " .. tostring(result))
    end
    
    isLoading = false
    return success and result
end

-- ============================================
-- FUNCTION: Create Panel UI dengan Luna
-- ============================================
local function createPanelUI()
    if not Luna then
        print("[Panel] Luna library tidak tersedia!")
        return
    end
    
    print("[Panel] Creating Panel UI...")
    
    -- Buat window utama
    local window = Luna:CreateWindow({
        Title = "Script Panel",
        Author = "Panel Manager",
        Size = UDim2.new(0, 350, 0, 400),
    })
    
    -- Tambah welcome tab
    local tab = window:CreateTab({
        Name = "Scripts",
        Icon = "rbxassetid://7734307357"
    })
    
    -- Label
    tab:AddLabel({
        Title = "Pilih Script untuk Dijalankan"
    })
    
    -- Tambah button untuk setiap script
    for i, script in ipairs(SCRIPTS) do
        tab:AddButton({
            Title = script.name,
            Description = script.description,
            Callback = function()
                loadScriptFromGitHub(script.url, script.name)
            end
        })
    end
    
    -- Divider
    tab:AddDivider()
    
    -- Info label
    tab:AddLabel({
        Title = "Total Scripts: " .. tostring(#SCRIPTS)
    })
    
    print("[Panel] Panel UI created successfully!")
end

-- ============================================
-- MAIN EXECUTION
-- ============================================
print("[Panel] Initializing Panel System...")

-- Load Luna Library
Luna = loadLunaLibrary()

-- Create Panel jika Luna berhasil diload
if Luna then
    createPanelUI()
    print("[Panel] Panel System Ready!")
else
    print("[Panel] FATAL ERROR: Luna Library tidak bisa diload!")
    warn("[Panel] Pastikan koneksi internet stabil dan URL Luna correct")
end

print("[Panel] Script panel.lua selesai initialize")

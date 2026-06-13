local shaderName = "blackhole"
local isShaderSupported = false

function onCreatePost()
    -- Check if the user's hardware supports shaders
    if shadersSupported then
        isShaderSupported = true
        
        -- Initialize the fragment shader
        initLuaShader(shaderName)
        
        -- Apply shader to the entire game camera (or change 'camGame' to 'camHUD')
        runHaxeCode([[
            var shader = game.createRuntimeShader(']] .. shaderName .. [[');
            game.camGame.setFilters([new openfl.filters.ShaderFilter(shader)]);
            
            // Set up initial resolution dimension vectors
            shader.setFloatArray('iResolution', [1280.0, 720.0, 0.0]);
            shader.setFloat('iTime', 0.0);
        ]])
    end
end

function onUpdate(elapsed)
    if isShaderSupported then
        -- Keep track of global playback time and feed it to the shader uniform
        local shaderTime = getPropertyFromClass('backend.Conductor', 'songPosition') / 1000
        
        runHaxeCode([[
            var shader = game.camGame.getFilters()[0].shader;
            if (shader != null) {
                shader.setFloat('iTime', ]] .. shaderTime .. [[);
            }
        ]])
    end
end

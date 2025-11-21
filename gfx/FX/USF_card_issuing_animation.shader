Includes = {
    "buttonstate.fxh"
}

PixelShader =
{
    Samplers =
    {
        MapTexture =
        {
            Index = 0
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
            MipMapLodBias = -0.8
        }
        MaskTexture =
        {
            Index = 1
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
        }
        AnimatedTexture =
        {
            Index = 2
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Wrap"
            AddressV = "Wrap"
        }
        MaskTexture2 =
        {
            Index = 3
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
        }
        AnimatedTexture2 =
        {
            Index = 4
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Wrap"
            AddressV = "Wrap"
        }
        MaskingTexture =
        {
            Index = 5
            MagFilter = "Point"
            MinFilter = "Point"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
        }
    }
}

VertexStruct VS_OUTPUT
{
    float4  vPosition : PDX_POSITION;
    float2  vTexCoord : TEXCOORD0;
};

// 顶点着色器：实现从指定坐标移动到原点(0,0)的平滑动画，并添加缩放效果
VertexShader =
{
    MainCode VertexShaderMain
    [[
        // 定义最大支持的物体序号，方便扩展
        #define MAX_OBJECT_INDEX 35 // 现在支持序号 0 到 35 (共36个物体)

        // 1. 定义序号对应的“起始坐标”
        // 当输入序号N时，物体将从 positionMap[N] 移动到 (0, 0)
        static const float2 positionMap[MAX_OBJECT_INDEX + 1] = {
            float2(0.0f, 0.0f),      // 索引0：原点 (无动画)

            float2(-380.0f, -310.0f), // 序号1：起始坐标
            float2(-240.0f, -310.0f),  // 序号2：起始坐标
            float2(-100.0f, -310.0f),   // 序号3：起始坐标
            float2(45.0f, -310.0f),  // 序号4：起始坐标
            float2(190.0f, -310.0f),  // 序号5：起始坐标
            float2(330.0f, -310.0f),  // 序号6：起始坐标
            float2(470.0f, -310.0f),  // 序号7：起始坐标

            float2(-225.0f, -310.0f),  // 序号8：起始坐标
            float2(-85.0f, -310.0f),  // 序号9：起始坐标
            float2(55.0f, -310.0f), // 序号10：起始坐标
            float2(200.0f, -310.0f), // 序号11：起始坐标
            float2(345.0f, -310.0f), // 序号12：起始坐标
            float2(485.0f, -310.0f), // 序号13：起始坐标
            float2(625.0f, -310.0f),  // 序号14：起始坐标

            float2(-100.0f, -310.0f),  // 序号15：起始坐标
            float2(70.0f, -310.0f),  // 序号16：起始坐标
            float2(160.0f, -310.0f), // 序号17：起始坐标
            float2(355.0f, -310.0f), // 序号18：起始坐标
            float2(500.0f, -310.0f), // 序号19：起始坐标
            float2(640.0f, -310.0f), // 序号20：起始坐标
            float2(880.0f, -310.0f),  // 序号21：起始坐标

            float2(-505.0f, -310.0f),  // 序号22：起始坐标
            float2(-365.0f, -310.0f),  // 序号23：起始坐标
            float2(-225.0f, -310.0f), // 序号24：起始坐标
            float2(-90.0f, -310.0f), // 序号25：起始坐标
            float2(50.0f, -310.0f), // 序号26：起始坐标
            float2(190.0f, -310.0f), // 序号27：起始坐标
            float2(330.0f, -310.0f),  // 序号28：起始坐标

            float2(-630.0f, -310.0f),  // 序号29：起始坐标
            float2(-490.0f, -310.0f),  // 序号30：起始坐标
            float2(-350.0f, -310.0f), // 序号31：起始坐标
            float2(-215.0f, -310.0f), // 序号32：起始坐标
            float2(-75.0f, -310.0f), // 序号33：起始坐标
            float2(65.0f, -310.0f), // 序号34：起始坐标
            float2(205.0f, -310.0f)  // 序号35：起始坐标
        };

        VS_OUTPUT main(const VS_INPUT v )
        {
            // 2. 解析游戏传入的控制数（格式：物体序号）
            int controlInt = floor(Offset.x);
            // 使用 clamp 确保序号在有效范围内 (0 到 MAX_OBJECT_INDEX)
            int objectIndex = clamp(controlInt, 0, MAX_OBJECT_INDEX);

            // 3. 获取该序号对应的“起始坐标”
            float2 startPos = positionMap[objectIndex];
            
            // 4. 计算平滑过渡因子 t (0.0 -> 1.0)
            float transitionTime = 0.5f; // 动画持续时间
            float vTime = Time - AnimationTime;
            float t = clamp(vTime / transitionTime, 0.0f, 1.0f);
            
            // --- 新增逻辑：如果序号是0，则强制t为1.0f，跳过所有动画 ---
            if (objectIndex == 0)
            {
                t = 1.0f; // t=1.0f 意味着物体已经到达目标位置和大小
            }
            else
            {
                t = 0.5f * (1.0f - cos(t * 3.1415926f)); // 仅对非0序号应用缓动函数
            }

            // 5. 计算缩放因子（核心修改：根据序号范围动态设置起始缩放）
            float startScale;
            float endScale = 1.0f; // 所有序号的最终缩放都是1.0f
            // 判断序号是否在 22~35 范围内
            if (objectIndex >= 22 && objectIndex <= 35)
            {
                startScale = 1.85f; // 序号22~35：起始缩放1.85倍
            }
            else
            {
                startScale = 1.3f;  // 其他序号（1~21）：起始缩放1.3倍
            }
            // 平滑过渡缩放（从startScale到endScale）
            float currentScale = lerp(startScale, endScale, t);

            // 6. 计算当前帧的位置
            // 逻辑：当前位置 = 起始位置 + (目标位置 - 起始位置) * t
            // 因为目标位置是 (0, 0)，所以简化为：当前位置 = startPos * (1 - t)
            float2 currentWorldPos = startPos * (1.0f - t);
            
            // 7. 计算最终顶点位置
            float4 worldPos = float4(v.vPosition.xy * currentScale + currentWorldPos, v.vPosition.z, 1.0f);
            
            VS_OUTPUT Out;
            Out.vPosition = mul(WorldViewProjectionMatrix, worldPos);
            Out.vTexCoord = v.vTexCoord;
            return Out;
        }
    ]]
}

PixelShader =
{
    MainCode PixelShaderMain
    [[
        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            return tex2D(MapTexture, v.vTexCoord);
        }
    ]]
}

BlendState BlendState
{
    BlendEnable = yes
    SourceBlend = "src_alpha"
    DestBlend = "inv_src_alpha"
}

Effect Up
{
    VertexShader = "VertexShaderMain"
    PixelShader = "PixelShaderMain"
}

Effect Down
{
    VertexShader = "VertexShaderMain"
    PixelShader = "PixelShaderMain"
}

Effect Disable
{
    VertexShader = "VertexShaderMain"
    PixelShader = "PixelShaderMain"
}

Effect Over
{
    VertexShader = "VertexShaderMain"
    PixelShader = "PixelShaderMain"
}
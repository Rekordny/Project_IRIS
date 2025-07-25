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
    float   vTime     : TEXCOORD1;  // 传递动画时间到像素着色器
};

VertexShader =
{
    MainCode VertexShaderMain
    [[
        VS_OUTPUT main(const VS_INPUT v)
        {
            float vTime = Time - AnimationTime;
            float total = Offset.x;
            
            // 解析7位输入值：前3位=prevIndex, 中间3位=nextIndex, 末位=标志位
            float flag = mod(total, 10.0);      // 获取末位标志位
            total = floor(total / 10.0);        // 移除标志位
            float vNextIndex = mod(total, 1000.0);
            float vPrevIndex = floor(total / 1000.0);

            float spacingBetweenIndices = 1.901f;
            float animFactor = (1.0 - sin((4.0 * clamp(vTime, 0.0, 0.5) - 1.0) * 1.57079633f));
            float yOffset = ((vPrevIndex - vNextIndex) * spacingBetweenIndices) * animFactor / 2.0;

            VS_OUTPUT Out;
            float4 modifiedPos = float4(v.vPosition.x, v.vPosition.y + yOffset, v.vPosition.z, 1.0);
            Out.vPosition = mul(WorldViewProjectionMatrix, modifiedPos);
            Out.vTexCoord = v.vTexCoord;
            Out.vTime = vTime;  // 传递当前动画时间
            return Out;
        }
    ]]
}

PixelShader =
{
    MainCode PixelShaderMain
    [[
        float4 main(VS_OUTPUT v) : PDX_COLOR
        {
            float4 color = tex2D(MapTexture, v.vTexCoord);
            float total = Offset.x;
            float flag = mod(total, 10.0);  // 提取末位标志位

            // 动画结束（>1秒）且标志位为0时隐藏
            if (v.vTime > 1.0 && flag < 0.5)
            {
                color.a = 0.0;  // 设置透明度为0
            }
            return color;
        }
    ]]
}

BlendState BlendState
{
    BlendEnable = yes
    SourceBlend = "src_alpha"
    DestBlend = "inv_src_alpha"
}

// 效果定义
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